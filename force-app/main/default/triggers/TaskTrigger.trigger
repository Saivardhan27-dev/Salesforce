trigger TaskTrigger on Task (before insert, after insert,before delete) {
    
    //Whenever a task is created set priority to high
    if(Trigger.isBefore && Trigger.isDelete)
    {
        TaskTriggerHandler.preventDeletionOfTask(Trigger.old);
    }
}