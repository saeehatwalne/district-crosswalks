* Saee
* DLHS data cleaning
* DLHS 4


clear all


if(c(username)=="sabareesh"){
	global medicalcolleges = ""

}

if(c(username)=="20170"){
	global medicalcolleges = ""

}


if (c(username) == "saeehatwalne") {
	global medicalcolleges = "/Users/saeehatwalne/Library/CloudStorage/Dropbox/Medical Education/Medical Colleges"
}

global DLHS4 "$medicalcolleges/Data/DLHS/DLHS4"
global DLHS4rawdata "$DLHS4/rawdata"
global DLHS4intermediate "$DLHS4/intermediate"
global DLHS4constructed "$DLHS4/constructed"



********************************************************************************

* (1) Mapping districts in DLHS4 to pc11_district_name/pc11_state_name from shrug
*     We get a dlhs4-pc11 mapping file at the end

********************************************************************************
* DLHS not available:
// Data from two states (Gujarat, Jammu and Kashmir) and four union territories (Dadra and Nagar Haveli, Daman and Diu, Delhi, and Lakshadweep) were not available for analysis.
// Also mentioned in https://doi.org/10.1016/j.ypmed.2020.106147

{
	import excel "$DLHS4rawdata/DLHS4-HH-STATA/DLHS4Documents/STATE and DIST NAME WITH CODE.xlsx", firstrow clear
	drop if state_code == .
	replace district_name = lower(district_name)
	replace district_name = lower(trim(district_name))
	replace state_name = lower(state_name)

	duplicates tag district_name, gen(dup) //this is to remove the double-named districts
	tab dup
	tab district_name if dup > 0
	duplicates drop district_name, force
	drop dup
	isid district_name 

	gen pc11_district_name = district_name
	
    ********************************************
	* renaming some districts to match with pc11 
	********************************************	
	{
		replace pc11_district_name = "amravati" if pc11_district_name == "amrawati"
		replace pc11_district_name = "anantapur" if pc11_district_name == "anantpur"
		replace pc11_district_name = "bara banki" if pc11_district_name == "barabanki"
		replace pc11_district_name = "bathinda" if pc11_district_name == "bhathinda"
		replace pc11_district_name = "bulandshahr" if pc11_district_name == "bulandshahar"
		replace pc11_district_name = "chikkaballapura" if pc11_district_name == "chikkaballarpura"
		replace pc11_district_name = "chittoor" if pc11_district_name == "chitoor"
		replace pc11_district_name = "datia" if pc11_district_name == "datai"
		replace pc11_district_name = "davanagere" if pc11_district_name == "davangere"
		replace pc11_district_name = "hanumangarh" if pc11_district_name == "hamumagarh"
		replace pc11_district_name = "jalor" if pc11_district_name == "jalore"
		replace pc11_district_name = "janjgir champa" if pc11_district_name == "janjgir - champa"
		replace pc11_district_name = "kaimur bhabua" if pc11_district_name == "kaimur (bhabua)"
		replace pc11_district_name = "kabeerdham" if pc11_district_name == "kawardha"
		replace pc11_district_name = "kurung kumey" if pc11_district_name == "kurung kamey"
		replace pc11_district_name = "lahul spiti" if pc11_district_name == "lahul & spiti"
		replace pc11_district_name = "malappuram" if pc11_district_name == "mallappuram"
		replace pc11_district_name = "morigaon" if pc11_district_name == "marigaon"
		replace pc11_district_name = "mumbai suburban" if pc11_district_name == "mumbai (suburban)"
		replace pc11_district_name = "nicobars" if pc11_district_name == "nicobar"
		replace pc11_district_name = "north middle andaman" if pc11_district_name == "north & middle andaman"
		replace pc11_district_name = "pakur" if pc11_district_name == "pakaur"
		replace pc11_district_name = "panipat" if pc11_district_name == "panipath"
		replace pc11_district_name = "papum pare" if pc11_district_name == "papumpare"
		replace pc11_district_name = "peren" if pc11_district_name == "paren"
		replace pc11_district_name = "puducherry" if pc11_district_name == "pondicherry"
		replace pc11_district_name = "purba medinipur" if pc11_district_name == "purba mednipur"
		replace pc11_district_name = "ribhoi" if pc11_district_name == "ri bhoi"
		replace pc11_district_name = "sahibzada ajit singh nagar" if pc11_district_name == "sas nagar"
		replace pc11_district_name = "sivasagar" if pc11_district_name == "sibsagar"
		replace pc11_district_name = "sonipat" if pc11_district_name == "sonipath"
		replace pc11_district_name = "south andaman" if pc11_district_name == "south andamana"
		replace pc11_district_name = "tarn taran" if pc11_district_name == "taran taran"
		replace pc11_district_name = "visakhapatnam" if pc11_district_name == "vishakapatnam"
		replace pc11_district_name = "warangal" if pc11_district_name == "warngal"
		replace pc11_district_name = "wayanad" if pc11_district_name == "wayanand"
		replace pc11_district_name = "yanam" if pc11_district_name == "yaman"
		replace pc11_district_name = "ysr kadapa" if pc11_district_name == "y.s.r."
		replace pc11_district_name = "south twenty four parganas" if pc11_district_name == "south 24 parganas"
		replace pc11_district_name = "north twenty four parganas" if pc11_district_name == "north 24 parganas"
		replace pc11_district_name = "subarnapur" if pc11_district_name == "sonapur"
		replace pc11_district_name = "the nilgiris" if pc11_district_name == "nilgiris"
		replace pc11_district_name = "uttar bastar kanker" if pc11_district_name == "kanker"
		replace pc11_district_name = "dakshin bastar dantewada" if pc11_district_name == "dantewada"
		replace pc11_district_name = "dima hasao" if pc11_district_name == "north cachar hills" //another name as per pc11
		replace pc11_district_name = "mahamaya nagar" if pc11_district_name == "hathras" //another name as per pc11
}


	merge 1:1 pc11_district_name using "/Users/saeehatwalne/Library/CloudStorage/Dropbox/Medical Education/Medical Colleges/Data/pc11_ec13_district_key_withoutrepeateddist.dta" 
	//this dta file has the unique state-district names as they appear in shrug pc11 

	tab pc11_district_name if _merge == 1
	keep if _merge == 3 | _merge == 1
	drop _merge
	
    *replacing pc11 state for the not-dropped double-district
	replace pc11_state_name = "bihar" if pc11_district_name == "aurangabad" & state_name == "bihar"
	replace pc11_state_name = "himachal pradesh" if pc11_district_name == "bilaspur" & state_name == "himachal pradesh"
	replace pc11_state_name = "karnataka" if pc11_district_name == "bijapur" & state_name == "karnataka" 
	//bijapur from chhattisgarh not in the excel list in raw dlhs data
	replace pc11_state_name = "himachal pradesh" if pc11_district_name == "hamirpur" & state_name == "himachal pradesh"
	replace pc11_state_name = "chhattisgarh" if pc11_district_name == "raigarh" & state_name == "chhattisgarh"
	replace pc11_state_name = "uttar pradesh" if pc11_district_name == "pratapgarh" & state_name == "uttar pradesh"
    //pratapgarh from rajasthan not in the excel list in raw dlhs data

    ********************************************
	* adding state and district codes from dlhs 
	* for the repeated districts
	********************************************
	{
	set obs `=_N + 4'
	replace pc11_district_name = "aurangabad" in -4
	replace district_name = "aurangabad" in -4
	replace pc11_state_name = "maharashtra" in -4
	replace state_name = "maharashtra" in -4
	replace district_code = 19 in -4
	replace state_code = 27 in -4

	replace pc11_district_name = "bilaspur" in -3
	replace district_name = "bilaspur" in -3
	replace pc11_state_name = "chhattisgarh" in -3
	replace state_name = "chhattisgarh" in -3
	replace district_code = 7 in -3
	replace state_code = 22 in -3

	replace pc11_district_name = "hamirpur" in -2
	replace district_name = "hamirpur" in -2
	replace pc11_state_name = "uttar pradesh" in -2
	replace state_name = "uttar pradesh" in -2
	replace district_code = 38 in -2
	replace state_code = 9 in -2

	replace pc11_district_name = "raigarh" in -1
	replace district_name = "raigarh" in -1
	replace pc11_state_name = "maharashtra" in -1
	replace state_name = "maharashtra" in -1
	replace district_code = 24 in -1
	replace state_code = 27 in -1
	}

	drop _freq


	isid state_code district_code
	isid pc11_district_name pc11_state_name
	unique pc11_district_name pc11_state_name //559
	
	preserve ///////////////
	
	use "$medicalcolleges/Data/pc11_ec13_district_key.dta", clear
	contract  pc11_state_name pc11_district_name pc11_state_id pc11_district_id
	tempfile mytemp
    save `mytemp'
  	
	restore ///////////////
	
	merge 1:1 pc11_state_name pc11_district_name using `mytemp', keep(3) nogen //getting pc11_state_id pc11_district_id
	//559
	isid pc11_state_id pc11_district_id
	drop _freq

	lab var state_code "state_code as appears in dlhs4"
	lab var district_code "district_code as appears in dlhs4"
	lab var pc11_district_name "2011 district name - can use with shrug"
    lab var pc11_state_name "2011 state name - can use with shrug"
	
	save "$DLHS4constructed/dlhs4districts_pc11_mapping.dta", replace


}





********************************************************************************

* Check point: Checking if the mapping file works properly

********************************************************************************
use "$DLHS4rawdata/DLHS4-HH-STATA/DLHS-4 HH.dta", clear
rename state state_code
rename dist district_code
merge m:1 state_code district_code using "$DLHS4constructed/dlhs4districts_pc11_mapping.dta", keep(3) nogen

lab var pc11_district_name "2011 district name - can use with shrug"
lab var pc11_state_name "2011 state name - can use with shrug"

* all master merged
* so now whenever one wants to use dlhs4 - use this mapping file

isid state dist psu prim_key


