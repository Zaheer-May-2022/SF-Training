/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc Zaheer Khan
 * @group             : 
 * @last modified on  : 01-02-2023
 * @last modified by  : Zaheer Khan
**/
@isTest
public with sharing class Constant_DataLoaderTest {

    @IsTest
    static void testConstant_DataLoaderTest() {
        
        Test.startTest();
            Constant_DataLoader obj = new Constant_DataLoader();
        Test.stopTest();

        Assert.areEqual('Task Migration', Constant_DataLoader.CUSTOM_SETTING, 'It should be Task Migration');
    }
}
