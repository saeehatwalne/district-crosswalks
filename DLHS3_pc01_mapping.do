* Saee
* DLHS data cleaning
* DLHS 3


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

global DLHS3 "$medicalcolleges/Data/DLHS/DLHS3"
global DLHS3rawdata "$DLHS3/rawdata"
global DLHS3intermediate "$DLHS3/intermediate"
global DLHS3constructed "$DLHS3/constructed"



********************************************************************************

* (1) Mapping districts in DLHS3 to pc01_district_name/pc01_state_name from shrug
*     We get a dlhs3-pc01 mapping file at the end

********************************************************************************
{
	import excel "$DLHS3rawdata/2DLHS3RCH-HH-STATA/DLHS3-DOCUMENTS/Dist_code/state_distcode.xls", firstrow clear
	rename State state_code
	rename Dist_name district_name
	rename Dist_code district_code
	rename State_name state_name

	drop scode
	drop if state_code == .
	replace state_name = lower(trim(subinstr(state_name, "*", "", .)))
	replace district_name = lower(trim(district_name))

	
	********************************************
	* COLLAPSE POST-2001 DISTRICTS → PARENT (MANUAL CODES)
	********************************************
    {
	* Punjab
	replace district_name = "amritsar" if district_name == "tarn taran"
	replace district_code = 302 if district_name == "amritsar" & district_code == 318   // fill parent code

	replace district_name = "rupnagar" if district_name == "sas nagar mohali"
	replace district_code = 307 if district_name == "rupnagar" & district_code == 319

	replace district_name = "sangrur" if district_name == "barnala"
	replace district_code = 316 if district_name == "sangrur" & district_code == 320

	* Haryana
	replace district_name = "faridabad" if district_name == "mewat"
	replace district_code = 619 if district_name == "faridabad" & district_code == 620

	* Arunachal Pradesh
	replace district_name = "lower subansiri" if district_name == "kurung kumey"
	replace district_code = 1205 if district_name == "lower subansiri" & district_code == 1214

	replace district_name = "dibang valley" if district_name == "lower dibang valley"
	replace district_code = 1210 if district_name == "dibang valley" & district_code == 1215

	replace district_name = "lohit" if district_name == "anjaw"
	replace district_code = 1211 if district_name == "lohit" & district_code == 1216

	* Assam
	replace district_name = "bongaigaon" if district_name == "chirang"
	replace district_code = 1804 if district_name == "bongaigaon" & district_code == 1824

	replace district_name = "kamrup" if district_name == "baska"
	replace district_code = 1806 if district_name == "kamrup" & district_code == 1825

	replace district_name = "kamrup" if district_name == "kamrup metro"
	replace district_code = 1806 if district_name == "kamrup" & district_code == 1826

	replace district_name = "darrang" if district_name == "udalguri"
	replace district_code = 1808 if district_name == "darrang" & district_code == 1827

	* Jharkhand
	replace district_name = "gumla" if district_name == "simdega"
	replace district_code = 2016 if district_name == "gumla" & district_code == 2019

	replace district_name = "pashchimi singhbhum" if district_name == "seraikela"
	replace district_code = 2017 if district_name == "pashchimi singhbhum" & district_code == 2020

	replace district_name = "palamu" if district_name == "latehar"
	replace district_code = 2002 if district_name == "palamu" & district_code == 2021

	replace district_name = "dumka" if district_name == "jamtara"
	replace district_code = 2011 if district_name == "dumka" & district_code == 2022

	* Tamil Nadu
	replace district_name = "dharmapuri" if district_name == "krishnagiri"
	replace district_code = 3305 if district_name == "dharmapuri" & district_code == 3317
	}
	
	
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
	replace pc01_district_name = "thoothukkudi" if district_name == "thoothukudi"
	replace pc01_district_name = "tiruchirappalli" if district_name == "trichy"
	replace pc01_district_name = "tirunelveli" if district_name == "thirunelveli"
	
	* districts formed between 2001 and 2008 from a single parent 2001 district
	replace pc01_district_name = "lohit" if district_name == "anjaw"
	replace pc01_district_name = "sangrur" if district_name == "barnala"
	replace pc01_district_name = "dibang valley" if district_name == "lower dibang valley"
	replace pc01_district_name = "kamrup" if district_name == "kamrup metro"
	replace pc01_district_name = "tuensang" if district_name == "kiphire"
	replace pc01_district_name = "tuensang" if district_name == "longleng"
	replace pc01_district_name = "dharmapuri" if district_name == "krishnagiri"
	replace pc01_district_name = "lower subansiri" if district_name == "kurung kumey"
	replace pc01_district_name = "palamu" if district_name == "latehar"
	replace pc01_district_name = "faridabad" if district_name == "mewat"
	replace pc01_district_name = "medinipur" if district_name == "pachim medinipur"
	replace pc01_district_name = "kohima" if district_name == "peren"
	replace pc01_district_name = "rupnagar" if district_name == "sas nagar (mohali)"
	replace pc01_district_name = "pashchimi singhbhum" if district_name == "seraikela"
	replace pc01_district_name = "gumla" if district_name == "simdega"
	replace pc01_district_name = "amritsar" if district_name == "tarn taran"
	replace pc01_district_name = "dumka" if district_name == "jamtara"
	
	
	* baksa from kamrup and nalbali ideally but nalbali not there in pc01 so considered kamrup only
	replace pc01_district_name = "kamrup" if district_name == "baska"

	* chirang split in 2004 from kokrajhar and bongaigaon
	* udalguri in 2004 from sonitpur and darrang
    * perambalur is not there in the dlhs3 data although ariyalur is there, which is mapped
	replace pc01_district_name = "bongaigaon" if district_name == "chirang" //major from bongaigaon
	replace pc01_district_name = "darrang" if district_name == "udalguri" //major from darrang

	
	}
	
// 	duplicates drop pc01_state_name pc01_district_name, force
	duplicates drop state_code district_code, force
	
	
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
	replace district_code = 2719 in -8
	replace state_code = 27 in -8

	replace pc01_district_name = "bilaspur" in -7
	replace district_name = "bilaspur" in -7
	replace pc01_state_name = "chhattisgarh" in -7
	replace state_name = "chhattisgarh" in -7
	replace district_code = 2207 in -7
	replace state_code = 22 in -7

	replace pc01_district_name = "hamirpur" in -6
	replace district_name = "hamirpur" in -6
	replace pc01_state_name = "uttar pradesh" in -6
	replace state_name = "himachal pradesh" in -6
	replace district_code = 938 in -6
	replace state_code = 9 in -6

	replace pc01_district_name = "raigarh" in -5
	replace district_name = "raigarh" in -5
	replace pc01_state_name = "maharashtra" in -5
	replace state_name = "maharashtra" in -5
	replace district_code = 2724 in -5
	replace state_code = 27 in -5

	replace pc01_district_name = "east" in -4
	replace district_name = "east" in -4
	replace pc01_state_name = "sikkim" in -4
	replace state_name = "sikkim" in -4
	replace district_code = 1104 in -4
	replace state_code = 11 in -4

	replace pc01_district_name = "west" in -3
	replace district_name = "west" in -3
	replace pc01_state_name = "sikkim" in -3
	replace state_name = "sikkim" in -3
	replace district_code = 1102 in -3
	replace state_code = 11 in -3

	replace pc01_district_name = "north" in -2
	replace district_name = "north" in -2
	replace pc01_state_name = "sikkim" in -2
	replace state_name = "sikkim" in -2
	replace district_code = 1101 in -2
	replace state_code = 11 in -2

	replace pc01_district_name = "south" in -1
	replace district_name = "south" in -1
	replace pc01_state_name = "sikkim" in -1
	replace state_name = "sikkim" in -1
	replace district_code = 1103 in -1
	replace state_code = 11 in -1
	}
	
	duplicates tag pc01_state_name pc01_district_name, gen(dup)
	tab dup

	merge m:1 pc01_state_name pc01_district_name using `mytemp' //m:1 because of medinipur
	tab pc01_district_name _merge if _merge < 3
	keep if _merge == 3
	drop _merge
	
// 	isid pc01_state_id pc01_district_id - will fail because of pacshim, purba medinipur referring to only medinipur in pc01 data
// 	isid pc01_state_name pc01_district_name
	
	
	lab var state_code "state code as appears in dlhs3"
	lab var district_code "district code as appears in dlhs3"

	lab var pc01_district_name "2001 district name - can use with shrug"
	lab var pc01_state_name "2001 state name - can use with shrug"	

	save "$DLHS3constructed/dlhs3districts_pc01_mapping.dta", replace

}
	
	
********************************************************************************

* Check point: Checking if the mapping file works properly

********************************************************************************
use "$DLHS3rawdata/2DLHS3RCH-HH-STATA/dlhs3hind.dta", clear
rename state state_code
rename dist district_code

* post-2001 split districts → parent district (manual changes)
    {
	replace district_code = 302  if district_code == 318   // fill parent code
// 	replace district_name = "rupnagar" if district_name == "sas nagar mohali"
	replace district_code = 307 if district_code == 319
// 	replace district_name = "sangrur" if district_name == "barnala"
	replace district_code = 316 if district_code == 320
// 	replace district_name = "faridabad" if district_name == "mewat"
	replace district_code = 619 if district_code == 620
// 	replace district_name = "lower subansiri" if district_name == "kurung kumey"
	replace district_code = 1205 if district_code == 1214
// 	replace district_name = "dibang valley" if district_name == "lower dibang valley"
	replace district_code = 1210 if district_code == 1215
// 	replace district_name = "lohit" if district_name == "anjaw"
	replace district_code = 1211 if district_code == 1216
// 	replace district_name = "bongaigaon" if district_name == "chirang"
	replace district_code = 1804 if district_code == 1824
// 	replace district_name = "kamrup" if district_name == "baska"
	replace district_code = 1806 if district_code == 1825
// 	replace district_name = "kamrup" if district_name == "kamrup metro"
	replace district_code = 1806 if district_code == 1826
// 	replace district_name = "darrang" if district_name == "udalguri"
	replace district_code = 1808 if district_code == 1827
// 	replace district_name = "gumla" if district_name == "simdega"
	replace district_code = 2016 if district_code == 2019
// 	replace district_name = "pashchimi singhbhum" if district_name == "seraikela"
	replace district_code = 2017 if district_code == 2020
// 	replace district_name = "palamu" if district_name == "latehar"
	replace district_code = 2002 if district_code == 2021
// 	replace district_name = "dumka" if district_name == "jamtara"
	replace district_code = 2011 if district_code == 2022
// 	replace district_name = "dharmapuri" if district_name == "krishnagiri"
	replace district_code = 3305 if district_code == 3317
	}
	

merge m:1 state_code district_code using "$DLHS3constructed/dlhs3districts_pc01_mapping.dta"

// all matched so working	
	
	