**********************************************************************************
** Marriage Tax Study
** Marriage of Interest
**		Use only the specified marriage, e.g. first, second, ...
**		`marriage_sort' = 
**			1 - Use earliest marriage
**			2 - Use last marriage
**			Else - Use all marriages
**********************************************************************************
args MoI

if `MoI' == 1 {
	* Always use earliest marriage
	* Note: will choose arbitrarily b/n marriages in same year
	** At least one case where this is true.
	sort family ID YoI
	* count number of marriages for each person
	bys family ID: gen num_marriages = _n
	bys couple: egen many_marriages = max(num_marriages)
	drop if many_marriages > 1
	}
if  `MoI' == 2 {
	* Always use last marriage
	* Note: will choose arbitrarily b/n marriages in same year
	** At least one case where this is true.
	sort family ID -YoI
	* count number of marriages for each person
	bys family ID: gen num_marriages = _n
	bys couple: egen many_marriages = max(num_marriages)
	drop if many_marriages > 1
	}
