/**
 * Purpose : Create a Automation on Contact to handle status fields.
 * Created By : ZAHEER KHAN
 * Created Date : 12-08-2022
 */

public with sharing class ContactTriggerHandler {
    
    public static void syncData(List<Contact> newList) {

        Set<Id> accSet = new Set<Id>();

        for(Contact conAcc : newList) {
            accSet.add(conAcc.AccountId);
        }
        List<Account> fetchAccList = [SELECT ID, Status__c, Property__r.Status__c FROM Account Where Id In :accSet];
        
        for(Contact con : newList) {
            if(con.Status__c == null) {
                for(Account account : fetchAccList) {
                    if(con.AccountId == account.ID) {
                        if(account.Status__c != null) {
                            con.Status__c = account.Status__c;
                            System.debug('Contact Status:======= ' + con.Status__c);
                        }
                        else if(account.Status__c == null) {
                            if(account.Property__r.Status__c != null) {
                                con.Status__c = account.Property__r.Status__c;
                                account.Status__c = account.Property__r.Status__c;
                                System.debug('Contact Status:======== ' + con.Status__c);
                                System.debug('Account Status:======== ' + account.Status__c);
                            }
                        }
                    }
                }
            }
        }
    }
}


