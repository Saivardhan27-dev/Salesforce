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
    
}