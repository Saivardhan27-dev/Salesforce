trigger OpportunityTriggerEx3 on Opportunity (after update, before update, before delete) {
    
    /*if(Trigger.isAfter && Trigger.isUpdate)
    {
        List<Task> taskList = new List<Task>();
        for(Opportunity opp : Trigger.new)
        {
            if(opp.StageName != Trigger.oldMap.get(opp.Id).StageName)
            {
                Task task1 = new Task();
                task1.Status = 'Not Started';
                task1.Subject = 'Call';
                task1.Priority = 'High';
                task1.WhatId = opp.Id;
                task1.OwnerId = UserInfo.getUserId();
                taskList.add(task1);
            }
        }
        
        if(!taskList.isEmpty())
            insert taskList;
    }*/
    
    /*if(Trigger.isUpdate && Trigger.isBefore)
    {
        for(Opportunity opp : Trigger.new)
        {
            if(opp.StageName == 'Closed Lost' && opp.StageName != trigger.oldMap.get(opp.Id).StageName && opp.Closed_Lost_Reason__c == Null)
            {
                opp.addError('Reason is mandatory to update Stage Name as closed lost');
            }
        }
    }*/
    
    if(trigger.isDelete && trigger.isBefore)
    {
        Profile p = [SELECT Id, Name from Profile where Name = 'System Administrator'];
        for(Opportunity opp : trigger.old)
        {
            if(opp.StageName == 'Closed Lost' || opp.StageName == 'Closed Won')
            {
                if(userInfo.getProfileId() != p.Id)
                {
                    opp.addError('You dont have permission to delete closed opportunities, please contact System Administrator');
                }
            }
        }
    }
}