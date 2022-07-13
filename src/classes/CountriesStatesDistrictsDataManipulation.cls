/**
    Created By : Zaheer Khan
    Created Date : 12-07-2022
    Description :
    -Hierarchy of Country Code, Country, State, District.
    -Filling the Map dynamically by Constructor
    -finding the  district whose length is >= 10
    -Generating JSON Formate/
**/

public with sharing class CountriesStatesDistrictsDataManipulation {
    // Map for CountryStateDistrict
    Map<String, Map<String, List<String>>> mapOfCountriesStatesDistricts = new Map<String, Map<String, List<String>>>();

    //Wrapper Classes
     public class Country{
        public String countryName{get; set;}
       	public List<States> states{get; set;}
        public Integer Total_Number_Of_Districts{get; set;}
        public Integer Total_Number_Of_States{get; set;}
    }
    Public List<Country> countryList{get; set;}
    public class States{
        Public List<Districts> districts{get; set;}
        public Integer Total_Number_Of_Districts{get; set;}
        Public string stateName{get; set;}
    }
    public class Districts {
        Public String districtName{get; set;}
    }
   

    // () find the Countries States District by Char (searching) (Constructor Start)
    public CountriesStatesDistrictsDataManipulation(String searchChar, Integer distance) {
        List<District__c> listOfDistricts = new List<District__c>();
        for(District__c dist : [SELECT Name, State__r.Name, State__r.Country__r.Name FROM District__c]) {
            listOfDistricts.add(dist);
        }
        try {
        List<String> listOfStateDistricts = new List<String>();
        for(District__c district : [SELECT Name, State__r.Name, State__r.Country__r.Name FROM District__c Where (Name LIKE :searchChar AND State__r.Name LIKE :searchChar AND State__r.Country__r.Name LIKE :searchChar)]) {

            listOfStateDistricts.add(district.Name);
            listOfStateDistricts.add(district.State__r.Name);
            listOfStateDistricts.add(district.State__r.Country__r.Name);
        }
            if(listOfStateDistricts.isEmpty()) {
                System.debug('No Such Country Combination');
            } else {
                String v1 = 'Intigrating Of Country, States & District = ';
        		System.debug(v1 + listOfStateDistricts);
            } 
        } 
        catch (Exception e) {
        	System.debug('There is no any countries as '+ searchChar);
        }
        
        // - Districts Which is >= 10 or can be dynamic
        List<String> listOfDistrictsData = new List<String>();
        for(District__c district : [SELECT Name FROM District__c]) {
            if(district.Name.Length()>=distance){
                listOfDistrictsData.add(district.Name);
            }
        }
        if(listOfDistrictsData.isEmpty()){
            System.debug('District not found >= distance');
                } else {
        System.debug('Districts Which is >= Distance: '+ listOfDistrictsData);
			}
        //Dynamically Data Filling (dataFillingStart)
        for(District__c district : listOfDistricts) {
            if(!mapOfCountriesStatesDistricts.containsKey(district.State__r.Country__r.Name)){
                mapOfCountriesStatesDistricts.put(district.State__r.Country__r.Name, new Map<String,List<String>>());
            }
            Map<String,List<String>> mapOfStateListOfDistrict = mapOfCountriesStatesDistricts.get(district.State__r.Country__r.Name);
            
            if(!mapOfStateListOfDistrict.containsKey(district.State__r.Name)){
                mapOfStateListOfDistrict.put(district.State__r.Name, new List<String>());
            }
            mapOfStateListOfDistrict.get(district.State__r.Name).add(district.Name);
            
    }// (dataFillingEnd)
}// (Constructor End)

//JSON Generator Start
public void methodJSONGenerator(String countryName) {
    Country wrapCountry = new Country();
    wrapCountry.countryName = countryName;
    wrapCountry.states = new List<States>();
    List<AggregateResult> listOfAggrStates = [Select COUNT(Name)Total_Number_Of_States from State__c Where Country__r.Name like :countryName  Group By Country__r.Name];  
    
    wrapCountry.Total_Number_Of_States =  (Integer)listOfAggrStates[0].get('Total_Number_Of_States');
    
    List<AggregateResult> listOfAggrDistricts = [Select COUNT(Name)Total_Number_Of_Districts from District__c Where State__r.Country__r.Name like :countryName Group By State__r.Country__r.Name];    
    
    wrapCountry.Total_Number_Of_Districts = (Integer)listOfAggrDistricts[0].get('Total_Number_Of_Districts');
    
    for(String state : mapOfCountriesStatesDistricts.get(countryName).keyset()){
        if(state == 'Rajasthan') {
            States wrapState = new States();
            wrapState.stateName = state;
            wrapState.districts = new list<Districts>();

            List<AggregateResult> listOfAggrDistrictState = [Select COUNT(Name)Total_Number_Of_Districts from District__c Where State__r.Country__r.Name like :countryName  Group By State__r.Name];
			
            wrapState.Total_Number_Of_Districts = (Integer)listOfAggrDistrictState[0].get('Total_Number_Of_Districts');
            
            for(String district : mapOfCountriesStatesDistricts.get(countryName).get(state)) {
                Districts wrapDistrict = new Districts();
                wrapDistrict.districtName = district;
                wrapState.districts.add(wrapDistrict);
            }
            wrapCountry.states.add(wrapState);
        }
        // Passing JSON Data to Country UI
    	// List<Country__c> jsonData = [SELECT Id, Name, Country_JSON_Data__c, Total_Number_of_Districts__c, Total_Number_of_States__c FROM Country__c WHERE Name Like :countryName];
     	// jsonData.Total_Number_of_States__c = wrapCountry.Total_Number_Of_States;
    }
    String json = JSON.serialize(wrapCountry);
    System.debug(json);
} // JSON Generator End
}//Main Class Closing

/*
####################################### Execution ###########################################
- CountriesStatesDistrictsDataManipulation v1 = new CountriesStatesDistrictsDataManipulation('I', 10);
v1.methodJSONGenerator('India');

######################################## Output ############################################ 
- No Such Country Combination
-  [50]|DEBUG|Intigrating Of Country, States & District = ()
-  [63]|DEBUG|Districts Which is >= Distance: (Sindhudurg, Sheikhpura, List<String> galiciaDistricts =  new List<String>{'Krakau', 'Sandomir',, Ahmednagar, Bognor Regis, Littlehampton, Sindhudurg)
- [115]|DEBUG|{"Total_Number_Of_States":3,"Total_Number_Of_Districts":22,"states":[{"Total_Number_Of_Districts":6,"stateName":"Rajasthan","districts":[{"districtName":"Ajmer"},{"districtName":"Kota"},{"districtName":"Alwar"},{"districtName":"Banswara"},{"districtName":"Jodhpur"},{"districtName":"Udaipur"}]}],"countryName":"India"}
*/