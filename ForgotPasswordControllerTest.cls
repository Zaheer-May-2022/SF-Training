/**
 * An apex page controller that exposes the site forgot password functionality
 */
// @IsTest public with sharing class ForgotPasswordControllerTest {
//   	 @IsTest(SeeAllData=true) public static void testForgotPasswordController() {
//     	// Instantiate a new controller with all parameters in the page
//     	ForgotPasswordController controller = new ForgotPasswordController();
//     	controller.username = 'test@salesforce.com';  

//     	System.assertEquals(controller.forgotPassword(),null); 
//     }
// }

@isTest (SeeAllData = false)
public class ForgotPasswordControllerTest {
  
	@isTest
	static void testForgotPassword() {
		ForgotPasswordController controller = new ForgotPasswordController();
		controller.username = 'test@example.com';
		
		Test.startTest();
			PageReference pageRef = controller.forgotPassword();
		Test.stopTest();
		
		System.assertNotEquals(null, pageRef, 'Page reference should not be null');
		System.assertEquals('/apex/ForgotPasswordConfirm', pageRef.getUrl(), 'Incorrect page reference');
	}
	
	@isTest
	static void testForgotPassword_InvalidUsername() {
		ForgotPasswordController controller = new ForgotPasswordController();
		controller.username = 'invalid@example.com';
		
		Test.startTest();
			PageReference pageRef = controller.forgotPassword();
		Test.stopTest();
		
		System.assertEquals(null, pageRef, 'Page reference should be null');
	}
}
