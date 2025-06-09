public class OpportunityTriggerHandler {

    public static void handleActivitiesAfterDelete(List<Opportunity> oldRecords){
        Set<Id> accountIds = new Set<Id>();
        for(Opportunity opp : oldRecords){
            accountIds.add(opp.AccountId);
        }
        List<Account> accountRecords = [SELECT Id, OwnerId from Account where Id IN (SELECT AccountId FROM Opportunity WHERE Id IN:accountIds)];
            
        List<Task> taskRecordList = new List<Task>();
        for(Opportunity opp : oldRecords){
            Task taskRecord = new Task();
            taskRecord.Description = 'Please investigate why the opportunity was deleted';
            taskRecord.Priority = 'High';
            taskRecord.OwnerId = opp.Account.OwnerId;
            taskRecord.Status = 'Not Started';
            taskRecord.WhatId = opp.Id;
            taskRecordList.add(taskRecord);
        }
        
        if(!taskRecordList.isEmpty()){
            insert taskRecordList;
        }
    }
    
    /*
    public static void handleActivitiesBeforeUpdate(List<Opportunity> newRecords,List<Opportunity> oldRecords){
        for(Opportunity newOpp : newRecords){
            for(Opportunity oldOpp : oldRecords){
                if(newOpp.Id == oldOpp.Id && newOpp.StageName != oldOpp.StageName){
                    System.debug('Stage has been modified');
                }
            }
        }
    }
	*/
    
    //Optimal solution for above handleActivitiesBeforeUpdate()
    public static void handleActivitiesBeforeUpdate(List<Opportunity> newRecords, Map<Id,Opportunity> oldMap){
		for(Opportunity newOpp : newRecords){
            if(oldMap.get(newOpp.Id).StageName != newOpp.StageName){
                //System.debug('Stage has been modified');
                newOpp.Amount = newOpp.Probability * newOpp.ExpectedRevenue;
            }
        }
    }
    
    public static void handleActivitiesAfterUpdate(List<Opportunity> newRecords){
        List<Id> listOfOppIds = new List<Id>();
        List<OpportunityTeamMember> deleteMemberList = new List<OpportunityTeamMember>();
        
        for(Opportunity opp : newRecords){
            listOfOppIds.add(opp.Id);
        }
        List<OpportunityTeamMember> teamMembers = [SELECT Id, OpportunityId FROM OpportunityTeamMember WHERE OpportunityId IN :listOfOppIds];
        
        for(Opportunity opp : newRecords){
            if(opp.StageName == 'Closed Lost'){
                for(OpportunityTeamMember teamMember : teamMembers){
                    if(teamMember.OpportunityId == opp.Id){
                        deleteMemberList.add(teamMember);
                    }
                }
            }
        }
        
        if(!deleteMemberList.isEmpty()){
            delete deleteMemberList;
        }
    }

    /**********
    * @description
    * This method is used to insert a new Forecast record after an Opportunity is inserted with Amount > 500000, 
    * expected revenue and the quarter in which the Opportunity is expected to close.
    * Also, create a Task for the Account Owner with a description of the new high-value Opportunity.
    **********/
    public static void insertForecastAfterOppInsert(List<Opportunity> oppRecords){
        List<Forecast__c> forecastList = new List<Forecast__c>();
        Set<Id> accountIds = new Set<Id>();
        List<Task> taskList = new List<Task>();
        if(!oppRecords.isEmpty()){
            for(Opportunity opp : oppRecords){
                if(opp.Amount > 500000){
                    Forecast__c forecastRecord = new Forecast__c();
                    forecastRecord.Opportunity__c = opp.Id;
                    forecastRecord.Forecast_Amount__c = opp.Amount;
                    forecastRecord.Forecast_Quarter__c = 'Q' + String.valueOf(Math.ceil(opp.CloseDate.month()/3.0));
                    forecastList.add(forecastRecord);
                }

                if(opp.AccountId != null){
                    accountIds.add(opp.AccountId);
                }
            }
        }

        if(!forecastList.isEmpty()){
            try{
                insert forecastList;
            }catch(DmlException e){
                System.debug('Error inserting forecast records: ' + e.getMessage());
            }
        }

        if(!accountIds.isEmpty()){
            List<Account> accountRecords = [SELECT Id, OwnerId FROM Account WHERE Id IN:accountIds];
            for(Account acc : accountRecords){
                Task taskRecord = new Task();
                taskRecord.Description = 'New high-value opportunity created for account: ' + acc.Name;
                taskRecord.Priority = 'High';
                taskRecord.OwnerId = acc.OwnerId;
                taskRecord.Status = 'Not Started';
                taskRecord.WhatId = acc.Id;
                taskList.add(taskRecord);
            }
        }

        if(!taskList.isEmpty()){
            try{
                insert taskList;
            }catch(DmlException e){
                System.debug('Error inserting task records: ' + e.getMessage());
            }
        }
    }
}