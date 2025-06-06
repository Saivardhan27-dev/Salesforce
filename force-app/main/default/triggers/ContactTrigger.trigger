trigger ContactTrigger on Contact (before insert,after update) {

    if(Trigger.isInsert && Trigger.isBefore)
    {
        ContactTriggerHandler.handleBeforeInsert(Trigger.NEW);       
    }
    
    if(trigger.isAfter && trigger.isUpdate)
    {
        ContactTriggerHandler.handleAfterUpdate(Trigger.new, trigger.oldMap);
    }
    
    if(trigger.isAfter && trigger.isInsert)
    {
        ContactTriggerHandler.handleAfterInsert(Trigger.new);
    }
}