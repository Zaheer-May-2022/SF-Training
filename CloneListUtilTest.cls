/**
 * @description       : 
 * @author            : Zaheer Khan
 * @group             : 
 * @last modified on  : 01-12-2023
 * @last modified by  : Zaheer Khan
**/
@isTest
public class CloneListUtilTest {    

    @testSetup
    private static void cloneListUtilTestSetup() {
        
        List<Account> account = TestFactory.createAccountList(10, true);

        List<Contact> contact = TestFactory.createContactList(10, true);
    }

    @isTest
    static void testVerifyChildObjectSelectedTrue() {

        List<ChildRelationship> childObjects = new List<ChildRelationship>();

        ChildRelationship cr = new ChildRelationship();
        cr.setSelected(true);

        childObjects.add(cr);

        Test.startTest();
            Boolean ret1 = CloneListUtil.verifyChildObjectSelected(childObjects);
        Test.stopTest();

        System.assertEquals(true, ret1, 'It should be true sObject is passes');
    }

    @isTest
    static void testVerifyChildObjectSelectedFalse() {

        List<ChildRelationship> childObjects = new List<ChildRelationship>();

        ChildRelationship cr = new ChildRelationship();
        cr.setSelected(false);

        childObjects.add(cr);

        Test.startTest();
            Boolean ret2 = !CloneListUtil.verifyChildObjectSelected(childObjects);
        Test.stopTest();

        System.assertEquals(true, ret2, 'It should be false sObject');
    }

    @isTest
    static void testGetObjectNameBasedOnPrefix() {
        // Test with a known object prefix
        String id = '001000000000000';
        String expectedObjectName = 'Account';

        Test.startTest();
            String actualObjectName = CloneListUtil.getObjectNameBasedOnPrefix(id);
        Test.stopTest();
        System.assertEquals(expectedObjectName, actualObjectName, 'It should be a known object name as an account');
    }

    @IsTest
    static void testGetChildRecordNames() {
        // Test with a known child record name
        Contact con = new Contact();
        con.id = TestFactory.getFakeId(Contact.SObjectType);
        con.lastName = 'Test';
        Account acc = new Account();
        acc.Id = TestFactory.getFakeId(Account.SObjectType);
        con.AccountId = acc.Id;

        String objectName = 'Account';
        String sourceId;

        Test.startTest();
        List<ChildRelationship> childRecords =  CloneListUtil.getChildRecordNames(objectName, con.Id);
        System.debug(LoggingLevel.DEBUG, 'childRecords: ' + childRecords);
        Test.stopTest();
        System.assertEquals(true, childRecords.size()>0, 'It should be a child record');
    }

    @IsTest
    static void testGenerateSelectAllQuery() {
        // Test with all fileds to be queryable
        Account acc = new Account();
        acc.Id = TestFactory.getFakeId(Account.SObjectType);
        acc.Name = 'Test Account';
        acc.Account_Status__c = 'in Progress';
        
        Test.startTest();
            String query = CloneListUtil.generateSelectAllQuery('Account', 'Name', acc.Id);
        Test.stopTest();
    }

    @isTest
    static void testCreateCloneParentRecord() {
        // Setup test data
        Account account = new Account(Name = 'Test Account', Account_Status__c = 'in Progress');
        insert account;

        String sourceId = account.Id;

        Test.startTest();
            Database.SaveResult result = CloneListUtil.createCloneParentRecord(sourceId);
        Test.stopTest();
        System.assert(result.isSuccess());
    }

    @isTest
    static void testCreateCloneChildRecords() {
        // Setup test data

        List<Contact> contactList = [SELECT Id, FirstName, LastName, AccountId From Contact LIMIT 10];

        String sourceId = contactList[0].Id;
        String destinationId = contactList[0].AccountId;

        ChildRelationship childRelationship = new ChildRelationship();
        childRelationship.setSelected(true);
        childRelationship.setRecordAmount(1);
        childRelationship.setObjectName('Contact');
        childRelationship.setFieldName('AccountId');

        List<ChildRelationship> childRecords = new List<ChildRelationship> { childRelationship };

        Test.startTest();
            List<Database.Error> errors = CloneListUtil.createCloneChildRecords(sourceId, destinationId, childRecords);
        Test.stopTest();
        System.assert(errors.isEmpty());
    }
}

