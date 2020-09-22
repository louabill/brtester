*! version 1.0.1 May 12, 2004 @ 10:46:09
*! reverses badly ordered ordinal labels
program define label_reverse
version 8.2
	local me "label_reverse"
	syntax , old(name) new(name) [min(str) max(str)]

	capture lab l `new'
	if !_rc {
		display as error "[`me']: The new macro `new' already exists!"
		exit 110
		}

	quietly label list `old'
	local omin `r(min)'
	local omax `r(max)'
	
	if "`max'"!="" & "`min'"!="" {
		display as error "[`me']: please specify only max or min!"
		exit 198
		}

	if "`min'"!="" {
		capture confirm integer number `min'
		if _rc {
			display as error "[`me']: min must be an integer!"
			exit _rc
			}
		}
	else {
		local min "`omin'"
		}

	if "`max'"!="" {
		capture confirm integer number `max'
		if _rc {
			display as error "[`me']: max must be an integer!"
			exit _rc
			}
		local min = `omin' - `omax' + `max'
		}

	forvalues oldval = `omin'/`omax' {
		local newval = `omax'-`oldval'+`min'
		local oldlab : label `old' `oldval'
		if `"`oldlab'"'!="`oldval'" {
			label define `new' `newval' `"`oldlab'"', modify
			}
		}

	
end
