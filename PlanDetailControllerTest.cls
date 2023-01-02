/**
 * @description       : 
 * @author            : Zaheer Khan
 * @group             : 
 * @last modified on  : 01-02-2023
 * @last modified by  : Zaheer Khan
**/
@IsTest(SeeAllData = false)
public with sharing class PlanDetailControllerTest {
    @IsTest
    static void testMethodName() {

        //Test Data
        Plan__c p = new Plan__c();
        p.Name = 'test';
        insert p;
        
        PlanDetailController.RecordWrapper RecordWrapperObj = new PlanDetailController.RecordWrapper();

        RecordWrapperObj.data = new List<String>{p.Name};
        RecordWrapperObj.label = new List<String>{'Name'};
        RecordWrapperObj.dataid = new List<String>{p.Id};

        Test.startTest();
            PlanDetailController.RecordWrapper returnRecordWrapperObj = PlanDetailController.PlanTable();
        Test.stopTest();

        System.assertEquals(RecordWrapperObj.dataid, returnRecordWrapperObj.dataid, 'Wrapper dataid should be equal');
        System.assertEquals(RecordWrapperObj.dataid, returnRecordWrapperObj.dataid, 'Wrapper dataid should be equal');
        System.assertEquals(RecordWrapperObj.dataid, returnRecordWrapperObj.dataid, 'Wrapper dataid should be equal');
    }
}
