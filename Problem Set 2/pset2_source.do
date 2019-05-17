use soildata.dta
* drop if yearfrom != "both"
gen year = .
replace year = 2
save temp_soildata.dta
replace year = 1
append temp_soildata.dta
gen soil1 = .
gen soil2 = .
gen soil3 = .
replace soil1 = ph97 if year == 1
replace soil1 = ph98 if year == 2
replace soil2 = oc97 if year == 1
replace soil2 = oc98 if year == 2
replace soil3 = om97 if year == 1
replace soil3 = om98 if year == 2
keep village hhn id soil* number plot year
* v h c t i
* What is number and plot?
save temp_soildata.dta
clear

*'''    SOILDATA.DTA
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

use sales.dta
gen year = year(date)
replace year = 1 if year == 1997
replace year = 2 if year == 1998
keep village hhn id round crop date unit quantity value plot year
*bysort village hhn id plot crop round: egen gross_quantity = total(quantity)
bysort village hhn plot crop round: egen gross_quantity = total(quantity)
gen log_sales = log(gross_sales)
gen log_quantity = log(gross_quantity)
gen log_yield = log_sales - log_quantity
save temp_sales.dta
clear

*'''    SALES.DTA
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
*spouse_sales    str9    %9s                   how much amount did respondent's
*                                                spouse get from their sale
*amt_spouse_gave str8    %8s                   how much amount did your spouse
*                                                give to you from their sales
*spouse_sales_~s str15   %15s                  how much amount did respondent's
*                                                spouse get from their sale
*                                                since Christmas
*'''

use landc.dta
keep village hhn respondent_number plot_number date toposequence area

save temp_landc.dta
clear

*'''    LANDC.DTA
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
*own_family_la~_ str3    %9s                   is this respondent's or
*                                                respondent's family's land
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
*'''

*

*'''    FIXED EFFECTS REGRESSION
*$var_dependent: log_yield
*$var_independent: ? ?
*$fe_: ?
*ixtreg var_dependent var_independent, vce(fe_)
*residuals_vhtci = ln_yield - ?
