
# Marriage Tax Study
**By:** Nick Frazier and Margaret McKeehan<br>
**Last edited:** 12/2/2016

This project details the empirical approach used in *Hesitating at the Altar: An Update on Taxes and the Timing of Marriage* by Nick Frazier and Margaret McKeehan.

The project uses data on couples in the PSID who marry in the 1st or 4th quarters of 1986-2011. We process this data to form the inputs into NBER's *Taxsim* program which yields estimated federal and state income tax liabilities for couples when filing separately and married. From these estimates we can infer a marriage tax which is our primary instrument of interest in determining the decision to delay.

### Usage guideline:

The program can be run from *main.do*. The user must update the indicated paths to their local equivalents and provide both the raw PSID data file and the Marriage History File.

#### Data

The marriage history file can be found [here at the ICPSR site](http://www.icpsr.umich.edu/icpsrweb/IFSS/studies/3202). The file *data.txt* used in conjunction with the "Variable List" feature of the Data Center at the [primary PSID portal here](http://simba.isr.umich.edu/default.aspx) produces the raw data for the project. Please note that this file is large and may include variables which are not strictly required to run the program.

The remaining settings are pre-set to produce the tables found in the paper and have in-text descriptions that describe other options available to the user.

**Please note:**<br>
If you do not have [*pdflatex*](https://en.wikipedia.org/wiki/PdfTeX) on your system path you will not be able to compile the LaTeX code that produces our tables. You should therefore set `in_stata=1` which will produce a less organized version in the Stata output window.
