**********************************************************************************
** Marriage Tax Study
** Merges MHF into Raw Data
**		Find individuals in MHF but not PSID
**		Add their info to Raw Data
**********************************************************************************

**********************************************************************************
* Section 1:  Merge MHF with Raw Data
**********************************************************************************
* Step 1: Primary Merge
local mfile = "data/MarriageHistoryFile.dta"
	* MarriageHistoryFile.dta is output of Refresh_MHF
merge 1:m family ID using "`mfile'"

* Step 2: Clean Merged Data
** Drop observations with no marriage history info
drop if _merge == 1
** Other cleaning
rename _merge inPSID
replace inPSID = 1 if inPSID == 3
replace inPSID = 0 if inPSID == 2
label define datalbl 0 "MHF only" 1 "full data"
label values inPSID datalbl

* Step 3: Double Check for Single-individual Couples
bys couple: replace couple_size = _N
summarize couple if couple_size == 1

**********************************************************************************
* Section 2:  Identify Eligible Couples and Expand
**********************************************************************************
* Step 1: Count # of Individuals in Couple in PSID
bys couple: egen PSID_count = sum(inPSID)

* Step 2: Drop Couples with no Individuals in PSID
drop if PSID_count == 0

* Step 3: Expand for Couples with Only one Individual in PSID
gen exp = 0
replace exp = 2 if inPSID == 1 & PSID_count == 1
expand exp, generate(new)
** Note: new = 1 if observation is a duplicate
drop exp

**********************************************************************************
* Section 2:  Transfer Marriage History File Information
**********************************************************************************
* Step 1: Identify Variables to Transfer Directly
local cc_vars "asex year_born marriage_number marr_howmany num_marriage_records"

* Step 2: Distribute Variables
** Appear to be largely blank, no info available assiged to zero under max()
* This is just to keep data from MHF (if it exists)
foreach var of local cc_vars {
	gen test_`var' = .
	replace test_`var' = `var' if inPSID == 0
	bys couple: egen temp = max(test_`var')
	replace `var' = temp if new == 1
	
	drop temp test_`var'
}

* Step 3: Drop Extra Observation
drop if inPSID == 0
bys couple: replace couple_size = _N
count if couple_size > 2
drop inPSID

**********************************************************************************
* Section 3:  Fix Personal Data
**********************************************************************************
* Step 1: Fix Family (Individual & Spouse)
replace family = family_spouse if new == 1
gen fam_temp = 0
replace fam_temp = family if PSID_count == 1 & new == 0
bys couple: egen fam_temp2 = max(fam_temp)
replace family_spouse = fam_temp2 if new == 1
drop fam_temp fam_temp2

* Step 2: Fix ID (Individual & Spouse)
replace ID = ID_spouse if new == 1
gen ID_temp = 0
replace ID_temp = ID if PSID_count == 1 & new == 0
bys couple: egen ID_temp2 = max(ID_temp)
replace ID_spouse = ID_temp2 if new == 1
drop ID_temp ID_temp2

* Step 3: Fix Gender if Not Available
replace sex = asex if new == 1
replace asex = 0
replace asex = sex if PSID_count == 1 & new == 0
bys couple: egen sex_temp = max(asex)
replace sex = 1 if new == 1 & sex_temp == 2 & sex == 0
replace sex = 2 if new == 1 & sex_temp == 1 & sex == 0
replace sex = 1 if new == 1 & sex_temp == 2 & sex == .
replace sex = 2 if new == 1 & sex_temp == 1 & sex == .
drop asex sex_temp

