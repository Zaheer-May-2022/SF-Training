/*
Purpose : Trigger for Sending mail to newly created account
Created By : Zaheer Khan
Created Date : 20-07-22 
Revision Log : 01, 02
 */

trigger AccountAssignmentTrigger on Account (before insert, after insert) {
  if(Trigger.isBefore && Trigger.isInsert) {
    AccountTriggerAssignmentHelper.prefixedMessage(Trigger.New);
  }
  else if(Trigger.isAfter && Trigger.isInsert) {
    AccountTriggerAssignmentHelper.emialSender(Trigger.New);
  }
}
