/**
 * @description       : 
 * @author            : Zaheer Khan
 * @group             : 
 * @last modified on  : 01-02-2023
 * @last modified by  : Zaheer Khan
**/
@isTest(SeeAllData = false)
public with sharing class Utility_IntegrateSalesforceOrgTest {

    @isTest
    // Test the transferData method
    static void testTransferData() {

        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        Connection__c connection = new Connection__c(Access_Token__c = 'abc123', InstanceUrl__c = 'https://test.salesforce.com');
        insert connection;

        // Set up test data
        String connectionId = connection.Id;
        String soapXmlBody = '<test>Test soap body</test>';
        
        Test.startTest();
            httpResponse response = Utility_IntegrateSalesforceOrg.transferData(connectionId, soapXmlBody);
        Test.stopTest();

        System.assertNotEquals(null, response, 'Response should not be null');
        System.assertEquals(200, response.getStatusCode(), 'Incorrect status code');
    }

    @IsTest
    static void testRequestFormation() {

        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
		
        // Set up test data
        String authToken = 'abc123';
        String instanceUrl = 'https://test.salesforce.com';
        String soapXmlBody = '<test>Test soap body</test>';
        
        Test.startTest();
            httpResponse response = Utility_IntegrateSalesforceOrg.requestformation(authToken, instanceUrl, soapXmlBody);
        Test.stopTest();
        
        System.assertNotEquals(null, response, 'Response should not be null');
        System.assertEquals(200, response.getStatusCode(), 'Incorrect status code');
    }

    /*@IsTest
    static void testfakeCoverage() {
        
        Test.startTest();
            Utility_IntegrateSalesforceOrg.fakeCoverage();
        Test.stopTest();
    }*/
}