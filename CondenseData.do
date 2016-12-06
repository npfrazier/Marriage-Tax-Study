**********************************************************************************
** Marriage Tax Study
** Data Condense File
** 		Condenses All Variables to Year of Interest Observation Only
**********************************************************************************

* Step 1: Identify Variables to Condense
** Distinguish between variables with and without couple analogues
#delimit ;
local nocouple_vars "taxage age head min_head max_head noage spouse_in employment
	race_head race_wife religion_head religion_wife region_couple Children_Over2
	brothers_head brothers_wife sisters_head sisters_wife education high_earner
	marr_howmany_f marr_howmany_m";
local couple_vars "mstat agex depx fiitax siitax fica frate pwages swages srate 
	ficar Child state depchild childcare dividends otherprop stcg ltcg ui 
	gssi pensions proptax rentpaid transfers mortgage otheritem year";
#delimit cr	
capture confirm variable FedAGI1993
if !_rc {
	#delimit ;
	local couple_vars2 ="FedAGI FedTax_RegTax FedCred_RefCTC FedCred_EITC FedTax_NoCredits";
	#delimit cr	
}

* Step 2: Create Variables to Store Data
* Put the "keep_" to avoid ambiguous abbreviation
foreach varname of local couple_vars {
	gen keep_`varname' = .
	gen keep_c_`varname' = .
	}
foreach varname of local couple_vars2 {
	gen keep_`varname' = .
	gen keep_c_`varname' = .
	}
foreach varname of local nocouple_vars {
	gen keep_`varname' = .
	}
* Create Cohabitation Variable
gen keep_pastage = .

* Step 3: Replace Variables if YOI
foreach y of global run_years {	
	* Previous Age Measurement
	if `y' < 1997 {
		local ny = `y' + 1
	else { 
		local ny = `y' + 2
		}
	}
	replace keep_pastage = age`y' if YoI == `ny'
	* Couple Variables
	foreach varname of local couple_vars {
		capture confirm variable `varname'`y'
		if !_rc {
			replace keep_`varname' = `varname'`y' if YoI == `y'
			replace keep_c_`varname' = c_`varname'`y' if YoI == `y'
			drop `varname'`y'
			drop c_`varname'`y'
		}
	}
	foreach varname of local couple_vars2 {
		capture confirm variable `varname'`y'
		if !_rc {
			replace keep_`varname' = `varname'`y' if YoI == `y'
			replace keep_c_`varname' = c_`varname'`y' if YoI == `y'
			drop `varname'`y'
			drop c_`varname'`y'
		}
	}
	* Individual Variables
	foreach varname of local nocouple_vars {
		replace keep_`varname' = `varname'`y' if YoI == `y'
		drop `varname'`y'
	}
}
		
* Step 4: Rename Final Values
foreach varname of local couple_vars {
	rename keep_`varname' `varname'
	rename keep_c_`varname' c_`varname'
}
foreach varname of local couple_vars2 {
	rename keep_`varname' `varname'
	rename keep_c_`varname' c_`varname'
}
foreach varname of local nocouple_vars {
	rename keep_`varname' `varname'
}
rename keep_pastage pastage

* Step 5: Drop Unneeded Variables and Problematic Observations
drop year c_year 
capture drop c_taxsimid*
** Drop if not a year included in survey
** Drop using mstat - should not be missing if year is run
drop if mstat == .

* Step 6: Drop Couples without a Head of Household in YoI
drop if max_head == 0
drop if min_head == 1

* Step 7: Drop Couples without a Spouse in YoI
drop if spouse_in == 0
	

