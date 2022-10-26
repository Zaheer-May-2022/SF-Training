trigger TransactionEntryTrigger on Transaction_Entry__c (after insert) {

  if(trigger.isAfter && trigger.isInsert) {
    TransactionEntryTriggerHelper.DebitDataLimit(trigger.new);
  }

}