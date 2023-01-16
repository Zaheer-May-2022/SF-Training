/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 12-19-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest (seeAllData = false)
public with sharing class SOQLQueryBuilderTestTest {

    @IsTest
    static void testMethodSOQLQueryBuilder() {

        Contact con = new Contact();
        con.id = TestFactory.getFakeId(Contact.SObjectType);
        con.lastName = 'Test';
        Account acc = new Account();
        acc.Id = TestFactory.getFakeId(Account.SObjectType);
        con.AccountId = acc.Id;
        String sObjectName = 'account';
        String fieldSetName = 'lastName';

        String nameField = 'lastName';
        List<String> extraResultFields = new List<String>();
        extraResultFields.add('firstName');
        extraResultFields.add('Phone');
        extraResultFields.add('Email');
        extraResultFields.add('AccountId');

        String conditionalString = 'lastName';

        String objectName = 'Contact';
        List<List<String>> conditions = new List<List<String>>{new List<String> {'lastName','=', 'Test'}};
        List<String> logicalOperators = new List<String>{'='};
        String fieldForSearch = 'lastName'; 
        String searchString = 'Test';

        Integer recordLimit = 10;
        Integer recordOffSet = 10;
        String logicalOperators2 = 'Like';
        String fieldNameToSort = 'lastName'; 
        String sortingDirection = 'ASC';
        
        SOQLQueryBuilderTest sqbt = new SOQLQueryBuilderTest();
        
        Test.startTest();
            SOQLQueryBuilderTest.getInstance();
            sqbt.getFields();
            sqbt.setFieldsUsingFieldSet(fieldSetName, sObjectName);
            sqbt.setFields(nameField, extraResultFields);
            sqbt.getfromSObjectType();
            sqbt.setfromSObjectType(sObjectName);
            sqbt.getWhereClause();
            sqbt.setWhereClauseUsingSingleString(conditionalString);
            sqbt.setWhereClause( objectName, conditions, logicalOperators, fieldForSearch, searchString);
            sqbt.getOrderBy();
            sqbt.setOrderBy('lastName', '');
            sqbt.getRecordLimit();
            sqbt.setRecordLimit(10);
            sqbt.getRecordOffset();
            sqbt.setRecordOffset(10);
            sqbt.toQuery(sObjectName, nameField, conditionalString, fieldNameToSort, sortingDirection, recordLimit,  recordOffSet);
            sqbt.toQuery(sObjectName, nameField, conditions, logicalOperators2, searchString, extraResultFields, fieldNameToSort, sortingDirection, recordLimit, recordOffSet);
        Test.stopTest();
    }
}
