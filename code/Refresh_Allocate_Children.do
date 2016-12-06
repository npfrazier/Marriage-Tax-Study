**********************************************************************************
** Marriage Tax Study
** Allocate Children
** 		Performs different allocation rules
** 		e.g. HoH, Bio, HighEarner, Male, Female
**********************************************************************************
args y step


* Step 1: Identify Couples with Heads of Household		
bys couple: egen t`y'_max_head = max(t`y'_head)
bys couple: egen t`y'_min_head = min(t`y'_head)

* Step 2: Allocate All Children to Couples with HOH
gen t`y'_c_Child = 0
replace t`y'_c_Child = t`y'_totChild if t`y'_max_head == 1

* Step 3: Calculate Year for Lookback Approach
if `y' >= 1999 {
	local x = `y' - 2
}
else {
	local x = `y' - 1
}

* Step 4: Allocate Children to Individuals Based on HOH Status (Considering Step Status)
gen ChildS`y' = 0 
label var ChildS`y' "Child Assignment Considering Step Status"
replace ChildS`y' = t`y'_HOHChild if t`y'_head == 1
replace ChildS`y' = t`y'OChild if t`y'_head == 0 & t`y'_max_head == 1

* Step 5: Allocate Children all Children to HoH
gen t`y'_Child = 0 
label var t`y'_Child "Child Assignment NOT Considering Step Status"
replace t`y'_Child = t`y'_totChild if t`y'_head == 1

* Step 6: Identify Pre-existing Parents for Lookback Approach
gen t`y'_preexist = 0
if `y' > 1986 {
	replace t`y'_preexist = 1 if t`x'_rel2HOH ~= 0
}
** Count total number of pre-existing parents
bys couple: egen t`y'_c_preexist = sum(t`y'_preexist)

* Step 7: Assign Child Based on Preexistence
gen ChildP`y' = 0
** Assign children if only one pre-existing parent
replace ChildP`y' = t`y'_child_e if t`y'_preexist == 1 & t`y'_c_preexist == 1
replace ChildP`y' = t`y'_over_two - t`y'_child_e if t`y'_preexist == 0 & t`y'_c_preexist == 1
** All children under two assigned to HoH
replace ChildP`y' = ChildP`y' + t`y'_c_Child - t`y'_over_two if t`y'_head == 1 & t`y'_c_preexist == 1
** If both or neither parents pre-exist, assign all children to HoH
replace ChildP`y' = t`y'_c_Child if t`y'_head == 1 & t`y'_c_preexist ~= 1

* Step 8: Assign Children to Higher Earner
* Determine Head & Spouse Wages
gen temp_inc = 0
replace temp_inc = t`y'_pwages1 if t`y'_head == 1
replace temp_inc = 0 if t`y'_head == 1 & t`y'_pwages1 == 9999999
if `y' <= 1993 {
	replace temp_inc = t`y'_swages1 if t`y'_swages1 ~= . & t`y'_head == 0 & t`y'_max_head == 1
	}
else {
	replace temp_inc = t`y'_swages3 + t`y'_swages5 if t`y'_swages3 + t`y'_swages5 ~= . & t`y'_head == 0 & t`y'_max_head == 1
}
* Determine Higher Earner
bys couple: egen max_inc = max(temp_inc)
gen high_earner`y' = 0
replace high_earner`y' = 1 if temp_inc == max_inc & max_inc > 0
* If no Income in Couple Assigne to HoH 
* (Should Not Matter for Tax Purposes - Prevents Double Counting)
replace high_earner`y' = 1 if max_inc == 0 & t`y'_head == 1
* Check for Duplicates
bys couple: egen min_earner = min(high_earner`y')
* Assign to HoH if Equal Earners
replace high_earner`y' = 0 if min_earner == 1 & t`y'_head == 0
* Assign Children to Higher Earner
gen ChildH`y' = 0
label var ChildH`y' "Child Assignment to Highest Earner"
replace ChildH`y' = t`y'_totChild if high_earner`y' == 1
* Drop Used Variable
drop temp_inc max_inc min_earner

* Step 9: Assign Children to Father/Mother
if `step' == 4 {
	gen ChildF`y' = 0
	replace ChildF`y' = t`y'_totChild if sex == 1
}
else if `step' == 5 {
	gen ChildM`y' = 0
	replace ChildM`y' = t`y'_totChild if sex == 2
}

* Step 10: Check for Error and Drop Old Variables
count if t`y'_c_Child - t`y'_over_two < 0
count if t`y'_c_Child - t`y'_over_two - t`y'_child_e ~= 0
drop t`y'_child_e t`y'_preexist t`y'_c_preexist
rename t`y'_over_two Children_Over2`y'
