{smcl}
{* *! version 1.0.0 April 16, 2009 @ 18:22:04}{...}
{hi:help xmlappend} 
{hline}

{title:Title}

{phang}
{cmd:xmlappend}{hline 3}Append a new sheet to an MS Excel XML file from a Stata data set
{p_end}

{title:Syntax}
{* put the syntax in what follows. Don't forget to use [ ] around optional items}
{p 8 17 2}
   {cmd: xmlappend}
   [{varlist}]
   {ifin}
   {help using}
   {cmd:,} 
   {opt sheet(filename)}
{p_end}

{title:Description}

{pstd}
{cmd:xmlappend} can put all or part of the dataset in memory onto an
MS Excel workbook as a new sheet. If the workbook doesn't exist,
{cmd:xmlappend} creates a new workbook.
{p_end}

{title:Options}

{phang}{opt sheet} is a required option which names the sheet.
{p_end}

{title:Example(s)}

{phang}Create a workbook, and then append a sheet to it.{p_end}

{phang2}{cmd:. sysuse auto}{p_end}
{phang2}{cmd:. xmlappend using "splitauto.xml" if foreign, sheet(foreign)}{p_end}
{phang2}{cmd:. xmlappend using "splitauto.xml" if !foreign, sheet(domestic)}{p_end}

{title:Notes}

{pstd}Unlike {help xmlsave}, a {it:varlist} is not required. If no
{it:varlist} is given, all variables are exported. 

{pstd}
{cmd:xmlappend} does not check to see if the given name for a sheet
already exists. This behavior might change in the future.

{pstd}
{cmd:xmlappend} will work only if it appends to workbooks created using
{help xmlsave} or {help xmlappend}. If you export a workbook from MS Excel,
and then use {cmd:xmlappend} to try to add pages, you will be disappointed.

{pstd}
This was put together rather quickly, and without a copy of MS Excel for
heavy duty testing. Please let me know if you experience any problems with it.

{title:Also see}

{psee}
Manual: {hi:[D] xmlsave}
{p_end}

{psee}
Online: help for {help xmlsave}
{p_end}

{title:Author}

{pstd}
Bill Rising, StataCorp{break}
email: brising@stata.com{break}
web: {browse "http://homepage.mac.com/brising":http://homepage.mac.com/brising}
{p_end}
