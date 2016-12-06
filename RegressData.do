**********************************************************************************
** Marriage Tax Study
** Runs Regressions contained in tables in paper
**		Define some universal regression options
**		Run some regressions for all child assignments
**		Run additional regressions for HoH (core) assignment
**		Run False Specification Regression
**********************************************************************************

* Step 1: Choose Regressions Options
* OLS vce() clust var
local cluster_var = "family"         /*e.g. state, family, robust */
* Children Allocation Assumptions
local reg_steps = "Bio HighE HoH Male Female Min" /* Bio HighE HoH Male Female Min */
* Baseline covariates
local indvarsF1 "marital_inc marital_inc_sq t_fix_* c_depx "
* Extended covariates
local indvarsF2 "Pregnant NewBaby m_age m_age2"
* Year fixed effects
local y_fix "Yes" /* Indicate if using year Fixed Effects */

* Step 2: Run Regressions for All Allocations
foreach name of local reg_steps {
	* Step A: Set MTAX Variable as Current Name/Step
	capture drop mtax* 
	gen mtax = MTAX_`name'
	gen mtax_pct = MTAX_`name'_pct
	gen mtax_pct_s = s_MTAX_`name'_pct
	label var mtax "MTax Level"
	label var mtax_pct "MTax (\%Inc)"
	label var mtax_pct_s "F S MTax (\%Inc)"

	* Step B: Run our baseline regressions
	qui reg delay mtax_pct `indvarsF1', vce(cluster `cluster_var')
	qui eststo `name'_lite, title("`name'")
	qui estadd local Yr_FE "`y_fix'", replace
	qui reg delay mtax_pct `indvarsF1' `indvarsF2', vce(cluster `cluster_var')
	qui eststo `name'_full, title("`name'")
	qui estadd local Yr_FE "`y_fix'", replace
	qui estadd local ST_FE "No" , replace
	qui reg delay mtax_pct `indvarsF1' `indvarsF2' t_stateFE_*, vce(cluster `cluster_var')
	qui eststo `name'_full_SF, title("`name'")
	qui estadd local Yr_FE "`y_fix'", replace
	qui estadd local ST_FE "Yes" , replace
	qui estadd local Rel_FE "No", replace
	qui estadd local Reg_FE "No", replace
	qui estadd local Race_FE "No", replace

	* Step C: Test inclusion of secondary controls
	qui test `indvarsF2'
	di "F-test on secondary controls for model `name'  " as error round(r(F),.01) ", pval= " round(r(p),.0001)
	* save f-stat for write_tables.do
	local f_stat_`name' = round(r(F),.01)
	
	* Step E: Run our focused sample regression
	qui reg delay mtax_pct `indvarsF1' `indvarsF2' if month_married < 3 | month_married > 10, vce(cluster `cluster_var')
	qui eststo `name'_focus, title("`name'")
	qui estadd local Yr_FE "`y_fix'", replace
} /* end of regression loop */

* Step 3: Run Additional Regressions for HoH
* Step A: Set MTAX Variable as Current Name/Step
capture drop mtax* 
gen mtax = MTAX_HoH
gen mtax_pct = MTAX_HoH_pct
gen mtax_pct_s = s_MTAX_HoH_pct
label var mtax "MTax Level"
label var mtax_pct "MTax (\%Inc)"
label var mtax_pct_s "F S MTax (\%Inc)"

* Step 4: Run exploratory regression of mtax on Income + controls
qui reg mtax `indvarsF1', vce(cluster `cluster_var')
qui eststo HoH_MTAX_LEVEL
qui estadd local Yr_FE "`y_fix'", replace
qui reg mtax `indvarsF1' `indvarsF2', vce(cluster `cluster_var')
qui eststo HoH_MTAX_LEVEL2
qui estadd local Yr_FE "`y_fix'", replace
qui reg mtax_pct `indvarsF1', vce(cluster `cluster_var')
qui eststo HoH_MTAX_pct
qui estadd local Yr_FE "`y_fix'", replace
qui reg mtax_pct `indvarsF1' `indvarsF2', vce(cluster `cluster_var')
qui eststo HoH_MTAX_pct2
qui estadd local Yr_FE "`y_fix'", replace

* Step 5: Run our baseline regressions in level/MLE form
qui reg delay mtax `indvarsF1' `indvarsF2', vce(cluster `cluster_var')
qui eststo HoH_level, title("MTAX Level")
qui estadd local Yr_FE "`y_fix'", replace
qui estadd local ST_FE "No" , replace
qui estadd local Rel_FE "No", replace
qui estadd local Reg_FE "No", replace
qui estadd local Race_FE "No", replace
qui probit delay mtax_pct `indvarsF1' `indvarsF2', vce(cluster `cluster_var')
qui eststo HoH_probit, title("Probit") : margins, atmeans dydx(*) post
qui estadd local Yr_FE "`y_fix'", replace
qui estadd local ST_FE "No" , replace
qui logit delay mtax_pct `indvarsF1' `indvarsF2', vce(cluster `cluster_var')
qui eststo HoH_logit, title("Logit") : margins, atmeans dydx(*) post
qui estadd local Yr_FE "`y_fix'", replace
qui estadd local ST_FE "No" , replace

* Step 6: Run Variable Robustness Regressions
** Everything
qui reg delay mtax_pct `indvarsF1' `indvarsF2' i_white i_africanamerican i_west i_south i_northeast ///
	SP_Ed HoH_Ed i_catholic_male i_jewish_male i_protestant_male t_stateFE_*, vce(cluster `cluster_var')
qui eststo HoH_wall
qui estadd local ST_FE "Yes" , replace
qui estadd local Yr_FE "`y_fix'", replace
qui estadd local Rel_FE "Yes", replace
qui estadd local Reg_FE "Yes", replace
qui estadd local Race_FE "Yes", replace

* Step 7: Run State Tax Regressions
qui reg delay mtax_pct_s `indvarsF1' `indvarsF2' t_stateFE_*, vce(cluster `cluster_var')
qui eststo HoH_state, title("`name'")
qui estadd local ST_FE "Yes" , replace
qui estadd local Yr_FE "`y_fix'", replace
qui estadd local Rel_FE "No", replace
qui estadd local Reg_FE "No", replace
qui estadd local Race_FE "No", replace

* Step 8: Run Income Sensitivity Tests
local indvarsF1_b "m_wages f_wages marital_inc_sq t_fix_* c_depx"
*marital_inc_sq
qui reg delay mtax_pct `indvarsF1_b' `indvarsF2', vce(cluster `cluster_var')
qui eststo HoH_ginc
qui estadd local ST_FE "No" , replace
qui estadd local Yr_FE "Yes", replace
qui estadd local Rel_FE "No", replace
qui estadd local Reg_FE "No", replace
qui estadd local Race_FE "No", replace
	
* Step 9: Run False Specification Regression for Q3
local specdata = "$data_dir"+"/falsespecdata_Q3.dta"
use "`specdata'", replace
gen m_age = m_taxage + 1
gen m_age2 = m_age*m_age
qui reg delay mtax_pct `indvarsF1' `indvarsF2', vce(cluster `cluster_var')
qui eststo False_SpecQ3, title("False Spec 3")
qui estadd local Yr_FE "`y_fix'", replace
clear 
