/**
 * @description       : 
 * @author            : Zaheer Khan
 * @group             : 
 * @last modified on  : 01-17-2023
 * @last modified by  : Zaheer Khan
**/
@isTest (seeAllData = false)
public with sharing class SOQLQueryBuilderTestTest {

    @IsTest
    static void testMethodSOQLQueryBuilder() {

        //Test Data
        List<Account> accList = TestFactory.createAccountList(10, false);
        for (Account acc : accList) {
            acc.Id = TestFactory.getFakeId(Account.SObjectType);
        }
        
        accList[0].Name = 'TestAccount';

        String sObjectName = 'Account';
        String fieldSetName = 'Name';

        String nameField = 'Name';
        List<String> extraResultFields = new List<String>();
        extraResultFields.add('AccountNumber');
        extraResultFields.add('Phone');
        extraResultFields.add('Email');
        extraResultFields.add('Account_Status__c');

        String conditionalString = 'AccountNumber';

        String objectName = 'Account';
        List<List<String>> conditions = new List<List<String>>{new List<String> {'Name','=', 'Test'}};
        List<String> logicalOperators = new List<String>{'='};
        String fieldForSearch = 'AccountNumber'; 
        String searchString = 'TestAccount';

        Integer recordLimit = 10;
        Integer recordOffSet = 10;
        String logicalOperators2 = 'Like';
        String fieldNameToSort = 'AccountNumber'; 
        String sortingDirection = 'ASC';
        
        SOQLQueryBuilderTest soqlQueBuilderIns = new SOQLQueryBuilderTest();
        
        Test.startTest();
            SOQLQueryBuilderTest.getInstance();
            soqlQueBuilderIns.getFields();
            soqlQueBuilderIns.setFieldsUsingFieldSet(fieldSetName, sObjectName);
            soqlQueBuilderIns.setFields(nameField, extraResultFields);
            soqlQueBuilderIns.setFields(nameField, null);
            soqlQueBuilderIns.getfromSObjectType();
            soqlQueBuilderIns.setfromSObjectType(sObjectName);
            soqlQueBuilderIns.getWhereClause();
            soqlQueBuilderIns.setWhereClauseUsingSingleString(conditionalString);
            soqlQueBuilderIns.setWhereClause( objectName, conditions, logicalOperators, fieldForSearch, searchString);
            soqlQueBuilderIns.getOrderBy();
            soqlQueBuilderIns.setOrderBy('lastName', '');
            soqlQueBuilderIns.getRecordLimit();
            soqlQueBuilderIns.setRecordLimit(10);
            soqlQueBuilderIns.getRecordOffset();
            soqlQueBuilderIns.setRecordOffset(10);
            soqlQueBuilderIns.toQuery(sObjectName, nameField, conditionalString, fieldNameToSort, sortingDirection, recordLimit,  recordOffSet);
            soqlQueBuilderIns.toQuery(sObjectName, nameField, conditions, logicalOperators2, searchString, extraResultFields, fieldNameToSort, sortingDirection, recordLimit, recordOffSet);
        Test.stopTest();
    }
}
