public class OpportunityTrigger1Handler {
	
    public static void updateOppDescription(List<Opportunity> oppRecords)
    {
        for(Opportunity opp : oppRecords)
        {
            if(opp.Amount != null && opp.Amount >= 100000 && opp.Amount <= 500000)
            {
                opp.Description = 'Hot Opportunity';
            }
        }
    }
    
    public static void updateLatestAmountOnAcc(List<Opportunity> oppRecords)
    {
        List<Account> accList = new List<Account>();
        for(Opportunity opp : oppRecords)
        {
            if(opp.Amount != null && opp.AccountId != null)
            {
                Account acc = new Account();
                acc.Id = opp.AccountId;
                acc.Recent_Opportunity_Amount__c = opp.Amount;
                accList.add(acc);
            }
        }
        
        if(!accList.isEmpty())
            update accList;
    }
    
    public static void updateDescBasedOnStage(List<Opportunity> oppRecords, Map<Id,Opportunity> oldMapRecords)
    {
        for(Opportunity opp : oppRecords)
        {
            if(oldMapRecords == null || opp.StageName != oldMapRecords.get(opp.Id).StageName)
            {
            	if(opp.StageName == 'Closed Won')
                    opp.Description = 'Opportunity is Closed Won';
                else if(opp.StageName == 'Closed Lost')
                    opp.Description = 'Opportunity is Closed Lost';
                else
                    opp.Description = 'Opportunity is Open';
            }
        }
    }
    
    public static void createTask(List<Opportunity> oppRecords, Map<Id,Opportunity> oldMapRecords)
    {
        List<Task> taskList = new List<Task>();
        for(Opportunity opp : oppRecords)
        {
            if(opp.StageName != oldMapRecords.get(opp.Id).StageName)
            {
                Task tsk = new Task();
                tsk.WhatId = opp.Id;
                tsk.Subject = 'Demo';
                tsk.Priority = 'Normal';
                tsk.Status = 'Not Started';
                tsk.OwnerId = opp.OwnerId; // or UserInfo.getUserId();
                taskList.add(tsk);
            }
        }
        
        if(!taskList.isEmpty())
            insert taskList;
    }
    
    /*public static void validationOnAmount(List<Opportunity> oppRecords)
    {
        for(Opportunity opp : oppRecords)
        {
            if(opp.Amount == null)
            {
                opp.addError('Amount cannot be null');
            }
        }
    }*/
}