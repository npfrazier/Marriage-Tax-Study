**********************************************************************************
** Marriage Tax Study
** 		Labels Variables for Regression Results
**********************************************************************************

**********************************************************************************
* Section 1: Re-label variables for easy regression output
**********************************************************************************
* MTAX
label var delay "Delay"
label var MTAX_HoH "MTax Level"
label var MTAX_HoH_pct "MTax (\%Inc)"
label var s_MTAX_HoH_pct "S F MTax (\%Inc)"

* Sample Summary Vars
label var num_deps "\#_deps"
label var YoI "Year"

* Main MTAX vars
label var marital_inc "Marital Income"
label var i_c_children "Children"
label var c_depx "Number of Children"
label var year "Year"

* Main additional vars
label var Pregnant "Pregnant"
label var NewBaby "New Baby"
label var i_multi_marr "Multiple Marriages"

* Other vars
label var marital_inc_sq "(Marital Income)$^2$"
label var marital_inc_c "(Marital Income)$^3$"
label var m_wages "Male's Income"
label var f_wages "Female's Income"
label var under21 "Under 21"
label var over40 "Over 40"
label var i_twoearner "Two Earner HH"
label var i_twoearner "Two Earners"
label var i_rcvd_credits "RCVD Credits"
label var taxage "Individual Age"
label var m_taxage "Male's Age"
label var f_taxage "Female's Age"
label var m_taxage2 "(Male's Age)$^2$"
label var f_taxage2 "$($Female's Age)$^2$"
label var m_age "Male's Age"
label var m_age2 "(Male's Age)$^2$"
label var f_age "Female's Age"
label var HoH_taxage "Head's Age"
label var i_nonwhite "Non-White (Male)"
label var i_northeast "NorthEast"
label var i_south "South"
label var i_west "West"
label var education "Yrs. Educ"
label var educ_sq "(Yrs. Educ)$^2$"
label var educ_3rd "(Yrs. Educ)$^3$"
label var year_born_HoH "Year Head Born"
label var year_born "Year Male Born"
label var i_catholic_male "Catholic (Male)"
label var i_protestant_male "Protestant (Male)"
label var i_notchristian_male "Non-Christian (Male)"
label var i_jewish_male "Jewish (Male)"
label var i_catholic_female "Catholic (Female)"
label var i_protestant_female "Protestant (Female)"
label var i_notchristian_female "Non-Christian (Female)"
label var i_jewish_female "Jewish (Female)"
label var marr_howmany "Number of Marriages"
label var SP_Ed "Wife's Education"
label var HoH_Ed "Head's Education"
label var i_northeast "Northeast"
label var i_africanamerican "African American (Male)"
label var i_c_children "Child Indicator"


		
