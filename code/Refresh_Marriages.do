**********************************************************************************
** Marriage Tax Study
** Refresh_Marriages
**		Fix relevant variables, post MHF merge,
** 		Create marriage variables
** 		Filter Marriages by Year
** 		Filter Marriages by Endurance
** 		Filter Marriages for Age of Participants
**		Preliminary stats on remaining couples
**********************************************************************************
args year_start year_end min_marr_years max_18 wrong_anniversary

local data_start = `year_start' + 1
local data_end = `year_end' + 1

**********************************************************************************
* Section 1: Fix Annual Variables With Changing Definitions
**********************************************************************************
** Transfer Annual Data
qui foreach y of global run_years {
	** Identify Heads of Household
	gen t`y'_head = 0
	replace t`y'_head = 1 if t`y'_rel2HOH == 1 & `y' <= 1982
	replace t`y'_head = 1 if t`y'_rel2HOH == 10 & `y' > 1982
	** Identify Spouses
	replace t`y'_head = 2 if t`y'_rel2HOH == 2 & `y' <= 1982
	replace t`y'_head = 2 if t`y'_rel2HOH == 9 & `y' <= 1982
	replace t`y'_head = 2 if t`y'_rel2HOH == 20 & `y' > 1982
	replace t`y'_head = 2 if t`y'_rel2HOH == 22 & `y' > 1982
	replace t`y'_head = 2 if t`y'_rel2HOH == 88 & `y' > 1982
	replace t`y'_head = 2 if t`y'_rel2HOH == 90 & `y' > 1982
	** Transfer to Generate Individual Rows
	gen temp_rel = 0
	replace temp_rel = t`y'_head if PSID_count == 1 & new == 0
	bys couple: egen max_rel = max(temp_rel)
	replace t`y'_head = 2 if new == 1 & max_rel == 1
	replace t`y'_head = 1 if new == 1 & max_rel == 2
	drop temp_rel max_rel
	** Save "Wife" Variable for Section 5 Step 3
	gen t`y'_wife = 0
	replace t`y'_wife = 1 if t`y'_head == 2
	** Set "Wife" == 0
	replace t`y'_head = 0 if t`y'_head == 2
	** Replace Age 
	replace t`y'_age = `y' - year_born if new == 1
	replace t`y'_taxage = t`y'_age - 1 if new == 1
	** Create Indicator Variable for Missing Age in y
	gen noage`y' = 0
	replace noage`y' = 1 if year_born == 0 & new == 1
	replace noage`y' = 1 if year_born == . & new == 1
	replace noage`y' = 1 if year_born > 9900 & new == 1
	replace noage`y' = 1 if t`y'_age <= 0
	replace noage`y' = 1 if t`y'_age == .	
}

**********************************************************************************
* Section 2: Introduce Marriage Variables and Correct for Mismatched Variables
**********************************************************************************
* Step 1: Correct Month Married if Mismatched
bys couple: egen max_MM = max(month_married)
bys couple: egen min_MM = min(month_married)
** Drop Mismatches where Both Couple Months Are Out of Sample
drop if max_MM ~= min_MM & max_MM < 10 & min_MM > 3
** Replace Month if One Individual Reported Month, Other Season
replace month_married = min_MM if month_married > 12
** Recalculate Mismatched Couples
drop max_MM min_MM
bys couple: egen max_MM = max(month_married)
bys couple: egen min_MM = min(month_married)
** Replace Month if Agreed on Quarter
replace month_married = min_MM if min_MM < 4 & max_MM < 4
replace month_married = min_MM if min_MM > 9 & max_MM > 9
** Recalculate Mismatched Couples and Drop Remaining (18 Couples)
drop max_MM min_MM
bys couple: egen max_MM = max(month_married)
bys couple: egen min_MM = min(month_married)
drop if min_MM ~= max_MM
drop min_MM max_MM
** Drop couples who report season, not month
drop if month_married >=13

* Step 2: Set YoI
* YoI == Year of Interest. (Year data taken from)
* YoI = Year After Marriage if Married in the Fall 
** Implies data is from the year of marriage
generate YoI = year_married	+ 1
* YoI = Prior Year if Married in the Spring
replace YoI = year_married if month_married < 4

* Step 3: Drop Couples with Marriage Year Differences
* Find mis-matches
bys couple: egen max_YoI = max(YoI)
bys couple: egen min_YoI = min(YoI)
gen YoIagree = 1
replace YoIagree = 0 if max_YoI ~= min_YoI
* Replace YoI with (1) head's (2) spouse's (3) minimum (4) maximum
gen YoI_of_Interest = 0
if `wrong_anniversary' == 1 { /* min_YoI */
	replace YoI_of_Interest = YoI  if YoI == min_YoI & YoIagree == 0
	}
if `wrong_anniversary' == 2 { /* max_YoI */
	replace YoI_of_Interest = YoI  if YoI == max_YoI & YoIagree == 0
	}	


* Step 4: Either drop >1yr Disagreements and Reconcile or Drop All
if `wrong_anniversary' > 0 {
	* Only drop if difference is more than a year
	drop if max_YoI - min_YoI > 1
	* One should be zero and the other a year	
	bys couple: egen YoI_new = max(YoI_of_Interest)
	replace YoI = YoI_new if YoIagree == 0
	}
else {
	* Drop if any difference at all
	drop if YoIagree == 0
	}

* Step 5: Fix Year Married
replace year_married = YoI
replace year_married = YoI - 1 if month_married > 4

* Step 6: Check for Singletons and Drop Temporary Variables
drop YoI_*
bys couple: replace couple_size = _N
list couple couple_size if couple_size ~= 2

**********************************************************************************
* Section 2: Filter Marriages by Year
**********************************************************************************
* Step 1: Remove Couples Outside of Data Range
** Drop if YoI Before Data
drop if YoI < `data_start'
** Drop if YOI After Data
drop if YoI > `data_end'

* Step 2: Check for Singletons
bys couple: replace couple_size = _N
list couple couple_size if couple_size ~= 2

**********************************************************************************
* Section 3: Filter Marriages by Endurance
**********************************************************************************
* Step 1: Drop Marriages which are Too Short
gen marriedyears = year_notmarried - year_married
drop if marriedyears < `min_marr_years'
drop marriedyears year_notmarried month_notmarried
** Before using check to make marriage length is constant across the couple
** (year married is cleaned but year not married is not)
qui sum couple
di as text "Number of eligible couples:  " as result `r(N)'

* Step 2: Check for Singletons
bys couple: replace couple_size = _N
list couple couple_size if couple_size ~= 2

**********************************************************************************
* Section 4: Filter Marriages by Age
**********************************************************************************
* Step 1: Drop Ineligible Marriages
** Set so that not kicked out if age information is missing
gen age_temp = 30
foreach y of global run_years {
	** Recall taxage is age in prior year
	replace age_temp = t`y'_age if noage`y' == 0
	bys couple: egen maxage`y' = max(age_temp)
	bys couple: egen minage`y' = min(age_temp)
	if `max_18' ==1 {
			drop if maxage`y' < 19 & year_married == `y'
		}
		else {
			drop if minage`y' < 19 & year_married == `y'
		}
		drop maxage`y' minage`y'
}
drop age_temp

**********************************************************************************
* Section 5: Summary Statistics on Remaining Couples
**********************************************************************************
* Step 1: Check for Singletons
bys couple: replace couple_size = _N
list couple couple_size if couple_size ~= 2

* Step 2: Analyze Remaining Sample
bys couple: gen count = _n
** Number of eligible couples
sum couple if count == 1
** Number of eligible couples w/ two people
sum couple if count == 2
bys family: replace count = _n
** Number of eligible families
sum family if count == 1

* Step 3: Check for Missing Spouses
foreach y of global run_years {
	gen spouse_in`y' = 0
	** Spouse in if HoH reports being married
	replace spouse_in`y' = 1 if t`y'_mstat1 == 1
	** Spouse in if positive swages reported
	if `y' <= 1993 {
		replace spouse_in`y' = 1 if t`y'_swages1 > 0
		}
	else {
		replace spouse_in`y' = 1 if t`y'_swages3 > 0
		replace spouse_in`y' = 1 if t`y'_swages5 > 0
	}
	** Spouse in if someone reports being wife
	replace spouse_in`y' = 1 if t`y'_wife == 1
	** Distribute spouse reporting across couple
	bys couple: egen max_spouse = max(spouse_in`y')
	replace spouse_in`y' = max_spouse
	drop t`y'_wife max_spouse
}

