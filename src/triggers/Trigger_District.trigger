/**
 * Purpose : Create a Automation for counting total district for state
 * Created By : ZAHEER KHAN
 * Created Date : 11-08-2022
 * Revision Logs : V_1.0 - Created By : ZAHEER KHAN - 11-08-2022
 */


trigger Trigger_District on District__c (after insert, after update, after delete) {
  if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate || Trigger.isDelete)) {
    DistrictTriggerHandler.dataManipulation(Trigger.old, Trigger.new);
    System.debug('District Trigger Fired:::::::::::::::::');
  }
}