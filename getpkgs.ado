*! version 1.0.3 August 17, 2020 @ 19:44:57
*! downloads all packages and ancillary files from a net from site
program define getpkgs, rclass
version 11.1
   local self "getpkgs"
	syntax, from(str) [Describe ANcillary ADo copy all more log(str) add replace subdirs]
   if "`all'"!="" {
      local describe "describe"
      local ancillary "ancillary"
      local ado "ado"
      }
   if "`more'"=="" {
      set more off
      }

   local logreplace "replace"
   local fmod "get"
   if `"`copy'"'!="" {
      if `"`add'"'=="add" & `"`replace'"'=="replace" {
         display as error "cannot specify both 'add' and 'replace' options"
         exit 198
         }
      if `"`add'"'=="add" {
         local fmod "add new"
         local logreplace "append"
         }
      else if `"`replace'"'=="replace " {
         local fmod "replace"
         }
      }
   
   tempfile toc results
   tempname toch logn
   if `"`log'"'!="" {
      log using `log', name(`logn') `logreplace'
      local theLogFile `"`r(filename)'"'
      }
   if `"`log'`describe'`ancillary'`ado'`copy'"' != "" {
      local noisily "noisily"
      }
   capture `noisily' {
      // would normally preserve current -net from- but this looks to be impossible
      net from "`from'" // have quotes for file names
      copy "`from'/stata.toc" `toc'
      file open `toch' using `toc', read
      file read `toch' tocline
      while "`r(status)'"!="eof" {
         if strpos(ltrim(`"`tocline'"'),"p")==1 {
            local pkg : word 2 of `tocline'
            local pkgs "`pkgs' `pkg'"
            if "`subdirs'"!="" {
               capture cd `"`pkg'"'
               if _rc {
                  mkdir `"`pkg'"'
                  quietly cd `"`pkg'"'
                  }
               }
            capture n {
               if "`describe'`ado'`ancillary'"!="" {
                  display as text _newline "Trying to `fmod' files in package " as result `"`pkg'"' _newline
                  }
               if "`describe'"!="" {
                  net describe `pkg'
                  }
               if "`copy'"!="" {
                  CopyPkg, pkg(`pkg') from(`"`from'"') `replace' `add'
                  if `"`r(problems)'"'!="" {
                     if `"`problems'"'=="" {
                        local problems `"`r(problems)'"'
                        }
                     else {
                        local problems `"`problems' `r(problems)'"'
                        }
                     }
                  }
               else {
                  if "`ado'"!="" {
                     net install `pkg'
                     }
                  if "`ancillary'"!="" {
                     net get `pkg'
                     }
                  }
               }
            local rc = _rc
            if `"`subdirs'"'!="" {
               quietly cd ..
               }
            if `rc' {
               ThisIsAnErrorIHope // trips capture
               }
            }
         file read `toch' tocline
         }
      } //  capture block
   local rc = _rc
   local pcnt : word count `problems'
   if `pcnt' {
      local files = plural(`pcnt', "file")
      display as error `"Could not download the following `files': "'
      foreach baddie of local problems {
         display as error `"  `baddie'"'
         }
      }
   capture file close `toch'
   if `"`log'"'!="" {
      log close `logn'
      view `"`theLogFile'"'
      }
   return local pkgs `"`pkgs'"'
   if `rc' {
      exit `rc'
      }
end

program define CopyPkg, rclass
   syntax, pkg(str) from(str) [ replace add ]
   tempfile pkgfile
   tempname pkgh
   copy `"`from'/`pkg'.pkg"' `pkgfile'
   file open `pkgh' using `pkgfile', read
   file read `pkgh' line
   capture n {
      while "`r(status)'"!="eof" {
         if strpos(ltrim(`"`line'"'),"f")==1 {
            local fullfile : word 2 of `line'
            * pathasciisuffix misses many text suffixes
*            mata: st_local("ext",usubstr(st_local("fullfile"),ustrrpos(st_local("fullfile"),".")+1,.))
            mata: st_local("ext",pathsuffix(st_local("fullfile")))
            if inlist(`"`ext'"',".ado",".dct",".do",".grec",".log",".mata",".raw",".smcl",".stbcal") | inlist(`"`ext'"',".sthlp",".hlp",".txt",".text",".csv",".xml",".html",".htm",".tex") {
               local text "text"
               }
            else {
               local text
               }
            mata: st_local("file",pathbasename(st_local("fullfile")))
            local copyme 1
            if "`add'"=="add" {
               capture confirm file `"`file'"'
               local copyme = _rc
               }
            if `copyme' {
               capture copy `"`from'/`fullfile'"' `"`file'"', `text' `replace'
               local rc = _rc
               if _rc {
                  if `"`problems'"'=="" {
                     local problems `"`pkg'/`file'"'
                     }
                  else {
                     local problems `"`problems' `pkg'/`file'"'
                     }
                  display as error `"Could not copy `file'"'
                  }
               else {
                  display as text `"...copied file `file'"'
                  }
               }
            else {
               display as text `"...skipped file `file'"'
               }
            }   
         file read `pkgh' line
         }
      }
   capture file close `pkgh'
   return local problems = `"`problems'"'
end
