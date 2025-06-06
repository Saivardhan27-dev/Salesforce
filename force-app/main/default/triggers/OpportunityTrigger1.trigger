trigger OpportunityTrigger1 on Opportunity (before insert, after insert,before update,after update) {

    if(Trigger.isBefore && Trigger.isInsert)
    {
        OpportunityTrigger1Handler.updateOppDescription(Trigger.new);
        //OpportunityTrigger1Handler.validationOnAmount(Trigger.new);
    }
    
    if(Trigger.isAfter && Trigger.isInsert)
    {
        OpportunityTrigger1Handler.updateLatestAmountOnAcc(Trigger.new);
    }
    
    if(Trigger.isBefore && (Trigger.isUpdate || Trigger.isInsert))
    {
        OpportunityTrigger1Handler.updateDescBasedOnStage(Trigger.new,Trigger.oldMap);
    }
    
    if(Trigger.isAfter && Trigger.isUpdate)
    {
        OpportunityTrigger1Handler.createTask(Trigger.new,Trigger.oldMap);
    }
}