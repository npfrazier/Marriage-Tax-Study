**********************************************************************************
** Marriage Tax Study
** Nick Frazier and Margaret McKeehan
** Code used to generate results from
**	 "Hesitating at the Altar: An Update on Taxes and the Timing of Marriage"
**
** See readme.md for more information
** Last Edited: 12/2/2016
**********************************************************************************
**********************************************************************************
capture clear all
set more off

**********************************************************************************
* Section 1:  Specify Run Parameters
**********************************************************************************

**Specify Local File Locations
* Path to current working directory and data
global main_dir = "C:\code\Marriage_Tax_Study\"
* Path to intermediate data files
global data_dir = "C:\code\Marriage_Tax_Study\data\"
* Path to raw data, from PSID portal
global RAW_data = "C:\Users\Nick\data\MarriageTax_Data.dta"
	* See description in included "DATA.txt"
* Path to "Marriage History File"
global MHF_data = "C:\Users\Nick\data\MH85_11.txt"
	* Used to clean data,see "http://psidonline.isr.umich.edu/Data/Documentation/cbks/supp/FamHist/mh85_07_intro.pdf"

* Years included in our paper
#delimit ;
global run_years "
							  1986 1987 1988 1989
1990 1991 1992 1993 1994 1995 1996 1997      1999
2001 2003 2005 2007 2009 2011";
#delimit cr

** Set Run Parameters

* Data Generation Parameters
local refreshdata = 1				/* Refreshes Data (Pulls from Marriage File, Runs TAXSIM)*/
	local genmarriage = 1			/* 0 => Uses existing marriage data */
	local step_vals = "0 1 3 4 5"   		/* Values to use in {RefreshData, ProcessData} loop */
									/* 0 => All to HoH*/
									/* 1 => Allocate stepchildren to spouse; */
									/* 2 => Assigns children based on pre-existence */
									/* 3 => Assigns children to highest earner */
									/* 4 => Assigns children to the male */
									/* 5 => Assigns children to the female */
local processdata = 1				/* 1 => Cleans and processes data */
local minims = "TPreMT_Male TPreMT_Female TPreMT_Bio" /* Options: _Bio _HoH _HighE _Male _Female*/

** Set Data Preparation Options

* Choose a fiscal year
local FiscalYear = 2012              /* 1983 1984 1985 1996 2012 */
* Choose How Dollars are Measured:
local DollarMeasure = 1000 /* 1000 (in thousands), 1 (in dollars), etc. */

** Set Output Options
local in_Stata = 0					/* 0 => Generate LaTeX pdf, o/w in output window */
local filename "Tables.tex"         /* Output file name ! WILL BE REPLACED if exists */

** Filtering

* Left inclusive bound for marriage date
local year_start = 1986
* Right inclusive bound for marriage date
local year_end = 2011
* Drop all marriages lasting < X (if == 0, none dropped)
local min_marr_years = 0
* Set 18 year age criterion
local max_18 = 0
	* If max_18 == 1 then drops all couples with max age < 18
	* Otherwise, drops couples with min age < 18
local wrong_anniversary = 1 /* drop YoI mismatches */
	*  Currently always drop mismatches of more than one year
	*	0 -- drop all mismatches
	*	1 -- drop mismatches >1yr & use min_YoI
	*	2 -- drop mismatches >1yr & use max_YoI
local MoI = 1		/*marriage_of_interest.do*/
		*	1 - Use earliest marriage
		* 	2 - Use last marriage
		* 	3 - Other marriage rule (not supported)
		*	Else - Use all marriages

cd "$main_dir"
capture mkdir data /*make sure it exists*/

**********************************************************************************
* Section 2: Refresh Data
**********************************************************************************
if `refreshdata' == 1 {
	foreach step of local step_vals {
		** Generate Data File and Run TAXSIM
		do RefreshData `genmarriage' `year_start' `year_end' `step' ///
				`min_marr_years' `max_18' `wrong_anniversary'

		** Condense Data
		do CondenseData
		** Save Data
		local temp = "$data_dir"+"condensed_step"+"`step'"+".dta"
		save "`temp'", replace
		}
} /* end of loop over step */

**********************************************************************************
* Section 3: Process Data
**********************************************************************************
if `processdata' == 1 {
	* Run Process File
	do ProcessData `year_start' `year_end' `FiscalYear' `DollarMeasure' `MoI' `minims'

	** Reduce Data Set
	* Used: Head - Implies HoH data used if unspecified (e.g., taxage, employment)
	drop if head ~= 1

	** Save Data
	local temp = "$data_dir"+"processed_data.dta"
	save "`temp'", replace
} /* if processed data */

* Step 2: Generate False Specification Data
do False_Spec `year_start' `year_end' `FiscalYear' `DollarMeasure' `MoI'

**********************************************************************************
* Section 4: Run Estimation
**********************************************************************************
* Step 1: Pull Processed Data
local temp = "$data_dir"+"processed_data.dta"
use "`temp'"

* Step 2: Final Data Set Restrictions
drop min_age
gen f_age = f_taxage + 1
gen m_age = m_taxage + 1
gen m_age2 = m_age*m_age / 1000
gen min_age = min(f_age,m_age)
drop if min_age < 18
drop if retired
drop if m_taxage == .

* Step 3a: Count Number of Families
bys family : gen FamCount = _n
count if FamCount == 1
global Num68Fams = r(N)

* Step 3b: Set Up for Regression Analysis
* Save Regression Data
local temp = "$data_dir"+"regression_data.dta"
save `temp', replace

* Step 4: Run regressions
* set regression options inside RegressData.do
do RegressData

* Step 6: Print Results
local temp = "$data_dir"+"regression_data.dta"
use `temp'

* Refresh variable labels for summary table
qui gen mtax = MTAX_HoH
label var mtax "MTax Level"
qui gen mtax_pct = MTAX_HoH_pct
label var mtax_pct "MTax (\%Inc)"
qui gen mtax_pct_s = s_MTAX_HoH_pct
label var mtax_pct_s "S+F MTax (\%Inc)"
* Print Results
if `in_Stata' == 0 {
	* Combine reg vars to make it easier to pass
	local reg_vars = "`indvarsF1'"+" "+"`indvarsF2'"
	* Write to pdf
	do write_tables `f_stat_HoH' `cluster_var' "`reg_vars'"
}
else {
	* See list of generated regression below
	estpost summarize delay marital_inc marital_inc_sq c_depx Pregnant NewBaby m_age f_age ///
		marr_howmany_m marr_howmany_f taxyear i_twoearner m_wages f_wages cohabit i_white i_africanamerican ///
		i_catholic_male i_catholic_female i_jewish_male i_jewish_female i_protestant_male i_protestant_female ///
		i_west i_south i_northeast MTAX_HoH MTAX_Male MTAX_Female MTAX_Bio MTAX_HighE MTAX_Min ///
		MTAX_HoH_pct MTAX_Male_pct MTAX_Female_pct MTAX_Bio_pct MTAX_HighE_pct MTAX_Min_pct
	estimates replay HoH_lite HoH_full HoH_focus False_SpecQ3
	estimates replay HoH_focus Male_focus Female_focus Bio_focus HighE_focus Min_focus
	estimates replay HoH_full Male_full Female_full Bio_full HighE_full Min_full
	estimates replay HoH_full_SF HoH_state HoH_wall HoH_ginc
}

di "Sundry statistics we report in our paper. Roughly in order of appearance in paper"
di "Number of 1968 families:   " as error $Num68Fams
di "F-stat for core: `core':   " as error `f_stat_HoH'
