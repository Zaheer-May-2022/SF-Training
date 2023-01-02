/**
 * @description       : 
 * @author            : Zaheer Khan
 * @group             : 
 * @last modified on  : 01-02-2023
 * @last modified by  : Zaheer Khan
**/
@isTest (SeeAllData = false)

public with sharing class FetchDataFromSourceOrgTest {

    @TestSetup
    static void setup() {
        
        // Test Data
        // List<Connection__c> connections = new List<Connection__c>();

        Connection__c conn = new Connection__c();
        conn.InstanceUrl__c = 'https://test.example.com';
        conn.Access_Token__c = 'TestToken';
        insert conn;
        // connections.add(conn);
    }
    
    @isTest
    static void testGetLookupFieldsValue() {

        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Set up test data
        Connection__c c = new Connection__c(InstanceUrl__c = 'https://test.salesforce.com', Access_Token__c = '1234567890');
        insert c;
        
        Map<String, String> mapSourceOrgLookupFields = new Map<String, String>{
            'Account' => 'Name',
            'Contact' => 'LastName'
        };
        Map<String, String> mapTargetOrgLookupFields = new Map<String, String>{
            'Account' => 'Name',
            'Contact' => 'LastName'
        };
        String lookupSet = '(\'Test Account 1\', \'Test Account 2\', \'Test Account 3\')';
        Map<String, String> sourceOrgLookupRecords = new Map<String, String>{
            'Test Account 1' => '12345',
            'Test Account 2' => '67890',
            'Test Account 3' => '13579'
        };

        Test.startTest();
            Map<String, String> result = FetchDataFromSourceOrg.getLookupFieldsValue(c.Id, mapSourceOrgLookupFields, mapTargetOrgLookupFields, lookupSet, sourceOrgLookupRecords);
        Test.stopTest();

        
        System.assertNotEquals(null, result, 'Expected non-null result');
        System.assert(true, result.size() > 0);
    }

    @isTest
    static void testTransferData() {

        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        // Set up test data
        Connection__c c = new Connection__c(InstanceUrl__c = 'https://test.salesforce.com', Access_Token__c = '1234567890');
        insert c;

        String soapXmlBody = '<GetRecord xmlns="urn:enterprise.soap.sforce.com">'
            + '<fieldList>Id, Name</fieldList>'
            + '<sObjectType>Account</sObjectType>'
            + '<id>12345</id>'
            + '</GetRecord>';

        // Test transferData method
        Test.startTest();
            HttpResponse response = FetchDataFromSourceOrg.transferData(c.Id, soapXmlBody);
        Test.stopTest();

        String contentType = response.getHeader('Content-Type');
        String body = response.getbody();
        System.assertNotEquals(null, body, 'Expected non-null body'); // "example":"test"
        System.assertNotEquals(null, response, 'Expected non-null response');
    }    
}
