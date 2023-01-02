/**
 * @description       : 
 * @author            : Zaheer Khan
 * @group             : 
 * @last modified on  : 01-02-2023
 * @last modified by  : Zaheer Khan
**/
@isTest (SeeAllData = false)
public with sharing class AccountTriggerHelperTest {
    @IsTest
    static void testinsertstatus() {
        
        MockDAO.AccountMockDAO accMocInstance = new MockDAO.AccountMockDAO();
        List<Account> accounts1 = new List<Account>();

        List<String> StatusList = new List<String>{'Not started','in Progress','Ready for Qa','Qa in Progress','Re4ady for Cross check','Ready for SB Move','moves to SB', 'Ready for UAT','UAT in Progress','Ready for Deployement','Deployed'};

        for(Integer i = 1; i <= 1; i++) {
            
            Account acc = new Account();
            acc.Id = TestFactory.getFakeId(Account.SObjectType);
            acc.Name = 'Test Account ' + i;
            acc.Account_Status__c = 'in Progress';
            accounts1.add(acc);
        }

        accMocInstance.accounts = accounts1;
        AccountDAO.IAccountDAO accI = new AccountDAO();
        accI = accMocInstance;
        List<Account> accounts2 = accI.generateAccount();

        Map<Id, Account> accountsMap2 = new Map<Id, Account>();

        for (Account acc : accounts2) {
            accountsMap2.put(acc.Id, acc);
        }
        
        for(Account a : accountsMap2.values()) {
            a.Account_Status__c = 'Qa in Progress';
        } 

        Test.startTest();
            AccountTriggerHelper.insertstatus(accounts2, Null);
            AccountTriggerHelper.insertstatus(accounts2, accountsMap2);
            System.debug('accounts1: ' + accounts2);
            System.debug('accountsMap2: ' + accountsMap2);
        Test.stopTest();

        System.assertEquals(true, accounts1.size()>0, 'It Should have data for accounts1');
        System.assertEquals(true, accountsMap2.size()>0, 'It Should have data for ' + accountsMap2);
    }
}
