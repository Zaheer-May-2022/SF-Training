/**
 * @description       : 
 * @author            : Zaheer Khan
 * @group             : 
 * @last modified on  : 01-09-2023
 * @last modified by  : Zaheer Khan
**/
@isTest (SeeAllData = false)
public with sharing class AccountTriggerHelperTest {
    @IsTest
    static void testInsertstatusWithoutOldMap() {

        List<Account> accList1 = TestFactory.createAccountList(10);
        System.debug('accList1: ' + accList1);
        
        Test.startTest();
            AccountTriggerHelper.insertstatus(accList1, Null);
        Test.stopTest();

        List<String> StatusList = new List<String>{'Not started','in Progress','Ready for Qa','Qa in Progress','Re4ady for Cross check','Ready for SB Move','moves to SB', 'Ready for UAT','UAT in Progress','Ready for Deployement','Deployed'};

        for (Account acc : accList1) {
            System.assertEquals(true, StatusList.Contains(acc.Account_Status__c), 'Account status should be Exist');
        }
    }

    @IsTest
    static void testInsertstatusWithOldMap() {

        List<Account> accList = TestFactory.createAccountList(10);
        System.debug('accList: ' + accList);

        Map<Id,Account> oldMap = new Map<Id,Account>();

        for (Account acc : accList) {
            oldMap.put(acc.id, acc);
        }

        List<Account> newList = new List<Account>();
        for (Account acc : accList) {
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
