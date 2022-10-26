@isTest
class StatementUnitTest {
    
    static testMethod void testStatement () {
        List<Transaction_Entry__c> transEntryList = new List<Transaction_Entry__c>();
        transEntryList = [SELECT Id, Name, Amount__c, Type__c, Contact__c, Status__c, Transaction_Date__c, Contact__r.Available_Balance__c FROM Transaction_Entry__c Where Contact__c = :recordId And  Transaction_Date__c >= :startDate And Transaction_Date__c <= :endDate];

        insert transEntryList;

        Test.startTest();
        testStatement testStaObj = new AccessManageCS();
        testStaObj.statementData();
		Test.stopTest();
    }
}
