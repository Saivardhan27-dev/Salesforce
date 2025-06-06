trigger AccountTrigger1 on Account (before insert, after insert, before update,before delete) {

    if(Trigger.isBefore && Trigger.isInsert)
    {
        AccountTriggerHandler1.updateRatingOnAccount(Trigger.new,null);
        
        AccountTriggerHandler1.copyBillingToShipping(Trigger.new, null);
    }
    
    if(Trigger.isAfter && Trigger.isInsert)
    {
        AccountTriggerHandler1.createRelatedContact(Trigger.new);
        
        AccountTriggerHandler1.createRelatedOpportunity(Trigger.new);
        
        AccountTriggerHandler1.createRelatedOppOrCon(Trigger.new);
        
        AccountTriggerHandler1.sendEmailToSysAdmin(Trigger.new);

    }
    
    if(Trigger.isBefore && Trigger.isUpdate)
    {
        AccountTriggerHandler1.updateAccDescWithPhone(Trigger.new,Trigger.oldMap);
        
        AccountTriggerHandler1.copyBillingToShipping(Trigger.new, Trigger.oldMap);
        
        AccountTriggerHandler1.updateRatingOnAccount(Trigger.new,Trigger.oldMap);
        
        AccountTriggerHandler1.preventUpdate(Trigger.new);

    }
    
    if(Trigger.isAfter && Trigger.isUpdate)
    {
        AccountTriggerHandler1.updateContactsHomePhone(Trigger.new,Trigger.oldMap);
        
        AccountTriggerHandler1.updateContactsMailingAddress(Trigger.new,Trigger.oldMap);
        
        AccountTriggerHandler1.updateRelatedOppStage(Trigger.new,Trigger.oldMap);

        AccountTriggerHandler1.updateOppStageToClosed(Trigger.new,Trigger.oldMap);
    }
    
    if(Trigger.isBefore && Trigger.isDelete)
    {
        AccountTriggerHandler1.preventDeletionOfAcc(Trigger.old);
    }
}