use soildata.dta
* drop if yearfrom != "both"
gen round = .
replace round = 2
save temp_soildata.dta
replace round = 1
append temp_soildata.dta
gen soil1 = .
gen soil2 = .
gen soil3 = .
replace soil1 = ph97 if round == 1
replace soil1 = ph98 if round == 2
replace soil2 = oc97 if round == 1
replace soil2 = oc98 if round == 2
replace soil3 = om97 if round == 1
replace soil3 = om98 if round == 2
keep village hhn id soil* number plot
* v h c t i
* What is number and plot?

*'''
*village         float   %3.0f                 
*hhn             float   %3.0f                 
*id              float   %3.0f                 
*plot            float   %3.0f                 
*ph97            float   %6.4g                 
*oc97            float   %6.4g                 
*om97            float   %6.4g                 
*number          float   %9.0g                 
*ph98            float   %9.0g                 
*oc98            float   %9.0g                 
*om98            float   %9.0g                 
*yearfrom        str5    %9s   
*'''

save temp_soildata.dta

use soilfin.dta