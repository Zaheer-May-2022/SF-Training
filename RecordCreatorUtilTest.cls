/**
 * @description       : 
 * @author            : Zaheer Khan
 * @group             : 
 * @last modified on  : 01-02-2023
 * @last modified by  : Zaheer Khan
**/
@isTest(seeAllData = false)
public with sharing class RecordCreatorUtilTest {

    @isTest
    static void testDynamicRecordCreator() {
        RecordCreatorUtil rcu = new RecordCreatorUtil();
        
        Account sourceAccount = new Account(Name = 'Test Account', Account_Status__c='in Progress');
        insert sourceAccount;
        
        Test.startTest();
            RecordCreatorUtil.dynamicRecordCreator('Account', 10, sourceAccount.Id);
        Test.stopTest();
        
        List<Account> createdAccounts = [SELECT Name FROM Account WHERE Id != :sourceAccount.Id];
        System.assertEquals(10, createdAccounts.size());
    }
    
    @isTest
    static void testDynamicContactRecordCreator() {

        Account testAccount = new Account(Name = 'Test Account', Account_Status__c ='in Progress');
        Contact testContact = new Contact(FirstName = 'Test', LastName='TestContact', AccountId = testAccount.Id);
        insert testAccount;
        insert testContact;
        
        Test.startTest();
            RecordCreatorUtil.dynamicContactRecordCreator('Account', 'Contact', 10, testContact.Id);
        Test.stopTest();

        List<Contact> createdContacts = [SELECT FirstName, AccountId FROM Contact WHERE Id != :testContact.Id];
        System.assertEquals(10, createdContacts.size());
    }
}
