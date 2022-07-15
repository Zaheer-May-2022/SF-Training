/**
    Description :
    -Hierarchy of Country Code, Country, State, District.
    -Filling the Map dynamically by Constructor.
    -Finding the  whose length is >= district.
    -Generating JSON Formate.

    Created By : Zaheer Khan
    Created Date : 11-07-2022
**/

public with sharing class CountriesStatesDistrictsDataManipulation {
    // Main Map for CountryStateDistrict
    Map<String, Map<String, List<String>>> mapOfCountriesStatesDistricts = new Map<String, Map<String, List<String>>>();

    List<String> listOfStateDistricts = new List<String>();

    List<District__c> listOfDistricts = new List<District__c>();


    //Wrapper Classes
     public class Country {
        public String countryName{get; set;}
       	public List<States> states{get; set;}
        public Integer Total_Number_Of_States{get; set;}
        public Integer Total_Number_Of_Districts{get; set;}

    }
    public class States {
        public string stateName{get; set;}
        public List<Districts> districts{get; set;}
        public Integer Total_Number_Of_Districts{get; set;}
    }
    Integer stateDistrictCount;
    public class Districts {
        public String districtName{get; set;}
    }

    
    // () find the Countries States District by Char (searching) (Constructor Start)
    public CountriesStatesDistrictsDataManipulation(String searchChar, Integer size) {
        try {
            // Getting all StatesDistrict and searching searchChar
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
        
        // - Districts Which is >= size (dynamic)
        List<String> listOfDistrictsData = new List<String>();
        for(District__c district : [SELECT Name FROM District__c]) {
            if(district.Name.Length()>=size){
                listOfDistrictsData.add(district.Name);
            }
        }
        if(listOfDistrictsData.isEmpty()){
            System.debug('District not found >= size');
        } else {
        System.debug('Districts Which is >= size: '+ listOfDistrictsData);
			}
    }// (Constructor End)
    
    //Dynamically Data Filling (dataFillingStart)  
    public void dynamicDataInsert() {
        // Getting all Districts data from DB
        for(District__c dist : [SELECT Name, State__r.Name, State__r.Country__r.Name FROM District__c]) {
            listOfDistricts.add(dist);
        }
        
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
    }


	//JSON Generator Start
    public void methodJSONGenerator(String countryName, String stName) {
        // for(Country__c cntCheck : [SELECT Id, Name FROM Country__c WHERE Name =:countryName]) {
        //     if(cntCheck == null) {
        //         cntCheck.Name =  countryName;
        //         insert cntCheck;
        //     }
        // }
        Country wrapCnt = new Country();
        wrapCnt.countryName = countryName;
        wrapCnt.states = new List<States>();
        List<AggregateResult> listOfAggrStates = [SELECT COUNT(Name)Total_Number_Of_States FROM State__c Where Country__r.Name like :countryName  Group By Country__r.Name];  
    
        wrapCnt.Total_Number_Of_States =  (Integer)listOfAggrStates[0].get('Total_Number_Of_States');
    
        List<AggregateResult> listOfAggrDistricts = [SELECT COUNT(Name)Total_Number_Of_Districts FROM District__c Where State__r.Country__r.Name like :countryName Group By State__r.Country__r.Name];    
    
        wrapCnt.Total_Number_Of_Districts = (Integer)listOfAggrDistricts[0].get('Total_Number_Of_Districts');
    
        for(String state : mapOfCountriesStatesDistricts.get(countryName).keyset()) {
            if(state == stName) {
                States wrapSt = new States();
                wrapSt.stateName = state;
                wrapSt.districts = new list<Districts>();

                List<AggregateResult> listOfAggrDistrictState = [SELECT COUNT(Name)Total_Number_Of_Districts FROM District__c Where State__r.Country__r.Name like :countryName  Group By State__r.Name];
			
                wrapSt.Total_Number_Of_Districts = (Integer)listOfAggrDistrictState[0].get('Total_Number_Of_Districts');

            stateDistrictCount = wrapSt.Total_Number_Of_Districts;
            
            for(String district : mapOfCountriesStatesDistricts.get(countryName).get(state)) {
                Districts wrapDst = new Districts();
                wrapDst.districtName = district;
                wrapSt.districts.add(wrapDst);
            }
            // country's states
            wrapCnt.states.add(wrapSt);
            }
            //else {
             //   System.debug('Add the State');
           // } 
        }// for loop state 
        String json = JSON.serialize(wrapCnt);
         // Passing JSON Data to Country UI
        List<Country__c> jsonData = [SELECT Id, Name, Country_JSON_Data__c, Total_Number_of_Districts__c, Total_Number_of_States__c FROM Country__c WHERE Name = :countryName LIMIT 1];
        jsonData[0].Total_Number_of_States__c = wrapCnt.Total_Number_Of_States;
        jsonData[0].Total_Number_of_Districts__c = wrapCnt.Total_Number_Of_Districts;
        jsonData[0].Country_JSON_Data__c = json;
        update jsonData;
        
        List<State__c> stateData = [SELECT Id, Name, Total_Number_of_Districts__c FROM State__c WHERE Name =:stName];
        
        for(State__c state : stateData) {
                    state.Total_Number_of_Districts__c = stateDistrictCount;
                }
                update stateData;
        //stateData[0].Total_Number_of_Districts__c = stateDistrictCount;
        
        System.debug(json);
    } // JSON Generator End
}//Main Class Closing

/*
####################################### Execution ###########################################
CountriesStatesDistrictsDataManipulation v1 = new CountriesStatesDistrictsDataManipulation('I', 5);
v1.dynamicDataInsert();
v1.methodJSONGenerator('India','Rajasthan');
######################################## Output ############################################ 
- No Such Country Combination
-  [50]|DEBUG|Intigrating Of Country, States & District = ()
-  [63]|DEBUG|Districts Which is >= size: (Sindhudurg, Sheikhpura, List<String> galiciaDistricts =  new List<String>{'Krakau', 'Sandomir',, Ahmednagar, Bognor Regis, Littlehampton, Sindhudurg)
- [115]|DEBUG|{"Total_Number_Of_States":3,"Total_Number_Of_Districts":22,"states":[{"Total_Number_Of_Districts":6,"stateName":"Rajasthan","districts":[{"districtName":"Ajmer"},{"districtName":"Kota"},{"districtName":"Alwar"},{"districtName":"Banswara"},{"districtName":"Jodhpur"},{"districtName":"Udaipur"}]}],"countryName":"India"}
*/