**********************************************************************************
** Marriage Tax Study
** Inflation_Adj
**		Applies CPI Adjustment to Fiscal Values
**			`FiscalYear': 1983, 1984, 1985, 1996, 2012
**		Normalize dollar measurement
**			`DollarMeasure': $, 1000's of $, etc.
**********************************************************************************
args FiscalYear DollarMeasure limited

if `limited' == 0 {
	#delimit ;
	local Dollar_Vars "pwages swages c_pwages c_swages fiitax c_fiitax
	siitax c_siitax ficar c_ficar c_ltcg ltcg dividends c_dividends otherprop
	c_otherprop stcg c_stcg c_FedTax_RegTax FedAGI c_FedAGI FedCred_EITC c_FedCred_EITC
	TPreMT_Bio TPreMT_HighE TPreMT_HoH TPreMT_Male TPreMT_Female
	PreMT_Bio PreMT_HighE PreMT_HoH PreMT_Male PreMT_Female
	s_TPreMT_Bio s_TPreMT_HighE s_TPreMT_HoH s_TPreMT_Male s_TPreMT_Female
	s_PreMT_Bio s_PreMT_HighE s_PreMT_HoH s_PreMT_Male s_PreMT_Female";
	#delimit cr
}
if `limited' == 1 {
	#delimit ;
	local Dollar_Vars "pwages swages c_pwages c_swages fiitax c_fiitax
	siitax c_siitax ficar c_ficar c_ltcg ltcg dividends c_dividends otherprop
	c_otherprop stcg c_stcg c_FedTax_RegTax FedAGI c_FedAGI FedCred_EITC c_FedCred_EITC";
	#delimit cr
}
* Removed predicted variables: pfiitax c_pfiitax pTaxInc c_pTaxInc

* Step 1: Adjust to correct dollar measurement
qui foreach X of local Dollar_Vars {
	replace `X' = `X'/`DollarMeasure'
}

* Step 2: Adjust Variables to the Fiscal Year
if `FiscalYear' == 1983 {	
	qui foreach X of local Dollar_Vars {
		replace `X' = `X'*2.86344034 if YoI == 1968
		replace `X' = `X'*2.71512949 if YoI == 1969
		replace `X' = `X'*2.56535737 if YoI == 1970
		replace `X' = `X'*2.45976538 if YoI == 1971
		replace `X' = `X'*2.38182543 if YoI == 1972
		replace `X' = `X'*2.24324324 if YoI == 1973
		replace `X' = `X'*2.01994254 if YoI == 1974
		replace `X' = `X'*1.85072778 if YoI == 1975
		replace `X' = `X'*1.75018304 if YoI == 1976
		replace `X' = `X'*1.64333837 if YoI == 1977
		replace `X' = `X'*1.52682678 if YoI == 1978
		replace `X' = `X'*1.37237341 if YoI == 1979
		replace `X' = `X'*1.20861563 if YoI == 1980
		replace `X' = `X'*1.0954083 if YoI == 1981
		replace `X' = `X'*1.03212435 if YoI == 1982
		replace `X' = `X'*1 if YoI == 1983
		replace `X' = `X'*0.95876785 if YoI == 1984
		replace `X' = `X'*0.9259374 if YoI == 1985
		replace `X' = `X'*0.90869003 if YoI == 1986
		replace `X' = `X'*0.87656766 if YoI == 1987
		replace `X' = `X'*0.84222394 if YoI == 1988
		replace `X' = `X'*0.80344179 if YoI == 1989
		replace `X' = `X'*0.76229351 if YoI == 1990
		replace `X' = `X'*0.73132228 if YoI == 1991
		replace `X' = `X'*0.70982302 if YoI == 1992
		replace `X' = `X'*0.68947217 if YoI == 1993
		replace `X' = `X'*0.67195143 if YoI == 1994
		replace `X' = `X'*0.65361479 if YoI == 1995
		replace `X' = `X'*0.63500159 if YoI == 1996
		replace `X' = `X'*0.62049631 if YoI == 1997
		replace `X' = `X'*0.61101171 if YoI == 1998
		replace `X' = `X'*0.59792886 if YoI == 1999
		replace `X' = `X'*0.5625 if YoI == 2001
		replace `X' = `X'*0.54142695 if YoI == 2003
		replace `X' = `X'*0.5100064 if YoI == 2005
		replace `X' = `X'*0.48036481 if YoI == 2007
		replace `X' = `X'*0.46425558 if YoI == 2009
		replace `X' = `X'*0.44278638 if YoI == 2011
	}
}	

if `FiscalYear' == 1984 {	
	qui foreach X of local Dollar_Vars {
		replace `X' = `X'*2.98658361 if YoI == 1968
		replace `X' = `X'*2.83189459 if YoI == 1969
		replace `X' = `X'*2.67568148 if YoI == 1970
		replace `X' = `X'*2.56554847 if YoI == 1971
		replace `X' = `X'*2.48425668 if YoI == 1972
		replace `X' = `X'*2.33971471 if YoI == 1973
		replace `X' = `X'*2.10681088 if YoI == 1974
		replace `X' = `X'*1.93031898 if YoI == 1975
		replace `X' = `X'*1.82545029 if YoI == 1976
		replace `X' = `X'*1.71401072 if YoI == 1977
		replace `X' = `X'*1.5924885 if YoI == 1978
		replace `X' = `X'*1.43139281 if YoI == 1979
		replace `X' = `X'*1.26059258 if YoI == 1980
		replace `X' = `X'*1.14251673 if YoI == 1981
		replace `X' = `X'*1.07651123 if YoI == 1982
		replace `X' = `X'*1.04300535 if YoI == 1983
		replace `X' = `X'*1 if YoI == 1984
		replace `X' = `X'*0.96575767 if YoI == 1985
		replace `X' = `X'*0.94776857 if YoI == 1986
		replace `X' = `X'*0.91426476 if YoI == 1987
		replace `X' = `X'*0.87844408 if YoI == 1988
		replace `X' = `X'*0.83799408 if YoI == 1989
		replace `X' = `X'*0.79507622 if YoI == 1990
		replace `X' = `X'*0.76277305 if YoI == 1991
		replace `X' = `X'*0.74034921 if YoI == 1992
		replace `X' = `X'*0.71912316 if YoI == 1993
		replace `X' = `X'*0.70084893 if YoI == 1994
		replace `X' = `X'*0.68172372 if YoI == 1995
		replace `X' = `X'*0.66231006 if YoI == 1996
		replace `X' = `X'*0.64718098 if YoI == 1997
		replace `X' = `X'*0.63728848 if YoI == 1998
		replace `X' = `X'*0.623643 if YoI == 1999
		replace `X' = `X'*0.58669051 if YoI == 2001
		replace `X' = `X'*0.56471121 if YoI == 2003
		replace `X' = `X'*0.53193941 if YoI == 2005
		replace `X' = `X'*0.50102307 if YoI == 2007
		replace `X' = `X'*0.48422106 if YoI == 2009
		replace `X' = `X'*0.46182857 if YoI == 2011
		}
}	

if `FiscalYear' == 1985 {	
	qui foreach X of local Dollar_Vars {
		replace `X' = `X'*3.09247724 if YoI == 1968
		replace `X' = `X'*2.9323035 if YoI == 1969
		replace `X' = `X'*2.77055162 if YoI == 1970
		replace `X' = `X'*2.65651369 if YoI == 1971
		replace `X' = `X'*2.57233958 if YoI == 1972
		replace `X' = `X'*2.42267267 if YoI == 1973
		replace `X' = `X'*2.1815109 if YoI == 1974
		replace `X' = `X'*1.99876123 if YoI == 1975
		replace `X' = `X'*1.89017426 if YoI == 1976
		replace `X' = `X'*1.77478345 if YoI == 1977
		replace `X' = `X'*1.64895248 if YoI == 1978
		replace `X' = `X'*1.48214491 if YoI == 1979
		replace `X' = `X'*1.3052887 if YoI == 1980
		replace `X' = `X'*1.1830263 if YoI == 1981
		replace `X' = `X'*1.11468048 if YoI == 1982
		replace `X' = `X'*1.07998661 if YoI == 1983
		replace `X' = `X'*1.03545644 if YoI == 1984
		replace `X' = `X'*1 if YoI == 1985
		replace `X' = `X'*0.98137307 if YoI == 1986
		replace `X' = `X'*0.94668133 if YoI == 1987
		replace `X' = `X'*0.90959059 if YoI == 1988
		replace `X' = `X'*0.86770637 if YoI == 1989
		replace `X' = `X'*0.82326679 if YoI == 1990
		replace `X' = `X'*0.78981827 if YoI == 1991
		replace `X' = `X'*0.76659936 if YoI == 1992
		replace `X' = `X'*0.74462071 if YoI == 1993
		replace `X' = `X'*0.72569854 if YoI == 1994
		replace `X' = `X'*0.70589522 if YoI == 1995
		replace `X' = `X'*0.68579322 if YoI == 1996
		replace `X' = `X'*0.67012771 if YoI == 1997
		replace `X' = `X'*0.65988446 if YoI == 1998
		replace `X' = `X'*0.64575517 if YoI == 1999
		replace `X' = `X'*0.60749247 if YoI == 2001
		replace `X' = `X'*0.58473386 if YoI == 2003
		replace `X' = `X'*0.55080009 if YoI == 2005
		replace `X' = `X'*0.51878756 if YoI == 2007
		replace `X' = `X'*0.50138981 if YoI == 2009
		replace `X' = `X'*0.47820337 if YoI == 2011
	}
}

if `FiscalYear' == 1996{
	quietly foreach X of local Fin_Vars_Head{
		replace `X' = `X'*4.50934356 if YoI == 1968
		replace `X' = `X'*4.27578373 if YoI == 1969
		replace `X' = `X'*4.03992273 if YoI == 1970
		replace `X' = `X'*3.87363655 if YoI == 1971
		replace `X' = `X'*3.75089677 if YoI == 1972
		replace `X' = `X'*3.53265766 if YoI == 1973
		replace `X' = `X'*3.18100389 if YoI == 1974
		replace `X' = `X'*2.91452462 if YoI == 1975
		replace `X' = `X'*2.75618685 if YoI == 1976
		replace `X' = `X'*2.58792795 if YoI == 1977
		replace `X' = `X'*2.40444558 if YoI == 1978
		replace `X' = `X'*2.16121254 if YoI == 1979
		replace `X' = `X'*1.90332693 if YoI == 1980
		replace `X' = `X'*1.72504812 if YoI == 1981
		replace `X' = `X'*1.6253886 if YoI == 1982
		replace `X' = `X'*1.5747992 if YoI == 1983
		replace `X' = `X'*1.50986684 if YoI == 1984
		replace `X' = `X'*1.45816548 if YoI == 1985
		replace `X' = `X'*1.43100433 if YoI == 1986
		replace `X' = `X'*1.38041804 if YoI == 1987
		replace `X' = `X'*1.32633359 if YoI == 1988
		replace `X' = `X'*1.26525948 if YoI == 1989
		replace `X' = `X'*1.20045921 if YoI == 1990
		replace `X' = `X'*1.15168574 if YoI == 1991
		replace `X' = `X'*1.11782872 if YoI == 1992
		replace `X' = `X'*1.08578021 if YoI == 1993
		replace `X' = `X'*1.05818856 if YoI == 1994
		replace `X' = `X'*1.02931204 if YoI == 1995
		replace `X' = `X'*1 if YoI == 1996
		replace `X' = `X'*0.9771571 if YoI == 1997
		replace `X' = `X'*0.96222075 if YoI == 1998
		replace `X' = `X'*0.94161789 if YoI == 1999
		replace `X' = `X'*0.88582455 if YoI == 2001
		replace `X' = `X'*0.85263873 if YoI == 2003
		replace `X' = `X'*0.80315767 if YoI == 2005
		replace `X' = `X'*0.75647811 if YoI == 2007
		replace `X' = `X'*0.73110932 if YoI == 2009
		replace `X' = `X'*0.69729964 if YoI == 2011
	}
}
if `FiscalYear' == 2012 {
	quietly foreach X of local Dollar_Vars{
		replace `X' = `X'*6.60068759 if YoI == 1968
		replace `X' = `X'*6.25880736 if YoI == 1969
		replace `X' = `X'*5.9135587 if YoI == 1970
		replace `X' = `X'*5.67015229 if YoI == 1971
		replace `X' = `X'*5.49048824 if YoI == 1972
		replace `X' = `X'*5.17103416 if YoI == 1973
		replace `X' = `X'*4.65629035 if YoI == 1974
		replace `X' = `X'*4.26622329 if YoI == 1975
		replace `X' = `X'*4.0344516 if YoI == 1976
		replace `X' = `X'*3.78815757 if YoI == 1977
		replace `X' = `X'*3.51957971 if YoI == 1978
		replace `X' = `X'*3.16354002 if YoI == 1979
		replace `X' = `X'*2.78605218 if YoI == 1980
		replace `X' = `X'*2.52509119 if YoI == 1981
		replace `X' = `X'*2.37921157 if YoI == 1982
		replace `X' = `X'*2.30515981 if YoI == 1983
		replace `X' = `X'*2.21011311 if YoI == 1984
		replace `X' = `X'*2.13443368 if YoI == 1985
		replace `X' = `X'*2.09467574 if YoI == 1986
		replace `X' = `X'*2.02062853 if YoI == 1987
		replace `X' = `X'*1.94146079 if YoI == 1988
		replace `X' = `X'*1.85206171 if YoI == 1989
		replace `X' = `X'*1.75720837 if YoI == 1990
		replace `X' = `X'*1.68581472 if YoI == 1991
		replace `X' = `X'*1.63625549 if YoI == 1992
		replace `X' = `X'*1.58934352 if YoI == 1993
		replace `X' = `X'*1.54895542 if YoI == 1994
		replace `X' = `X'*1.50668654 if YoI == 1995
		replace `X' = `X'*1.46378015 if YoI == 1996
		replace `X' = `X'*1.43034316 if YoI == 1997
		replace `X' = `X'*1.40847963 if YoI == 1998
		replace `X' = `X'*1.37832158 if YoI == 1999
		replace `X' = `X'*1.29665239 if YoI == 2001
		replace `X' = `X'*1.24807565 if YoI == 2003
		replace `X' = `X'*1.17564626 if YoI == 2005
		replace `X' = `X'*1.10731765 if YoI == 2007
		replace `X' = `X'*1.07018331 if YoI == 2009
		replace `X' = `X'*1.02069337 if YoI == 2011
	}
}
