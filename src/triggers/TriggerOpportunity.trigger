/**
 * Purpose : Create a Automation of new instance of Automobile according to details provided on the Opportunity’s Automobile Tag Details 1, Automobile Tag Details 2, Automobile Tag Details 3 and Return To HQ fields.
 * Created By : ZAHEER KHAN
 * Created Date : 30-07-2022
 * Revision Logs : V_1.0 - Created By : ZAHEER KHAN - 30-07-2022
 */

trigger TriggerOpportunity on Opportunity (after insert, after update) {
  // if(Trigger.isAfter && Trigger.isInsert) {
  //   OpportunityTriggerHandler.newAutomationInstance(Trigger.new);
  //   System.debug('============Inserted a record:================== ' + Trigger.new);
  // }
  // else if(Trigger.isAfter && Trigger.isUpdate) {
  //   OpportunityTriggerHandler.updateAutomationInstance(Trigger.oldMap, Trigger.new);
  //   System.debug('============Updated a record: Old record=========' + Trigger.old);
  //   System.debug('============Updated a record: New record=========' + Trigger.new);
  // }

  if(Trigger.isAfter) {
    if(Trigger.isInsert || Trigger.isUpdate) {
      OpportunityTriggerHelper.automobileInstance(Trigger.oldMap, Trigger.new);
      System.debug('============Updated a record: Old record=========' + Trigger.oldMap);
      System.debug('============Updated a record: New record=========' + Trigger.new);
    }
  }
}










// Error
// void OpportunityTriggerHandler.newAutomationInstance(List<Opportunity> oppList)
// Method does not exist or incorrect signature: void newAutoRecord(List<Opportunity>) from the type OpportunityTriggerHandler 