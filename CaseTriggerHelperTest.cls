/**
 * @description       : 
 * @author            : Zaheer Khan
 * @group             : 
 * @last modified on  : 01-02-2023
 * @last modified by  : Zaheer Khan
**/
@IsTest (SeeAllData = false)
public with sharing class CaseTriggerHelperTest {
    @TestSetup
    static void setup() {
        List<Case> cases = new List<Case>();
        for(Integer i = 0; i< 10; i++) {

            Case c = new Case();
            c.Origin = 'Phone';
            c.Subject = 'Test Case Subject' + i;
            cases.add(c);
        }

        cases.add(new Case(Origin = 'Phone', subject = 'Out of Office'));

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
        System.debug('AllCases'+ allCases);
        System.debug('Size' + allCases.size());
        System.assertEquals(true, allCases.size()>0, 'it should return true check the data ');
    }
}
