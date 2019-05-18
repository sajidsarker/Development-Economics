
*ps2ans.do
version 7.0

clear
cap log close

set memory 40m
set matsize 250
set more off

        global base "gender i.hectdec i.soiltype ph om i.topo"
        global base_g "i.hectdec i.soiltype ph om i.topo"

use ps2
   replace topo=5 if topo==4 /*gets rid of the singleton ... I happen to know this is ok, but you wouldn't*/
   gen profitph=profit/hectares
   gen gender = 1
   replace gender = 0 if id==0
   gen hhyfe = (vill*100+ hhn)*10+year1
   xtile hectdec = hectares, nq(10)
save ps2t, replace

        xi: xtreg profitph $base , fe i(hhyfe)

use ps2t


*spatial effects

  xi i.hectdec i.soiltype i.topo
  foreach z of varlist profitph gender _I* x y ph om {
   qui drop if `z'==.
  }

gen cutx = 1500
gen cuty = 1500
save temp, replace
xtdata , fe i(hhyfe)
gen cons=1
x_ols x y cutx cuty profitph cons gender _I* ph om, xreg(18) coord(2)


*now the harder part -- construct spatial fixed effects

clear
set mem 100m

*distance is the number of meters over which we construct the fixed effects
*base is the base RHS set of variables
*basereg is how they enter the regressions
*utils is the set of variables that we need to do varous stuff
*extended is everything we need in the data



global distance=250
global base "gender hectdec soiltype ph om topo"
global basereg "gender I* ph om"
global indicvars "i.hectdec i.soiltype i.topo"
global otherindicvars "i.otherhectdec i.othersoiltype i.othertopo"
global utils "village hhn id plot year1"
global depend "profitph"
global extended $depend $utils $base

di "The cut-off for construction of the spatial f.e. is "
di "$distance  meters"


*set up the neighborhood

   use ps2t
   keep village hhn id plot x y
   qui by vill hhn id plot: keep if _n==1

cap save baselocation, replace
*construct the neighborhoods village by village in order to
*save memory

#delimit ;
for num 1/4:

   use baselocation                  \
   keep if village==X                \
   cap save baselocationX, replace   \
   ren hhn otherhhn                  \
   ren id otherid                    \
   ren plot otherplot                \
   ren x otherx                      \
   ren y othery                      \
   cross using baselocationX         \
   drop if hhn==otherhhn & id==otherid & plot==otherplot  \
   gen prox = sqrt((x-otherx)^2+(y-othery)^2)            \
   di "Village X"                    \
   count if prox <= $distance        \
   keep if prox <= $distance         \
cap save neighborX, replace       ;

#delimit cr
use neighbor1
   for num 2/4: append using neighborX
   order village hhn id plot otherhhn otherid otherplot x y prox
   sort village hhn id plot
cap save neighbor, replace

*
*we now have a dataset called neighbor in the form
*village hhn id plot otherhhn otherid otherplot
*such that every plot within $distance meters of v-hhn-id-plot is matched to it
*
*It's a huge dataset, so it is best to be careful about what you merge into it
*the global variable $extended contains all the variables that we want to use
*in the current analysis
*
use ps2t
   keep $extended
   sort village hhn id plot
   joinby village hhn id plot using neighbor
   sort village otherhhn otherid otherplot
save temp, replace

use ps2t
   keep $extended
   for var $extended: ren X otherX
   ren othervillage village
   sort village otherhhn otherid otherplot
   joinby village otherhhn otherid otherplot using temp
   sort village hhn id plot
cap save working, replace

*
*construct the indicator variables
*

xi $otherindicvars $indicvars
renpfix _Iother otherI
renpfix _I I

*
*collapse the data to difference out the spatial means
*

collapse (mean) other* $depend $basereg x y , by(village hhn id plot year1)

for num 2/10: ren Ihectdec_X Ihect_X
for num 2/3: ren Isoiltype_X Isoil_X


gen hhyfe=village*1000+hhn*10+year1

for var $depend $basereg: replace X=X-otherX

xtreg $depend $basereg, fe i(hhyfe)



