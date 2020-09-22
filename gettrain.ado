*! version 1.1.0 March 1, 2017 @ 10:55:22
*! wrapper for getpkgs to grab things from local site
program define gettrain
version 11.1
	syntax, date(str) [ local stage log(str) suffix(str) subdirs building ///
      sessions(str) ]
   if `"`sessions'"'=="" {
      local sessions  "/Volumes/Shuttle/Training/Sessions"
      }
   if "`log'"=="" {
      local log "downloadtest"
      }
   if "`local'"!="" {
      if "`stage'"!="" {
         display as error "May not specify -local- and -stage- at the same time"
         exit 198
         }
      local from : dir `"`sessions'"' dirs ///
        `"`:display %tdCCYY_NN_DD date("`date'","DMY")' *"'
      local howmany : word count `from'
      if `howmany'==0 {
         display as error "No training folder for `date' found"
         exit 9
         }
      else if `howmany' > 1 {
         display as error "Found multiple folders for `date':"
         display as result `"  `from'"'
         exit 9
         }
      local from : subinstr local from `"""' "", all // " for emacs
      local from `"`sessions'/`from'/Handouts"'
      }
   else {
      if "`stage'"!="" {
         if `"`building'"'!="" {
            local from "http://stage.stata.com/training"
            }
         else {
            getports stage
            local from "http://localhost:`r(portnum)'/training"
            }
         }
      else {
         local from "http://www.stata.com/training"
         }
      }

   capture erase `"`log'.smcl"'
   getpkgs, from(`from'/`date'`suffix') all copy log(`log') `subdirs'
end
