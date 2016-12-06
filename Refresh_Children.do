**********************************************************************************
** Marriage Tax Replication
** YEARS: All Years
** Identifies Individual Tax Age and Counts Children
**********************************************************************************
args y

**********************************************************************************
* Section 1:  Calculate Tax Age
*****************************************************************************
local y_plus_1 = `y' + 1
local y_plus_2 = `y' + 2
* Step 1: Generate Tax Age from Individual Age
gen t`y'_taxage = .
gen t`y'_age = .
capture confirm variable t`y'_age3 
if !_rc {
	replace t`y'_taxage = t`y'_age3 - 1 if t`y'_age3 ~= . & t`y'_age3 ~= 0 & t`y'_age3 ~= 999
	replace t`y'_age = t`y'_age3 if t`y'_age3 ~= . & t`y'_age3 ~= 0 & t`y'_age3 ~= 999
	* Try year later since some people just entered sample
	if `y' < 1997 {
		replace t`y'_taxage = t`y_plus_1'_age3 - 2 if t`y'_taxage == . & t`y_plus_1'_age3 ~= . & t`y_plus_1'_age3 ~= 0 & t`y_plus_1'_age3 ~= 999 
		replace t`y'_age = t`y_plus_1'_age3 - 1 if t`y'_age == . & t`y_plus_1'_age3 ~= . & t`y_plus_1'_age3 ~= 0 & t`y_plus_1'_age3 ~= 999 
	}
	* and a year after that 
	if `y' > 1997 & `y' < 2011 {
	replace t`y'_taxage = t`y_plus_2'_age3 - 3 if t`y'_taxage == . & t`y_plus_2'_age3 ~= . & t`y_plus_2'_age3 ~= 0 & t`y_plus_2'_age3 ~= 999 
	replace t`y'_age = t`y_plus_2'_age3 - 2 if t`y'_age == . & t`y_plus_2'_age3 ~= . & t`y_plus_2'_age3 ~= 0 & t`y_plus_2'_age3 ~= 999 
		}
	}
	

* Step 2: Use Year Individual Born
capture confirm variable t`y'_age1 
if !_rc {
	if `y' > 1982 {
		replace t`y'_taxage = `y' - t`y'_age1 - 1 if t`y'_taxage== . & t`y'_age1 ~= . & t`y'_age1>0
		replace t`y'_age = `y' - t`y'_age1 if t`y'_taxage== . & t`y'_age1 ~= . & t`y'_age1>0
		}
	drop t`y'_age1
	}
replace t`y'_taxage = . if t`y'_taxage < 0
replace t`y'_age = . if t`y'_age < 0

* Step 3: Use Year HOH Born
capture confirm variable t`y'_age2 
if !_rc {
	if `y' > 1982 {
		gen HOH = 0
		replace HOH = 1 if t`y'_rel2HOH == 1 | t`y'_rel2HOH == 10
		replace t`y'_taxage = `y' - t`y'_age2 - 1 if t`y'_taxage== . & t`y'_age2 ~= . & t`y'_rel2HOH == 1 & t`y'_age2> 0  & HOH == 1
		replace t`y'_age = `y' - t`y'_age2 if t`y'_taxage== . & t`y'_age2 ~= . & t`y'_age2 > 0 & HOH == 1
		drop HOH
		}
	drop t`y'_age2
	}
replace t`y'_taxage = . if t`y'_taxage < 0
replace t`y'_age = . if t`y'_age < 0

**********************************************************************************
* Section 2:  Count Children (Current Information Only)
*****************************************************************************
* Step 1: Identify Children
gen t`y'_c1 = 0 	/* Any Child for Years 1968 - 1982*/
gen t`y'_c2 = 0		/* HOH Child for Years 1982 + */
gen t`y'_c3 = 0		/* Stepchild for Years 1982 + */
replace t`y'_c1 = 1 if t`y'_rel2HOH == 3 & `y' <= 1982
replace t`y'_c2 = 1 if t`y'_rel2HOH == 30 & `y' > 1982		/* Children, including adopted */
replace t`y'_c2 = 1 if t`y'_rel2HOH == 38 & `y' > 1982		/* Foster Children */
replace t`y'_c3 = 1 if t`y'_rel2HOH == 33 & `y' > 1982		/* Stepchildren */
replace t`y'_c3 = 1 if t`y'_rel2HOH == 35 & `y' > 1982		/* Children of HOH Partner */
replace t`y'_c3 = 1 if t`y'_rel2HOH == 37 & `y' > 1982		/* Children in law */
* Note Step Children not Identified Prior to 1983

* Step 2: Calculate Year for Lookback Approach
		if `y' >= 1999 {
			local x = `y' - 2
		}
		else {
			local x = `y' - 1
		}
		
* Step 3: Make Step Children HoH Child if already "Step Child" Prior to Marriage
if `y' > 1986 {
	replace t`y'_c3 = 0 if t`y'_c3 == 1 & t`x'_c3 == 1
	replace t`y'_c1 = 1 if t`y'_c3 == 1 & t`x'_c3 == 1
	drop t`x'_c3
}

* Step 4: Do Not Count as Child if Over 18 Years Old at Time of Marriage
replace t`y'_c1 = 0 if t`y'_age3 > 18
replace t`y'_c2 = 0 if t`y'_age3 > 18
replace t`y'_c3 = 0 if t`y'_age3 > 18

* Step 5: Count Children
bys t`y'_familyID: egen t`y'_child1 = sum(t`y'_c1)
bys t`y'_familyID: egen t`y'_child2 = sum(t`y'_c2)
bys t`y'_familyID: egen t`y'_child3 = sum(t`y'_c3)
gen t`y'_totChild = t`y'_child1 + t`y'_child2 + t`y'_child3 /* Total Number of Children */
label var t`y'_totChild "Total Number of Children in Family"
gen t`y'_HOHChild = t`y'_child1 + t`y'_child2				/* Non-step Children */
label var t`y'_HOHChild "Head's Number of Children in Family"
rename t`y'_child3 t`y'OChild								/* Step Children */
label var t`y'OChild "Number of Step Children in Family"

* Step 4: Drop Intermediate Variables
drop t`y'_child1 t`y'_child2

**********************************************************************************
* Section 2:  Count Children (Backwards Looking Information)
*****************************************************************************
* Step 1: Identify Children & Look if Included in Prior Survey
gen child_temp = t`y'_c1 + t`y'_c2 + t`y'_c3
gen in_sample = 0
if `y' > 1986 {
	replace in_sample = 1 if t`x'_rel2HOH ~= 0 & child_temp > 0
}
** Only consider children as pre-existing if at least two years old
replace in_sample = 0 if t`y'_age < 2

* Step 2: Count Pre-existing Children Based on Sample Status
* Over Two and Previous Included in the Survey
bys t`y'_familyID: egen t`y'_child_e = sum(in_sample)
* Over Two, No Restriction on Sample Preexistence
gen child2_temp = 0
replace child2_temp = 1 if t`y'_age >= 2 & child_temp > 0
bys t`y'_familyID: egen t`y'_over_two = sum(child2_temp)
label var t`y'_over_two "Number of Children Over Two"

* Step 4: Drop Intermediate Variables
drop in_sample child_temp child2_temp t`y'_c1 t`y'_c2
* Note: Cannot Drop t`y'_c3 in current year becuase referenced in next iteration

