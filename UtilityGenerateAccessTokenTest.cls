/**
 * @description       : 
 * @author            : Zaheer Khan
 * @group             : 
 * @last modified on  : 01-06-2023
 * @last modified by  : Zaheer Khan
**/
@IsTest (SeeAllData = false)
public with sharing class UtilityGenerateAccessTokenTest {
    
    @IsTest
    static void testMethodName() {
        Environment_Settings__c es =  new Environment_Settings__c(Name = 'Task Migration', Access_Token_End_Point__c = '79546558985', Client_Id__c = 'test785453961',
                                                                 SalesforceIntegrationEndpoint__c = '745855495851', Target_Org_Name__c = 'TestCDLDev',
                                                                 Target_Org_Password__c = 'SF#Test123455', Target_Org_URL__c = 'login.salesforce.com');
        insert es;
        
        String userName = 'Test';
        String password = 'qrxdTbVBfbYNKyf1';

        Test.startTest();
        	Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
            string sessionId = UtilityGenerateAccessToken.getSessionId(userName, password);
        Test.stopTest();
        System.assertEquals('001D00KjIsdkhgduia9', sessionId, 'It should be the session id as expected');
    }
}