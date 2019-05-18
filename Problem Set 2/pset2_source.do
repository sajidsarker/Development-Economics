* Development Economics: Problem Set 2
* S M Sajid Al Sanai

use soildata.dta
* drop if yearfrom != "both"
gen year = .
replace year = 2
save temp_soildata.dta
replace year = 1
append temp_soildata.dta
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
* What is number and plot?
save temp_soildata.dta, replace
clear

*"""    SOILDATA.DTA
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
*"""

* Avoid use
use sales.dta
gen year = year(date)
replace year = 1 if year == 1997
replace year = 2 if year == 1998
keep village hhn id round crop date unit quantity value plot year
*bysort village hhn id plot crop round: egen gross_quantity = total(quantity)
bysort village hhn plot crop round: egen gross_value = total(value)
gen log_value = log(gross_value)
*gen log_yield = log_sales - log_quantity
save temp_sales.dta, replace
clear

*"""    SALES.DTA
*village         byte    %8.0g                 
*hhn             byte    %8.0g                 
*id              byte    %8.0g                 
*round           long    %8.0g                 
*crop            str9    %9s                   
*ID_addsales     float   %9.0g                 
*date            long    %dD_m_Y               interview date
*unit            str10   %10s                  unit of crop sales
*quantity        double  %10.0g                quantity of crop sales
*value           double  %12.0g                value of crop sales
*plot            str3    %9s                   which plot was used for harvest
*when_harvest    str15   %15s                  when was it harvested
*sold_to         str21   %21s                  sold to whom
*who_harvest     str13   %13s                  who did harvest crop
*all_given       str4    %9s                   did respondent give all the crops
*                                                to her(yes/no)
*crops_remain    str14   %14s                  if all_given=No, how much crops
*                                                remained
*crops_date      str15   %15s                  if all_given=No, what month will
*                                                you give to her
*all_paid        str4    %9s                   have respondent completely been
*                                                paid(yes/no)
*pay_remains     str14   %14s                  if all_paid=No, how much remains
*                                                to be paid
*pay_date        str15   %15s                  if all_paid=No, what month will
*                                                you be paid
*checked         str1    %1s                   
*pineapple_price str15   %15s                  pineapple price
*kilos_sold      str14   %14s                  kilos of sold pineapple
*give_to_spouse  str15   %15s                  how much amount did respondent
*                                                give to spouse
*spouse_sales    str9    %9s                   how much amount did respondent"s
*                                                spouse get from their sale
*amt_spouse_gave str8    %8s                   how much amount did your spouse
*                                                give to you from their sales
*spouse_sales_~s str15   %15s                  how much amount did respondent"s
*                                                spouse get from their sale
*                                                since Christmas
*"""

use landc.dta
gen year = year(date)
replace year = 1 if year == 1997
replace year = 2 if year == 1998
keep village hhn respondent_number plot_number date toposequence soil* area year
rename respondent_number id
rename plot_number plot
rename toposequence topo
gen ln_area = log(area)
gen soiltype = .

replace soiltype = "red sandy" if soil_description == "ama sika" | if soil_description == "pongpong" | if soil_description == "red soil" | if soil_description == "sand (nfutuma)" | if soil_description == "sandy" | if soil_description == "sandy, mbe sika"

replace soiltype = "black sandy" if soil_description == "black and sandy" | if soil_description == "black and sandy soil" | if soil_description == "black loose soil" | if soil_description == "black sand" | if soil_description == "black soil" | if soil_description == "black soil and red soil" | if soil_description == "blank soil" | if soil_description == "blind soil" | if soil_description == "hard soil" | if soil_description == "loose black soil" | if soil_description == "marshy (black soil)" | if soil_description == "oworam" | if soil_description == "red and black soil" | if soil_description == "sandy and black soil" | if soil_description == "sandy black" | if soil_description == "sandy black soil" | if soil_description == "sandy soil"

replace soiltype = "rocky" if soil_description == "bipuosu " | if soil_description == "hard sandy" | if soil_description == "rocky" | if soil_description == "rocky (black soil)" | if soil_description == "rocky and sandy" | if soil_description == "rocky red soil" | if soil_description == "rocky, sandy" | if soil_description == "sand and rocky" | if soil_description == "sandy and rocky" | if soil_description == "sandy and very stony" | if soil_description == "sandy rocks" | if soil_description == "stony"

replace soiltype = "gravels" if soil_description == "abu siabu" | if soil_description == "afo nwa" | if soil_description == "black soil wilt stones" | if soil_description == "gravels" | if soil_description == "gravels (mbosia)" | if soil_description == "mbe sika" | if soil_description == "mbe sika with small stones" | if soil_description == "mbe sika, sandy" | if soil_description == "nbe sika" | if soil_description == "nbusia" | if soil_description == "nbusia, rocky" | if soil_description == "sand and gravels" | if soil_description == "sandy (nbesika)" | if soil_description == "sandy and gravels"

replace soiltype = "clay" if soil_description == "akrampasu" | if soil_description == "akranpasu" | if soil_description == "ameti" | if soil_description == "ameti and sand" | if soil_description == "asase kokoo" | if soil_description == "askrampasu" | if soil_description == "atwepi" | if soil_description == "atwepi abo" | if soil_description == "atwipi" | if soil_description == "black and red soil (clay)" | if soil_description == "black soil and clay" | if soil_description == "clay" | if soil_description == "clay (red soil)" | if soil_description == "clay and black soil" | if soil_description == "clay and sand" | if soil_description == "clay and sandy" | if soil_description == "clay sand" | if soil_description == "hard clay" | if soil_description == "marshy" | if soil_description == "nso nwea (clay and sand)" | if soil_description == "otanim (clay)" | if soil_description == "otari" | if soil_description == "sand and clay" | if soil_description == "sandy (clay)" | if soil_description == "sandy and clay" | if soil_description == "sandy and water log" | if soil_description == "sandy clay" | if soil_description == "siw asase" | if soil_description == "water log"

replace soiltype = "loamy" if soil_description == "loam and clay" | if soil_description == "loamy" | if soil_description == "lomay" | if soil_description == "refuse dump"

replace soiltype = "rocky clay" if soil_description == "ameti with rocks" | if soil_description == "clay and gravels" | if soil_description == "clay and rocky" | if soil_description == "clay rocks" | if soil_description == "white sand" | if soil_description == "white soil (sandy)"

save temp_landc.dta, replace
clear

*"""    LANDC.DTA
*village         byte    %8.0g                 village of respondent
*hhn             byte    %8.0g                 household number of respondent
*respondent_nu~r byte    %8.0g                 id number of respondent within
*                                                household
*plot_number     byte    %8.0g                 plot number
*date            long    %dD/N/Y               date of interview
*soil_descript~n str35   %35s                  description of soil on plot
*toposequence    str16   %16s                  toposequence of plot
**area            str19   %19s                  area of plot (in acres unless
*                                                otherwise noted)
*land_last_fal~w str14   %14s                  when was the land last fallow
*current_fallow  str24   %24s                  duration of last or current
*                                                fallow (years)
*own_family_la~_ str3    %9s                   is this respondent"s or
*                                                respondent"s family"s land
*harvest_dec     str15   %15s                  who decides when to harvest the
*                                                crops on this plot
*harvest_dec_c~1 str9    %9s                   type of crop 1 (harvest)
*harvest_dec_p~1 str9    %9s                   who decides when to harvest crop
*                                                1 on this plot
*harvest_dec_c~2 str9    %9s                   type of crop 2 (harvest)
*harvest_dec_p~2 str4    %4s                   who decides when to harvest crop
*                                                2 on this plot
*harvest_dec_c~3 str8    %8s                   type of crop 3 (harvest)
*harvest_dec_p~3 str1    %1s                   who decides when to harvest crop
*                                                3 on this plot
*sell_dec        str31   %31s                  who decides whether and when to
*                                                sell the crops
*sell_dec_crop1  str7    %7s                   type of crop 1 (sell)
*sell_dec_pers1  str7    %7s                   who decides when to sell crop 1
*                                                on this plot
*sell_dec_crop2  str9    %9s                   type of crop 2 (sell)
*sell_dec_pers2  str4    %4s                   who decides when to sell crop 2
*                                                on this plot
*sell_dec_crop3  str1    %1s                   type of crop 3 (sell)
*sell_dec_pers3  str1    %1s                   who decides when to sell crop 3
*                                                on this plot
*inherit_dec     str20   %20s                  who decides who will inherit this
*                                                plot
*inherit_person  str18   %18s                  do you know now who will inherit
*                                                the land
*rent_dec        str20   %20s                  who can rent out the land for a
*                                                season
*lend_dec        str20   %20s                  who can lend out the land for a
*                                                season
*mortgage_dec    str20   %20s                  who can mortgage the land
*pledge_dec      str20   %20s                  who can pledge the land
*sell_land_dec   str20   %20s                  who can sell the land
*register_dec    str20   %20s                  who can register the land
*"""

use cropc.dta
gen year = year(date)
replace year = 1 if year == 1997
replace year = 2 if year == 1998
keep village hhn respondent_number plot_number crop year
rename respondent_number id
rename plot_number plot
save temp_cropc.dta, replace
clear

*"""    CROPC.DTA
*village         byte    %8.0g                 village of respondent
*hhn             int     %8.0g                 household number of respondent
*respondent_nu~r byte    %8.0g                 id number of respondent within
*                                                household
*plot_number     byte    %8.0g                 number of plot
*crop            str10   %10s                  crop currently being grown on
*                                                plot
*date_planted_~_ str28   %28s                  date crop was planted
*proportion_of~t str14   %14s                  proportion of plot used for this
*                                                crop
*notes           str37   %37s                  notes about the crops
*date            long    %dD/N/Y               date of interview
*"""

use plotact.dta
save temp_plotact.dta, replace
clear

*"""    PLOTACT.DTA
*village         byte    %8.0g                 
*hhn             int     %8.0g                 
*id              float   %9.0g                 
*plot            float   %9.0g                 
*round           float   %9.0g                 when survey was done
*plot_descript~n str80   %80s                  
*activity1       str15   %15s                  type of plot activity
*activity2       str15   %15s                  type of plot activity if there is
*                                                more than one
*activity3       str15   %15s                  type of plot activity if there is
*                                                more than two
*crop1           str10   %10s                  type of crop
*crop2           str9    %9s                   type of crop if there is more
*                                                than one
*crop3           str10   %10s                  type of crop if there is more
*                                                than two
*crop4           str14   %14s                  type of crop if there is more
*                                                than three
*payment         str25   %25s                  whether there is payments on
*                                                account of this land
*payment_value   double  %12.0g                value of payments in Ghana
*                                                current cds
*payment_to      str17   %17s                  payment to whom
*form            float   %9.0g                 
*activity4       str1    %1s                   type of plot activity if there is
*                                                more than three
*r_s_notes       str80   %80s                  notes from survery
*repround        float   %9.0g                 actual round of activity when
*                                                this is not as same as round
*"""

use plotharv.dta
keep village hhn id plot crop round value
rename value gross_yield
gen ln_yield = log(gross_yield)
save temp_plotharv.dta, replace
clear

*"""    PLOTHARV.DTA
*village         byte    %8.0g                 
*hhn             float   %9.0g                 
*id              float   %8.0g                 
*plot            float   %9.0g                 
*crop            str25   %25s                  type of crop
*unit            str15   %15s                  units of crop harvested
*quantity        double  %9.0g                 quantity of crop harvested
*value           double  %12.0g                total value of crop in Ghana
*                                                current cds
*to_owner        str19   %19s                  how much of harvest did they give
*                                                to owner of land
*round           float   %9.0g                 when survey was done
*form            float   %8.0g                 
*what_happened~_ str25   %25s                  describe what they did with
*                                                harvest in code
*plot_descript~n str80   %80s                  
*r_s_notes       str80   %80s                  notes from survery
*repround        float   %9.0g                 actual round of activity when
*                                                this is not as same as round
*"""

use plotinp.dta
gen fertiliser = .
replace fertiliser = 0 if input != .
replace fertiliser = 1 if input == "fertilizer" | (input >= 41 and input <= 49)
keep village hhn id plot round unit quantity
save temp_plotinp.dta, replace
clear

*"""    PLOTINP.DTA
*village         byte    %8.0g                 
*hhn             float   %8.0g                 
*id              float   %8.0g                 
*plot            float   %9.0g                 
*input           str25   %25s                  type of non-labour inputs
*unit            str15   %15s                  units of non-labour inputs
*quantity        double  %9.0g                 quantity of non-labour inputs
*value           double  %12.0g                total value of non-labour inputs
*                                                in Ghana current cds
*source          str19   %19s                  sources of non-labour inputs
*how             str20   %20s                  how was it obtained
*round           float   %9.0g                 when survey was done
*form            float   %8.0g                 
*plot_descript~n str80   %80s                  
*r_s_notes       str80   %80s                  notes from survery
*repround        float   %9.0g                 actual round of activity when
*                                                this is not as same as round
*seed            float   %9.0g                 dummy varaible whether they used
*                                                seed or other chemicals
*"""

*


* Merge
*use ...
*merge 1:1 $varlist using dataset.dta
*merge 1:1 observations using temp_plotact.dta
*merge 1:1 observations using temp_plotharv.dta
*merge 1:1 observations using temp_plotinp.dta
*merge 1:1 observations using temp_cropc.dta
*merge 1:1 observations using temp_landc.dta
*merge 1:1 observations using temp_soildata.dta
*save pset2_dataset.dta, replace


* Generate gender
gen female = .
if id == 1 replace female = 1
if id == 0 replace female = 0
drop if female == .


* Generate fixed effects
gen fe_vtc  = (village * 10000) + (fcrop * 100) + round
label var fe_vtc "vtc Fixed Effects"
gen fe_vhtc = (fe_vtc * 100) + hhn
label var fe_vhtc "vhtc Fixed Effects"


* Dependent variable is log of yield (vhtci)
** {yield = tot_value / tot_area}
** => ln_yield = ln( tot_value / tot_area )
** => ln_yield = ln( tot_value ) - ln( tot_area )
gen ln_yield = ln_value - ln_area
label var ln_yield "Log of Yield"


* Fixed Effects Regression
** {xtreg, fe i(.)}				Command format
** {topo* soil* loc* ln_area}	Covariates matrix
** {totarea lntarea lnhhsize}	Exclude

*** use #  for interaction
*** use *  for wildcard
*** use i. for categorical

global dependent    "ln_yield"
global soil         "ph oc om"
global land         "$soil i.soiltype i.topo ln_area"
global independent  "female fertiliser $land"

xtreg $dependent $independent, fe i(fe_vhtc)
predict residuals_v, e
label var residuals_v "Residuals"