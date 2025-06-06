trigger StudentTrigger on Student__c (after insert,after delete,after update) {
    
    if(trigger.isInsert && trigger.isAfter)
    {
        StudentTriggerHandler.updateStudentCountOnClass(Trigger.new);
    }
    
    if(trigger.isDelete && trigger.isAfter)
    {
        StudentTriggerHandler.afterStudentDeletion(Trigger.old);
    }
    
    if(trigger.isUpdate && trigger.isAfter)
    {
        StudentTriggerHandler.afterStudentUpdation(Trigger.new,Trigger.oldMap);
    }
}