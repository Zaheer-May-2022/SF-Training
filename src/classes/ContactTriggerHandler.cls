public with sharing class ContactTriggerHandler {
    
    public static void syncData(List<Contact> newList) {

        // List<Contact> conList = new List<Contact>();
        List<Account> acc = [SELECT ID, Status__c, Property__r.Status__c FROM Account];
        
        for(Contact con : newList) {
            if(con.Status__c == null) {
                for(Account account : acc) {
                    if(con.AccountId == account.ID) {
                        if(account.Status__c != null) {
                            // Contact addCon = new Contact();
                            // addCon.Status__c = account.Status__c;
                            // conList.add(addCon);
                            con.Status__c = account.Status__c;
                            System.debug('Contact Status: ' + con.Status__c);
                        }
                        else if(account.Status__c == null) {
                            // Contact addCon = new Contact();
                            // addCon.Status__c = account.Property__r.Status__c;
                            // conList.add(addCon);
                            con.Status__c = account.Property__r.Status__c;
                            System.debug('Contact Status: ' + con.Status__c);
                        }
                    }
                }
            }
        }
        // if(!conList.isEmpty()) {
        //     insert conList;
        // }
    }
}


