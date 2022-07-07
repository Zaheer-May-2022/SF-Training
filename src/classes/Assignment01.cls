public with sharing class Assignment01 {

    // Create list in which store the data of District
    Map<String,String> mapOfDistrictWithState = new Map<String,String>();
    Map<String,String> mapOfStateWithCountry = new Map<String,String>();
    Map<Integer,String> mapOfCountryWithCountryCode = new Map<Integer,String>();

    // Adding data 
    public void show(){
        List<String> districts = new List<String>{'Sikar','Khandela','Jaipur','Churu'};
        Map<String,List<String>> mapOfStateWithDistricts = new Map<String,List<String>>();
        mapOfStateWithDistricts.put('Rajasthan',districts);
        mapOfStateWithDistricts.put('Maharastra',districts);
        mapOfStateWithDistricts.put('Dehli',districts);


        Map<String,Map<String,List<String>>> mapOfCountryWithState = new Map<String,Map<String,List<String>>>();

        mapOfCountryWithState.put('India',mapOfStateWithDistricts);
        mapOfCountryWithState.put('Singapor',mapOfStateWithDistricts);
        mapOfCountryWithState.put('China',mapOfStateWithDistricts);


        // Travesing data for getting data as per needed
        for(String it : mapOfCountryWithState.keySet()) {
            if(it.startsWithIgnoreCase('S')) { // All the Values of Country
                System.debug(it);
                System.debug(mapOfCountryWithState.get(it));
            }
            for (String it2 : mapOfCountryWithState.get(it).keySet()) {
                if(it2.startsWithIgnoreCase('S')) { // All the Values of State
                    System.debug(mapOfCountryWithState.get(it).get(it2));
                    System.debug('District which we got' + it2);
            }
            }
        }
// Method 1
        // if(it.startsWithIgnoreCase('S')) 
// Method 2
        // String = Zaheer
        // String[0] = Z
    }
}
