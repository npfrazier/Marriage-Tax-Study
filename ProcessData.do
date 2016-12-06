**********************************************************************************
** Marriage Tax Study
** Data Process File
**		Merges Data with Other Pre-Marriage Data
** 		Cleans Marriage Date Info
**		Adjusts Dollar Values (CPI and Units)
**		Selects Marriage of Interest
**		Generates regression variables
**		Calculates MTAX and MTAX_pct
**********************************************************************************
args year_start year_end FiscalYear DollarMeasure MoI minims

local data_start = `year_start' + 1
local data_end = `year_end' + 1

**********************************************************************************
* Section 1: Merge together MTAX estimates under different child allocations
**********************************************************************************
* Step 1: Merge and Update Pre-Marriage Tax Estimates
do Merge_Child_Assignments
* save a temp copy
local dname = "$data_dir"+"/all_mtax_values.dta"
save `dname', replace

* Step 2: Re-load HoH Condensed Data and Merge with Alternative Child Assignments
local HoH_data = "$data_dir"+"\condensed_step0.dta"
use "`HoH_data'"
capture drop _merge
merge 1:1 family ID couple using `dname'
drop _merge

**********************************************************************************
* Section 2: Clean Marriage Date Information
**********************************************************************************
* Step 1: Drop Individuals Outside of Data Range
* YoI == Year of Interest. (Created in Marriage_Filter.do)
drop if YoI < `data_start'
drop if YoI > `data_end'

* Step 2: Clean month_married Variable
* Drop if Only Season Reported (23 Couples, 0 "Spring"/"Winter") (Other cleaning done in Marriage_Filter)
count if month_married == 21 | month_married == 22
drop if month_married >= 13
label define monthlbl 1 "Jan" 2 "Feb" 3 "Mar" 4 "Apr" 5 "May" 6 "Jun" 7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec"
label values month_married monthlbl

* Step 3: Generate Delay Variable & Drop Individuals Married Outside of Seasons of Interest
gen delay = 0
drop if month_married > 3 & month_married < 10
replace delay = 1 if month_married < 4

* Step 4: Fix state variable
* TaxSim requires state == 0 when really state == .
replace state = . if state == 0
replace state = . if state == 0
replace siitax = . if state == .
replace c_siitax = . if state == .

**********************************************************************************
* Section 3: Convert to x-year Dollars and Select Marriage of Interest
**********************************************************************************
* Step 1: Run CPI Conversion File
local limited = 0
qui do Inflation_Adj `FiscalYear' `DollarMeasure' `limited'

* Step 2: Choose Marriage(s) of Interest
** Applies filtering rule to people who have more than one marriage in the dataset
qui do Marriage_of_Interest `MoI'

**********************************************************************************
* Section 5: Prep Data for Regression
**********************************************************************************
* Step 1: Run Data Prep Files
qui do Data_Prep1 `year_start' `year_end'
foreach y of global run_years {
	 qui do Data_Prep2 `y'
} 

* Step 2: Run Variable Corrections
** Correct pregnancy if birth not captured for partner
bys couple: egen preg_c = max(Pregnant)
replace Pregnant = preg_c
drop preg_c
** Correct new baby if birth not captured in partner
bys couple: egen baby_c = max(NewBaby)
replace NewBaby = baby_c
drop baby_c

* Step 3: Calculate Marriage Tax for All Base Child Assignments and Late Data
gen tot_wages = f_wages + m_wages
local listicle = "Bio HighE HoH Male Female"		
foreach A of local listicle {
	* Federal Marriage Tax
	gen MTAX_`A' = c_fiitax - TPreMT_`A'
	gen MTAX_`A'_pct = (MTAX_`A'/tot_wages)
	replace MTAX_`A'_pct = 0  if MTAX_`A' == 0 & tot_wages == 0

	label var MTAX_`A' "Marriage Tax Under Assignment `A'"
	label var MTAX_`A'_pct "Marriage Tax Pct Under Assignment `A'"
	
	* Federal and State Marriage Tax
	gen s_MTAX_`A' = c_fiitax + c_siitax - TPreMT_`A' - s_TPreMT_`A'
	gen s_MTAX_`A'_pct = (s_MTAX_`A'/tot_wages)
	replace s_MTAX_`A'_pct = 0  if s_MTAX_`A' == 0 & tot_wages == 0

	label var s_MTAX_`A' "Marriage (Federal and State) Tax Under Assignment `A'"
	label var s_MTAX_`A'_pct "Marriage Tax Pct (Federal and State) Under Assignment `A'"
}

* Step 4: Identify Pre-Marriage Tax Using Tax Minimization
gen MTAX_Min = .
gen s_MTAX_Min = .
foreach varname of local minims {
	if MTAX_Min == . {
		replace MTAX_Min = `varname'
		replace s_MTAX_Min = `varname' + s_`varname'
	}
	else {
		replace MTAX_Min = min(MTAX_Min, `varname')
		replace s_MTAX_Min = min(s_MTAX_Min, `varname' + s_`varname')
	}
}

** Calculate Marriage Tax
replace MTAX_Min = c_fiitax - MTAX_Min
label var MTAX_Min "Minimizes Over `minims'"
replace s_MTAX_Min = c_fiitax + c_siitax - s_MTAX_Min
label var s_MTAX_Min "Minimizes Over `minims' (w/ state taxes)"
** Calculate as Share of Total Wage Income
gen MTAX_Min_pct = MTAX_Min / tot_wages
replace MTAX_Min_pct = 0  if MTAX_Min == 0 & tot_wages == 0
label var MTAX_Min_pct "Minimizes Over `minims'"
gen s_MTAX_Min_pct = s_MTAX_Min / tot_wages
replace s_MTAX_Min_pct = 0  if s_MTAX_Min == 0 & tot_wages == 0
label var s_MTAX_Min_pct "Minimizes Over `minims' (w/ state taxes)"
