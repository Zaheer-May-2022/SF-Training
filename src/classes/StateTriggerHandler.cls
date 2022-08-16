/**
 * Purpose : Create a Automation for counting total states for country
 * Created By : ZAHEER KHAN
 * Created Date : 11-08-2022
 * Revision Logs : V_1.0 
 */

public with sharing class StateTriggerHandler {

    public class Country {

        public String countryName{get; set;}
        public Integer Total_Number_Of_States{get; set;}
        public Integer Total_Number_Of_Districts{get; set;}
    }

    public static void dataManipulation(List<State__c> oldList, List<State__c> newList) {

        Country wrapCon;

        List<Integer> totalStatePerCoun = new List<Integer>();
        List<Country__c> totalStInCon = new List<Country__c>();
        Set<Id> countryName = new Set<Id>();

        if(newList == null && oldList != null) {
            System.debug('Some States are Deleted');
            for(State__c state : OldList) {
                Id country = state.Country__c;
                countryName.add(country);
            }
        }
        else if (newList != null) {
            for(State__c state : newList) {
                Id country = state.Country__c;
                countryName.add(country);
            }
        }
        System.debug('Changed ::::::::::' + countryName);

        List<AggregateResult> listOfAggrStates = [SELECT COUNT(Name)Total_State FROM State__c WHERE Country__c In :countryName  Group By Country__r.Name]; // Total state as per country

        for(AggregateResult agr : listOfAggrStates) {
            totalStatePerCoun.add((Integer)agr.get('Total_State'));
        }

        // Fetch Country Like Set
        List<Country__c> presCoun = [SELECT Id, Name, Total_Number_of_States__c, Total_Number_of_Districts__c From Country__c WHERE Id In :countryName]; // Total  Country as per State Inserted.

        Integer i = 0;
        for(Country__c country : presCoun) {
            country.Total_Number_of_States__c = totalStatePerCoun[i++];
            wrapCon = new Country();
            wrapCon.countryName = country.Name;
            wrapCon.Total_Number_Of_States = (Integer)country.Total_Number_of_States__c;
            wrapCon.Total_Number_Of_Districts = (Integer)country.Total_Number_of_Districts__c;
            String jsonCounData = JSON.serialize(wrapCon);
            System.debug('Country JSON: ' + jsonCounData);
            country.Country_JSON_Data__c = jsonCounData;
            totalStInCon.add(country);
        }

        // Count Total District of States

        if(!totalStInCon.isEmpty()) {
            Update totalStInCon;
            System.debug('Total States :::::::::::::::' + totalStInCon );
        }

    } // method dataManipulation
}
