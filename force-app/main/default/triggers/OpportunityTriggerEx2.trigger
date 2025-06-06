trigger OpportunityTriggerEx2 on Opportunity (after insert, before insert, before update) {

    if(Trigger.isAfter && trigger.isInsert)
    {
        List<Account> accList = new List<Account>();
        for(Opportunity opp : trigger.new)
        {
            if(opp.Amount!=null && opp.AccountId != null)
            {
                Account acc = new Account();
                acc.Recent_Opportunity_Amount__c = opp.Amount;
                acc.Id = opp.AccountId;
                accList.add(acc);
            }
        }
        
        if(!accList.isEmpty())
        {
            update accList;
        }
    }
    
    if(Trigger.isBefore && Trigger.isInsert)
    {
        for(Opportunity opp : Trigger.new)
        {
            if(opp.StageName == 'Closed Won')
                opp.Description = 'Opportunity is Closed Won';
            else if(opp.StageName == 'Closed Lost')
                opp.Description = 'Opportunity is Closed Lost';
            else
                opp.Description = 'Opportunity is Open';
        }
    }
    
    if(Trigger.isBefore && Trigger.isUpdate)
    {
        for(Opportunity opp : Trigger.new)
        {
            if(opp.StageName != Trigger.oldMap.get(opp.Id).StageName)
                if(opp.StageName == 'Closed Won')
                    opp.Description = 'Opportunity is Closed Won';
                else if(opp.StageName == 'Closed Lost')
                    opp.Description = 'Opportunity is Closed Lost';
                else
                    opp.Description = 'Opportunity is Open';
            }
    }
}