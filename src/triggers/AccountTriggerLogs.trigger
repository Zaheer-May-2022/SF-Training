/*
Purpose : Logs for checking all Context Variables
Created By : Zaheer Khan
Created Date : 27-07-22 
Revision Log : 01
 */



trigger AccountTriggerLogs on Account (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    if(Trigger.isBefore) {
        system.debug('=================== Before Trigger Fired ===============');
        if(Trigger.isInsert) {
            system.debug('New Inserted records ::: Trigger.New ' + Trigger.New);
            system.debug('Old Inserted records ::: Trigger.old ' + Trigger.old);
        }
        if(Trigger.isUpdate) {
            system.debug('Check Update List ::: Trigger.New ' + Trigger.New);
            system.debug('Check Update List ::: Trigger.old ' + Trigger.old);
        }
        if(Trigger.isDelete) {
          System.debug('Deleted records' + Trigger.New);
        }
    }
    
    if(Trigger.isAfter) {
        system.debug('=================== After Trigger Fired ===============');
        if(Trigger.isInsert) {
          system.debug('New Inserted records ::: Trigger.New ' + Trigger.New);
          system.debug('Old Inserted records ::: Trigger.old ' + Trigger.old);
      }
      else if(Trigger.isUpdate) {
          system.debug('New Updated records ::: Trigger.New ' + Trigger.New);
          system.debug('Old Updated records ::: Trigger.old ' + Trigger.old);
      }
      else if (Trigger.isDelete) {
        system.debug('New deleted records ::: Trigger.New ' + Trigger.New);
          system.debug('Old deleted records ::: Trigger.old ' + Trigger.old);
      }
      else if(Trigger.isUndelete) {
        system.debug('New recovered  records ::: Trigger.New ' + Trigger.New);
          system.debug('Old recovered  records ::: Trigger.old ' + Trigger.old);
      }
    }
} // main
