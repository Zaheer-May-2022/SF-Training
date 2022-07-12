public with sharing class WorkOnMap {
    public static void findNameWithChar(Integer countryCode, String searchChar) {

        //
        Map<Integer, Map<String, Map<String, List<String>>>> countryCodeWithCountryStateDistrict = new Map<Integer, Map<String, Map<String, List<String>>>>();

        // country Which have State and District Name with the char = S
        Map<String,Map<String,List<String>>> countryWithStateDistrictAsChar = new Map<String,Map<String,List<String>>>();

        // State which have District as Dynamic Char
        Map<String,List<String>> stateWithDistrictAsChar = new Map<String,List<String>>();

        // District Name Which Start with the Char  = S
        List <String> districtAsChar = new List<String>();

        // Adding district on list 
        List<String> rajasthanDistricts = new List<String>{'Ajmer','Alwar','Banswara','Barmer','Bharatpur','Bhilwara','Bikaner','Bundi','Chittorgarh','Churu','Dausa','Dholpur','Dungarpur','Hanumangarh','Jaipur','Jaisalmer','Jalore','Jhalawar','Jhunjhunu','Jodhpur','Karauli','Kota','Nagaur','Pali','Pratapgarh','Rajsamand','Sawai Madhopur','Sikar','Sirohi','Sri Ganganagar','Tonk','Udaipur'};
        List<String> biharDistricts =  new List<String>{'Araria','Arwal','Aurangabad','Banka','Bhojpur','Gaya','Samastipur','Sheikhpura','Supaul','Vaishali','West Champaran'};
        List<String> maharashtraDistricts = new List<String>{'Ahmednagar','Beed','Mumbai','Pune','Sindhudurg','Solapur'};

        // StateWithDistrict
        Map<String, List<String>> state = new Map<String, List<String>>();
        state.put('Rajasthan', rajasthanDistricts);
        state.put('Bihar', biharDistricts);
        state.put('Maharashtra', maharashtraDistricts);       
        
        // Adding State with country
        Map<String, Map<String, List<String>>> countryName = new Map<String, Map<String, List<String>>>();
        countryName.put('India', state);

        // Add district on list
        List<String> andalusiaDistricts =  new List<String>{'Huelva', 'Cádiz', 'Sevilla', 'Málaga', 'Granada','Almería'};
        List<String> cataloniaDistricts =  new List<String>{'Barcelona', 'Girona', 'Lleida', 'Tarragona'};
        List<String> galiciaDistricts =  new List<String>{'Krakau', 'Sandomir', 'Lublin', 'Belz', 'Red Ruthenia','Podolia'};

        // Adding StateWithDistrict
        Map<String, List<String>> state2 = new Map<String, List<String>>();
        state2.put('Andalusia', andalusiaDistricts);
        state2.put('Catalonia', cataloniaDistricts);
        state2.put('Galicia', galiciaDistricts);

        // Adding State with country 
        Map<String, Map<String, List<String>>> countryName2 = new Map<String, Map<String, List<String>>>();
        countryName2.put('Spain', state2);

        // Add district on list
        List<String> arunKshetraDistricts =  new List<String>{'Arundel', 'Bognor Regis', 'Littlehampton'};
        List<String> janakpurKshetraDistricts =  new List<String>{'Dhanusha' , 'Madhesh'};
        List<String> kathmanduDistricts = new List<String>{'Dolpa', 'Humla', 'Taplejung', 'Gorkha'};
        
        // Adding StateWithDistrict
        Map<String, List<String>> state3 = new Map<String, List<String>>();
        state3.put('Arun Kshetra', arunKshetraDistricts);
        state3.put('Janakpur Kshetra', janakpurKshetraDistricts);
        state3.put('Kathmandu', kathmanduDistricts);

        // Adding State with country 
        Map<String, Map<String, List<String>>> countryName3 = new Map<String, Map<String, List<String>>>();
        countryName3.put('Nepal', state3);

        // Adding countryCountryCode
        countryCodeWithCountryStateDistrict.put(91, countryName);
        countryCodeWithCountryStateDistrict.put(34, countryName2);
        countryCodeWithCountryStateDistrict.put(977, countryName3);

        Boolean districtFlag = false;
        Boolean stateFlag = false;
        Boolean countryFlag = false;

        String current_country;
        String current_state;


        for(Integer code : countryCodeWithCountryStateDistrict.keySet()) {
            if(code == countryCode) {
                for(String countryNames : countryCodeWithCountryStateDistrict.get(code).keySet()) {
                    // String CountryNameAsChar =  countryNames;
                    if(true) {
                        current_country = countryNames;
                    System.debug('CountryCode Country name is = ' + countryNames);
                        for(String stateNames : countryCodeWithCountryStateDistrict.get(code).get(countryNames).keySet()) {
                            if(stateNames.startsWithIgnoreCase(searchChar)) {
                                current_state = stateNames;
                                System.debug('State which starts with "' + searchChar + '" is ' + stateNames);                            
                                for(String districtName : countryCodeWithCountryStateDistrict.get(code).get(countryNames).get(stateNames)){                                 
                                    if(districtName.startsWithIgnoreCase(searchChar) && districtName.length() >= 5) {
                                        districtAsChar.add(districtName);
                                        districtflag = true;
                                    }
                                }
                                stateFlag = true;
                            } 
                        }
                        // break;
                        countryFlag = true;
                    }
                }
                // break;
            }
        }

        // checking if there is no match
        if(districtFlag == false) {
            System.debug('There is no district in ' + current_state +' which starts with ' + searchChar);
        }
        if(stateFlag == false) {
            System.debug('There is no state in ' + current_country + ' which starts with ' + searchChar );
        }
        if(countryFlag == false) {
            System.debug('There is no any country which code is = ' + countryCode);
        }
        // Printing all the District
        for (String it : districtAsChar) {
            System.debug('We have district ' + searchChar +' as ' + it);
        }
    }
}

//########### Execution ########

// WorkOnMap.findNameWithChar(91,'R');



//########## OUTPUT ##########
/* 
16:58:15:024 USER_DEBUG [80]|DEBUG|CountryCode Country name is = India
16:58:15:024 USER_DEBUG [84]|DEBUG|State which starts with "R" is Rajasthan
16:58:15:029 USER_DEBUG [112]|DEBUG|We have district R as Rajsamand
 */