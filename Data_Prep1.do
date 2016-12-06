**********************************************************************************
** Marriage Tax Study
** Creates variables used in regressions
** 		Covers Data Calculated Once (not annual)
**********************************************************************************
args year_start year_end

**********************************************************************************
* Section 1: Create Primary Control Variables
**********************************************************************************
** Combined After Tax Income (Marital Income)
gen marital_inc = c_pwages + c_swages - c_fiitax
*gen marital_inc = c_pwages + c_swages
label var marital_inc "Combined Income After Federal Tax (Marital Income)"
gen s_marital_inc = c_pwages + c_swages - c_fiitax - c_siitax
label variable s_marital_inc "Combined Income After Federal and State Tax (Marital Income) "
gen marital_inc_sq = marital_inc * marital_inc
label variable marital_inc_sq "Square of Combined After Federal Tax Marital Income"
gen marital_inc_c = marital_inc_sq*marital_inc
label variable marital_inc_c "Cube of Combined After Federal Tax Marital Income"
* Further Adjust Marital Income Values (For thousand => tens of thousands, etc)
replace marital_inc = marital_inc
replace marital_inc_sq = marital_inc_sq/1000
replace marital_inc_c = marital_inc_c/1000
** Under 21    
* Temp_age set to a value that will not assign the person to either category if age is missing
gen temp_age = taxage
replace temp_age = 29 if noage == 1 
bys couple: egen age_min = min(temp_age)
gen under21 = 0
replace under21 = 1 if age_min < 21
label variable under21 "=1 if either individual is 20 or younger when married"
** Over 30   
gen over30 = 0
bys couple: egen age_max = max(temp_age)
replace over30 = 1 if age_max > 30
label variable over30 "=1 if either individual is 30 or older when married"
** Over 40   
gen over40 = 0
replace over40 = 1 if age_max > 40
label variable over40 "=1 if either individual is 40 or older when married"
drop temp_age /* age_max dropped in EITC sections */
** Sex  
replace sex = 0 if sex == 2
label variable sex "=1 if male"
** Year
gen year = YoI - 1900
label variable year "year when married"
** Note may be large. IE, married fall 1998, YOI = 1999 and year = 99

**********************************************************************************
* Section 2: Create Additional Control Variables
**********************************************************************************
* Step 1: Create Race Variables
** Race -- i_nonwhite
gen i_nonwhite = 0
replace i_nonwhite = 1 if race_head ~=1 | race_wife ~= 1
label variable i_nonwhite "Did not report race as white"
gen i_white = .
replace i_white = 1 if i_nonwhite == 0
replace i_white = 0 if i_nonwhite == 1
label var i_white "White (Male)"
** Race -- i_AfricanAmerican
gen i_africanamerican = 0
replace i_africanamerican = 1 if race_head == 2 | race_wife == 2
label variable i_africanamerican "reported race as African American"

* Step 2: Create Religion Variables
** Religion -- i_nonchristian
gen i_notchristian_head = 0
gen i_notchristian_wife = 0
replace i_notchristian_head = 1 if religion_head == 1 & YoI < 1985
replace i_notchristian_wife = 1 if religion_wife == 1 & YoI < 1985
replace i_notchristian_head = 1 if religion_head == 9 & YoI < 1985
replace i_notchristian_wife = 1 if religion_wife == 9 & YoI < 1985
replace i_notchristian_head = 1 if religion_head == 2 & YoI >= 1985
replace i_notchristian_wife = 1 if religion_wife == 2 & YoI >= 1985
replace i_notchristian_head = 1 if religion_head == 10 & YoI >= 1985
replace i_notchristian_wife = 1 if religion_wife == 10 & YoI >= 1985
replace i_notchristian_head = 1 if religion_head == 99 & YoI >= 1985
replace i_notchristian_wife = 1 if religion_wife == 99 & YoI >= 1985
replace i_notchristian_head = 1 if religion_head == 0 & YoI >= 1985
replace i_notchristian_wife = 1 if religion_wife == 0 & YoI >= 1985
** Relgion -- i_catholic
gen i_catholic_head = 0
gen i_catholic_wife = 0
replace i_catholic_head = 1 if religion_head == 8 & YoI < 1985
replace i_catholic_wife = 1 if religion_wife == 8 & YoI < 1985
replace i_catholic_head = 1 if religion_head == 1 & YoI >= 1985
replace i_catholic_wife = 1 if religion_wife == 1 & YoI >= 1985
** Relgion -- i_jewish
gen i_jewish_head = 0
gen i_jewish_wife = 0
replace i_jewish_head = 1 if religion_head == 9 & YoI < 1985
replace i_jewish_wife = 1 if religion_wife == 9 & YoI < 1985
replace i_jewish_head = 1 if religion_head == 2 & YoI >= 1985
replace i_jewish_wife = 1 if religion_wife == 2 & YoI >= 1985
** Relgion -- i_protestant
gen i_protestant_head = 0
gen i_protestant_wife = 0
replace i_protestant_head = 1 if i_notchristian_head == 0 & i_catholic_head == 0
replace i_protestant_wife = 1 if i_notchristian_wife == 0 & i_catholic_wife == 0
** VARIABLES NOT SETUP FOR PRE-1985
** Relgion -- i_muslim_rastafarian_etc
gen i_reli_etc_head = 0
gen i_reli_etc_wife = 0
replace i_reli_etc_head = 1 if religion_head == 10
replace i_reli_etc_wife = 1 if religion_wife == 10
** Relgion -- i_orthodox_christian
gen i_orthodox_christian_head = 0
gen i_orthodox_christian_wife = 0
replace i_orthodox_christian_head = 1 if religion_head == 13
replace i_orthodox_christian_wife = 1 if religion_wife == 13
** Relgion -- i_none_atheist_agnostic
gen i_none_ath_ag_head = 0
gen i_none_ath_ag_wife = 0
replace i_none_ath_ag_head = 1 if religion_head == 0 
replace i_none_ath_ag_wife = 1 if religion_wife == 0 


* Step 3: Adjust Religion Variables to Vary by Gender (Not HoH Status)
** Reassign Based on Gender, Not HoH Status
local relis = "notchristian catholic jewish protestant reli_etc orthodox_christian none_ath_ag"
foreach rel of local relis {
	gen i_`rel'_male = i_`rel'_head if sex == 1
	replace i_`rel'_male = i_`rel'_wife if sex == 0
	gen i_`rel'_female = i_`rel'_head if sex == 0
	replace i_`rel'_female = i_`rel'_wife if sex == 1
	drop i_`rel'_head i_`rel'_wife
}
** Label Variables
label var i_notchristian_male "Male Reports Non-Christian"
label var i_notchristian_female "Female Reports Non-Christian"
label var i_notchristian_male "Male Reports Non-Christian"
label var i_notchristian_female "Female Reports Non-Christian"
label var i_catholic_male "Male Reports Catholic"
label var i_catholic_female "Female Reports Catholic"
label var i_jewish_male "Male Reports Jewish"
label var i_jewish_female "Female Reports Jewish"
label var i_protestant_male "Male Reports Protestant"
label var i_protestant_female "Female Reports Protestant"
label var i_reli_etc_male "Male Reports Non-christian: muslim, rastafarian, etc"
label var i_reli_etc_female "Female Reports Non-christian: muslim, rastafarian, etc"
label var i_orthodox_christian_male "Male Reports Orthodox Christian"
label var i_orthodox_christian_female "Female Reports Orthodox Christian"
label var i_none_ath_ag_male "Male Reports None/Atheist/Agnostic"
label var i_none_ath_ag_female "Female Reports None/Atheist/Agnostic"

* Step 4: Create Region Variables
** Region -- i_northeast
gen i_northeast = 0
replace i_northeast = 1 if region_couple == 1
label variable i_northeast "Connecticut, Maine, Massachusetts, New Hampshire, New Jersey, New York, Pennsylvania, Rhode Island, Vermont"
** Region -- i_north_central
gen i_north_central = 0
replace i_north_central = 1 if region_couple == 2
label variable i_north_central "Illinois, Indiana, Iowa, Kansas, Michigan, Minnesota, Missouri, Nebraska, North Dakota, Ohio, South Dakota, Wisconsin"
** Region -- i_south
gen i_south = 0
replace i_south = 1 if region_couple == 3
label variable i_south "Alabama, Arkansas, Delaware, Florida, Georgia, Kentucky, Louisiana, Maryland, Mississippi, North Carolina, Oklahoma, South Carolina, Tennessee, Texas, Virginia, Washington DC, West Virginia"
** Region -- i_west
gen i_west = 0
replace i_west = 1 if region_couple == 4
label variable i_west "Arizona, California, Colorado, Idaho, Montana, Nevada, New Mexico, Oregon, Utah, Washington, Wyoming."
** Region -- i_alaska_hawaii
gen i_alaska_hawaii = 0
replace i_alaska_hawaii = 1 if region_couple == 5
label variable i_alaska_hawaii "ALASKA, HAWAII"
** Region -- i_foreign_country
gen i_foreign_country = 0
replace i_foreign_country = 1 if region_couple == 6
label variable i_foreign_country "Foreign Country"

* Step 5: State Fixed Effects
tabulate state, gen(t_stateFE_)
capture drop t_stateFE_1

* Step 6: Additional Control Variables
** Indicator if Not First Marriage for Either Individual
replace marriage_number = 1 if marriage_number >= 98
bys couple: egen max_marr_num = max(marriage_number)
gen i_multi_marr = 0
replace i_multi_marr = 1 if max_marr_num > 1
label variable i_multi_marr "=1 if not first marriage for at least one individual"
** Indicator if Not First Marriage for Head
gen head_marr_temp = 0
replace head_marr_temp = 1 if marriage_number > 1 & head == 1
egen i_head_marr = max(head_marr_temp)
drop head_marr_temp
label var i_head_marr "=1 if not first marriage for head"
** Number of Dependents
gen num_deps = c_depx
label variable num_deps "# of dependents in household"
** Children Indicator
* note that currently depchild == depx
gen i_children = 0
gen i_c_children = 0
replace i_children = 1 if depx > 0
replace i_c_children = 1 if c_depx > 0
label variable i_children "=1 if depx > 0 by individual"
label variable i_c_children "=1 if depx > 0 by couple"
** Clean Year Born Indicator
replace year_born = . if year_born < 1900 | year_born > 2011
replace year_born = YoI - taxage if year_born == . & taxage ~= .
gen year_born_HoH_temp = 0
replace year_born_HoH_temp = year_born if head
bys couple: egen year_born_HoH = max(year_born_HoH_temp)
drop year_born_HoH_temp
drop if year_born_HoH == .
** Generate HoH Taxage
gen HoH_taxage_temp = .
replace HoH_taxage_temp = taxage if head
bys couple: egen HoH_taxage = max(HoH_taxage_temp)
drop HoH_taxage_temp
drop if HoH_taxage == .
label var HoH_taxage "Head's Taxage in YoI"
gen HoH_taxage2 = HoH_taxage^2
label variable HoH_taxage2 "HoH's tax age squared"
** Generate Male Taxage
gen m_taxage_temp = .
replace m_taxage_temp = taxage if sex == 1
bys couple: egen m_taxage = max(m_taxage_temp)
drop m_taxage_temp
label var m_taxage "Male's Taxage in YoI"
gen f_taxage_temp = .
replace f_taxage_temp = taxage if sex == 0
bys couple: egen f_taxage = max(f_taxage_temp)
drop f_taxage_temp
label var f_taxage "Female's Taxage in YoI"
gen m_taxage2 = m_taxage^2/1000
label variable m_taxage2 "Male's tax age squared /1000"
gen f_taxage2 = f_taxage^2/1000
label variable f_taxage2 "Female's tax age squared /1000"
egen t_age = rowmax(m_taxage f_taxage)
bys couple : egen max_age = max(t_age)
egen t_age2 = rowmin(m_taxage f_taxage)
bys couple : egen min_age = min(t_age)
drop t_age*
** Retirement
gen retired = 0 
replace retired = 1 if employment == 4
label var retired "Retirement Indicator"
** Change in Marginal Tax Rate
gen Change_in_Rate = c_frate - frate
label variable Change_in_Rate "Calculate Change in METR Upon Marriage -- Federal Only"
gen s_Change_in_Rate = c_srate - srate
label variable s_Change_in_Rate "Calculate Change in METR Upon Marriage -- State and Federal"
** Two Earner Indicator
bys couple : egen min_income = min(pwages)
bys couple : egen max_income = max(pwages)
gen i_twoearner = 0
replace i_twoearner = 1 if min_income > 0
replace i_twoearner = . if max_income == 0
label variable i_twoearner "= 1 if couple's minimum income > 0"
drop min_income
** Year of MTAX Measurement
gen taxyear = YoI - 1

** Indicator for Prior Cohabitation Couple
gen cohabit = 1
replace pastage = 0 if pastage == .
bys couple: egen min_pastage = min(pastage)
replace cohabit = 0 if min_pastage == 0
drop min_pastage

* Step 7: Generate Income by Gender
* Male's Wages
gen m_wages_temp = 0
replace m_wages_temp = pwages if sex == 1
bys couple: egen m_wages = max(m_wages_temp)
drop m_wages_temp
label var m_wages "Male's Wage Inc."
* Female's Wages
gen f_wages_temp = 0
replace f_wages_temp = pwages if sex == 0
bys couple: egen f_wages = max(f_wages_temp)
drop f_wages_temp
label var f_wages "Female's Wage Inc."

* Step 8: Clean Number of Marriages Variable (for Summary Stat Table)
replace marr_howmany = . if marr_howmany > 95
replace marr_howmany_f = . if marr_howmany_f > 95
replace marr_howmany_m = . if marr_howmany_m > 95

**********************************************************************************
* Section 3: Control Variables Only Available with Full TAXSIM Output
**********************************************************************************
** Received Federal Credits
capture confirm variable c_FedTax_NoCredits
if !_rc {
	** i_rcvd_credits 
	* fiitax = Fedtax - FedCred --> FedCred > 0 if FedTax-fiitax > 0
	gen c_FedCred = c_fiitax - c_FedTax_RegTax
	gen i_rcvd_credits = 0
	replace i_rcvd_credits = 1 if c_FedCred < 0
	label variable i_rcvd_credits "=1 if couple received tax credits on their return"
	
	** c_FedCred
	* Just use c_FedCred for amt of credits rcvd by couple
	label variable c_FedCred "amount of federal tax credits couple rcvd on their return"
	}

**********************************************************************************
** Section 4: Education Variables
**********************************************************************************
* Step 1: Apply Education Info Across Couples
* Head
gen hoh_ed_temp = 0
replace hoh_ed_temp = education if education < 99 & head == 1
bys couple: egen HoH_Ed = max(hoh_ed_temp)
replace HoH_Ed = . if HoH_Ed < 0
* Spouse
gen SP_ed_temp = 0
replace SP_ed_temp = education if education < 99 & head == 0
bys couple: egen SP_Ed = max(SP_ed_temp)
* Clean vars
drop hoh_ed_temp SP_ed_temp
* Minimum education in couple
bys couple: egen min_educ = min(education) if education < 99
replace min_educ = 0 if min_educ == .
* Maximum education in couple
bys couple: egen max_educ = max(education) if education < 99
replace max_educ = 0 if max_educ == .

* Education Control Variables
gen educ_sq = education^2
gen educ_3rd = education^3

**********************************************************************************
** Section 5: Generate Variables to Be Calcualted Annually
**********************************************************************************
gen Pregnant = 0
gen NewBaby = 0
gen mean_change_in_burden = .
gen s_mean_change_in_burden = .

**********************************************************************************
** Section 6: Review Final Data Set
**********************************************************************************
* Step 1: Observe Couples by Size
bys couple: gen CoupleCount = _n
count if CoupleCount == 1
scalar NumOfCouples = r(N)

bys couple: replace couple_size = _N
count if couple_size > 2  & CoupleCount == 1
scalar CrowdedCouples = r(N)

count if couple_size == 1  & CoupleCount == 1
scalar Singletons = r(N)

count if couple_size == 2  & CoupleCount == 1 
scalar Duopolies = r(N)


* Step 2: Report Results on Couples
if CrowdedCouples == 0 {
	di as text "Of " NumOfCouples " couples " CrowdedCouples " have more than 2 members" 
	}
else {
	di as error "Of " NumOfCouples " couples " CrowdedCouples " have more than 2 members" 
	}
	
* Step 3: Report Additional Couple Information
qui count if CoupleCount == 1	
scalar Total_Couples = r(N)
di as text "Of " as result NumOfCouples as text " couples " as result Singletons as text " have only 1 member" 
di as text "Of " as result NumOfCouples as text " couples " as result Duopolies as text " have 2 members" 
scalar OnesOverTwos = Singletons/Duopolies
di as text "percentage of singletons  " as error OnesOverTwos
di as text "number of couples         " as error Total_Couples






