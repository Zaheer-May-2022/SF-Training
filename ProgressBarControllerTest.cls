/**
 * @description       : 
 * @author            : Zaheer Khan
 * @group             : 
 * @last modified on  : 01-23-2023
 * @last modified by  : Zaheer Khan
**/
@isTest	(SeeAllData = false)
public with sharing class ProgressBarControllerTest {

    
    @TestSetup
    static void progressBarControllerTestSetup() {

        Connection__c connection = new Connection__c();
        connection.InstanceUrl__c = 'https://test.salesforce.com';
        connection.Access_Token__c = '00D5g000004gZLhEAM001AB854967213025';
        insert connection;
        
        Object_Mapping__c mappings = new Object_Mapping__c();
        mappings.External_Id__c = 'AccountNumber';
        mappings.Referenced_Field__c = 'AccountNumber';
        mappings.Source_Org_Object_Name__c = 'Account';
        mappings.Target_Org_Object_Name__c = 'Account';
        mappings.Connection__c = connection.Id;
        insert mappings;
 
        Data_Migration__c migration = new Data_Migration__c();
        migration.Connection__c = connection.Id;
        migration.DML_Operation__c = 'Insert';
        migration.ObjectMapping__c	= mappings.Id;
        insert migration;
        
        Field_Mapping__c fieldMapping = new Field_Mapping__c();
        fieldMapping.ObjectMapping__c = mappings.Id;
        fieldMapping.Source_Org_Field_Name__c = 'AccountNumber';
        fieldMapping.Target_Org_Field_Name__c = 'AccountNumber';
        insert fieldMapping;

        LookupMapping__c lookupMap = new LookupMapping__c();
        lookupMap.Target_Field_Name__c = 'AccountNumber';
        lookupMap.Target_Object_Name__c = 'Account';
        lookupMap.Source_VlookUp_Name__c = 'AccountNumber';
        lookupMap.FieldMapping__c = fieldMapping.Id;
        insert lookupMap;
    }

    @isTest
    static void testProgressBarControllerForAbort() {

        Account acc = new Account(Name = 'Test Account', Account_Status__c = 'in Progress', AccountNumber = 'CD785462');
        insert acc;
    
        Map<String, String> mapTargetObjIds = new Map<String, String>();
        mapTargetObjIds.put('Account', acc.Id);

        Map<String, String> mapLookupDataToBeTransferInTargetOrg = new Map<String, String>();
        mapLookupDataToBeTransferInTargetOrg.put('Account', acc.Id);

        Connection__c connection = [SELECT ID, InstanceUrl__c, Access_Token__c FROM Connection__c];

        Object_Mapping__c mappings = [SELECT ID, External_Id__c, Referenced_Field__c, Source_Org_Object_Name__c, Target_Org_Object_Name__c, Connection__c 
                                        FROM Object_Mapping__c 
                                        WHERE Connection__c =:connection.Id];
        
        Data_Migration__c migration = [SELECT ID, Connection__c, Connection__r.InstanceUrl__c, DML_Operation__c, ObjectMapping__c, Where_Clause__c
                                        FROM Data_Migration__c 
                                        WHERE Connection__c =: connection.Id AND ObjectMapping__c =: mappings.Id];

        Field_Mapping__c fieldMapping = [SELECT ID, ObjectMapping__c, Source_Org_Field_Name__c, Target_Org_Field_Name__c
                                            FROM Field_Mapping__c
                                            WHERE ObjectMapping__c =: mappings.Id];

        LookupMapping__c lookupMap = [SELECT ID, Target_Field_Name__c, Target_Object_Name__c, Source_VlookUp_Name__c, FieldMapping__c
                                        FROM LookupMapping__c
                                        WHERE FieldMapping__c =: fieldMapping.Id];
        
        ProgressBarController controller = new ProgressBarController();

        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
            Id jobId;
            ApexPages.currentPage().getParameters().put('id',migration.id);
            Batch_DataTransfer batch = new Batch_DataTransfer(migration, mapTargetObjIds, mapLookupDataToBeTransferInTargetOrg, null, false, null, 'Account');
            jobId = Database.executeBatch(batch);
            
            // Create test data
            Data_Migration__c dataMigration = new Data_Migration__c(Id = migration.Id, Job_Id__c = jobId);
            Update dataMigration;
                
            AsyncApexJob batchJob = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors FROM AsyncApexJob Where Id = :jobId];
        
            for ( AsyncApexJob aJob : [ Select id ,Status, ApexClass.Name 
                            from AsyncApexJob where Status!='Aborted' 
                            and Status!='Completed' ] ){

                System.AbortJob(aJob.Id);
            }
        
            AsyncApexJob asyncApexJob = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors
                                FROM AsyncApexJob WHERE ID =: jobId ];
            System.debug('Async JOBS --> '+asyncApexJob);
        
            PageReference pageRef2 = controller.checkStatus();

        Test.stopTest();
        
        System.assertEquals(0, controller.deProgressBarWidth, 'Progress bar width is incorrect');
        System.assertEquals('Checking Status...', controller.strStatus, 'Status is incorrect');
        System.assertEquals(true, controller.bProcess, 'bProcess flag is incorrect');
        System.assertEquals(0, controller.JobItemsProcessed, 'JobItemsProcessed is incorrect');
        System.assertEquals(0, controller.TotalJobItems, 'TotalJobItems is incorrect');
    }
    
    @isTest
    static void testProgressBarController() {

        Account acc = new Account(Name = 'Test Account', Account_Status__c = 'in Progress', AccountNumber = 'CD785462');
        insert acc;
    
        Map<String, String> mapTargetObjIds = new Map<String, String>();
        mapTargetObjIds.put('Account', acc.Id);

        Map<String, String> mapLookupDataToBeTransferInTargetOrg = new Map<String, String>();
        mapLookupDataToBeTransferInTargetOrg.put('Account', acc.Id);

        Connection__c connection = [SELECT ID, InstanceUrl__c, Access_Token__c FROM Connection__c LIMIT 1];

        Object_Mapping__c mappings = [SELECT ID, External_Id__c, Referenced_Field__c, Source_Org_Object_Name__c, Target_Org_Object_Name__c, Connection__c 
                                        FROM Object_Mapping__c 
                                        WHERE Connection__c =:connection.Id];

        
        Data_Migration__c migration = [SELECT ID, Connection__c, Connection__r.InstanceUrl__c, DML_Operation__c, ObjectMapping__c, Where_Clause__c
                                        FROM Data_Migration__c 
                                        WHERE Connection__c =: connection.Id AND ObjectMapping__c =: mappings.Id];

        Field_Mapping__c fieldMapping = [SELECT ID, ObjectMapping__c, Source_Org_Field_Name__c, Target_Org_Field_Name__c
                                            FROM Field_Mapping__c
                                            WHERE ObjectMapping__c =: mappings.Id];

        LookupMapping__c lookupMap = [SELECT ID, Target_Field_Name__c, Target_Object_Name__c, Source_VlookUp_Name__c, FieldMapping__c
                                        FROM LookupMapping__c
                                        WHERE FieldMapping__c =: fieldMapping.Id];

        ProgressBarController controller = new ProgressBarController();

        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
            Id jobId;
            ApexPages.currentPage().getParameters().put('id',migration.id);
            Batch_DataTransfer batch = new Batch_DataTransfer(migration, mapTargetObjIds, mapLookupDataToBeTransferInTargetOrg, null, false, null, 'Account');
            jobId = Database.executeBatch(batch);
        PageReference pageRef2 = controller.checkStatus();
        Test.stopTest();
        
        System.assertEquals(0, controller.deProgressBarWidth, 'Progress bar width is incorrect');
        System.assertEquals('Checking Status...', controller.strStatus, 'Status is incorrect');
        System.assertEquals(true, controller.bProcess, 'bProcess flag is incorrect');
        System.assertEquals(0, controller.JobItemsProcessed, 'JobItemsProcessed is incorrect');
        System.assertEquals(0, controller.TotalJobItems, 'TotalJobItems is incorrect');
    }
    
    @isTest
    static void testProgressBarControllerForQueue() {

        Account acc = new Account(Name = 'Test Account', Account_Status__c = 'in Progress', AccountNumber = 'CD785462');
        insert acc;
    
        Map<String, String> mapTargetObjIds = new Map<String, String>();
        mapTargetObjIds.put('Account', acc.Id);

        Map<String, String> mapLookupDataToBeTransferInTargetOrg = new Map<String, String>();
        mapLookupDataToBeTransferInTargetOrg.put('Account', acc.Id);

        Connection__c connection = [SELECT ID, InstanceUrl__c, Access_Token__c FROM Connection__c LIMIT 1];

        Object_Mapping__c mappings = [SELECT ID, External_Id__c, Referenced_Field__c, Source_Org_Object_Name__c, Target_Org_Object_Name__c, Connection__c 
                                        FROM Object_Mapping__c 
                                        WHERE Connection__c =:connection.Id];        

        Data_Migration__c migration = [SELECT ID, Connection__c, Connection__r.InstanceUrl__c, DML_Operation__c, ObjectMapping__c, Where_Clause__c
                                        FROM Data_Migration__c 
                                        WHERE Connection__c =: connection.Id AND ObjectMapping__c =: mappings.Id];

        Field_Mapping__c fieldMapping = [SELECT ID, ObjectMapping__c, Source_Org_Field_Name__c, Target_Org_Field_Name__c
                                            FROM Field_Mapping__c
                                            WHERE ObjectMapping__c =: mappings.Id];

        LookupMapping__c lookupMap = [SELECT ID, Target_Field_Name__c, Target_Object_Name__c, Source_VlookUp_Name__c, FieldMapping__c
                                        FROM LookupMapping__c
                                        WHERE FieldMapping__c =: fieldMapping.Id];

        ProgressBarController controller = new ProgressBarController();

        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
            Id jobId;
            ApexPages.currentPage().getParameters().put('id',migration.id);
            Batch_DataTransfer batch = new Batch_DataTransfer(migration, mapTargetObjIds, mapLookupDataToBeTransferInTargetOrg, null, false, null, 'Account');
            jobId = Database.executeBatch(batch);
            
            // Create test data
            Data_Migration__c dataMigration = new Data_Migration__c(Id = migration.Id, Job_Id__c = jobId);
            Update dataMigration;
        
            PageReference pageRef2 = controller.checkStatus();

        Test.stopTest();
        
        System.assertEquals(0, controller.deProgressBarWidth, 'Progress bar width is incorrect');
        System.assertEquals('Checking Status...', controller.strStatus, 'Status is incorrect');
        System.assertEquals(true, controller.bProcess, 'bProcess flag is incorrect');
        System.assertEquals(0, controller.JobItemsProcessed, 'JobItemsProcessed is incorrect');
        System.assertEquals(0, controller.TotalJobItems, 'TotalJobItems is incorrect');
    }
}