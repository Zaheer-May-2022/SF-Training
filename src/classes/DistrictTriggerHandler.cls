/**
 * Purpose : Create a Automation for counting total district for state
 * Created By : ZAHEER KHAN
 * Created Date : 11-08-2022
 * Revision Logs : V_1.0 - Created By : ZAHEER KHAN - 11-08-2022
 */

public with sharing class DistrictTriggerHandler {

    public static void dataManipulation(List<District__c> oldList, List<District__c> newList) {

        List<Integer> stateDisCount = new List<Integer>();
        List<State__c> totalDisInSt = new List<State__c>();
        List<Integer> counDisCount = new List<Integer>();
        List<Country__c> totalDisInCoun = new List<Country__c>();
        Set<Id> stateName = new Set<Id>();
        Set<Id> countryName = new Set<Id>();

        if(newList == null) {
            System.debug('Some District are Deleted');
            for(District__c dis : OldList) {
                Id state = dis.State__c;
                stateName.add(state);
                Id country = dis.Country__c; 
                countryName.add(country);
            }
        }
        else if (newList.size() > 0) {
            for(District__c dis : newList) {
                Id state = dis.State__c;
                stateName.add(state);
                Id country = dis.Country__c; 
                countryName.add(country);
            }
        }
        System.debug('Changed ::::::::::' + stateName);
        System.debug('Changed ::::::::::' + countryName);

        List<AggregateResult> listOfAggrDisSt = [SELECT COUNT(Name)total_District_For_State FROM District__c Where State__c In :stateName  Group By State__r.Name]; // Total state as per country

        for(AggregateResult agr : listOfAggrDisSt) {
            stateDisCount.add((Integer)agr.get('total_District_For_State'));
        }
        System.debug('Total District in State::::::::' + stateDisCount);

        List<AggregateResult> listOfAggrDisCoun = [SELECT COUNT(Name)total_District_For_Country FROM District__c Where State__r.Country__c In :countryName  Group By State__r.Country__r.Name];

        for(AggregateResult agr : listOfAggrDisCoun) {
            counDisCount.add((Integer)agr.get('total_District_For_Country'));
        }
        System.debug('Total District in Country::::::::' + counDisCount);

        // Fetch State Like Set
        List<State__c> presSt = [Select Id, Name, Total_Number_of_Districts__c From State__c Where Id In :stateName]; // State as per District Inserted.

        Integer i = 0;
        for(State__c st : presSt) {
            st.Total_Number_of_Districts__c = stateDisCount[i++];
            totalDisInSt.add(st);
        }

        if(!totalDisInSt.isEmpty()) {
            Update totalDisInSt;
            System.debug('Total District States :::::::::::::::' + totalDisInSt );
        }

        List<Country__c> presCoun = [Select Id, Name, Total_Number_of_Districts__c From Country__c Where Id In :countryName]; //  State as per District Inserted.

        Integer i2 = 0;
        for(Country__c coun : presCoun) {
            coun.Total_Number_of_Districts__c = counDisCount[i2++];
            totalDisInCoun.add(coun);
        }

        if(!totalDisInCoun.isEmpty()) {
            Update totalDisInCoun;
            System.debug('Total District States :::::::::::::::' + totalDisInCoun );
        }

    } // method

}// main
