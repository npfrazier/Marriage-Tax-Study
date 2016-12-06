**********************************************************************************
** Marriage Tax Study
** Refresh Control variables
** 		Generate additional controls for regressions
**********************************************************************************
args y

** Sections
* 1 * Race     : race_head race_wife
* 2 * Religion : religion_head religion_wife
* 3 * Region   : region_couple
* 4 * Siblings : brothers_head brothers_wife sisters_head sisters_wife
* 5 * Work Status : employment

**********************************************************************************
* Section 1:  Race
**********************************************************************************
* Step 1: Set Head's Race
gen race_head`y' = .
capture confirm variable t`y'_race1
if !_rc {
	replace race_head`y' = t`y'_race1 if t`y'_race1 < 5 
	/* 8 = DK, 9 = NA,etc; All the rest coded inconsistently over the
	period. Sum of remainders (e.g. "Mentions Latino descent") always
	less than 6% */
	drop t`y'_race1
}
* Step 2: Set Spouse's Race
gen race_wife`y' = .
capture confirm variable t`y'_race2
if !_rc {
	replace race_wife`y' = t`y'_race2 if t`y'_race2 > 0 & t`y'_race2 < 5
	/* 8 = DK, 9 = NA,etc; All the rest coded inconsistently over the
	period. Sum of remainders (e.g. "Mentions Latino descent") always
	less than 6% */
	drop t`y'_race2
}


**********************************************************************************
* Section 2:  Religion
**********************************************************************************
* Step 1: Set Head's Religion
gen religion_head`y' = .
capture confirm variable t`y'_religion1
if !_rc {
	/*
	** Use conventions of 1994+ 
	1	Catholic
	2	Jewish
	8	Protestant (Post 1995 "Protestant" Includes jehovah's witness, "christian", and pentacostal
	10	Other non-Christian: Muslim, Rastafarian, etc.
	13	Greek/Russian/Eastern Orthodox
	97	Other
	98	DK
	99	NA; refused
	0	Inap.: none; atheist; agnostic
	*/
	** Catholic (==1 for 1985+)
	replace religion_head`y' = 1 if t`y'_religion1 == 1 & `y' > 1984 & `y' < 1994
	** Jewish (==2 for 1985+)
	replace religion_head`y' = 2 if t`y'_religion1 == 2 & `y' > 1984 & `y' < 1994
	** Protestant (==8 for 1994+) (=3-9 for 1985-1995)
	replace religion_head`y' = 8 if t`y'_religion1 > 2 & t`y'_religion1 < 10 ///
		& `y' > 1984 & `y' < 1994
	** Add Jehovah's Witnesses to Protestant (==12 for 1985-1995)
	replace religion_head`y' = 8 if t`y'_religion1 == 12 & `y' > 1984 & `y' < 1994
	** Add "Christian" to Protestant (==14 for 1985-1995)
	replace religion_head`y' = 8 if t`y'_religion1 == 14 & `y' > 1984 & `y' < 1994
	** Add "Pentacostal" to Protestant (==18 for 1985-1995)
	replace religion_head`y' = 8 if t`y'_religion1 == 18 & `y' > 1984 & `y' < 1994
	** Greek Orthodox
	replace religion_head`y' = 13 if t`y'_religion1 == 13 & `y' > 1984 & `y' < 1994
	** Create Broad Others Category
	** Mormons
	replace religion_head`y' = 97 if t`y'_religion1 == 11 & `y' > 1984 & `y' < 1994
	** Unitarian, Christiant Scientist, Seventh Day Adventist
	replace religion_head`y' = 97 if t`y'_religion1 > 14 & t`y'_religion1 < 18 ///
		& `y' > 1984 & `y' < 1994	
	** Amish, Mennonite, Quaker, Church of God, etc.	
	replace religion_head`y' = 97 if t`y'_religion1 > 19 & t`y'_religion1 <= 97 ///
		& `y' > 1984 & `y' < 1994
	** None
	replace religion_head`y' = 0 if t`y'_religion1 == 0 & `y' > 1984 & `y' < 1994
	** 1994+ 
	replace religion_head`y' = t`y'_religion1 if `y' > 1993 & t`y'_religion1 <= 97
	** Drop Used Variable
	drop t`y'_religion1
}
* Step 2: Set Wife's Religion
gen religion_wife`y' = .
capture confirm variable t`y'_religion2
if !_rc {
	* see religion_head for explanation
	* NOTE: wife differs in year 1994 for some reason (But Response Range Does Not)
	** Catholic (==1 for 1985+)
	replace religion_wife`y' = 1 if t`y'_religion2 == 1 & `y' > 1984 & `y' < 1994
	** Jewish (==2 for 1985+)
	replace religion_wife`y' = 2 if t`y'_religion2 == 2 & `y' > 1984 & `y' < 1994
	** Protestant (==8 for 1994+) (=3-9 for 1985-1995)
	replace religion_wife`y' = 8 if t`y'_religion2 > 2 & t`y'_religion2 < 10 ///
		& `y' > 1984 & `y' < 1994
	** Add Jehovah's Witnesses to Protestant (==12 for 1985-1995)
	replace religion_wife`y' = 8 if t`y'_religion2 == 12 & `y' > 1984 & `y' < 1994
	** Add "Christian" to Protestant (==14 for 1985-1995)
	replace religion_wife`y' = 8 if t`y'_religion2 == 14 & `y' > 1984 & `y' < 1994
	** Add "Pentacostal" to Protestant (==18 for 1985-1995)
	replace religion_wife`y' = 8 if t`y'_religion2 == 18 & `y' > 1984 & `y' < 1994
	** Greek Orthodox
	replace religion_wife`y' = 13 if t`y'_religion2 == 13 & `y' > 1984 & `y' < 1994
	** Create Broad Others Category
	** Mormons
	replace religion_wife`y' = 97 if t`y'_religion2 == 11 & `y' > 1984 & `y' < 1994
	** Unitarian, Christiant Scientist, Seventh Day Adventist
	replace religion_wife`y' = 97 if t`y'_religion2 > 14 & t`y'_religion2 < 18 ///
		& `y' > 1984 & `y' < 1994	
	** Amish, Mennonite, Quaker, Church of God, etc.	
	replace religion_wife`y' = 97 if t`y'_religion2 > 19 & t`y'_religion2 <= 97 ///
		& `y' > 1984 & `y' < 1994
	** None
	replace religion_wife`y' = 0 if t`y'_religion2 == 0 & `y' > 1984 & `y' < 1994
	** 1994+ (No Changes Required)
	replace religion_wife`y' = t`y'_religion2 if `y' > 1993 & t`y'_religion2 <= 97
	** Drop Used Variable
	drop t`y'_religion2
}

**********************************************************************************
* Section 3: Region
**********************************************************************************
* Couple's region of residence
gen region_couple`y' = .
capture confirm variable t`y'_region1
if !_rc {
	/*
	1 - NORTHEAST: Connecticut, Maine, Massachusetts, New Hampshire, New Jersey,
	New York, Pennsylvania, Rhode Island, Vermont
	2 - NORTH CENTRAL: Illinois, Indiana, Iowa, Kansas, Michigan, Minnesota, Missouri,
	Nebraska, North Dakota, Ohio, South Dakota, Wisconsin
	3 - SOUTH: Alabama, Arkansas, Delaware, Florida, Georgia, Kentucky, Louisiana,
	Maryland, Mississippi, North Carolina, Oklahoma, South Carolina,
	Tennessee, Texas, Virginia, Washington DC, West Virginia
	4 - WEST: Arizona, California, Colorado, Idaho, Montana, Nevada, New Mexico,
	Oregon, Utah, Washington, Wyoming.
	5 - ALASKA,HAWAII
	6 - FOREIGN COUNTRY
	9 - NA (?)
	*/
	replace region_couple`y' = t`y'_region1 if t`y'_region1 < 9
	drop t`y'_region1
}

**********************************************************************************
* Section 4: Siblings
**********************************************************************************
* Step 1: Head's number of brothers
gen brothers_head`y' = .
capture confirm variable t`y'_siblings1
if !_rc {
	replace brothers_head`y' = t`y'_siblings1 if t`y'_siblings1 < 51
	drop t`y'_siblings1
}
* Step 2: Head's number of sisters
gen sisters_head`y' = .
capture confirm variable t`y'_siblings2
if !_rc {
	replace sisters_head`y' = t`y'_siblings2 if t`y'_siblings2 < 51
	drop t`y'_siblings2
}
* Step 3: Wife's number of brothers
gen brothers_wife`y' = .
capture confirm variable t`y'_siblings3
if !_rc {
	replace brothers_wife`y' = t`y'_siblings3 if t`y'_siblings3 < 51
	drop t`y'_siblings3
}
* Step 4: Wife's number of sisters
gen sisters_wife`y' = .
capture confirm variable t`y'_siblings4
if !_rc {
	replace sisters_wife`y' = t`y'_siblings4 if t`y'_siblings4 < 51
	drop t`y'_siblings4
}

**********************************************************************************
* Section 5: Education
**********************************************************************************
rename t`y'_education1 education`y'

**********************************************************************************
* Section 6: Employment Status
**********************************************************************************
rename t`y'_employment1 employment`y'

**********************************************************************************
* Section 7: Number of Marriages
**********************************************************************************
gen tmp_F = marr_howmany if sex == 2
gen tmp_M = marr_howmany if sex == 1
bys couple : egen marr_howmany_f`y' = max(tmp_F)
bys couple : egen marr_howmany_m`y' = max(tmp_M)
drop tmp_*

