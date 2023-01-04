/**
 * @description       : 
 * @author            : Zaheer Khan
 * @group             : 
 * @last modified on  : 01-04-2023
 * @last modified by  : Zaheer Khan
**/
@isTest
public class CloneListUtilTest {

    @testSetup
    private static void cloneListUtilTestSetup() {
        
        Account account = new Account(Name = 'Test Account', Account_Status__c = 'in Progress');
        insert account;

        Contact contact = new Contact(FirstName = 'Test', LastName = 'Contact', AccountId = account.Id);
        insert contact;
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

        System.assert(ret1);
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

        System.assert(ret2);
    }

    @isTest
    static void testGetObjectNameBasedOnPrefix() {
        // Test with a known object prefix
        String id = '001000000000000';
        String expectedObjectName = 'Account';

        Test.startTest();
            String actualObjectName = CloneListUtil.getObjectNameBasedOnPrefix(id);
        Test.stopTest();
        System.assertEquals(expectedObjectName, actualObjectName);
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
        acc.Name = 'Test Account';
        acc.Account_Status__c = 'in Progress';
        insert acc;
        
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
        Account account = [SELECT Id, Name, Account_Status__c FROM Account Where Name Like 'Test Account'];

        Contact contact = [SELECT Id, FirstName, LastName, AccountId From Contact WHERE AccountId =:account.Id];

        String sourceId = contact.Id;
        String destinationId = account.Id;

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

