public with sharing class getTransactionData {

    @AuraEnabled
    public static List<Transaction_Entry__c> transData(integer transLimit, Id recordId) {

        try {
            return [SELECT Id, Name, Amount__c, Contact__c, Status__c, Transaction_Date__c, Contact__r.Available_Balance__c FROM Transaction_Entry__c Where Contact__c = :recordId And Contact__r.Transaction_Status__c Like 'Active' Limit :transLimit ];
        } catch (Exception e) {
            System.debug('An Exception: '+ e);
            return null;
        }
        
    }
}
