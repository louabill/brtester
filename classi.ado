*! version 1.0.0 February 10, 2009 @ 16:50:37
*! immediate classification table
program define classi, rclass
version 9
	syntax anything(everything)
	local cnt 1
	tokenize `"`anything'"', parse("\")
	if `"`2'"'!="\" | `"`4'"'!="" {
		Usage
		}
	tokenize `"`1' `3'"'
	if `"`4'"'=="" | `"`5'"'!="" {
		Usage
		}
	local cnt 1
	local letters "a b c d"
	foreach letter of local letters {
		capture confirm integer number ``cnt''
		if _rc {
			Usage
			}
		if ``cnt'' < 0 {
         Usage
         }
      local `letter' ``cnt''
      local ++cnt
      }
   
   ret scalar P_corr = ((`a'+`d')/(`a'+`b'+`c'+`d'))*100 
   ret scalar P_p1 = (`a'/(`a'+`c'))*100     //  sensitivity
   ret scalar P_n0 = (`d'/(`b'+`d'))*100     //  specificity
   ret scalar P_p0 = (`b'/(`b'+`d'))*100     //  false + given ~D
   ret scalar P_n1 = (`c'/(`a'+`c'))*100     //  false - given D
   ret scalar P_1p = (`a'/(`a'+`b'))*100     //  + pred value
   ret scalar P_0n = (`d'/(`c'+`d'))*100     //  - pred value
   ret scalar P_0p = (`b'/(`a'+`b'))*100     //  false + given +
   ret scalar P_1n = (`c'/(`c'+`d'))*100     //  false - given -
   global S_1 "`return(P_corr)'"
   global S_2 "`return(P_p1)'"
   global S_3 "`return(P_n0)'"
   global S_4 "`return(P_p0)'"
   global S_5 "`return(P_n1)'"
   global S_6 "`return(P_1p)'"
   global S_7 "`return(P_0n)'"
   global S_8 "`return(P_0p)'"
   global S_9 "`return(P_1n)'"
   
   di _n as text "Immediate classification table"
   di _n in smcl as text _col(15) "{hline 8} True {hline 8}" _n                 ///
                `"Classified {c |}"' _col(22) `"D"' _col(35)                    ///
                `"~D  {c |}"' _col(46) `"Total"'                         
   di    in smcl as text "{hline 11}{c +}{hline 26}{c +}{hline 11}" 
   di    in smcl as text _col(6) "+" _col(12) `"{c |} "'                        ///
                 as result %9.0g `a' _col(28) %9.0g `b'                         ///
                 as text `"  {c |}  "'                                          ///
                 as result %9.0g `a'+`b' 
   di    in smcl as text _col(6) "-" _col(12) "{c |} "                          ///
                 as result %9.0g `c' _col(28) %9.0g `d'                         ///
                 as text `"  {c |}  "'                                          ///
                 as result %9.0g `c'+`d'  
   di    in smcl as text "{hline 11}{c +}{hline 26}{c +}{hline 11}" 
   di    in smcl as text `"   Total   {c |} "'                                  ///
                 as result %9.0g `a'+`c' _col(28) %9.0g `b'+`d'                 ///
                 as text `"  {c |}  "'                                          ///
                 as result %9.0g `a'+`b'+`c'+`d'
   di _n in smcl as text "{hline 50}"
   di            as text `"Sensitivity"' _col(33) `"Pr( +| D)"'                 ///
                 as result %8.2f return(P_p1) `"%"' _n                          ///
                 as text `"Specificity"' _col(33) `"Pr( -|~D)"'                 ///
                 as result %8.2f return(P_n0) `"%"' _n                          ///
                 as text `"Positive predictive value"' _col(33) `"Pr( D| +)"'   ///
                 as result %8.2f return(P_1p) `"%"' _n                          ///
                 as text `"Negative predictive value"' _col(33) `"Pr(~D| -)"'   ///
                 as result %8.2f return(P_0n) `"%"' 
   di    in smcl as text "{hline 50}"  
   di            as text `"False + rate for true ~D"' _col(33) `"Pr( +|~D)"'      ///
                 as result %8.2f return(P_p0) `"%"' _n                            ///
                 as text `"False - rate for true D"' _col(33) `"Pr( -| D)"'       ///
                 as result %8.2f return(P_n1) `"%"' _n                            ///
                 as text `"False + rate for classified +"' _col(33) `"Pr(~D| +)"' ///
                 as result %8.2f return(P_0p) `"%"' _n                            ///
                 as text `"False - rate for classified -"' _col(33) `"Pr( D| -)"' ///
                 as result %8.2f return(P_1n) `"%"' 
   di    in smcl as text "{hline 50}" 
   di            as text `"Correctly classified"' _col(42)                       /// 
                 as result %8.2f return(P_corr) `"%"' 
   di    in smcl as text "{hline 50}"  
end

program Usage
	display as error "specify cells as a b \ c d, where a, b, c, and d are non-negative integers"
	exit 198
end

