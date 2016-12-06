**********************************************************************************
** Marriage Tax Study
** Creates variables used in regressions
** 		Covers Data Calculated annually
**********************************************************************************
args y 

**********************************************************************************
* Section 1: Identify and Construct Regression Variables
**********************************************************************************
* Step 1: Set Temp YoI Variable
gen YoI_temp = YoI
	
* Step 2: Pregnant
replace Pregnant = 1 if YoI_temp == `y' & birthy1 == `y' & birthm1 <= 6
replace Pregnant = 1 if YoI_temp == `y' & birthy2 == `y' & birthm2 <= 6
replace Pregnant = 1 if YoI_temp == `y' & birthy3 == `y' & birthm3 <= 6
replace Pregnant = 1 if YoI_temp == `y' & birthy4 == `y' & birthm4 <= 6
replace Pregnant = 1 if YoI_temp == `y' & birthy5 == `y' & birthm5 <= 6

* Step 3: New Baby
replace NewBaby = 1 if YoI_temp == `y' & birthy1 == `y' - 1
replace NewBaby = 1 if YoI_temp == `y' & birthy2 == `y' - 1
replace NewBaby = 1 if YoI_temp == `y' & birthy3 == `y' - 1
replace NewBaby = 1 if YoI_temp == `y' & birthy4 == `y' - 1
replace NewBaby = 1 if YoI_temp == `y' & birthy5 == `y' - 1

* Step 4: Year Fixed effect
gen t_fix_`y' = 0
replace t_fix_`y' = 1 if YoI == `y'
label var t_fix_`y' "Time Fixed Effect"
capture drop t_fix_1986

* Step 5: Drop Temp Variables
drop YoI_temp

