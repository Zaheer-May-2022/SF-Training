public with sharing class getStatementData {
    
    @AuraEnabled
    public static List<Transaction_Entry__c> statementData(date startDate, date endDate, id recordId) {

        try {
            return [SELECT Id, Name, Amount__c, Type__c, Contact__c, Status__c, Transaction_Date__c, Contact__r.Available_Balance__c FROM Transaction_Entry__c Where Contact__c = :recordId And  Transaction_Date__c >= :startDate And Transaction_Date__c <= :endDate];
        } catch (Exception e) {
            System.debug('An Exception: '+ e);
            return null;
        }
        
    }
}
