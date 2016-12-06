**********************************************************************************
** Marriage Tax Study
** Data Refresh File
** 		Merges Marriage and Primary Datasets
** 		Filters for Eligible Marriaged
** 		Allocates Children
**		Runs TAXSIM
**********************************************************************************
args genmarriage year_start year_end step min_marr_years max_18 wrong_anniversary 

**********************************************************************************
* Section 1: Prep Marriage File and Primary PSID Data File
**********************************************************************************
* Step 1: Run Marriage Data File Generation if Specified
if `genmarriage' {
	do Refresh_MHF `year_start' `year_end'
}

* Step 2: Prep Main Data File
use "$RAW_data"

* Step 3: Drop Families Outside of Main PSID Sample
drop if ER30001 > 2931

* Step 4: Run Rename File for Set Years
qui do Refresh_Rename_Vars

* Step 5: Calculate Age and Count Children
foreach y of global run_years {
	do Refresh_Children `y'
}

**********************************************************************************
* Section 2:  Merge Marriage Data and Main File
**********************************************************************************
* Step 1: Transfer Data for Individuals not in the PSID
** Transfer Non-Annual Data
qui do Refresh_Merge_MHF

**********************************************************************************
* Section 3:  Filter for Individuals with Eligible Marriages
**********************************************************************************
* Step 1: Reduce Sample to Individuals Married in Eligible Years
do Refresh_Marriages `year_start' `year_end' `min_marr_years' `max_18' `wrong_anniversary'

* Step 2: Drop Out of Sample Individuals
drop if YoI < `year_start'

**********************************************************************************
* Section 4: Allocate Children to Individuals
**********************************************************************************
* Step 1: For each year, run all allocation schemes
foreach y of global run_years {
	do Refresh_Allocate_Children `y' `step'
	}

* Step 2: Drop Irrelevant Variables
	if `step' ~= 1 { 
		drop ChildS*
	}
	if `step' ~= 2 {
		drop ChildP*
	}
	if `step' ~= 3 {
		drop ChildH*
	}

**********************************************************************************
* Section 5: Run TAXSIM
**********************************************************************************
* Step 1: Drop Unused Variables
capture drop ER*
capture drop V*

* Step 2: Run Filter to TAXSIM over Run Years
foreach y of global run_years {
	do Refresh_TAXSIM `y' `step'
}

* Step 3: Rename and Clean Additional Control Variables (race, religion, siblings)
foreach y of global run_years {
	do Refresh_Controls `y'
}

* Step 4: Drop Unused Variables
capture drop t19*
capture drop t20*
