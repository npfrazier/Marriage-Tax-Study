**********************************************************************************
** Marriage Tax Study
** False Specification Test
	* Pulls condensed data according for HoH assignment
	* Run applicable process data components for delaying to Q3
	* Calculates marriage tax for these couples
	* Does not merge with other estimates
**********************************************************************************
args year_start year_end FiscalYear DollarMeasure MoI

local data_start = `year_start' + 1
local data_end = `year_end' + 1

**********************************************************************************
* Section 1: Process Data for False Specification Delay to Q3
**********************************************************************************
* Step 1: Load `core' Condensed Data Set
local tdata = "$data_dir"+"\condensed_step0.dta"
use "`tdata'"

* Step 2: Drop Individuals Outside of Data Range
* YoI == Year of Interest. (Created in Marriage_Filter.do)
drop if YoI < `data_start'
drop if YoI > `data_end'

* Step 3: Clean month_married Variable
* Drop if Only Season Reported (23 Couples, 0 "Spring"/"Winter") (Other cleaning done in Marriage_Filter)
count if month_married == 21 | month_married == 22
drop if month_married >= 13

* Step 4: Generate Delay Variable & Drop Individuals Married Outside of Seasons of Interest
gen delay = 0
drop if month_married < 4 | month_married > 9
replace delay = 1 if month_married < 7

* Step 5: Run CPI Conversion File
local limited = 1
qui do Inflation_Adj `FiscalYear' `DollarMeasure' `limited'

* Step 6: Choose Marriage(s) of Interest
** Applies filtering rule to people who have more than one marriage in the dataset
do Marriage_of_Interest `MoI'

* Step 7: Run Data Prep Files
qui do Data_Prep1 `year_start' `year_end'
foreach y of global run_years {
	qui do Data_Prep2 `y'
	** fix definition of pregnant
	* Pregnant in 2nd half of year
	replace Pregnant = 1 if YoI == `y' & birthy1 == `y' & birthm1 > 6
	replace Pregnant = 1 if YoI == `y' & birthy2 == `y' & birthm2 > 6
	replace Pregnant = 1 if YoI == `y' & birthy3 == `y' & birthm3 > 6
	replace Pregnant = 1 if YoI == `y' & birthy4 == `y' & birthm4 > 6
	replace Pregnant = 1 if YoI == `y' & birthy5 == `y' & birthm5 > 6
	} 

* Step 8: Run Variable Corrections
** Correct pregnancy if birth not captured for partner
bys couple: egen preg_c = max(Pregnant)
replace Pregnant = preg_c
drop preg_c
** Correct new baby if birth not captured in partner
bys couple: egen baby_c = max(NewBaby)
replace NewBaby = baby_c
drop baby_c

* Step 9: Calculate Marriage Tax
gen mtax = c_fiitax - fiitax
gen mtax_pct = mtax/ c_FedAGI

* Step 10: Reduce Data Set
* Used: Head - Implies HoH data used if unspecified (e.g., taxage, employment)
drop if head ~= 1

* Step 11: Save
local datasavef = "$data_dir"+"/falsespecdata_Q3.dta"
save "`datasavef'", replace
