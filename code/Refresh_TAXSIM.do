**********************************************************************************
** Marriage Tax Study
** Prep for TAXSIM Run
**		Idea: Assume all file separately, then create a new obs summed over couples
**		* Couple variables have `c_' preceding var name
** 		Generate input variables for TAXSIM (not all used in paper)
** 		Set unmodelled variables to 0
** 		Run TAXSIM
**********************************************************************************
args y step

local calc_state     = 1
local calc_agex      = 1
local calc_depx      = 1
local calc_depchild  = 1
local calc_mstat     = 1
local calc_pwages    = 1
local calc_swages    = 1
** Not used in final version of paper **
local calc_asset_inc = 0 
  local asset_assign "ltcg" /* choose tax treatment for all asset income */
*	  Choices: "stcg" "ltcg" "dividends" "otherprop"
local calc_pensions  = 0
local calc_gssi      = 0
local calc_rentpaid  = 0
local calc_childcare = 0 /* recc: '88 and later only */
local calc_ui        = 0
local calc_proptax 	 = 0

/* Taxsim Input Variables
year: (survey year minus 1)
state:  state identifier. These are numeric codes from 1 to 51 (Alabama to Wyoming in alphabetical order) with zero indicating "no state tax".
agex: Number of age 65+ taxpayers. 0, 1 or 2.
depx: Number of dependents (usually kids, but can be any age) per tax form. Must not be less than depchild (below).
depchild: Number of dependent children under 17 (for child credit).
mstat: Marital status 1 for single, 2 for joint, 3 for head of household. Ignore "file as a dependent"
pwages: Wage income of primary taxpayer
swages: Wage income of secondary taxpayer
<NA> dividends: Dividend income
<NA> otherprop: Interest and other property income. This may be negative. You can put net alimony here, and subtract any adjustments such as IRAs, Keoghs and self employment tax, to the extent that yuo may know such items.
<NA> stcg: Short term capital gain or loss (+/-).
<NA> ltcg: Long term capital gain or loss (+/-).
<NA> pensions: Taxable pension income
<NA> gssi: Gross social security benefits. Taxsim will calculate the portion includable in AGI.
<NA> transfers: Non-taxable transfer income, used for calculating low income credits and property tax credits on state taxes.
<NA> rentpaid: Rent paid is used in some state property tax credits.
<NA> proptax: Property tax paid is an itemized deduction and is a preference for the AMT.
<NA> otheritem: Taxes paid other than state income taxes. Taxsim will use its own calculated state income tax as an itemized deduction. These are preferences for the AMT.
<NA> childcare: Child care expenses are a credit in the federal tax.
<NA> ui: Unemployment compensation benefits. Taxsim will calculate the portion included in AGI.
<NA> mortgage: Mortgage interest paid, possibly plus charitable contibutions, and some minor items that are not preferences for the AMT.
*/

**********************************************************************************
* Section 1: Setup
**********************************************************************************
* Step 1: Load parameters

rename t`y'_head head`y'
rename t`y'_c_Child c_Child`y'
rename t`y'_Child Child`y'
rename t`y'_max_head max_head`y'
rename t`y'_min_head min_head`y'
rename t`y'_age age`y'

* Step 2: Setup Loop and Variables for Annual Calculation
*Generate TaxYear
gen year`y' = `y' -1 
* Couple Version
gen c_year`y' = year`y'
	
**********************************************************************************
* Section 2: Calculate State of Residence
**********************************************************************************
* Step 1: Calculate State Variables
gen state`y' = 0
gen c_state`y' = 0

if `calc_state' == 1 {
	capture confirm variable t`y'_state1
	if !_rc {
		* Replace for Alabama
		replace state`y' = 1 if t`y'_state1 == 1
		* Replace for Arizona - Georgia
		replace state`y' = t`y'_state1 + 1 if t`y'_state1 >= 2 & t`y'_state1 <= 10
		* Replace for Idaho - Wyoming
		replace state`y' = t`y'_state1 + 2 if t`y'_state1 >= 11 & t`y'_state1 <= 49
		* Replace for Alaska
		replace state`y' =  2 if t`y'_state1 == 50
		* Replace for Hawaii
		replace state`y' =  12 if t`y'_state1 == 51
		}
	* Step 2: Calculate Couple State	
	gen c_state`y'_temp = 0
	replace c_state`y'_temp = state`y' if head`y' == 1
	bys couple: egen c_state`y'_temp2 = max(c_state`y'_temp)
	replace c_state`y' = c_state`y'_temp2
	drop c_state`y'_temp*
	}
* state taxes not available before 1977
if `y' < 1977 {
	replace state`y' = 0
	replace c_state`y' = 0
	}
	
capture drop t`y'_state*

**********************************************************************************
* Section 3: Calculate Elderly Exemption
**********************************************************************************	
gen agex`y' = 0
gen c_agex`y' = 0

if `calc_agex' == 1 {
	* Step 1: Calculate Individual Elderly Status
	replace agex`y' = 1 if t`y'_taxage > 65 & t`y'_taxage ~= . & noage`y' ~= 1

	* Step 2: Calculate Couple Elderly Status
	bys couple: egen c_agex_temp = sum(agex`y')
	replace c_agex`y' = c_agex_temp
	drop c_agex_temp
	}

gen taxage`y' = t`y'_taxage
drop t`y'_taxage

**********************************************************************************
* Section 4: Generate Dependents
**********************************************************************************
gen depx`y' = 0
gen c_depx`y' = 0

if `calc_depx' == 1 {
	replace c_depx`y' = c_Child`y'
	if `step' == 0 {
		replace depx`y' = Child`y'
		}
	if `step' == 1 {
		replace depx`y' = ChildS`y'
		}
	if `step' == 2 {
		replace depx`y' = ChildP`y'
		}
	if `step' == 3 {
		replace depx`y' = ChildH`y'
		}
	if `step' == 4 {
		replace depx`y' = ChildF`y'
		}
	if `step' == 5 {
		replace depx`y' = ChildM`y'
		}
	}

**********************************************************************************
* Section 5: Generate Young Children Dependents
**********************************************************************************
gen depchild`y' = 0
gen c_depchild`y' = 0 

if `calc_depchild' == 1 {
	replace depchild`y' = depx`y'
	replace c_depchild`y' = c_depx`y'
	}

**********************************************************************************
* Section 6: Calculate Filing Status
**********************************************************************************
* Step 1: Calculate Individual Filing Status
** Default: single, no dependents
gen mstat`y' = 1
if `calc_mstat' == 1 {
	* HOH if dependents
	replace mstat`y' = 3 if depchild`y' > 0
}

* Step 2: Set Couple Filing Status to Joint
gen c_mstat`y' = 2

**********************************************************************************
* Section 6: Calculate Childcare Expenses
**********************************************************************************	
** Not used in final version of paper

gen childcare`y' = 0
gen c_childcare`y' = 0

**********************************************************************************
* Section 7: Calculate Primary Earner Wages 
**********************************************************************************
gen  pwages`y' = 0
if `calc_pwages' == 1 {
	** Replace False Entries
	if `y' == 1994 | `y' == 1995 { 
		replace t`y'_pwages1 = 0 if t`y'_pwages1 == 9999999
		}
	replace pwages`y' = t`y'_pwages1 if head`y' == 1
	}
capture drop t`y'_pwages*


**********************************************************************************
* Section 8: Calculate Secondary Earner Wages 
**********************************************************************************
** Note: Farm income not included after 1993 (not available) darn!
gen swages`y' = 0
if `calc_swages' == 1 {
	if `y' <= 1993 {
		replace swages`y' = t`y'_swages1 if t`y'_swages1 ~= .
		}
	else {
		replace swages`y' = t`y'_swages3 + t`y'_swages5 if t`y'_swages3 + t`y'_swages5 ~= .
		}
	}
capture drop t`y'_swages*

**********************************************************************************
* Section 9: Calculate Couple Wages
**********************************************************************************
* Step 1: Generate Couple Pwages
** Primarily use head's reporting for pwages
gen c_pwages`y' = .
replace c_pwages`y' = pwages`y' if head`y' == 1
replace c_pwages`y' = 0 if c_pwages`y' == .
bys couple: egen pwage_temp = max(c_pwages`y')
replace c_pwages`y' = pwage_temp
drop pwage_temp

* Step 2: Generate Couple Swages
** Primarily use spouse's reporting for swages
gen c_swages`y' = .
replace c_swages`y' = swages`y' if head`y' ~= 1
replace c_swages`y' = 0 if c_swages`y' == .
bys couple: egen swage_temp = max(c_swages`y')
replace c_swages`y' = swage_temp
drop swage_temp

* Step 3: Calculate Single Wages for Head
* Heads have no spouse
replace swages`y' = 0 if head`y' == 1

* Step 4: Calculate Single Wages for Spouse
* Spouses are primary earners
replace pwages`y' = swages`y' if head`y' ~= 1
* Spouses have no spouse
replace swages`y' = 0 if head`y' ~= 1
* Now they are filing single, so if (female) then (pwages:=swages)

**********************************************************************************
* Section 10: Calculate Dividends, Other Property Income and Capital Gains
**********************************************************************************
** Not used in final version of paper
gen dividends`y' = 0
gen c_dividends`y' = 0
gen otherprop`y' = 0
gen c_otherprop`y' = 0
gen stcg`y' = 0
gen c_stcg`y' = 0
gen ltcg`y' = 0	
gen c_ltcg`y' = 0

**********************************************************************************
* Section 9: Calculate Unemployment Income
**********************************************************************************	
** Not used in final version of paper
gen ui`y' = 0
gen c_ui`y' = 0

**********************************************************************************
* Section 11: Calculate Social Security Income
**********************************************************************************
** Not used in final version of paper
gen gssi`y' = 0
gen c_gssi`y' = 0

**********************************************************************************
* Section 12: Calculate Taxable Pension Income
**********************************************************************************
** Not used in final version of paper
gen pensions`y' = 0
gen c_pensions`y' = 0

**********************************************************************************
* Section 13: Calculate Property Tax Paid
**********************************************************************************
** Not used in final version of paper
gen proptax`y' = 0
gen c_proptax`y' = 0

**********************************************************************************
* Section 14: Calculate Rent Paid
**********************************************************************************
** Not used in final version of paper
gen rentpaid`y' = 0
gen c_rentpaid`y' = 0

**********************************************************************************
* Section 15: Set to Unavailable Variables to Zero
**********************************************************************************	
** Never captured in data
gen transfers`y' = 0 
gen c_transfers`y' = transfers`y'
gen mortgage`y' = 0
gen c_mortgage`y' = mortgage`y'
gen otheritem`y' = 0
gen c_otheritem`y' = otheritem`y'

**********************************************************************************
* Section 16: Run TAXSIM
**********************************************************************************	
* Step 1: Run TAXSIM Model
di "step `step' in `y'"
if `y' >= 1977 {
	local statetaxes = 1
	}
else {
	local statetaxes = 0
	}
local full = 1
* Run as single
local married_values = 0 /* run with the individual values */
do Refresh_CallTaxsim `statetaxes' `full' `married_values' `y' 
* Run as married
local married_values = 1 /* run with the married values */
do Refresh_CallTaxsim `statetaxes' `full' `married_values' `y' 
