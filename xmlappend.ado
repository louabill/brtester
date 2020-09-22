*! version 1.0.0 April 11, 2009 @ 11:39:40
*! appends a Stata dataset as xml to an existing xml dataset
program define xmlappend
version 10.1
	local self "xmlappend"
	syntax [varlist] [if] [in] using/, sheet(string)

	capture confirm file `"`using'"'
	if _rc {
		local new "new"
		}

	if "`varlist'"=="" {
		local varlist _all
		}

	tempfile xmlholder
	xmlsave `varlist' using `xmlholder' `if' `in', doctype(excel)
	if "`new'"!="" {
		filefilter `xmlholder' `"`using'"', from("Sheet1") to(`"`sheet'"')
		}
	else {
		tempfile xmlcleaner
		tempname inhandle outhandle 
		filefilter `xmlholder' `xmlcleaner', from("Sheet1") to(`"`sheet'"')

		file open `inhandle' using `"`using'"', read
		file open `outhandle' using `xmlholder', write replace
		file read `inhandle' line
		while !r(eof) {
			if `"`line'"'!="</Workbook>" {
				file write `outhandle' `"`line'"'_newline
				}
			else {
				continue, break
				}
			file read `inhandle' line
			}
		file close `inhandle'
		
		file open `inhandle' using `xmlcleaner', read
		file read `inhandle' line
		local nowrite 1
		while !r(eof) {
			if `nowrite' {
				if substr(`"`line'"',1,10)=="<Worksheet" {
					file write `outhandle' `"`line'"'_newline
					local nowrite 0
					}
				}
			else {
				file write `outhandle' `"`line'"'_newline
				}
			file read `inhandle' line
			}
*		file write `outhandle' "</Workbook>"_newline
		file close `inhandle'
		file close `outhandle'
		copy `xmlholder' `"`using'"', replace
		}
end
