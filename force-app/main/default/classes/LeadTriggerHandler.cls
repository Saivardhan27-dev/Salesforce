public class LeadTriggerHandler {
    
    public static void handleActivitiesBeforeDelete(List<Lead> leadRecords)
    {
        for(Lead leads : leadRecords)
        {
            if(leads.Status == 'Working-Contacted')
            {
                leads.addError('You cannot delete a Lead in progress');
            }
        }
    }
	
    public static void handleActivitiesAfterInsert(List<Lead> leadRecords)
    {
        List<Task> taskListToInsert = new List<Task>();
        for(Lead leadrec : leadRecords)
        {
            Task taskRecord = new Task();
            taskRecord.Priority = 'High';
            taskRecord.OwnerId = leadrec.OwnerId;
            taskRecord.Description = 'This task is created on lead after trigger';
            taskRecord.Status = 'Not Started';
            taskRecord.Subject = 'Follow Up';
            taskRecord.WhoId = leadrec.Id;
            taskListToInsert.add(taskRecord);
        }
        
        if(!taskListToInsert.isEmpty())
        {
            insert taskListToInsert;
        }
    }
    
    public static void LogChangesOnLeadUpdate(List<Lead> leadRecords, Map<Id, Lead> oldMap){
        List<Change_Log__c> logsToInsert = new List<Change_Log__c>();
        if(!leadRecords.isEmpty()){
            for(Lead leadRec : leadRecords){
                if(leadRec.Status != oldMap.get(leadRec.Id).Status){
                    Change_Log__c changeLog = new Change_Log__c();
                    changeLog.Which_Object__c = 'Lead';
                    changeLog.RecordId__c = leadRec.Id;
                    changeLog.Field_Changed__c = 'Status';
                    changeLog.Old_Value__c = oldMap.get(leadRec.Id).Status;
                    changeLog.New_Value__c = leadRec.Status;
                    logsToInsert.add(changeLog);
                }
            }
        }

        if(!logsToInsert.isEmpty()){
            insert logsToInsert;
        }
    }
}