/**
 * @description       : 
 * @author            : Zaheer Khan
 * @group             : 
 * @last modified on  : 01-12-2023
 * @last modified by  : Zaheer Khan
**/
@isTest (SeeAllData = false)
public with sharing class ChildRelationshipTest {

    @IsTest
    static void testChildRelationship() {
        
        ChildRelationship childRelInstance = new ChildRelationship();
        
        Boolean selected = true;
        String objectName = 'test';
        String relationshipName = 'tests';
        String fieldName = 'testField';
        Boolean masterDetail = false;
        Integer recordAmount = 0;

        Test.startTest();
            childRelInstance.setSelected(selected);
            Boolean retSel = childRelInstance.getSelected();

            childRelInstance.setObjectName(objectName);
            String retObjName = childRelInstance.getObjectName();

            childRelInstance.setRelationshipName(relationshipName);
            String retRelationshipName = childRelInstance.getRelationshipName();

            childRelInstance.setMasterDetail(masterDetail);
            Boolean retMasterDetail = childRelInstance.getMasterDetail();

            childRelInstance.setFieldName(fieldName);
            String retFieldName = childRelInstance.getFieldName();

            childRelInstance.setRecordAmount(recordAmount);
            Integer retRecordAmount = childRelInstance.getRecordAmount();
        Test.stopTest();

        System.assertEquals(selected, retSel, 'It should be ' + selected);
        System.assertEquals(objectName, retObjName, 'It should be ' + objectName);
        System.assertEquals(relationshipName, retRelationshipName, 'It should be ' + relationshipName);
        System.assertEquals(masterDetail, retMasterDetail, 'It should be ' + masterDetail);
        System.assertEquals(fieldName, retFieldName, 'It should be' + fieldName);
        System.assertEquals(recordAmount, retRecordAmount, 'It should be ' + recordAmount);
    }
}
