**   Data Pack
**   COP FY17
**   Aaron Chafetz
**   Purpose: mehcanism list
**   Date: December 10, 2016
**   Updated: 1/25/16

*** SETUP ***

*define date for Fact View Files
	global datestamp "20161230_v2_2"

*set today's date for saving
	global date: di %tdCCYYNNDD date(c(current_date), "DMY")

*import/open data
	capture confirm file "$fvdata/ICPI_FactView_PSNU_IM_${datestamp}.dta"
		if !_rc{
			use "$fvdata/ICPI_FactView_PSNU_IM_${datestamp}.dta", clear
		}
		else{
			import delimited "$fvdata/ICPI_FactView_PSNU_IM_${datestamp}.txt", clear
			save "$fvdata/ICPI_FactView_PSNU_IM_${datestamp}.dta", replace
		}
		*end
*clean
	run "$dofiles/06_datapack_dup_snus"
	
*update all partner and mech to offical names (based on FACTS Info)
	run "$dofiles/05_datapack_officialnames"
	
*keep
	gen n = 1
	collapse n, by(operatingunit fundingagency mechanismid implementingmechanismname)
	drop n
	drop if mechanismid<2 //drop dedups 00000 and 00001
	sort operatingunit mechanismid
*export
	export excel using "$dpexcel/Global_PSNU_${date}.xlsx", ///
		sheet("PBAC IM Targets") firstrow(variables) sheetreplace
