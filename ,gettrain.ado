*! version 1.1.0 October 16, 2015 @ 22:07:33
*! wrapper for getpkgs to grab things from local site
program define gettrain
version 11.1
	syntax, date(str) [ local stage log(str) suffix(str) ]
   if "`log'"=="" {
      local log "downloadtest"
      }
   if "`local'"!="" {
      if "`stage'"!="" {
         display as error "May not specify -local- and -stage- at the same time"
         exit 198
         }
      local from : dir "/Volumes/Shuttle/Training/Sessions" dirs ///
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
      local from `"/Volumes/Shuttle/Training/Sessions/`from'/Handouts"'
      }
   else {
      if "`stage'"!="" {
         local from "http://localhost:8006/training"
         }
      else {
         local from "http://www.stata.com/training"
         }
      }

   capture erase `"`log'.smcl"'
   getpkgs, from(`from'/`date'`suffix') all log(`log')
end
