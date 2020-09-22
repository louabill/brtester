*! version 1.0.1 March 10, 2011 @ 17:17:09
*! downloads all packages and ancillary files from a net from site
program define getpkgs
version 11.1
   local self "getpkgs"
	syntax, from(str) [Describe ANcillary ADo all more log(str) replace]
   if "`all'"!="" {
      local describe "describe"
      local ancillary "ancillary"
      local ado "ado"
      }
   if "`more'"=="" {
      set more off
      }
   tempfile toc results
   tempname toch logn
   if `"`log'"'!="" {
      log using `log', name(`logn') `replace'
      local capture "capture n"
      }
   `capture' {
      net from "`from'" // have quotes for file names
      // would normally preserve current -net from- but this looks to be impossible
      copy "`from'/stata.toc" `toc'
      file open `toch' using `toc', read
      file read `toch' tocline
      while "`r(status)'"!="eof" {
         if strpos(ltrim(`"`tocline'"'),"p")==1 {
            local pkg : word 2 of `tocline'
            display as text _newline "Trying to get package " as result `"`pkg'"' _newline
            if "`describe'"!="" {
               net describe `pkg'
               }
            if "`ado'"!="" {
               net install `pkg'
               }
            if "`ancillary'"!="" {
               net get `pkg'
               }
            }
         file read `toch' tocline
         }
      } // possible capture block
   capture file close `toch'
   if `"`capture'"'!="" {
      log close `logn'
      view `"`log'.smcl"'
      if _rc {
         exit _rc
         }
      }
end
