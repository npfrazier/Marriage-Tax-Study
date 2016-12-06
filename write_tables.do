**********************************************************************************
** Marriage Tax Study
** 		Generates Summary Tables
**		Generates Regression Tables
**		Writes a latex document with all the tables
**********************************************************************************
args f_stat cluster_var reg_vars 

**********************************************************************************
* Section 1: ????
**********************************************************************************
* Re-Label variables for nicer table output
do reg_labels

* Uncomment to Review Regressions Run:
* eststo dir

#delimit ; 

/************************************************************************************/
/* Section 2: Generate Summary Tables */
/************************************************************************************/
local filename = "mtax_1_SummaryTable.tex";

/* SUMMARY OF REGRESSRION VARIABLES */
eststo RegSum : qui estpost summarize delay marital_inc marital_inc_sq c_depx Pregnant NewBaby m_age f_age
	marr_howmany_m marr_howmany_f taxyear i_twoearner m_wages f_wages cohabit i_white i_africanamerican 
	i_catholic_male i_catholic_female i_jewish_male i_jewish_female i_protestant_male i_protestant_female 
	i_west i_south i_northeast 
	MTAX_HoH MTAX_Male MTAX_Female MTAX_Bio MTAX_HighE MTAX_Min
	MTAX_HoH_pct MTAX_Male_pct MTAX_Female_pct MTAX_Bio_pct MTAX_HighE_pct MTAX_Min_pct;
esttab RegSum using `filename', replace
	nonumber title("Summary Statistics (Table 1)") label
	labcol2("Indicates if the couple marries in first quarter"
	"Couple's net income in year married (thousands of 2012 dollars)" 
	"Square of \emph{Marital Income} (millions of 2012 dollars)"
	"Number of children"
	"Indicates if a child is born in Jan-July following marriage" 
	"Indicates if a child is born in the year prior to marriage"
	"Male's age at marriage" 
	"Female's age at marriage"
	"Number of marriages recorded for male"
	"Number of marriages recorded for female"
	"Year in which marriage tax is measured"
	"Indicates if both individuals earn positive labor income"
	"Male's reported labor income (thousands of 2012 dollars)"
	"Female's reported labor income (thousands of 2012 dollars)"
	"Indicates prior cohabitation"
	"Indicates if male identifies as white" "Indicates if male identifies as African American"
	"Indicates if male reports as Catholic" "Indicates if female reports as Catholic" 
	"Indicates if male reports as Jewish" "Indicates if female reports as Jewish"
	"Indicates if male reports as Protestant" "Indicates if female reports as Protestant"
	"Indicates family resides in the West" "Indicates family resides in the South" "Indicates family resides in the Northeast"
	"Change in tax liability upon marriage (thousands of 2012 dollars)"
	"Change in tax liability: male claims all children"
	"Change in tax liability: female claims all children"
	"Change in tax liability: biological parent claims children"
	"Change in tax liability: high earner claims all children"
	"Change in tax liability: children claimed to minimize taxes"
	"\emph{MTax Level} divided by federal AGI"
	"MTax (\%Inc) when male claims all children" 
	"MTax (\%Inc) when female claims all children"
	"MTax (\%Inc) when biological parent claims children" 
	"MTax (\%Inc) when the high earner claims all children"
	"MTax (\%Inc) when children are claimed to minimize taxes", width(24))
	varlabels(delay "\emph{Delay}"  marital_inc "\emph{Marital Income}"
	marital_inc_sq "\emph{(Marital Income)$^2$}" c_depx "\emph{Number of Children}" Pregnant "\emph{Pregnant}"
	NewBaby "\emph{New Baby}" m_taxage "\emph{Male's Age}" f_taxage "Female's Age" i_west "West" i_south "South" i_northeast "Northeast"
	marr_howmany_m "\# of Marriages (Male)" marr_howmany_f "\# of Marriages (Female)" taxyear "Tax Year" i_twoearner "Two Earner Family" 
	MTAX_HoH "MTax Level" MTAX_Male "MTAX Level (Male)" MTAX_Female "MTAX Level (Female)" MTAX_Bio "MTAX Level (Bio)" 
	MTAX_HighE "MTAX Level (High Earner)" MTAX_Min "MTAX Level (Min)" MTAX_HoH_pct "\emph{MTax (\%Inc)}"
	MTAX_Male_pct "MTax(\%) Male" MTAX_Female_pct "MTax(\%) Female" MTAX_Bio_pct "MTax(\%) Bio" MTAX_HighE_pct "MTax(\%) High Earner"
	MTAX_Min_pct "MTax(\%) Min")
	cells("mean(fmt(2 2 2 1 1 2 2 2 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3) label(Mean)) 
		   sd(  fmt(2 2 2 1 1 2 2 2 1 1 1 1 2 2 1 2 2 2 2 2 2 2 2 2 2 2 3) label(SE))
		   min( fmt(0 2 2 0 0 0 0 0 0 0 0 0 2 2 0 0 0 0 0 0 0 0 0 0 0 0 3) label(Min.)) 
		   max( fmt(0 2 2 0 0 0 0 0 0 0 0 0 2 2 0 0 0 0 0 0 0 0 0 0 0 0 3) label(Max.))
		   ")
	;		
	/* label("Std. Dev.") label("Min.") label("Max.")*/

/************************************************************************************/
/* Section 3: Generate Regression Tables */
/************************************************************************************/
/* MAIN REGRESSRION TABLE */
local filename = "mtax_2_MainRegTable.tex";

esttab HoH_lite HoH_full HoH_focus False_SpecQ3
	using `filename', replace
	nonumber title("Core Results (Table 2)") label 
	cells(b(star fmt(3)) se(par fmt(%9.3f)))
	stats(Yr_FE N r2, labels("Year Fixed Effects" "N" "r$^2$") fmt(0 0 3))
	starlevels(* 0.1 ** 0.05 *** 0.01)
	drop(t_fix_*) noomitted
	coeflabels(1.s_EITC#c.mtax_pct "EITC Eligibility $\times$ Marriage Tax (\%)")
	mtitles("Limited Controls" "Full Controls" "Focused Sample" "False Specification")
	collabels(none) 
	addnotes("Asterisks indicate significance at the 10\% (*), 5\% (**), and 1\% (***) level. Coefficients for year fixed effects"
	"omitted for brevity. All errors are clustered at the `cluster_var' level.");;

/* MAIN REG UNDER DIFFERENT CHILDREN ALLOCATION ASSUMPTIONS TABLE (FOCUSED)*/
local filename = "mtax_3a_ChildAllocation.tex";

esttab HoH_focus Male_focus Female_focus Bio_focus HighE_focus Min_focus
	using `filename', replace  
	nonumber title("Focused Sample Regressions (Table 3A)") label 
	cells(b(star fmt(3)) se(par fmt(%9.3f)))
	stats(Yr_FE N r2, labels("Year Fixed Effects" "N" "r$^2$") fmt(0 0 3))
	starlevels(* 0.1 ** 0.05 *** 0.01)
	drop(t_fix_*) noomitted
	mlabels("HoH" "Male" "Female" "Bio" "High Earner" "Minimize")
	collabels("Q1/Q4" "Q1/Q4" "Q1/Q4" "Q1/Q4" "Q1/Q4" "Q1/Q4")
	addnotes("Asterisks indicate significance at the 10\% (*), 5\% (**), and 1\% (***) level. Coefficients for year fixed effects omitted for brevity."
	"All errors are clustered at the `cluster_var' level.");

/* MAIN REG UNDER DIFFERENT CHILDREN ALLOCATION ASSUMPTIONS TABLE (FULL)*/
local filename = "mtax_3b_ChildAllocation.tex";

esttab HoH_full Male_full Female_full Bio_full HighE_full Min_full
	using `filename', replace  
	nonumber title("Full Sample Regressions (Table 3B)") label 
	cells(b(star fmt(3)) se(par fmt(%9.3f)))
	stats(Yr_FE N r2, labels("Year Fixed Effects" "N" "r$^2$") fmt(0 0 3))
	starlevels(* 0.1 ** 0.05 *** 0.01)
	drop(t_fix_*) noomitted
	mlabels("HoH" "Male" "Female" "Bio" "High Earner" "Minimize")
	collabels("Q1/Q4" "Q1/Q4" "Q1/Q4" "Q1/Q4" "Q1/Q4" "Q1/Q4")
	addnotes("Asterisks indicate significance at the 10\% (*), 5\% (**), and 1\% (***) level. Coefficients for year fixed effects omitted for brevity."
	"All errors are clustered at the `cluster_var' level.");

/* SENSITIVITY TESTS*/
local filename = "mtax_4_Sensitivity.tex";

esttab HoH_full_SF HoH_state HoH_wall HoH_ginc
	using `filename', replace  
	nonumber title("Sensitivity Tests (Table 4)") label 
	cells(b(star fmt(3)) se(par fmt(%9.3f)))
	starlevels(* 0.1 ** 0.05 *** 0.01)
	stats(Reg_FE Rel_FE Race_FE Yr_FE ST_FE N r2, labels("Region Fixed Effects" "Religion Fixed Effects" "Race Fixed Effects"
	"Year Fixed Effects" "State Fixed Effects" "N" "r$^2$") fmt(0 0 0 0 0 0 3))
	drop(i_catholic_male i_jewish_male i_protestant_male i_west i_south i_northeast i_white i_africanamerican t_state* t_fix*) noomitted
	mlabels("State FE" "State Tax" "Demo. Controls" "Spouse Income" "Levels")
	addnotes("Asterisks indicate significance at the 10\% (*), 5\% (**), and 1\% (***) level. Coefficients for year fixed effects omitted for brevity."
	"All errors are clustered at the `cluster_var' level. Region fixed effects include \emph{West}, \emph{South}, and \emph{Northeast}. Religion fixed"
	"effects include \emph{Male Reports Catholic}, \emph{Male Reports Jewish}, and \emph{Male Reports Protestant}. Race fixed effects include \emph{White (Male)}, and "
	"\emph{African American (Male)}".);	
	
/************************************************************************************/
/* Section 5: Put all the tables in a nice pdf */
/************************************************************************************/


#delimit ; 
/* *************************************************** */
file open myfile using "Tables.tex", write replace;
file write myfile "\documentclass{article} \usepackage{booktabs} \usepackage{pdflscape} \usepackage{geometry} \begin{document}" _newline(3);
file write myfile "\newgeometry{margin=.5cm}  " _newline(1);
file write myfile "\input{mtax_1_SummaryTable.tex}" _newline(3);
file write myfile "\input{mtax_2_MainRegTable.tex}" _newline(3);
file write myfile "\input{mtax_3a_ChildAllocation.tex}" _newline(3);
file write myfile "\input{mtax_3b_ChildAllocation.tex}" _newline(3);
file write myfile "\input{mtax_4_Sensitivity.tex}" _newline(3);

file write myfile "\end{document}";
file close myfile;
#delimit cr	

!pdflatex Tables.tex
!START Tables.pdf

