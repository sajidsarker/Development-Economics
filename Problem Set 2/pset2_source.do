* Development Economics: Problem Set 2
* S M Sajid Al Sanai


*"""    SOILDATA.DTA
use /Users/studentuser/Desktop/Ghana/soildata.dta
gen year = .
replace year = 2
save /Users/studentuser/Desktop/Ghana/temp_soildata.dta, replace
replace year = 1
append using /Users/studentuser/Desktop/Ghana/temp_soildata.dta
gen ph = .
gen oc = .
gen om = .
replace ph = ph97 if year == 1
replace ph = ph98 if year == 2
replace oc = oc97 if year == 1
replace oc = oc98 if year == 2
replace om = om97 if year == 1
replace om = om98 if year == 2
keep village hhn id ph oc om number plot year
* v h c t i
save /Users/studentuser/Desktop/Ghana/temp_soildata.dta, replace
clear

*"""    LANDC.DTA
use /Users/studentuser/Desktop/Ghana/landc.dta
gen year = year(date)
replace year = 0 if year == 1996
replace year = 1 if year == 1997
replace year = 2 if year == 1998
tab year
drop if year > 2
gen month = month(date)
gen day = day(date)
gen round = .
replace round = 1 if year == 0
replace round = 9 if year == 1 & ((month == 12 & day <= 31) | (month < 11))
replace round = 8 if year == 1 & ((month == 12 & day < 2) | (month < 12))
replace round = 7 if year == 1 & ((month == 9 & day < 29) | (month < 9))
replace round = 6 if year == 1 & ((month == 8 & day < 18) | (month < 8))
replace round = 5 if year == 1 & ((month == 7 & day < 7) | (month < 7))
replace round = 4 if year == 1 & ((month == 6 & day < 2) | (month < 6))
replace round = 3 if year == 1 & ((month == 4 & day < 14) | (month < 4))
replace round = 2 if year == 1 & ((month == 3 & day < 3) | (month < 3))
replace round = 1 if year == 1 & ((month == 1 & day < 27))
replace round = 15 if year == 2 & ((month == 8 & day >= 10) | (month > 8))
replace round = 14 if year == 2 & ((month == 8 & day < 10) | (month < 8))
replace round = 13 if year == 2 & ((month == 7 & day < 5) | (month < 7))
replace round = 12 if year == 2 & ((month < 7))
replace round = 11 if year == 2 & ((month == 4 & day < 20) | (month < 4))
replace round = 10 if year == 2 & ((month == 3 & day < 16) | (month < 3))
replace round = 9 if year == 2 & ((month == 10 & day < 20))
keep village hhn respondent_number plot_number date toposequence soil* area* day month year round
rename respondent_number id
rename plot_number plot
rename toposequence topo
replace topo = "3" if topo == "3 (60%), 9 (40%)" | topo == "3 (50%), 9 (50%)"
replace topo = "9" if topo == "3 (30%), 9 (70%)" | topo == "3 (40%), 9 (60%)" | topo == "5 (30%), 9 (70%)" | topo == "9 (90%), 3 (10%)"
replace topo = "3" if topo == "3, 5"
replace topo = "9" if topo == "5, 9"
replace topo = "5" if topo == "flat"
drop if topo == "hilly" | topo == "very"
destring topo, generate(ftopo)
drop topo
rename ftopo topo
gen ln_area = log(area_sqm)
xtile deciles_area = area_sqm, nq(10)
gen soiltype = ""
replace soiltype = "red sandy" if soil_description == "ama sika" | soil_description == "pongpong" | soil_description == "red soil" | soil_description == "sand (nfutuma)" | soil_description == "sandy" | soil_description == "sandy, mbe sika"
replace soiltype = "black sandy" if soil_description == "black and sandy" | soil_description == "black and sandy soil" | soil_description == "black loose soil" | soil_description == "black sand" | soil_description == "black soil" | soil_description == "black soil and red soil" | soil_description == "blank soil" | soil_description == "blind soil" | soil_description == "hard soil" | soil_description == "loose black soil" | soil_description == "marshy (black soil)" | soil_description == "oworam" | soil_description == "red and black soil" | soil_description == "sandy and black soil" | soil_description == "sandy black" | soil_description == "sandy black soil" | soil_description == "sandy soil"
replace soiltype = "rocky" if soil_description == "bipuosu " | soil_description == "hard sandy" | soil_description == "rocky" | soil_description == "rocky (black soil)" | soil_description == "rocky and sandy" | soil_description == "rocky red soil" | soil_description == "rocky, sandy" | soil_description == "sand and rocky" | soil_description == "sandy and rocky" | soil_description == "sandy and very stony" | soil_description == "sandy rocks" | soil_description == "stony"
replace soiltype = "gravels" if soil_description == "abu siabu" | soil_description == "afo nwa" | soil_description == "black soil wilt stones" | soil_description == "gravels" | soil_description == "gravels (mbosia)" | soil_description == "mbe sika" | soil_description == "mbe sika with small stones" | soil_description == "mbe sika, sandy" | soil_description == "nbe sika" | soil_description == "nbusia" | soil_description == "nbusia, rocky" | soil_description == "sand and gravels" | soil_description == "sandy (nbesika)" | soil_description == "sandy and gravels"
replace soiltype = "clay" if soil_description == "akrampasu" | soil_description == "akranpasu" | soil_description == "ameti" | soil_description == "ameti and sand" | soil_description == "asase kokoo" | soil_description == "askrampasu" | soil_description == "atwepi" | soil_description == "atwepi abo" | soil_description == "atwipi" | soil_description == "black and red soil (clay)" | soil_description == "black soil and clay" | soil_description == "clay" | soil_description == "clay (red soil)" | soil_description == "clay and black soil" | soil_description == "clay and sand" | soil_description == "clay and sandy" | soil_description == "clay sand" | soil_description == "hard clay" | soil_description == "marshy" | soil_description == "nso nwea (clay and sand)" | soil_description == "otanim (clay)" | soil_description == "otari" | soil_description == "sand and clay" | soil_description == "sandy (clay)" | soil_description == "sandy and clay" | soil_description == "sandy and water log" | soil_description == "sandy clay" | soil_description == "siw asase" | soil_description == "water log"
replace soiltype = "loamy" if soil_description == "loam and clay" | soil_description == "loamy" | soil_description == "lomay" | soil_description == "refuse dump"
replace soiltype = "rocky clay" if soil_description == "ameti with rocks" | soil_description == "clay and gravels" | soil_description == "clay and rocky" | soil_description == "clay rocks" | soil_description == "white sand" | soil_description == "white soil (sandy)"
rename soiltype soilt
gen soiltype = .
replace soiltype = 0 if soilt == "red sandy"
replace soiltype = 1 if soilt == "black sandy"
replace soiltype = 2 if soilt == "rocky"
replace soiltype = 3 if soilt == "gravels"
replace soiltype = 4 if soilt == "clay"
replace soiltype = 5 if soilt == "loamy"
replace soiltype = 6 if soilt == "rocky clay"
rename soilt soilcategory
save /Users/studentuser/Desktop/Ghana/temp_landc.dta, replace
clear

*"""    CROPC.DTA
use /Users/studentuser/Desktop/Ghana/cropc.dta
gen year = year(date)
replace year = 0 if year == 1996
replace year = 1 if year == 1997
replace year = 2 if year == 1998
tab year
drop if year > 2
gen month = month(date)
gen day = day(date)
gen round = .
replace round = 1 if year == 0
replace round = 9 if year == 1 & ((month == 12 & day <= 31) | (month < 11))
replace round = 8 if year == 1 & ((month == 12 & day < 2) | (month < 12))
replace round = 7 if year == 1 & ((month == 9 & day < 29) | (month < 9))
replace round = 6 if year == 1 & ((month == 8 & day < 18) | (month < 8))
replace round = 5 if year == 1 & ((month == 7 & day < 7) | (month < 7))
replace round = 4 if year == 1 & ((month == 6 & day < 2) | (month < 6))
replace round = 3 if year == 1 & ((month == 4 & day < 14) | (month < 4))
replace round = 2 if year == 1 & ((month == 3 & day < 3) | (month < 3))
replace round = 1 if year == 1 & ((month == 1 & day < 27))
replace round = 15 if year == 2 & ((month == 8 & day >= 10) | (month > 8))
replace round = 14 if year == 2 & ((month == 8 & day < 10) | (month < 8))
replace round = 13 if year == 2 & ((month == 7 & day < 5) | (month < 7))
replace round = 12 if year == 2 & ((month < 7))
replace round = 11 if year == 2 & ((month == 4 & day < 20) | (month < 4))
replace round = 10 if year == 2 & ((month == 3 & day < 16) | (month < 3))
replace round = 9 if year == 2 & ((month == 10 & day < 20))
keep village hhn respondent_number plot_number crop year day month round
rename respondent_number id
rename plot_number plot
save /Users/studentuser/Desktop/Ghana/temp_cropc.dta, replace
clear

*"""    PLOTACT.DTA
use /Users/studentuser/Desktop/Ghana/plotact.dta
save /Users/studentuser/Desktop/Ghana/temp_plotact.dta, replace
clear

*"""    PLOTHARV.DTA
use /Users/studentuser/Desktop/Ghana/plotharv.dta
keep village hhn id plot crop round value
rename value gross_value
gen ln_value = log(gross_value)
save /Users/studentuser/Desktop/Ghana/temp_plotharv.dta, replace
clear

*"""    PLOTINP.DTA
use /Users/studentuser/Desktop/Ghana/plotinp.dta
gen fertiliser = .
replace fertiliser = 0 if input != ""
replace fertiliser = 1 if input == "fertilizer" | (real(input) >= 41 & real(input) <= 49)
keep village hhn id plot round unit quantity fertiliser value
save /Users/studentuser/Desktop/Ghana/temp_plotinp.dta, replace
clear

* Merge
use /Users/studentuser/Desktop/Ghana/temp_landc.dta
sort village hhn id plot round
merge 1:1 _n using /Users/studentuser/Desktop/Ghana/temp_cropc.dta
sort village hhn id plot round crop
drop if _merge != 3
drop _merge

merge 1:1 _n using /Users/studentuser/Desktop/Ghana/temp_plotinp.dta
sort village hhn id plot round crop
drop if _merge != 3
drop _merge

merge 1:1 _n using /Users/studentuser/Desktop/Ghana/temp_plotact.dta
sort village hhn id plot round crop
drop if _merge != 3
drop _merge

merge 1:1 _n using /Users/studentuser/Desktop/Ghana/temp_plotharv.dta
sort village hhn id plot round crop
drop if _merge != 3
drop _merge

merge 1:1 _n using /Users/studentuser/Desktop/Ghana/temp_soildata.dta
sort village hhn id plot round crop
drop if _merge != 3
drop _merge

save /Users/studentuser/Desktop/Ghana/pset2_ghana.dta, replace

* Generate crop
replace crop = "24" if crop == "coconut"
replace crop = "0" if crop == "fallow"
replace crop = "36" if crop == "mango"
replace crop = "37" if crop == "pear"
replace crop = "38" if crop == "teak"
destring crop, generate(fcrop)
drop crop
rename fcrop crop

* Generate gender
gen female = .
replace female = 1 if id == 1
replace female = 0 if id == 0
drop if female == .

* Generate fixed effects
gen fe_vtc  = (village * 10000) + (crop * 100) + round
label var fe_vtc "vtc Fixed Effects"
gen fe_vhtc = (fe_vtc * 100) + hhn
label var fe_vhtc "vhtc Fixed Effects"

* Dependent variable is log of yield (vhtci)
** {yield = tot_value / tot_area}
** => ln_yield = ln( tot_value / tot_area )
** => ln_yield = ln( tot_value ) - ln( tot_area )
gen ln_yield = ln_value - ln_area
label var ln_yield "Log of Yield"

save /Users/studentuser/Desktop/Ghana/pset2_ghana.dta, replace

* Fixed Effects Regression
** {xtreg, fe i(.)}				Command format
** {topo* soil* loc* ln_area}	Covariates matrix
** {totarea lntarea lnhhsize}	Exclude

*** use #  for interaction
*** use *  for wildcard
*** use i. for categorical

global dependent    "ln_yield"
global soil         "ph oc om"
global land         "$soil i.soiltype i.topo i.deciles_area"
global independent  "female fertiliser $land"

xtreg $dependent $independent, fe i(fe_vhtc)
predict residuals_v, e
label var residuals_v "Residuals"
