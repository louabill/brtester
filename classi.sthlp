{smcl}
{* February 10, 2009 @ 17:00:29}{...}
{hi:help classi} 
{hline}

{title:Title}

{phang}
{cmd:classi}{hline 2}Simple immediate classification table
{p_end}

{title:Syntax}
{* put the syntax in what follows. Don't forget to use [ ] around optional items}
{p 8 17 2}
   {cmd: classi}
   {it:a b} {cmd:\} {it:c d}
{p_end}

{title:Description}

{pstd}
{cmd:classi} creates an immediate classification table like that created by
{help logistic_postestimation##estatclas:estat classification} after commands
such as {help logit:logit}, {help logistic:logistic}, {help probit:probit},
{help ivprobit:ivprobit}, and {help dprobit:dprobit}.
{p_end}

{title:Example}

{phang}{cmd:. classi 320 25 \ 47 195}{break}
{p_end}

{title:Author}

{pstd}
Bill Rising, StataCorp{break}
email: brising at stata.com{break}
web: {browse "http://homepage.mac.com/brising":http://homepage.mac.com/brising}
{p_end}
