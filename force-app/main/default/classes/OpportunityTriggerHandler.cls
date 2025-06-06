public class OpportunityTriggerHandler {

    public static void handleActivitiesAfterDelete(List<Opportunity> oldRecords)
    {
        Set<Id> accountIds = new Set<Id>();
        for(Opportunity opp : oldRecords)
        {
            accountIds.add(opp.AccountId);
        }
        List<Account> accountRecords = [SELECT Id, OwnerId from Account where Id IN (SELECT AccountId FROM Opportunity WHERE Id IN:accountIds)];
            
        List<Task> taskRecordList = new List<Task>();
        for(Opportunity opp : oldRecords)
        {
            Task taskRecord = new Task();
            taskRecord.Description = 'Please investigate why the opportunity was deleted';
            taskRecord.Priority = 'High';
            taskRecord.OwnerId = opp.Account.OwnerId;
            taskRecord.Status = 'Not Started';
            taskRecord.WhatId = opp.Id;
            taskRecordList.add(taskRecord);
        }
        
        if(!taskRecordList.isEmpty())
        {
            insert taskRecordList;
        }
    }
    
    /*
    public static void handleActivitiesBeforeUpdate(List<Opportunity> newRecords,List<Opportunity> oldRecords)
    {
        for(Opportunity newOpp : newRecords)
        {
            for(Opportunity oldOpp : oldRecords)
            {
                if(newOpp.Id == oldOpp.Id && newOpp.StageName != oldOpp.StageName)
                {
                    System.debug('Stage has been modified');
                }
            }
        }
    }
	*/
    
    //Optimal solution for above handleActivitiesBeforeUpdate()
    public static void handleActivitiesBeforeUpdate(List<Opportunity> newRecords, Map<Id,Opportunity> oldMap)
    {
		for(Opportunity newOpp : newRecords)
        {
            if(oldMap.get(newOpp.Id).StageName != newOpp.StageName)
            {
                //System.debug('Stage has been modified');
                newOpp.Amount = newOpp.Probability * newOpp.ExpectedRevenue;
            }
        }
    }
    
    public static void handleActivitiesAfterUpdate(List<Opportunity> newRecords)
    {
        List<Id> listOfOppIds = new List<Id>();
        List<OpportunityTeamMember> deleteMemberList = new List<OpportunityTeamMember>();
        
        for(Opportunity opp : newRecords)
        {
            listOfOppIds.add(opp.Id);
        }
        List<OpportunityTeamMember> teamMembers = [SELECT Id, OpportunityId FROM OpportunityTeamMember WHERE OpportunityId IN :listOfOppIds];
        
        for(Opportunity opp : newRecords)
        {
            if(opp.StageName == 'Closed Lost')
            {
                for(OpportunityTeamMember teamMember : teamMembers)
                {
                    if(teamMember.OpportunityId == opp.Id)
                    {
                        deleteMemberList.add(teamMember);
                    }
                }
            }
        }
        
        if(!deleteMemberList.isEmpty())
        {
            delete deleteMemberList;
        }
    }
}