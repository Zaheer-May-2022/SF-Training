/**
 * @description       : 
 * @author            : Zaheer Khan
 * @group             : 
 * @last modified on  : 01-02-2023
 * @last modified by  : Zaheer Khan
**/
@isTest(SeeAllData=false)

public with sharing class PlacesearchTest {
    
    @IsTest
    static void testPlacesearchMethod() {
        
        String url = 'http://demo.example';
        Placesearch ps = new Placesearch();
        Test.startTest();
            ps.recordController();
            String req = ps.httpRequest(url);
        Test.stopTest();

        System.assertEquals(req,null);
    }
}
