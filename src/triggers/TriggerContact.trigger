trigger TriggerContact on Contact (before insert) {
  if(Trigger.isBefore && Trigger.isInsert) {
    ContactTriggerHandler.syncData(Trigger.new);
  }
}