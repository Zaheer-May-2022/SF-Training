/**
 * Purpose : Create a Automation for counting total states for country
 * Created By : ZAHEER KHAN
 * Created Date : 11-08-2022
 * Revision Logs : V_1.0 - Created By : ZAHEER KHAN - 11-08-2022
 */


public with sharing class StateTriggerHandler {

    public static void dataManipulation(List<State__c> oldList, List<State__c> newList) {

        List<Integer> totalStatePerCoun = new List<Integer>();
        List<Country__c> totalStInCon = new List<Country__c>();
        Set<Id> countryName = new Set<Id>();

        if(newList == null) {
            System.debug('Some States are Deleted');
            for(State__c state : OldList) {
                Id country = state.Country__c;
                countryName.add(country);
            }
        }
        else if (newList.size() > 0) {
            for(State__c state : newList) {
                Id country = state.Country__c;
                countryName.add(country);
            }
        }
        System.debug('Changed ::::::::::' + countryName);

        List<AggregateResult> listOfAggrStates = [SELECT COUNT(Name)Total_State FROM State__c Where Country__c In :countryName  Group By Country__r.Name]; // Total state as per country

        for(AggregateResult agr : listOfAggrStates) {
            totalStatePerCoun.add((Integer)agr.get('Total_State'));
        }

        // Fetch Country Like Set
        List<Country__c> presCoun = [Select Id, Name, Total_Number_of_States__c From Country__c Where Id In :countryName]; // Total  Country as per State Inserted.

        Integer i = 0;
        for(Country__c country : presCoun) {
            country.Total_Number_of_States__c = totalStatePerCoun[i++];
            totalStInCon.add(country);
        }

        // Count Total District of States

        List<AggregateResult> totalDistrict = [Select Id, COUNT(Name)Total_District From ]

        if(!totalStInCon.isEmpty()) {
            Update totalStInCon;
            System.debug('Total States :::::::::::::::' + totalStInCon );
        }
    } // method dataManipulation
}
