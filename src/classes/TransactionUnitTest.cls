@isTest
class TransactionUnitTest {
    static testMethod void testTransaction () {
        List<Transaction_Entry__c> transEntryList = new List<Transaction_Entry__c>();
        transEntryList = [SELECT Id, Name, Amount__c, Contact__c, Status__c, Transaction_Date__c, Contact__r.Available_Balance__c FROM Transaction_Entry__c Where Contact__c = :recordId And Contact__r.Transaction_Status__c Like 'Active' Limit :transLimit ];

        insert transEntryList;

        Test.startTest();
        testStatement testTransObj = new AccessManageCS();
        testTransObj.transData();
		Test.stopTest();
    }
}