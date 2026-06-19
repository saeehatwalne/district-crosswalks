* Saee
* DLHS data cleaning
* DLHS 2


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

global DLHS2 "$medicalcolleges/Data/DLHS/DLHS2"
global DLHS2rawdata "$DLHS2/rawdata"
global DLHS2intermediate "$DLHS2/intermediate"
global DLHS2constructed "$DLHS2/constructed"



********************************************************************************

* (1) Mapping districts in DLHS2 to pc01_district_name/pc01_state_name from shrug
*     We get a dlhs2-pc01 mapping file at the end

********************************************************************************
{
	import excel "$DLHS2rawdata/DLHS2RCH-HOUSEHOLD-STATA/CODE FILE/STATE-DISTRICT CODE FILE.xls", firstrow clear
	rename State_code state_code
	rename DistrictName district_name
	rename District_code district_code
	rename StateName state_name
	drop if district_code == .
	replace state_name = lower(trim(subinstr(state_name, "*", "", .)))
	replace district_name = lower(trim(district_name))

    duplicates tag district_name, gen(dup) //this is to remove the double-named districts
	tab dup
	tab district_name if dup > 0
	duplicates drop district_name, force
	drop dup
	isid district_name 
	tab state_name
	
	
	preserve ///////////////
	
	use "$medicalcolleges/Data/pc11_ec13_district_key.dta", clear
	contract  pc01_state_name pc01_district_name pc01_state_id pc01_district_id
	drop if pc01_state_name == ""
	drop if pc01_district_name == ""
	drop _freq
	tempfile mytemp
    save `mytemp'
	tab pc01_state_name
  	
	restore ///////////////
	
	gen pc01_state_name = state_name 
	gen pc01_district_name = district_name
	
	********************************************
	* renaming some districts to match with pc01
	********************************************	
	{
	replace pc01_state_name = "andaman nicobar islands" if state_name == "andaman & nicobar islands"
	replace pc01_state_name = "chhattisgarh" if state_name == "chhatisgarh"
	replace pc01_state_name = "dadra nagar haveli" if state_name == "dadra & nagar haveli"
	replace pc01_state_name = "daman diu" if state_name == "daman & diu"
	replace pc01_state_name = "jammu kashmir" if state_name == "jammu & kashmir"
	replace pc01_state_name = "uttarakhand" if state_name == "uttaranchal"
	
    replace pc01_district_name = "ambedkar nagar" if district_name == "ambedaker nagar"
	replace pc01_district_name = "anantnag" if district_name == "anantanag"
	replace pc01_district_name = "bulandshahr" if district_name == "bulandshahar"
	replace pc01_district_name = "dadra nagar haveli" if district_name == "dadra & nagar haveli"
	replace pc01_district_name = "hanumangarh" if district_name == "hamumangarh"
	replace pc01_district_name = "hazaribag" if district_name == "hazaribagh"
	replace pc01_district_name = "jalor" if district_name == "jalore"
	replace pc01_district_name = "janjgir champa" if district_name == "janjgir-champa"
	replace pc01_district_name = "junagadh" if district_name == "junagarh"
	replace pc01_district_name = "kaimur bhabua" if district_name == "kaimur (bhabua)"
	replace pc01_district_name = "lahul spiti" if district_name == "lahul & spiti"
	replace pc01_district_name = "leh ladakh" if district_name == "leh (ladakh)"
	replace pc01_district_name = "mumbai suburban" if district_name == "mumbai (suburban)"
	replace pc01_district_name = "the nilgiris" if district_name == "nilgiris"
	replace pc01_district_name = "north twenty four parganas" if district_name == "north twentyfour parganas"
	replace pc01_district_name = "pudukkottai" if district_name == "pudukottai"
	replace pc01_district_name = "medinipur" if district_name == "purab medinipur"
	replace pc01_district_name = "ramanathapuram" if district_name == "ramanathpuram"
	replace pc01_district_name = "sivaganga" if district_name == "sivganga"
	replace pc01_district_name = "south twenty four parganas" if district_name == "south twentyfour parganas"
	replace pc01_district_name = "thoothukkudi" if district_name == "toothukudi"
	replace pc01_district_name = "tiruchirappalli" if district_name == "trichy"
	replace pc01_district_name = "tirunelveli" if district_name == "thirunelveli"	
	replace pc01_district_name = "tiruvannamalai" if district_name == "tiruvanamalai"	
	replace pc01_district_name = "karur" if district_name == "kapur"	
	}
	
	duplicates drop pc01_state_name pc01_district_name, force
	
	********************************************
	* adding state and district codes from dlhs 
	* for the repeated districts
	********************************************
	{
	set obs `=_N + 8'
	replace pc01_district_name = "aurangabad" in -8
	replace district_name = "aurangabad" in -8
	replace pc01_state_name = "maharashtra" in -8
	replace state_name = "maharashtra" in -8
	replace district_code = 19 in -8
	replace state_code = 27 in -8

	replace pc01_district_name = "bilaspur" in -7
	replace district_name = "bilaspur" in -7
	replace pc01_state_name = "chhattisgarh" in -7
	replace state_name = "chhattisgarh" in -7
	replace district_code = 7 in -7
	replace state_code = 22 in -7

	replace pc01_district_name = "hamirpur" in -6
	replace district_name = "hamirpur" in -6
	replace pc01_state_name = "uttar pradesh" in -6
	replace state_name = "himachal pradesh" in -6
	replace district_code = 38 in -6
	replace state_code = 9 in -6

	replace pc01_district_name = "raigarh" in -5
	replace district_name = "raigarh" in -5
	replace pc01_state_name = "maharashtra" in -5
	replace state_name = "maharashtra" in -5
	replace district_code = 24 in -5
	replace state_code = 27 in -5

	replace pc01_district_name = "east" in -4
	replace district_name = "east" in -4
	replace pc01_state_name = "sikkim" in -4
	replace state_name = "sikkim" in -4
	replace district_code = 4 in -4
	replace state_code = 11 in -4

	replace pc01_district_name = "west" in -3
	replace district_name = "west" in -3
	replace pc01_state_name = "sikkim" in -3
	replace state_name = "sikkim" in -3
	replace district_code = 2 in -3
	replace state_code = 11 in -3

	replace pc01_district_name = "north" in -2
	replace district_name = "north" in -2
	replace pc01_state_name = "sikkim" in -2
	replace state_name = "sikkim" in -2
	replace district_code = 1 in -2
	replace state_code = 11 in -2

	replace pc01_district_name = "south" in -1
	replace district_name = "south" in -1
	replace pc01_state_name = "sikkim" in -1
	replace state_name = "sikkim" in -1
	replace district_code = 3 in -1
	replace state_code = 11 in -1
	}
	
duplicates tag pc01_state_name pc01_district_name, gen(dup)
	tab dup

	merge 1:1 pc01_state_name pc01_district_name using `mytemp'
	tab pc01_district_name _merge if _merge < 3
	keep if _merge == 3
	drop _merge
	
	isid pc01_state_id pc01_district_id 
	isid pc01_state_name pc01_district_name
	
	
	lab var state_code "state code as appears in dlhs3"
	lab var district_code "district code as appears in dlhs3"

	lab var pc01_district_name "2001 district name - can use with shrug"
	lab var pc01_state_name "2001 state name - can use with shrug"	

	save "$DLHS2constructed/dlhs2districts_pc01_mapping.dta", replace
}	
	
	
********************************************************************************

* Check point: Checking if the mapping file works properly

********************************************************************************
use "$DLHS2rawdata/DLHS2RCH-HOUSEHOLD-STATA/india_hh.dta", clear
rename state state_code
rename dist district_code
merge m:1 state_code district_code using "$DLHS2constructed/dlhs2districts_pc01_mapping.dta", keep(3) nogen

// all matched so working	
		
		
use "$DLHS2constructed/DLHS2_person_merged.dta", clear		
rename state state_code
rename dist district_code
merge m:1 state_code district_code using "$DLHS2constructed/dlhs2districts_pc01_mapping.dta"
		
// all matched so working	
		