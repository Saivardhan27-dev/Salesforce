trigger CandidateTrigger on Candidate__c (after insert,after update) {

    if(Trigger.isInsert)
    {
        if(Trigger.isAfter)
        {
            CandidateTriggerHandler.sendEmail(Trigger.NEW, null);
        }
    }
    
    if(Trigger.isUpdate)
    {
        if(Trigger.isAfter)
        {
            CandidateTriggerHandler.sendEmail(Trigger.NEW,Trigger.oldMap);
        }
    }
}