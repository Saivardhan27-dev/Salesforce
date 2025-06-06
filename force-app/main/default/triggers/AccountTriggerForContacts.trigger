trigger AccountTriggerForContacts on Account (after insert) {
    
    if(Trigger.isAfter && Trigger.isInsert)
    {
        System.enqueueJob(new CreateContactQueueable(Trigger.NEW));
    }
    
}