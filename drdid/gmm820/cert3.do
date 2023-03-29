cscript cert3.do 

*************************************************************
********************** No regressors ************************ 
*************************************************************


use lalonde, clear
set seed 111 
replace re = re/1000
tempvar dy

*local xvar age educ black married nodegree hisp re74
keep if treated==0 | sample==2
bysort id (year):gen double dy=re[2]-re[1] 
drdid re `xvar', time(year) tr( experimental ) reg 
matrix A = e(b), e(V)
drdid re `xvar', time(year) tr( experimental ) reg gmm
matrix B = e(b)[1,1], e(V)[1,1]
assert mreldif(A,B)<1E-8
drdid re `xvar',time(year) tr( experimental ) dripw 
matrix A = e(b), e(V)
drdid re `xvar', time(year) tr( experimental ) dripw gmm  
matrix B = e(b)[1,1], e(V)[1,1]
assert mreldif(A,B)<1E-8
drdid re `xvar', time(year) tr( experimental ) drimp
matrix A = e(b), e(V)
drdid re `xvar', time(year) tr( experimental ) drimp gmm 
matrix B = e(b)[1,1], e(V)[1,1]
assert mreldif(A,B)<1E-8
drdid re `xvar', time(year) tr( experimental ) ipw 
matrix A = e(b), e(V)
drdid re `xvar', time(year) tr( experimental ) ipw gmm 
matrix B = e(b)[1,1], e(V)[1,1]
assert mreldif(A,B)<1E-8
drdid re `xvar', time(year) tr( experimental ) stdipw 
matrix A = e(b), e(V)
drdid re `xvar', time(year) tr( experimental ) stdipw gmm 
matrix B = e(b)[1,1], e(V)[1,1]
assert mreldif(A,B)<1E-8
// !! SHOULD ERROR OUT
/*drdid re `xvar', time(year) tr( experimental ) ipwra 
matrix A = e(b), e(V)
drdid re `xvar', time(year) tr( experimental ) ipwra gmm  
matrix B = e(b)[1,1], e(V)[1,1]
assert mreldif(A,B)<1E-7
*/

use lalonde, clear
set seed 111 
drop if runiform()<.1
replace re = re/1000
tempvar dy
*local xvar age educ black married nodegree hisp re74
keep if treated==0 | sample==2
bysort id (year):gen double dy=re[2]-re[1] 
drdid re `xvar', time(year) tr( experimental ) reg 
matrix A = e(b), e(V)
drdid re `xvar', time(year) tr( experimental ) reg gmm
matrix B = e(b)[1,1], e(V)[1,1]
assert mreldif(A,B)<1E-8
drdid re `xvar', time(year) tr( experimental ) dripw 
matrix A = e(b), e(V)
drdid re `xvar', time(year) tr( experimental ) dripw gmm 
matrix B = e(b)[1,1], e(V)[1,1]
assert mreldif(A,B)<1E-8 
drdid re `xvar', time(year) tr( experimental ) drimp
matrix A = e(b), e(V)
drdid re `xvar', time(year) tr( experimental ) drimp gmm 
matrix B = e(b)[1,1], e(V)[1,1]
assert mreldif(A,B)<1E-8 
drdid re `xvar', time(year) tr( experimental ) ipw 
matrix A = e(b), e(V)
drdid re `xvar', time(year) tr( experimental ) ipw gmm 
matrix B = e(b)[1,1], e(V)[1,1]
assert mreldif(A,B)<1E-8 
drdid re `xvar', time(year) tr( experimental ) stdipw 
matrix A = e(b), e(V)
drdid re `xvar', time(year) tr( experimental ) stdipw gmm 
matrix B = e(b)[1,1], e(V)[1,1]
assert mreldif(A,B)<1E-8
// !! SHOULD ERROR OUT 
/*
cap noi drdid re `xvar', time(year) tr( experimental ) ipwra 
matrix A = e(b), e(V)
drdid re `xvar', time(year) tr( experimental ) ipwra gmm  
matrix B = e(b)[1,1], e(V)[1,1]
assert mreldif(A,B)<1E-7
*/


*************************************************************
*********************** Regresssors ************************* 
*************************************************************

use lalonde, clear
set seed 111 
replace re = re/1000
tempvar dy

local xvar age educ black married nodegree hisp re74
keep if treated==0 | sample==2
bysort id (year):gen double dy=re[2]-re[1] 
drdid re `xvar', time(year) tr( experimental ) reg 
matrix A = e(b), e(V)
drdid re `xvar', time(year) tr( experimental ) reg gmm
matrix B = e(b)[1,1], e(V)[1,1]
assert mreldif(A,B)<1E-7
//!! NUMERICAL DIFFERENCES
/*
drdid re `xvar',time(year) tr( experimental ) dripw 
matrix A = e(b), e(V)
drdid re `xvar', time(year) tr( experimental ) dripw gmm  
matrix B = e(b)[1,1], e(V)[1,1]
assert mreldif(A,B)<1E-8
*/
drdid re `xvar', time(year) tr( experimental ) drimp
matrix A = e(b), e(V)
drdid re `xvar', time(year) tr( experimental ) drimp gmm 
matrix B = e(b)[1,1], e(V)[1,1]
assert mreldif(A,B)<1E-8
*/
drdid re `xvar', time(year) tr( experimental ) ipw 
matrix A = e(b), e(V)
drdid re `xvar', time(year) tr( experimental ) ipw gmm 
matrix B = e(b)[1,1], e(V)[1,1]
assert mreldif(A,B)<1E-8
drdid re `xvar', time(year) tr( experimental ) stdipw 
matrix A = e(b), e(V)
drdid re `xvar', time(year) tr( experimental ) stdipw gmm 
matrix B = e(b)[1,1], e(V)[1,1]
assert mreldif(A,B)<1E-8
// !! SHOULD ERROR OUT ?
cap noi drdid re `xvar', time(year) tr( experimental ) ipwra 
rcof "noi drdid re `xvar', time(year) tr( experimental ) ipwra gmm"==198

use lalonde, clear
set seed 111 
drop if runiform()<.1
replace re = re/1000
tempvar dy
local xvar age educ black married nodegree hisp re74
keep if treated==0 | sample==2
bysort id (year):gen double dy=re[2]-re[1] 
drdid re `xvar', time(year) tr( experimental ) reg 
matrix A = e(b), e(V)
drdid re `xvar', time(year) tr( experimental ) reg gmm
matrix B = e(b)[1,1], e(V)[1,1]
assert mreldif(A,B)<1E-8
/* !! NUMERICAL DIFFERENCES 
drdid re `xvar', time(year) tr( experimental ) dripw 
matrix A = e(b), e(V)
drdid re `xvar', time(year) tr( experimental ) dripw gmm 
matrix B = e(b)[1,1], e(V)[1,1]
assert mreldif(A,B)<1E-8 

drdid re `xvar', time(year) tr( experimental ) drimp
matrix A = e(b), e(V)
drdid re `xvar', time(year) tr( experimental ) drimp gmm 
matrix B = e(b)[1,1], e(V)[1,1]
assert mreldif(A,B)<1E-8 
*/
drdid re `xvar', time(year) tr( experimental ) ipw 
matrix A = e(b), e(V)
drdid re `xvar', time(year) tr( experimental ) ipw gmm 
matrix B = e(b)[1,1], e(V)[1,1]
assert mreldif(A,B)<1E-8 
drdid re `xvar', time(year) tr( experimental ) stdipw 
matrix A = e(b), e(V)
drdid re `xvar', time(year) tr( experimental ) stdipw gmm 
matrix B = e(b)[1,1], e(V)[1,1]
assert mreldif(A,B)<1E-8
// !! SHOULD ERROR OUT ?

cap noi drdid re `xvar', time(year) tr( experimental ) ipwra 
rcof "noi drdid re `xvar', time(year) tr( experimental ) ipwra gmm"==198 


