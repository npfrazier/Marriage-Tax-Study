**********************************************************************************
** Marriage Tax Study
** CallTaxsim - run Taxsim for year `y'
** 		Preps Taxsim inputs
** 		Runs Taxsim
** 		Processes output
**********************************************************************************
args statetaxes fulltaxes married_values y

**********************************************************************************
* Section 1: Select Correct Set of Run Options
**********************************************************************************
if (`fulltaxes' == 1 & `statetaxes' == 1) {
	local opts "full replace"
	}
else if `statetaxes' == 1 {
	local opts "replace"
	}
else if `fulltaxes' == 1 {
	replace state`y' = 0
	local opts "full replace"
	}	
else {
	capture gen state`y' = 0
	replace state`y' = 0
	local opts "replace"
	}


********************************************************************
* Section 2: Prep Variables for TAXSIM
********************************************************************
* Step 1: Identify Input Variables
#delimit ;
local taxsiminput "year state mstat agex depx pwages 
 swages dividends otherprop pensions gssi transfers 
 rentpaid proptax otheritem childcare ui depchild 
 mortgage stcg ltcg";
 #delimit cr
 
* Step 2: Strip PSID vars of `y' (so taxsim reads them)
if `married_values' == 0 {           /*individual values */
	foreach name of local taxsiminput {
		rename `name'`y' `name'
	}
}                                     /* couple values */
else {
	foreach name of local taxsiminput {
		rename c_`name'`y' `name'
	}
}

**********************************************************************************
* Section 3: Run TAXSIM and Label Output
**********************************************************************************
* Step 1: Run TAXSIM
di `y'
taxsim9, `opts'

* To keep an additional var from output add here
*    and delete `sim' before name in rename and label file
#delimit ;
local taxsimoutput "fiitax siitax fica frate srate
	ficar FedAGI FedTax_RegTax FedCred_RefCTC FedCred_EITC 
	FedTax_NoCredits";
#delimit cr

* Step 2: Label Variables
label variable fiitax "federal income tax" 
label variable siitax "state income tax" 
label variable fica "Federal Ins. Constributions Act (Medicare+SocSec)"
label variable frate "Highest Federal marginal tax rate" 
label variable srate "Highest State marginal tax rate"
label variable ficar "Federal FICA Tax Rate"

if `fulltaxes' == 1 {
	rename v10 FedAGI
	rename v11 simUIinAGI
	rename v12 simSSinAGI
	rename v13 simZeroBracketAmt
	rename v14 simPersonalExemptions
	rename v15 simExemptPhaseout
	rename v16 simDeductPhaseout
	rename v17 simDeductAllowed
	rename v18 simFedTaxableY
	rename v19 FedTax_RegTax
	rename v20 simExemptSurtax
	rename v21 simGenTaxCredit
	rename v22 simCTC_adj
	rename v23 FedCred_RefCTC
	rename v24 simFedCred_ChildCare
	rename v25 FedCred_EITC
	rename v26 simYforAMT
	rename v27 simAMTtax
	rename v28 FedTax_NoCredits
	rename v29 simFICA
	if `statetaxes' == 1 {
		rename v30 simStateHHY
		rename v31 simStateRent
		rename v32 simStateAGI
		rename v33 simStateExempt
		rename v34 simStateStandDed
		rename v35 simStateItemDed
		rename v36 simStateTaxInc
		rename v37 simStatePTC
		rename v38 simStateCCC
		rename v39 simStateEITC
		rename v40 simStateTotCred
		rename v41 simStateBcktRate
		}

	** Variables we do not start with "sim" and are dropped
	label variable FedAGI "Federal AGI" 
	label variable simUIinAGI "UI in AGI" 
	label variable simSSinAGI "Social Security in AGI" 
	label variable simZeroBracketAmt "Zero Bracket Amount" 
	label variable simPersonalExemptions "Personal Exemptions" 
	label variable simExemptPhaseout "Exemption Phaseout" 
	label variable simDeductPhaseout "Deduction Phaseout" 
	label variable simDeductAllowed "Deductions allowed" 
	label variable simFedTaxableY "Federal Taxable Income" 
	label variable FedTax_RegTax "Federal Regular Tax" 
	label variable simExemptSurtax "Exemption Surtax" 
	label variable simGenTaxCredit "General Tax Credit" 
	label variable simCTC_adj "Child Tax Credit (as adjusted)" 
	label variable FedCred_RefCTC "Refundable Part of Child Tax Credit" 
	label variable simFedCred_ChildCare "Child Care Credit" 
	label variable FedCred_EITC "Earned Income Credit" 
	label variable simYforAMT "Income for the Alternative Minimum Tax" 
	label variable simAMTtax "AMT Liability (addition to regular tax)" 
	label variable FedTax_NoCredits "Income Tax before Credits"
	label variable simFICA "FICA" 
	if `statetaxes' == 1 {
		label variable simStateHHY "State Household Income" 
		label variable simStateRent "State Rent Payments" 
		label variable simStateAGI "State AGI" 
		label variable simStateExempt "State Exemption amount" 
		label variable simStateStandDed "State Standard Deduction" 
		label variable simStateItemDed "State Itemized Deductions" 
		label variable simStateTaxInc "State Taxable Income" 
		label variable simStatePTC "State Property Tax Credit" 
		label variable simStateCCC "State Child Care Credit" 
		label variable simStateEITC "State EITC "
		label variable simStateTotCred "State Total Credits" 
		label variable simStateBcktRate "State Bracket Rate" 
	}
	
	* Drop unused variables
	drop sim* taxsimid
	} /* end fulltax == 1*/

**********************************************************************************
* Section 4: Format Output
**********************************************************************************
* Step 1: Give vars back their `y'
 if `married_values' == 0 {           /*individual values */
	* Give PSID vars back their `y'
	foreach name of local taxsiminput {
		rename  `name' `name'`y'
		}
	* Give taxsim vars their `y'
	foreach name of local taxsimoutput {
		rename `name' `name'`y'
		} 
	} 
if `married_values' == 1 {             /* couple values */
	* Give PSID vars back their `y'
	foreach name of local taxsiminput {
		rename  `name' c_`name'`y'
		}
		* Give taxsim vars their `y'
	foreach name of local taxsimoutput {
		rename `name' c_`name'`y'
		} 
	}
	

/* 

********************************************************
* Input vars  (from the taxsim9 help file)
*******************************************************
    year: 4-digit year between 1960 and 2013. Between 1977 and 2010 if state tax is requested. No default.
    state: state identifier. These are numeric codes from 1 to 51 (Alabama to Wyoming in alphabetical order) with zero indicating "no state tax".
    mstat: Marital status 1 for single, 2 for joint, 3 for head of household. No default.
    depx: Number of dependents ( usually kids, but can be any age ) per tax form. Must not be less than depchild (below).
    agex: Number of age 65+ taxpayers. 0, 1 or 2.
    pwages: Wage income of primary taxpayer
    swages: Wage income of secondary taxpayer
    dividends: Dividend income
    otherprop: Interest and other property income. This may be negative. You can put net alimony here, and subtract any adjustments such as IRAs, Keoghs and self employment tax, to the
    extent that yuo may know such items.
    pensions: Taxable pension income
    gssi: Gross social security benefits. Taxsim will calculate the portion includable in AGI.
    transfers: Non-taxable transfer income, used for calculating low income credits and property tax credits on state taxes.
    rentpaid: Rent paid is used in some state property tax credits.
    proptax: Property tax paid is an itemized deduction and is a preference for the AMT.
    otheritem: Taxes paid other than state income taxes. Taxsim will use its own calculated state income tax as an itemized deduction. These are preferences for the AMT.
    childcare: Child care expenses are a credit in the federal tax.
    ui: Unemployment compensation benefits. Taxsim will calculate the portion included in AGI.
    depchild: Number of dependent children under 17 (for child credit).
    mortgage: Mortgage interest paid, possibly plus charitable contibutions, and some minor items that are not preferences for the AMT.
    stcg: Short term capital gain or loss (+/-).
    ltcg: Long term capital gain or loss (+/-).
********************************************************
* "Full" set of outputvars	(from .ado file)
*******************************************************
The 9 columns of results returned by default are:

v1 = taxsimid = Case ID
v2 = year = Year
v3 = state = State
v4 = fiitax = Federal income tax liability
v5 = siitax = State income tax liability
v6 = fica = FICA (OADSI and HI, sum of employee AND employer)
v7 = frate = federal marginal rate
v8 = srate = state marginal rate
v9 = ficar = FICA rate
Marginal rates are with respect to wage income unless another rate is requested. If detailed intermediate results are requested, the following 32 columns of data are added:

v10 = Federal AGI
v11 = UI in AGI
v12 = Social Security in AGI
v13 = Zero Bracket Amount
v14 = Personal Exemptions
v15 = Exemption Phaseout
v16 = Deduction Phaseout
v17 = Deductions Allowed (Zero for non-itemizers)
v18 = Federal Taxable Income
v19 = Federal Regular Tax
v20 = Exemption Surtax
v21 = General Tax Credit
v22 = Child Tax Credit (as adjusted)
v23 = Additional Child Tax Credit (refundable)
v24 = Child Care Credit
v25 = Earned Income Credit (total federal)
v26 = Income for the Alternative Minimum Tax
v27 = AMT Liability (addition to regular tax)
v28 = Federal Income Tax Before Credits
v29 = FICA
The last 12 columns are zeroed if no state is specified:

v30 = State Household Income
v31 = State Rent Payments
v32 = State AGI
v33 = State Exemption amount
v34 = State Standard Deduction
v35 = State Itemized Deductions
v36 = State Taxable Income
v37 = State Property Tax Credit
v38 = State Child Care Credit
v39 = State EIC
v40 = State Total Credits
v41 = State Bracket Rate
*/
