trigger Trigger_Country on Country__c (after insert, after update, after delete) {
  if(Trigger.isAfter && Trigger.isInsert && Trigger.isUpdate && Trigger.isDelete) {
    CountryTriggerHandler.dataManipulation(Trigger.oldMap, Trigger.new);
  }
}