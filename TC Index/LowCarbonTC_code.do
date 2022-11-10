*** Change the path before running
** Make sure to install outreg package 
use "G:\final_tc.dta", replace
pca gii_* [aw=1/tot_cap]
***pca gii_*
predict absorp innov
scatter absorp innov , mlabel(countrycode)
gen combin=abs+inno
gen lnGDPPC=ln(ny_gdp_pcap_pp_kd)
drop if countrycode=="IRN"
*scatter score abs , mlabel(countrycode)
foreach var in score abs inno combin {
egen max_`var'=max(`var')
egen min_`var'=min(`var')
gen ind_`var'=(`var'-min_`var')/(max_`var'-min_`var')
}
reg re_score ind_abs  lnGDPPC,robust
outreg2 using RISE.doc,replace
reg re_score ind_inno lnGDPPC, robust
outreg2 using RISE.doc,append
reg re_score ind_combin lnGDPPC, robust
outreg2 using RISE.doc,append
scatter ind_abs   ind_inno , mlabel(countrycode)
export ind_abs  ind_inno  re_score all_score countrycode combin  tot_gen incomelevel delimited using "plots_new.csv", replace
*scatter score ind_com  , mlabel(countrycode)
