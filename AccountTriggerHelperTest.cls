/**
 * @description       : 
 * @author            : Zaheer Khan
 * @group             : 
 * @last modified on  : 01-10-2023
 * @last modified by  : Zaheer Khan
**/
@isTest (SeeAllData = false)
public with sharing class AccountTriggerHelperTest {


    @TestSetup
    static void accountTriggerHelperTestSetup() {
        
        List<Account> accList1 = TestFactory.createAccountList(10, false);
        for (Account acc : accList1) {
            acc.Id = TestFactory.getFakeId(Account.SObjectType);
        }
        System.debug('accList1: ' + accList1);
    }
    @IsTest
    static void testInsertstatusWithoutOldMap() {

        List<Account> accList1 = [SELECT Id, Name, Account_Status__c 
                                    FROM Account LIMIT 10];

        MockDAO.AccountMockDAO accountMockDAOInstance = new MockDAO.AccountMockDAO(); // MOCKDAO instance
        mockDAOInstance.accounts = accList1;
        
        AccountDAO.IAccountDAO accountDAOInstance = new AccountDAO(); // AccountDAO instance
        accountDAOInstance = accountMockDAOInstance;

        Test.startTest();
            List<Account> accList2 = accountMockDAOInstance.generateAccount();
            AccountTriggerHelper.insertstatus(accList2, Null);
        Test.stopTest();

        List<String> StatusList = new List<String>{'Not started','in Progress','Ready for Qa','Qa in Progress','Re4ady for Cross check','Ready for SB Move','moves to SB', 'Ready for UAT','UAT in Progress','Ready for Deployement','Deployed'};

        for (Account acc : accList2) {
            System.assertEquals(true, StatusList.Contains(acc.Account_Status__c), 'Account status should be Exist');
        }
    }

    @IsTest
    static void testInsertstatusWithOldMap() {

        List<Account> accList1 = [SELECT Id, Name, Account_Status__c 
                                    FROM Account LIMIT 10];

        MockDAO.AccountMockDAO accountMockDAOInstance = new MockDAO.AccountMockDAO(); // MOCKDAO instance
        mockDAOInstance.accounts = accList1;
        
        AccountDAO.IAccountDAO accountDAOInstance = new AccountDAO(); // AccountDAO instance
        accountDAOInstance = accountMockDAOInstance;

        Map<Id,Account> oldMap = new Map<Id,Account>();

        for (Account acc : accList1) {
            oldMap.put(acc.id, acc);
        }

        List<Account> newList = new List<Account>();
        for (Account acc : accList1) {
            Account account = new Account();
            account.Id = acc.id;
            account.Account_Status__c = 'in Progress';
            newList.add(account);
        }

        if(!newList.isEmpty()) {
            upsert newList;
        }

        Test.startTest();
            AccountTriggerHelper.insertstatus(newList, oldMap);
        Test.stopTest();

        List<String> StatusList = new List<String>{'Not started','in Progress','Ready for Qa','Qa in Progress','Re4ady for Cross check','Ready for SB Move','moves to SB', 'Ready for UAT','UAT in Progress','Ready for Deployement','Deployed'};

        for (Account acc : newList) {
            System.assertEquals(true, StatusList.Contains(acc.Account_Status__c), 'Account status should be Exist');
        }
    }
}
