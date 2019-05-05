* Development Economics: Problem Set 1
* S M Sajid Al Sanai

* Import dataset
use burkina731.dta, clear

* Identifier variables do not use {0} as indexing value
//tab village //v	[1-6]
//tab hhn     //h	[1-32]
//tab year    //t	[1-3]
//tab fcrop   //c	[1-44] 	discont.
//tab plotnum //i	[1-999]	discont.

* Generate fixed effects
** Fixed effects are 
gen fe_vtc  = (village * 1000) + (fcrop * 10) + year
label var fe_vtc "vtc Fixed Effects"
gen fe_vhtc = (fe_vtc  * 100)  + hhn
label var fe_vhtc "vhtc Fixed Effects"

* Dependent variable is log of yield (vhtci)
** {yield = tot_value / tot_area}
** => ln_yield = ln( tot_value / tot_area )
** => ln_yield = ln( tot_value ) - ln( tot_area )
rename lnvalue ln_value
rename lnarea  ln_area
gen ln_yield = ln_value - ln_area

* Fixed Effects Regression
** {xtreg, fe i(.)}				Command format
** {topo* soil* loc* ln_area}	Covariates matrix
** {totarea lntarea lnhhsize}	Exclude
xtreg ln_yield topo* soil* loc* ln_area, fe i(fe_vtc)
predict residuals_v, e
label var residuals_v "v Residuals"

xtreg ln_yield topo* soil* loc* ln_area, fe i(fe_vhtc)
predict residuals_h, e
label var residuals_h "h Residuals"

* Estimation of Density
kdensity residuals_v, normal gen(est_pts_vtc density_vtc)
label var density_vtc "vtc Density"
label var est_pts_vtc "vtc Pred. Dev."
graph export graph1.png, replace

kdensity residuals_h, at(est_pts_vtc) gen(est_pts_vhtc density_vhtc)
label var density_vhtc "vhtc Density"
label var est_pts_vhtc "vhtc Pred. Dev."
graph export graph2.png, replace

graph twoway connected density_vtc density_vhtc est_pts_vtc, l("Kernel Density Estimate")
graph export graph3.png, replace

* Modifying dataset structure and cleaning up
** Append residuals for village level and household level regressions
** into a single column by saving with one constructed index and then
** importing from temporary dataset.
keep residuals_v residuals_h
* Create the indexx
gen is_village = 1
* Save temporary dataset
save temp_burkina73, replace
* Change the index
replace is_village = 0
* Append using old index
append using temp_burkina73
* Verify
tab is_village
* Construct single variable residuals using index
gen residuals = .
replace residuals = residuals_v if is_village == 1
replace residuals = residuals_h if is_village == 0
keep residuals is_village
* Save temporary dataset
save temp_burkina73, replace

* Testing for equality of distribution
ksmirnov residuals, by(is_village)

* Reuse dataset prior to temporary modifications
use burkina731.dta, clear

* Generate fixed effects
** Fixed effects are 
gen fe_vtc  = (village * 1000) + (fcrop * 10) + year
label var fe_vtc "vtc Fixed Effects"
gen fe_vhtc = (fe_vtc  * 100)  + hhn
label var fe_vhtc "vhtc Fixed Effects"

* Dependent variable is log of yield (vhtci)
** {yield = tot_value / tot_area}
** => ln_yield = ln( tot_value / tot_area )
** => ln_yield = ln( tot_value ) - ln( tot_area )
rename lnvalue ln_value
rename lnarea  ln_area
gen ln_yield = ln_value - ln_area

* Fixed Effects Regression w/ Additional Household Characteristics
** {xtreg, fe i(.)}				Command format
** {topo* soil* loc* ln_area}	Covariates matrix
** {lntarea lnhhsize}			Additional Characteristics
** {totarea}					Exclude
xtreg ln_yield topo* soil* loc* ln_area lnhhsize, fe i(fe_vtc)
predict residuals_v_hs, e
label var residuals_v_hs "v Residuals w/ Log of Household Size"

xtreg ln_yield topo* soil* loc* ln_area lntarea, fe i(fe_vtc)
predict residuals_v_hta, e
label var residuals_v_hta "v Residuals w/ Log of Total Area Cultivated by Household Head"
