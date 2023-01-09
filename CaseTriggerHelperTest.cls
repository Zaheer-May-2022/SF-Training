/**
 * @description       : 
 * @author            : Zaheer Khan
 * @group             : 
 * @last modified on  : 01-09-2023
 * @last modified by  : Zaheer Khan
**/
@IsTest (SeeAllData = false)
public with sharing class CaseTriggerHelperTest {
    @TestSetup
    static void setupCaseTriggerHelper() {

        List<Case> cases = TestFactory.createCaseList(10, false);
        cases.add(new Case(Origin = 'Phone', subject = 'Out of Office'));
		
        system.debug('cases : ' + cases);
        if(!cases.isEmpty()) {
            insert cases;
        }
    }
    
    @IsTest
    static void testCaseDelete() {
        
        CaseTriggerHelper c = new CaseTriggerHelper();

        List<Case> allCases = [SELECT ID, CaseNumber, Subject, Origin from Case LIMIT 11];

        Test.startTest();
            CaseTriggerHelper.caseDeletion(allCases);
        Test.stopTest();

        List<Case> remainingCases = [SELECT ID, CaseNumber, Subject, Origin from Case LIMIT 11];
        System.assertEquals(10, remainingCases.size(), 'There should be 10 cases remaining after the delete method is called as per the test case data');
    }
}