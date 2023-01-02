/**
 * @description       : 
 * @author            : Zaheer Khan
 * @group             : 
 * @last modified on  : 01-02-2023
 * @last modified by  : Zaheer Khan
**/
@isTest (SeeAllData = false)
public with sharing class Future_updateCaseTest {

    @TestSetup
    static void setup() {

        List<Case> cases = new List<Case>();
        for(Integer i=0;i<10;i++) {

            Case c = new Case();
            c.Subject = 'Test Subject' + i ;
            c.Origin = 'Phone';

            cases.add(c);
        }

        if(!cases.isEmpty()) {

            insert cases;
        }
    }
    
    @IsTest
    static void testUpdateType() {
        
        List<Case> cases = new List<Case>();
        Test.startTest();
        cases = [SELECT Id, Subject, Origin FROM Case LIMIT 10];

        Future_updateCase.updatetype(cases[0].Id);
        Test.stopTest();

        System.debug('cases: ' + cases);
        System.assertEquals(true, cases.size()>0, 'It should contin data check list cases');
    }
}
