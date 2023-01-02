/**
 * @description       : 
 * @author            : Zaheer Khan
 * @group             : 
 * @last modified on  : 01-02-2023
 * @last modified by  : Zaheer Khan
**/
@IsTest (SeeAllData = false)
public with sharing class RelatedListControllerTest {
    
    @isTest
    static void testFetchData() {
        // Set up test data
        RelatedListController.ComponentInfo testInfo = new RelatedListController.ComponentInfo();
        testInfo.pageNumber = 1;
        testInfo.recordToDisplay = 10;
        testInfo.objectType = 'Account';
        testInfo.parentField = '';
        testInfo.parentRecordId = '001D000000I9X6n';
        testInfo.recordId = '789001D000I9X6n';
        
        Test.startTest();
            RelatedListController.ObjectWrapper result = RelatedListController.fetchData(JSON.serialize(testInfo));
        Test.stopTest();

        //Assert
        System.assertNotEquals(null, result, 'Expected non-null result');
        System.assertEquals(10, result.pageSize, 'Expected page size of 10');
        System.assertEquals(1, result.page, 'Expected page number of 1');

    }
    


    @isTest
    static void testGetCountQueryString() {
        // Data
        RelatedListController controller = new RelatedListController();
        RelatedListController.ComponentInfo info = new RelatedListController.ComponentInfo();
        info.objectType = 'Account';
        info.parentField = 'ParentId';
        info.parentRecordId = '001D000000I9X6n';

        Test.startTest();
            String query = RelatedListController.getCountQueryString(info);
        Test.stopTest();

    }
    @isTest
    static  void testGetObjectQueryString() {
        // Data
        RelatedListController controller = new RelatedListController();
        RelatedListController.ComponentInfo info = new RelatedListController.ComponentInfo();
        info.objectType = 'Account';
        info.parentField = 'ParentId';
        info.parentRecordId = '001D000000I9X6n';

        Test.startTest();
            String query = RelatedListController.getObjectQueryString(info);
        Test.stopTest();

    }
    @isTest
    static  void testGetObjectQueryStringWithNoParent() {
        // Arrange
        RelatedListController controller = new RelatedListController();
        RelatedListController.ComponentInfo info = new RelatedListController.ComponentInfo();
        info.objectType = 'Account';
        info.recordToDisplay = 10;
        info.pageNumber = 1;

        Test.startTest();
            String query = RelatedListController.getObjectQueryString(info);
        Test.stopTest();

    }

    @isTest
    static void testDeleteRecord() {
        // Set up test data
        Profile p = [Select Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Username = 'testbyzaheer@mailh.com', Email = 'test123user@test.com', Alias='test123', EmailEncodingKey = 'UTF-8', LastName = 'Test', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Los_Angeles', ProfileId = p.Id);
        insert u;

        Account a = new Account(Name = 'Test Account', Account_Status__c = 'in Progress');
        insert a;

        RelatedListController.ComponentInfo testInfo = new RelatedListController.ComponentInfo();
        testInfo.pageNumber = 1;
        testInfo.recordToDisplay = 10;
        testInfo.objectType = 'Account';
        testInfo.parentField = '';
        testInfo.parentRecordId = '001D000000I9X6n';
        testInfo.recordId = a.Id;

        // Test deleteRecord method
        System.runAs(u) {
            
            Test.startTest();
                RelatedListController.ObjectWrapper result = RelatedListController.deleteRecord(JSON.serialize(testInfo));
			Test.stopTest();
            
            //Assert
            System.assertNotEquals(null, result, 'Expected non-null result');
            System.assertEquals(10, result.pageSize, 'Expected page size of 10');
            System.assertEquals(1, result.page, 'Expected page number of 1');
        }
    }
}
