**********************************************************************************
** Marriage Tax Study
** Marriage History File (MHF)
**		MHF used to better identify couples 
**		See: http://psidonline.isr.umich.edu/Data/Documentation/cbks/supp/FamHist/mh85_07_intro.pdf
** 		Loads and names data from MHF
** 		Processes data to create comparable variables
**		Prepares data for merging with raw data
**********************************************************************************
args year_start year_end

**********************************************************************************
* Section 1: File Setup (PSID Generated Code)
**********************************************************************************
#delimit ;
**************************************************************************
   Label           : Marriage History File 1985-2011
   Rows            : 54630
   Columns         : 20
   ASCII File Date : May 31, 2013
*************************************************************************;

infix 
      MH1             1 - 4         MH2             5 - 7         MH3             8 - 8    
      MH4             9 - 10        MH5            11 - 14        MH6            15 - 18   
      MH7            19 - 21        MH8            22 - 23        MH9            24 - 25   
      MH10           26 - 29        MH11           30 - 30        MH12           31 - 32   
      MH13           33 - 36        MH14           37 - 38        MH15           39 - 42   
      MH16           43 - 46        MH17           47 - 48        MH18           49 - 49   
      MH19           50 - 51        MH20           52 - 52   
using "$MHF_data", clear 
;
label variable  MH1        "1968 INTERVIEW NUMBER OF INDIVIDUAL" ;             
label variable  MH2        "PERSON NUMBER OF INDIVIDUAL" ;                     
label variable  MH3        "SEX OF INDIVIDUAL" ;                               
label variable  MH4        "MONTH INDIVIDUAL BORN" ;                           
label variable  MH5        "YEAR INDIVIDUAL BORN" ;                            
label variable  MH6        "1968 INTERVIEW NUMBER OF SPOUSE" ;                 
label variable  MH7        "PERSON NUMBER OF SPOUSE" ;                         
label variable  MH8        "ORDER OF THIS MARRIAGE" ;                          
label variable  MH9        "MONTH MARRIED" ;                                   
label variable  MH10       "YEAR MARRIED" ;                                    
label variable  MH11       "STATUS OF THIS MARRIAGE" ;                         
label variable  MH12       "MONTH WIDOWED OR DIVORCED" ;                       
label variable  MH13       "YEAR WIDOWED OR DIVORCED" ;                        
label variable  MH14       "MONTH SEPARATED" ;                                 
label variable  MH15       "YEAR SEPARATED" ;                                  
label variable  MH16       "YEAR MOST RECENTLY REPORTED MARRIAGE" ;            
label variable  MH17       "NUMBER OF MARRIAGES OF THIS INDIVIDUAL" ;          
label variable  MH18       "LAST KNOWN MARITAL STATUS" ;                       
label variable  MH19       "NUMBER OF MARRIAGE RECORDS" ;                      
label variable  MH20       "RELEASE NUMBER" ;                                  

rename MH1 family ;
rename MH2 ID ;
rename MH3 sex ;
rename MH4 month_born ;
rename MH5 year_born ;
rename MH6 family_spouse ;
rename MH7 ID_spouse ;
rename MH8 marriage_number ;
rename MH9 month_married ;
rename MH10 year_married ;
rename MH11 marriage_status ;
rename MH12 month_notmarried ;
rename MH13 year_notmarried ;
rename MH14 month_separated ;
rename MH15 year_separated ;
rename MH16 marriage_updated ;
rename MH17 marr_howmany ;
rename MH18 marital_status ;
rename MH19 num_marriage_records ;
rename MH20 release_number ;

#delimit cr
* Keep only main sample
drop if family > 2931 

**********************************************************************************
* Section 2: Identify Couples
**********************************************************************************
* Step 1: Remove Individuals That Don't Report Marriages
drop if ID_spouse == 0
drop if ID_spouse == 999 & family_spouse == 9999

* Step 2: Generate Data Variables
gen couple = .
egen obs_num = group(family ID)
summarize obs_num

* Step 3: Identify Couples and Assign Couple#
forvalues i = 1/`r(max)' {
	* Get family # of `i' 
	qui summarize family if obs_num == `i'
	local F = `r(mean)'
		
	* Get ID# of `i' 
	qui summarize ID if obs_num  == `i'
	local I = `r(mean)'
		
	* Assign person `i' to couple `i'
	qui replace couple = `i' if obs_num == `i'
	* Add anyone that had ID_spouse or family_spouse == ID family of `i'
	qui replace couple = `i' if ID_spouse == `I' & family_spouse == `F'
}


* Reorder Couple# them From 1 to N
egen temp = group(couple)
replace couple = temp

**********************************************************************************
* Section 3: Clean Couple Matchings
**********************************************************************************
* Step 1: Reduce Large Couples
bys couple: gen couple_size = _N
sum couple_size if couple_size > 2
** Exile individuals with incorrect spouse ID
bys couple: egen min_id = min(ID)
bys couple: egen max_id = max(ID)
gen idincouple = 0
replace idincouple = 1 if ID_spouse == min_id
replace idincouple = 1 if ID_spouse == max_id
qui sum couple
scalar cmax = r(max)
replace couple = cmax + 1 if idincouple == 0 & couple_size > 2
bys couple: replace couple_size = _N
sum couple_size if couple_size > 2 & couple ~= cmax + 1
** Drop observations if marriage year NA
drop if couple_size > 2 & year_married >= 9998
bys couple: replace couple_size = _N
sum couple_size if couple_size > 2 & couple ~= cmax + 1
** Drop observations if marriage year mismatched with mode
bys couple: egen mode = mode(year_married)
replace mode = 0 if couple_size <= 2
gen fit = 1
replace fit = 0 if year_married ~= mode & couple_size > 2
drop if fit == 0
bys couple: replace couple_size = _N
sum couple_size if couple_size > 2 & couple ~= cmax + 1
** Drop temporary variables
drop min_id max_id fit mode

* Step 2: Identify Properly Matched Couples
by couple: egen match = sum(idincouple)
replace match = 0 if couple_size == 1
replace match = match /2 if couple_size == 2
** match == 1 indicates a proper match

* Step 3: Reconcile Individuals with Missing Marriage Timing Data
** Replace blank years with spouse's reported year if available
replace year_married = 0 if year_married >= 9000
bys couple: egen max_yr = max(year_married)
replace year_married = max_yr if year_married == 0 & match == 1
** Drop if neither individual has a valid marriage year
drop if max_yr == 0
bys couple: replace couple_size = _N
sum couple_size if couple_size == 1
** Replace blank months with spouse's reported month if available
replace month_married = 0 if month_married >= 90
bys couple: egen max_mth = max(month_married)
replace month_married = max_mth if month_married == 0 & match == 1
** Drop if neither individual has a valid marriage month
drop if max_mth == 0
bys couple: replace couple_size = _N
sum couple_size if couple_size == 1
** Drop temporary variables
drop max_yr max_mth

* Step 4: Break Apart Incorrectly Matched Couples
** Identify individuals to separate
bys couple: gen person = _n
gen separate = 0
replace separate = 1 if match ~= 1 & person > 1
** Change couple number for identified individuals
bys separate: gen add = _n
replace add = 0 if separate == 0
qui sum couple
scalar cmax = r(max)
replace couple = cmax + add if separate == 1
** Drop temporary variables
drop person separate add

* Step 5: Drop Any Single Individuals with Missing Marriage Info
bys couple: replace couple_size = _N
drop if couple_size == 1 & year_married > 9900
drop if couple_size == 1 & year_married == 0
drop if couple_size == 1 & month_married > 90
drop if couple_size == 1 & month_married == 0

**********************************************************************************
* Section 4: Create Spouse Observation for Single Individuals
**********************************************************************************
* Step 1: Expand Data Set for Single Individuals
bys couple: replace couple_size = _N
summarize couple if couple_size == 1
gen exp = 0
replace exp = 2 if couple_size == 1
expand exp
sort couple ID

* Step 2: Replace Spouse Identification Data
bys couple ID: gen dup = _N
bys couple ID: gen num = _n
gen family_spouse2 = family_spouse
gen ID_spouse2 = ID_spouse
replace family_spouse = family if dup == 2 & num == 2
replace ID_spouse = ID if dup == 2 & num == 2
replace family = family_spouse2 if dup == 2 & num == 2
replace ID = ID_spouse2 if dup == 2 & num == 2
drop family_spouse2 ID_spouse2

* Step 3: Replace Other Spouse Data with Blanks if Not Available
replace sex = . if dup == 2 & num == 2
replace month_born = . if dup == 2 & num == 2
replace year_born = . if dup == 2 & num == 2
replace marriage_number = . if dup == 2 & num == 2
replace marriage_updated = . if dup == 2 & num == 2
replace marr_howmany = . if dup == 2 & num == 2
replace marital_status = . if dup == 2 & num == 2
replace num_marriage_records = . if dup == 2 & num == 2
replace release_number = . if dup == 2 & num == 2

* Step 4: Recalculate Couple Size
bys couple: replace couple_size = _N
list couple sex year_married family ID if couple_size > 2
list couple sex year_married family ID if couple_size < 2

**********************************************************************************
* Section 5: Prepare Data for Merging
**********************************************************************************
* Step 1: Drop Superfluous Variables
rename sex asex
drop obs_num temp dup num exp month_born idincouple match
* note year born not available for all individuals -should not use later

* Step 2: Save Data File
local out_data = "data/MarriageHistoryFile.dta"
save `out_data', replace
