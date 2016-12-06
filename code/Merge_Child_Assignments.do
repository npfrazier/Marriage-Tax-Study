**********************************************************************************
** Marriage Tax Study
** PreM_Tax_Merge 
**		Combines Pre-Marital Tax Data Across Child Assignments
**********************************************************************************

**********************************************************************************
* Section 1: File Setup
**********************************************************************************
* Step 1: Run Setup
capture clear all
set more off

**********************************************************************************
* Section 2: Collect Data
**********************************************************************************
* Step 1: Pull Data for Head of Household Assignment
local dname = "$data_dir"+"condensed_step0.dta"
use "`dname'"

keep family ID couple marriage_number fiitax siitax
rename fiitax PreMT_HoH
rename siitax s_PreMT_HoH
label var PreMT_HoH "Individual Tax Before Marriage with Head Child Assignment"
label var s_PreMT_HoH "Individual State Tax Before Marriage with Head Child Assignment"

* Step 2: Pull Data for Highest Earner
local dname = "$data_dir"+"\condensed_step3.dta"
merge 1:1 family ID marriage_number using "`dname'", keepusing(fiitax siitax)
rename fiitax PreMT_HighE
rename siitax s_PreMT_HighE
replace PreMT_HighE = . if _merge == 1
replace s_PreMT_HighE = . if _merge == 1
drop _merge
label var PreMT_HighE "Individual Tax Before Marriage with High Earner Child Assignment"
label var s_PreMT_HighE "Individual State Tax Before Marriage with High Earner Child Assignment"

* Step 3: Pull Data for Biological Assignment
local dname = "$data_dir"+"\condensed_step1.dta"
merge 1:1 family ID marriage_number using "`dname'", keepusing(fiitax siitax)
rename fiitax PreMT_Bio
rename siitax s_PreMT_Bio
replace PreMT_Bio = . if _merge == 1
replace s_PreMT_Bio = . if _merge == 1
drop _merge
label var PreMT_Bio "Individual Tax Before Marriage with Biological Child Assignment"
label var s_PreMT_Bio "Individual State Tax Before Marriage with Biological Child Assignment"

* Step 4: Pull Data for Assigning to Male
local dname = "$data_dir"+"\condensed_step4.dta"
merge 1:1 family ID marriage_number using "`dname'", keepusing(fiitax siitax)
rename fiitax PreMT_Male
rename siitax s_PreMT_Male
replace PreMT_Male = . if _merge == 1
replace s_PreMT_Male = . if _merge == 1
drop _merge
label var PreMT_Male "Individual Tax Before Marriage with Male Child Assignment"
label var s_PreMT_Male "Individual State Tax Before Marriage with Male Child Assignment"

* Step 5: Pull Data for Assigning to Female
local dname = "$data_dir"+"\condensed_step5.dta"
merge 1:1 family ID marriage_number using "`dname'", keepusing(fiitax siitax)
rename fiitax PreMT_Female
rename siitax s_PreMT_Female
replace PreMT_Female = . if _merge == 1
replace s_PreMT_Female = . if _merge == 1
drop _merge
label var PreMT_Female "Individual Tax Before Marriage with Male Child Assignment"
label var s_PreMT_Female "Individual State Tax Before Marriage with Male Child Assignment"

**********************************************************************************
* Section 3: Generate Total Tax Liability Under All Three Scenarios
**********************************************************************************
* Step 1: Establish Assignment List
local listicle = "Bio HighE HoH Male Female"

* Step 2: Calculate Total Tax Liability (Current Year Data)
foreach A of local listicle {
	** Federal Tax Liability
	bys couple: egen TPreMT_`A' = sum(PreMT_`A')
	label var TPreMT_`A' "Total Tax Before Marriage"
	gen error = 0
	replace error = 1 if PreMT_`A' == .
	bys couple: egen error2 = max(error)
	replace TPreMT_`A' = . if error2 == 1
	drop error error2
	** State Tax Liability
	bys couple: egen s_TPreMT_`A' = sum(s_PreMT_`A')
	label var s_TPreMT_`A' "Total State Tax Before Marriage"
	gen error = 0
	replace error = 1 if s_PreMT_`A' == .
	bys couple: egen error2 = max(error)
	replace s_TPreMT_`A' = . if error2 == 1
	drop error error2
}


