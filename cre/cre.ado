*! v1.1.1  CRE Correlated RE model. Allows for Fracreg
* v1.1  CRE Correlated RE model. Drops unnecessary Means
* does not work with "complex" heckman, because that requires different variables. 

* requires reghdfe
*capture program drop cre
*capture program drop myhdmean
*capture program drop cre_opt
program define cre, properties(prefix)
	set prefix cre
	gettoken first second : 0, parse(":")
	if "`first'"==":" {
		`second' 
	}
	else {
		cre_opt `first'
		local felist `r(felist)'
		local prefix `r(prefix)'
		local keep   `r(keep)'
		local keepsingletons `r(keepsingletons)'
		
		local compact  `r(compact)'
		
		gettoken other cmd0 : second, parse(" :")
		*cmd0 will have the command itself.

		gettoken cmd 0: cmd0
		if inlist("`cmd'","ivregress","fracreg") {
			gettoken cmd2 0: 0	
			local cmd `cmd' `cmd2'
		}
		
		syntax anything [if] [in] [aw iw fw pw], [*]
		
		_iv_parse `0'

		local x `s(exog)'   `s(inst)'
		local y `s(lhs)' 
		marksample touse
		markout `touse' `felist' `x'  `y'
 		***
  
		myhdmean `x' if `touse' [`weight'`exp'], abs(`felist') prefix(`prefix') `compact' `keepsingletons'
		local vlist `r(vlist)'
		`cmd' `anything' `vlist'  `if' `in' [`weight'`exp'], `options'
		if "`keep'"==""{
			drop `vlist'
		}
		
	}
end

program cre_opt, rclass
	syntax , abs(varlist) [keep prefix(name) compact keepsingletons]
	if "`prefix'"=="" local prefix m
	return local felist `abs'
	return local prefix `prefix'
	return local keep   `keep'
	return local keepsingletons   `keepsingletons'
	return local compact   `compact'
end 

program myhdmean, rclass
	syntax anything [if] [aw iw pw fw], abs(varlist) prefix(name) [compact  keepsingletons]
	
	ms_fvstrip `anything' `if', expand dropomit
	local vvlist `r(varlist)'
	** First check and create
	foreach i in `vvlist' {
		capture confirm variable `i'
		if _rc!=0 {
			local vn = strtoname("`i'")
			gen double `vn'=`i'
			local dropvlist `dropvlist' `vn'
		}
		else local vn `i'
		
		local vflist `vflist' `vn'
	}
	***
	
	if "`compact'"=="" {
		foreach i in `vflist' {
			local vplist
			local cnt
			local fex
			foreach j of varlist `abs' {
				local cnt=`cnt'+1
				capture drop `prefix'`cnt'_`i'
				local fex `fex' `prefix'`cnt'_`i'=`j'
				local vplist `vplist' `prefix'`cnt'_`i'
			}
			qui:reghdfe `i' `if'  [`weight'`exp'], abs(`fex')  `keepsingletons' resid
			qui:sum _reghdfe_resid, meanonly
			if abs(`r(max)'-`r(min)')>epsfloat() local vlist `vlist' `vplist'
			else  local dropvlist `dropvlist' `vplist'
		}
		
		local vflist `vlist'
		local vlist
		foreach i in `vflist' {
			sum `i', meanonly
			if abs(`r(max)'-`r(min)')>epsfloat() local vlist `vlist' `i'
			else local dropvlist `dropvlist' `i'
		}
		
		return local vlist  `vlist'
	}
	else {
		foreach i in  `vflist' {
			local cnt
			local fex
			local vplist
			capture drop `prefix'`cnt'_`i'
			qui:reghdfe `i' `if'  [`weight'`exp'], abs(`abs') resid `keepsingletons'
			qui:sum _reghdfe_resid, meanonly
			if abs(`r(max)'-`r(min)')>epsfloat() {
				qui:gen double `prefix'`cnt'_`i'=`i'-_reghdfe_resid-_cons
				local vlist `vlist' `prefix'`cnt'_`i'
			}
 			qui:drop _reghdfe_resid			
		}
		
		/*local vflist `vlist'
		local vlist
		foreach i in `vflist' {
			sum `i', meanonly
			if abs(`r(max)'-`r(min)')>epsfloat() local vlist `vlist' `i'
			else local dropvlist `dropvlist' `i'
		}*/
		return local vlist   `vlist'
	}
	*display in w "`dropvlist'"
	if "`dropvlist'"!="" drop `dropvlist'
	
end

*cre,   abs( age isco) :reg lnwage educ exper tenure  [w=wt]
*reghdfe lnwage educ exper tenure  [w=wt], abs(age isco)