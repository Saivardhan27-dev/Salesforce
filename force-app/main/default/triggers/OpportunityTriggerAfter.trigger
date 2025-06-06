trigger OpportunityTriggerAfter on Opportunity (after Update) {
    
    if(Trigger.isAfter && Trigger.isUpdate)
    {
        List<Task> taskListToInsert = new List<Task>();
        for(Opportunity opp:Trigger.new)
        {
            if(opp.StageName == 'Closed Won')
            {
                Task taskRecord = new Task();
                taskRecord.Priority = 'High';
                taskRecord.OwnerId = opp.OwnerId;
                taskRecord.Description = 'Task is created for practicing apex triggers';
                taskRecord.Status = 'Not Started';
                taskRecord.WhatId = opp.Id;
                taskListToInsert.add(taskRecord);
            }
        }
        
        if(!taskListToInsert.isEmpty())
        {
            insert taskListToInsert;
        }
    }
    
}