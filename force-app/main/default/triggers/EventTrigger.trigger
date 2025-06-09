trigger EventTrigger on Event (after update) {
    if(Trigger.isAfter && Trigger.isUpdate){
        EventTriggerHandler.createAuditUponStartDateUpdate(Trigger.new, Trigger.oldMap);
    }
}