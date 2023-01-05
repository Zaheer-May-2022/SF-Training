/**
 * @description       : 
 * @author            : Zaheer Khan
 * @group             : 
 * @last modified on  : 01-05-2023
 * @last modified by  : Zaheer Khan
**/

@isTest (SeeAllData = false)
public class ForgotPasswordControllerTest {
  
	@isTest
	static void testForgotPassword() {
        Profile p = [Select Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Username = 'test1@test.com'+math.random(), Email = 'test123user@test.com',
                          Alias='test123', EmailEncodingKey = 'UTF-8', LastName = 'Test', 
                          LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', 
                          TimeZoneSidKey = 'America/Los_Angeles', ProfileId = p.Id, isActive = true);
        insert u;
        
		ForgotPasswordController controller = new ForgotPasswordController();
		controller.username = 'test1@test.com';
       
        PageReference pageRef;
		Test.startTest();
         system.runAs(u){
			pageRef = controller.forgotPassword();
         }
		Test.stopTest();
	
		System.assertNotEquals(null, pageRef, 'Page reference should not be null');
	}
	
}