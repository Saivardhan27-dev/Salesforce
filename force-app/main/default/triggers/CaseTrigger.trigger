trigger CaseTrigger on Case (before insert) {
    
    if(Trigger.isBefore && Trigger.isInsert)
    {
        for(Case caseRecords:Trigger.NEW)
        {
            if(caseRecords.Origin == 'Phone')
            {
                caseRecords.Priority = 'High';
            }
            else
            {
                caseRecords.Priority = 'Low';
            }
        }
    }
    
    if(Trigger.isBefore && Trigger.isDelete)
    {
        CaseTriggerHandler.handleBeforeDelete(Trigger.old);
    }

    if(Trigger.isAfter && Trigger.isInsert){
        CaseTriggerHandler.createFollowUpTaskOrEscalateCase(Trigger.new, Trigger.oldMap);
        CaseTriggerHandler.sendEmailWhenCaseEscalated(Trigger.new, Trigger.oldMap);
    }
}