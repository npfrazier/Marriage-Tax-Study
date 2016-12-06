**********************************************************************************
** Marriage Tax Study
** Renames Variables from Raw PSID File
** 		See DATA.txt for necessary PSID variables
** 		Some variable listed here may not be used later
**********************************************************************************

**********************************************************************************
* Section 1:  Rename Permanent Variables
**********************************************************************************
* Step 1: Primary Variables
rename ER30001 family, replace
rename ER30002 ID, replace
rename ER32000 sex, replace
rename ER32024 birthy1, replace
rename ER32023 birthm1, replace
rename ER32032 birthy2, replace
rename ER32031 birthm2, replace
rename ER32030 birthy3, replace
rename ER32029 birthm3, replace
rename ER32028 birthy4, replace
rename ER32027 birthm4, replace
rename ER32026 birthy5, replace
rename ER32025 birthm5, replace

* Step 2: Create Family Replication Variable for 1968
gen ER30001 = family

**********************************************************************************
* Section 2:  Rename Annual Variables
**********************************************************************************
* Step 1: 1986 Rename of TAXSIM Variables
rename ER30503 t1986_age1, replace
rename V13011 t1986_age2, replace
rename ER30501 t1986_age3, replace
rename ER30513 t1986_education1, replace
rename ER30509 t1986_employment1, replace
rename ER30498 t1986_familyID, replace
rename V13665 t1986_mstat1, replace
rename V13017 t1986_mstat2, replace
rename V13624 t1986_pwages1, replace
rename ER30500 t1986_rel2HOH, replace
rename V12532 t1986_rentpaid1, replace
rename V12503 t1986_state1, replace
rename V12803 t1986_swages1, replace
rename V13565 t1986_race1, replace
rename V13500 t1986_race2, replace
rename V13604 t1986_religion1, replace
rename V13530 t1986_religion2, replace
rename V13631 t1986_region1, replace
rename V13552 t1986_siblings1, replace
rename V13488 t1986_siblings2, replace

* Step 2: 1987 Rename of TAXSIM Variables
rename ER30540 t1987_age1, replace
rename V14114 t1987_age2, replace
rename ER30538 t1987_age3, replace
rename ER30549 t1987_education1, replace
rename ER30545 t1987_employment1, replace
rename ER30535 t1987_familyID, replace
rename V14712 t1987_mstat1, replace
rename V14120 t1987_mstat2, replace
rename V14671 t1987_pwages1, replace
rename ER30537 t1987_rel2HOH, replace
rename V13703 t1987_state1, replace
rename V13905 t1987_swages1, replace
rename V14612 t1987_race1, replace
rename V14547 t1987_race2, replace
rename V14651 t1987_religion1, replace
rename V14577 t1987_religion2, replace
rename V14678 t1987_region1, replace
rename V14599 t1987_siblings1, replace
rename V14535 t1987_siblings2, replace

* Step 3: 1988 Rename of TAXSIM Variables
rename ER30575 t1988_age1, replace
rename V15130 t1988_age2, replace
rename ER30573 t1988_age3, replace
rename ER30584 t1988_education1, replace
rename ER30580 t1988_employment1, replace
rename ER30570 t1988_familyID, replace
rename V14949 t1988_gssi3, replace
rename V14970 t1988_gssi5, replace
rename V16187 t1988_mstat1, replace
rename V15136 t1988_mstat2, replace
rename V16145 t1988_pwages1, replace
rename ER30572 t1988_rel2HOH, replace
rename V14803 t1988_state1, replace
rename V14920 t1988_swages1, replace
rename V16086 t1988_race1, replace
rename V16021 t1988_race2, replace
rename V16125 t1988_religion1, replace
rename V16051 t1988_religion2, replace
rename V16152 t1988_region1, replace
rename V16073 t1988_siblings1, replace
rename V16009 t1988_siblings2, replace

* Step 4: 1989 Rename of TAXSIM Variables
rename ER30611 t1989_age1, replace
rename V16631 t1989_age2, replace
rename ER30609 t1989_age3, replace
rename ER30620 t1989_education1, replace
rename ER30616 t1989_employment1, replace
rename ER30606 t1989_familyID, replace
rename V17565 t1989_mstat1, replace
rename V16637 t1989_mstat2, replace
rename V17534 t1989_pwages1, replace
rename ER30608 t1989_rel2HOH, replace
rename V16303 t1989_state1, replace
rename V16420 t1989_swages1, replace
rename V17483 t1989_race1, replace
rename V17418 t1989_race2, replace
rename V17522 t1989_religion1, replace
rename V17448 t1989_religion2, replace
rename V17538 t1989_region1, replace
rename V17470 t1989_siblings1, replace
rename V17406 t1989_siblings2, replace

* Step 5: 1990 Rename of TAXSIM Variables
rename ER30647 t1990_age1, replace
rename V18049 t1990_age2, replace
rename ER30645 t1990_age3, replace
rename ER30657 t1990_education1, replace
rename ER30653 t1990_employment1, replace
rename ER30642 t1990_familyID, replace
rename V18916 t1990_mstat1, replace
rename V18055 t1990_mstat2, replace
rename V18878 t1990_pwages1, replace
rename ER30644 t1990_rel2HOH, replace
rename V17703 t1990_state1, replace
rename V17836 t1990_swages1, replace
rename V18814 t1990_race1, replace
rename V18749 t1990_race2, replace
rename V18853 t1990_religion1, replace
rename V18779 t1990_religion2, replace
rename V18889 t1990_region1, replace
rename V18801 t1990_siblings1, replace
rename V18737 t1990_siblings2, replace

* Step 6: 1991 Rename of TAXSIM Variables
rename ER30694 t1991_age1, replace
rename V19349 t1991_age2, replace
rename ER30692 t1991_age3, replace
rename ER30703 t1991_education1, replace
rename ER30699 t1991_employment1, replace
rename ER30689 t1991_familyID, replace
rename V20216 t1991_mstat1, replace
rename V19355 t1991_mstat2, replace
rename V20178 t1991_pwages1, replace
rename ER30691 t1991_rel2HOH, replace
rename V19003 t1991_state1, replace
rename V19136 t1991_swages1, replace
rename V20114 t1991_race1, replace
rename V20049 t1991_race2, replace
rename V20153 t1991_religion1, replace
rename V20079 t1991_religion2, replace
rename V20189 t1991_region1, replace
rename V20101 t1991_siblings1, replace
rename V20037 t1991_siblings2, replace

* Step 7: 1992 Rename of TAXSIM Variables
rename ER30738 t1992_age1, replace
rename V20651 t1992_age2, replace
rename ER30736 t1992_age3, replace
rename ER30748 t1992_education1, replace
rename ER30744 t1992_employment1, replace
rename ER30733 t1992_familyID, replace
rename V21522 t1992_mstat1, replace
rename V20657 t1992_mstat2, replace
rename V21484 t1992_pwages1, replace
rename ER30735 t1992_rel2HOH, replace
rename V20303 t1992_state1, replace
rename V20436 t1992_swages1, replace
rename V21420 t1992_race1, replace
rename V21355 t1992_race2, replace
rename V21459 t1992_religion1, replace
rename V21385 t1992_religion2, replace
rename V21495 t1992_region1, replace
rename V21407 t1992_siblings1, replace
rename V21343 t1992_siblings2, replace

* Step 8: 1993 Rename of TAXSIM Variables
rename ER30811 t1993_age1, replace
rename V22406 t1993_age2, replace
rename ER30809 t1993_age3, replace
rename ER30820 t1993_education1, replace
rename ER30816 t1993_employment1, replace
rename ER30806 t1993_familyID, replace
rename V22027 t1993_gssi3, replace
rename V22301 t1993_gssi5, replace
rename V23336 t1993_mstat1, replace
rename V22412 t1993_mstat2, replace
rename V23323 t1993_pwages1, replace
rename ER30808 t1993_rel2HOH, replace
rename V21603 t1993_state1, replace
rename V23324 t1993_swages1, replace
rename V21807 t1993_swages3, replace
rename V21806 t1993_swages5, replace
rename V23276 t1993_race1, replace
rename V23212 t1993_race2, replace
rename V23315 t1993_religion1, replace
rename V23242 t1993_religion2, replace
rename V23327 t1993_region1, replace
rename V23263 t1993_siblings1, replace
rename V23200 t1993_siblings2, replace

* Step 9: 1994 Rename of TAXSIM Variables
rename ER33106 t1994_age1, replace
rename ER2007 t1994_age2, replace
rename ER33104 t1994_age3, replace
rename ER33115 t1994_education1, replace
rename ER33111 t1994_employment1, replace
rename ER33101 t1994_familyID, replace
rename ER4159A t1994_mstat1, replace
rename ER201 t1994_mstat2, replace
rename ER2034 t1994_proptax1, replace
rename ER4140 t1994_pwages1, replace
rename ER33103 t1994_rel2HOH, replace
rename ER4156 t1994_state1, replace
rename ER4144 t1994_swages3, replace
rename ER4141 t1994_swages5, replace
rename ER3944 t1994_race1, replace
rename ER3883 t1994_race2, replace
rename ER3983 t1994_religion1, replace
rename ER3913 t1994_religion2, replace
rename ER4157E t1994_region1, replace
rename ER3929 t1994_siblings1, replace
rename ER3869 t1994_siblings2, replace

* Step 10: 1995 Rename of TAXSIM Variables
rename ER33206 t1995_age1, replace
rename ER5006 t1995_age2, replace
rename ER33204 t1995_age3, replace
rename ER33215 t1995_education1, replace
rename ER33211 t1995_employment1, replace
rename ER33201 t1995_familyID, replace
rename ER6999A t1995_mstat1, replace
rename ER5013 t1995_mstat2, replace
rename ER5033 t1995_proptax1, replace
rename ER6980 t1995_pwages1, replace
rename ER33203 t1995_rel2HOH, replace
rename ER6996 t1995_state1, replace
rename ER6984 t1995_swages3, replace
rename ER6981 t1995_swages5, replace
rename ER6814 t1995_race1, replace
rename ER6753 t1995_race2, replace
rename ER6853 t1995_religion1, replace
rename ER6783 t1995_religion2, replace
rename ER6997E t1995_region1, replace
rename ER6799 t1995_siblings1, replace
rename ER6739 t1995_siblings2, replace

* Step 11: 1996 Rename of TAXSIM Variables
rename ER33306 t1996_age1, replace
rename ER7006 t1996_age2, replace
rename ER33304 t1996_age3, replace
rename ER33315 t1996_education1, replace
rename ER33311 t1996_employment1, replace
rename ER33301 t1996_familyID, replace
rename ER9250A t1996_mstat1, replace
rename ER7013 t1996_mstat2, replace
rename ER9231 t1996_pwages1, replace
rename ER33303 t1996_rel2HOH, replace
rename ER9247 t1996_state1, replace
rename ER9235 t1996_swages3, replace
rename ER9232 t1996_swages5, replace
rename ER9060 t1996_race1, replace
rename ER8999 t1996_race2, replace
rename ER9099 t1996_religion1, replace
rename ER9029 t1996_religion2, replace
rename ER9248E t1996_region1, replace
rename ER9045 t1996_siblings1, replace
rename ER8985 t1996_siblings2, replace

* Step 12: 1997 Rename of TAXSIM Variables
rename ER33406 t1997_age1, replace
rename ER10009 t1997_age2, replace
rename ER33404 t1997_age3, replace
rename ER33415 t1997_education1, replace
rename ER33411 t1997_employment1, replace
rename ER33401 t1997_familyID, replace
rename ER12223A t1997_mstat1, replace
rename ER10016 t1997_mstat2, replace
rename ER12080 t1997_pwages1, replace
rename ER33403 t1997_rel2HOH, replace
rename ER12221 t1997_state1, replace
rename ER12082 t1997_swages3, replace
rename ER12214 t1997_swages5, replace
rename ER11848 t1997_race1, replace
rename ER11760 t1997_race2, replace
rename ER11895 t1997_religion1, replace
rename ER11807 t1997_religion2, replace
rename ER12221E t1997_region1, replace
rename ER11830 t1997_siblings1, replace
rename ER11749 t1997_siblings2, replace

* Step 13: 1999 Rename of TAXSIM Variables
rename ER33506 t1999_age1, replace
rename ER13010 t1999_age2, replace
rename ER33504 t1999_age3, replace
rename ER33516 t1999_education1, replace
rename ER33512 t1999_employment1, replace
rename ER33501 t1999_familyID, replace
rename ER16423 t1999_mstat1, replace
rename ER13021 t1999_mstat2, replace
rename ER16463 t1999_pwages1, replace
rename ER33503 t1999_rel2HOH, replace
rename ER13004 t1999_state1, replace
rename ER16465 t1999_swages3, replace
rename ER16511 t1999_swages5, replace
rename ER15928 t1999_race1, replace
rename ER15836 t1999_race2, replace
rename ER15977 t1999_religion1, replace
rename ER15884 t1999_religion2, replace
rename ER16430 t1999_region1, replace
rename ER15910 t1999_siblings1, replace
rename ER15825 t1999_siblings2, replace

* Step 14: 2001 Rename of TAXSIM Variables
rename ER33606 t2001_age1, replace
rename ER17013 t2001_age2, replace
rename ER33604 t2001_age3, replace
rename ER33616 t2001_education1, replace
rename ER33612 t2001_employment1, replace
rename ER33601 t2001_familyID, replace
rename ER20369 t2001_mstat1, replace
rename ER17024 t2001_mstat2, replace
rename ER20443 t2001_pwages1, replace
rename ER33603 t2001_rel2HOH, replace
rename ER17004 t2001_state1, replace
rename ER20447 t2001_swages3, replace
rename ER20444 t2001_swages5, replace
rename ER19989 t2001_race1, replace
rename ER19897 t2001_race2, replace
rename ER20038 t2001_religion1, replace
rename ER19945 t2001_religion2, replace
rename ER20376 t2001_region1, replace
rename ER19971 t2001_siblings1, replace
rename ER19886 t2001_siblings2, replace

* Step 15: 2003 Rename of TAXSIM Variables
rename ER33706 t2003_age1, replace
rename ER21017 t2003_age2, replace
rename ER33704 t2003_age3, replace
rename ER33716 t2003_education1, replace
rename ER33712 t2003_employment1, replace
rename ER33701 t2003_familyID, replace
rename ER24150 t2003_mstat1, replace
rename ER21023 t2003_mstat2, replace
rename ER24116 t2003_pwages1, replace
rename ER33703 t2003_rel2HOH, replace
rename ER21003 t2003_state1, replace
rename ER24135 t2003_swages3, replace
rename ER24111 t2003_swages5, replace
rename ER23426 t2003_race1, replace
rename ER23334 t2003_race2, replace
rename ER23474 t2003_religion1, replace
rename ER23382 t2003_religion2, replace
rename ER24143 t2003_region1, replace
rename ER23408 t2003_siblings1, replace
rename ER23323 t2003_siblings2, replace

* Step 16: 2005 Rename of TAXSIM Variables
rename ER33806 t2005_age1, replace
rename ER25017 t2005_age2, replace
rename ER33804 t2005_age3, replace
rename ER33817 t2005_education1, replace
rename ER33813 t2005_employment1, replace
rename ER33801 t2005_familyID, replace
rename ER28049 t2005_mstat1, replace
rename ER25023 t2005_mstat2, replace
rename ER27931 t2005_pwages1, replace
rename ER33803 t2005_rel2HOH, replace
rename ER25003 t2005_state1, replace
rename ER27943 t2005_swages3, replace
rename ER27940 t2005_swages5, replace
rename ER27393 t2005_race1, replace
rename ER27297 t2005_race2, replace
rename ER27442 t2005_religion1, replace
rename ER27346 t2005_religion2, replace
rename ER28042 t2005_region1, replace
rename ER27374 t2005_siblings1, replace
rename ER27285 t2005_siblings2, replace

* Step 17: 2007 Rename of TAXSIM Variables
rename ER33906 t2007_age1, replace
rename ER36017 t2007_age2, replace
rename ER33904 t2007_age3, replace
rename ER33917 t2007_education1, replace
rename ER33913 t2007_employment1, replace
rename ER33901 t2007_familyID, replace
rename ER41039 t2007_mstat1, replace
rename ER36023 t2007_mstat2, replace
rename ER40921 t2007_pwages1, replace
rename ER33903 t2007_rel2HOH, replace
rename ER36003 t2007_state1, replace
rename ER40933 t2007_swages3, replace
rename ER40930 t2007_swages5, replace
rename ER40565 t2007_race1, replace
rename ER40472 t2007_race2, replace
rename ER40614 t2007_religion1, replace
rename ER40521 t2007_religion2, replace
rename ER41032 t2007_region1, replace
rename ER40549 t2007_siblings1, replace
rename ER40460 t2007_siblings2, replace

* Step 18: 2009 Rename of TAXSIM Variables
rename ER34006 t2009_age1, replace
rename ER42017 t2009_age2, replace
rename ER34004 t2009_age3, replace
rename ER34020 t2009_education1, replace
rename ER34016 t2009_employment1, replace
rename ER34001 t2009_familyID, replace
rename ER46983 t2009_mstat1, replace
rename ER42023 t2009_mstat2, replace
rename ER46829 t2009_pwages1, replace
rename ER34003 t2009_rel2HOH, replace
rename ER42003 t2009_state1, replace
rename ER46841 t2009_swages3, replace
rename ER46838 t2009_swages5, replace
rename ER46543 t2009_race1, replace
rename ER46449 t2009_race2, replace
rename ER46592 t2009_religion1, replace
rename ER46498 t2009_religion2, replace
rename ER46974 t2009_region1, replace
rename ER46526 t2009_siblings1, replace
rename ER46432 t2009_siblings2, replace

* Step 19: 2011 Rename of TAXSIM Variables
rename ER34106 t2011_age1, replace
rename ER47317 t2011_age2, replace
rename ER34104 t2011_age3, replace
rename ER34119 t2011_education1, replace
rename ER34116 t2011_employment1, replace
rename ER34101 t2011_familyID, replace
rename ER52407 t2011_mstat1, replace
rename ER47323 t2011_mstat2, replace
rename ER52237 t2011_pwages1, replace
rename ER34103 t2011_rel2HOH, replace
rename ER47303 t2011_state1, replace
rename ER52249 t2011_swages3, replace
rename ER52246 t2011_swages5, replace
rename ER51904 t2011_race1, replace
rename ER51810 t2011_race2, replace
rename ER51953 t2011_religion1, replace
rename ER51859 t2011_religion2, replace
rename ER52398 t2011_region1, replace
rename ER51887 t2011_siblings1, replace
rename ER51793 t2011_siblings2, replace

