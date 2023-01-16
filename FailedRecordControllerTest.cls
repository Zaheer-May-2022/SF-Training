/**
 * @description       : 
 * @author            :  Zaheer Khan
 * @group             : 
 * @last modified on  : 01-06-2023
 * @last modified by  : Zaheer Khan
**/
@IsTest (SeeAllData = false)
public with sharing class FailedRecordControllerTest {

    @isTest
    static void testGetFailedRecords() {
        FailedRecordController frc  = new FailedRecordController();
        
        // Create a test data
        Data_Migration__c migration = new Data_Migration__c(
            Name = 'Test Migration'
        );
        insert migration;

        Migration_Batch__c batch = new Migration_Batch__c(
            Data_Migration__c = migration.Id
        );
        insert batch;

        Migration_Status__c failedRecord = new Migration_Status__c(
            Migration_Failed_Batch__c = batch.Id
        );
        insert failedRecord;

        Test.startTest();
            List<Migration_Batch__c> failedBatches = FailedRecordController.GetFailedRecords(migration.Id);
        Test.stopTest();

        System.assertEquals(1, failedBatches.size(), 'The query should have returned 1 batch');
        System.assertEquals(batch.Id, failedBatches[0].Id, 'The query returned the wrong batch');
    }

    @isTest
    static void testRunSelectedBatch() {
        //Test Data
        Connection__c conn = new Connection__c(InstanceUrl__c = 'https://test.salesforce.com', 
                                               Access_Token__c = '00D5g000004gZLhEAM001AB854967213025');
        insert conn;
		
        //Object Mapping data
        List<Object_Mapping__c> mappings = new List<Object_Mapping__c>();
        Object_Mapping__c mapping = new Object_Mapping__c(External_Id__c = 'AccountNumber', Referenced_Field__c = 'Name',
        												  Source_Org_Object_Name__c = 'Account', Target_Org_Object_Name__c = 'Account', 
        												  Synchronization_Key__c = '', Connection__c = conn.Id);
        mappings.add(mapping);
        insert mappings;
		
        //Data Migration Data
        List<Data_Migration__c> migrations = new List<Data_Migration__c>();
        Data_Migration__c migration = new Data_Migration__c(Name = 'Test Migration', ObjectMapping__c = mappings[0].Id, 
                                                            Where_Clause__c = 'CreatedDate',
            												Child_Object__c = 'Contact', Connection__c = conn.id, isAlreadyRun__c = false, 
            												DML_Operation__c = 'upsert');
        migrations.add(migration);
        insert migrations;
        
        //Migration Batch Data
        List<Migration_Batch__c> batches = new List<Migration_Batch__c>();
        
        Migration_Batch__c batch1 = new Migration_Batch__c(isChild__c = true, Data_Migration__c = migrations[0].Id);
        batches.add(batch1);
        
        Migration_Batch__c batch2 = new Migration_Batch__c(isChild__c = false, Data_Migration__c = migrations[0].Id);
        batches.add(batch2);
        
        insert batches;
		
        //Migration Status Data
        List<Migration_Status__c> statuses = new List<Migration_Status__c>();
        
        Migration_Status__c status1 = new Migration_Status__c(Migration_Succeeded_Batch__c = batch1.Id, 
                                                              Source_Record_Link__c = 'https://test.record1.link/84865sw6',
                                                             Target_Record_Link__c = 'https://test.salesforce.com/84865sw6');
		statuses.add(status1);
        
        Migration_Status__c status2 = new Migration_Status__c(Migration_Succeeded_Batch__c = batch2.Id, Migration_Failed_Batch__c = batch2.Id,
                                                             Source_Record_Link__c = 'https://test.record2.link/ae5fs6rg4', Target_Record_Link__c = 'https://test.salesforce.com/ae5fs6rg4');
        statuses.add(status2);
        
        insert statuses;
        
        //Test Data Field_Mapping__c
        List<Field_Mapping__c> fieldMappings = new List<Field_Mapping__c>();
        
        Field_Mapping__c fieldMapping = new Field_Mapping__c(ObjectMapping__c = mappings[0].Id, Source_Org_Field_Name__c = 'AccountNumber',
                                                            Target_Org_Field_Name__c = 'AccountNumber');
        fieldMappings.add(fieldMapping);
        
        insert fieldMappings;
        
        //Lookup Mapping Data
        List<LookupMapping__c> lookupMappings = new List<LookupMapping__c>();
        
        LookupMapping__c lookupMapping = new LookupMapping__c(Data_Migration__c = migrations[0].Id, Source_VlookUp_Name__c='Account',
                                                             Target_Field_Name__c = 'AccountNumber', Target_Object_Name__c = 'Account',
                                                             FieldMapping__c = fieldMappings[0].Id);
        lookupMappings.add(lookupMapping);
        
        insert lookupMappings;
        
        String selectedIds = JSON.serialize(new Set<String>{batches[0].Id, batches[1].Id});

        Test.startTest();
        	Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
            String result = FailedRecordController.RunSelectedBatch(selectedIds, migrations[0].Id);
        	String result2 = FailedRecordController.RunSelectedBatch(selectedIds, '');
        Test.stopTest();
        System.assertEquals('SUCCESS', result);
        System.assertEquals(null, result2);
    }
}