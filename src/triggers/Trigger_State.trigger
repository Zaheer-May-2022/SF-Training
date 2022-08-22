/**
 * Purpose : Create a Automation for counting total states for country
 * Created By : ZAHEER KHAN
 * Created Date : 11-08-2022
 * Revision Logs : V_1.0 - Created By : ZAHEER KHAN - 11-08-2022
 */

trigger Trigger_State on State__c (after insert, after update, after delete) {
  if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate || Trigger.isDelete)) {
    StateTriggerHandler.dataManipulation(Trigger.new, Trigger.new);
    System.debug('State trigger fired::::::::::::::::::::::::::');
  }
}