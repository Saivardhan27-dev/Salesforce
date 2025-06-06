trigger OpportunityValidationTrigger on Opportunity (before update) 
{   
    for(Opportunity opp : Trigger.new)
    {
        if(opp.CloseDate < Date.Today())
        {
            opp.addError('Opportunity cannot have closed date in the past');
        }
        
        if(opp.StageName == 'Closed Won' && Trigger.oldMap.get(opp.Id).StageName == 'Prospecting')
        {
            opp.addError('Opportunity cannot transition directly from Prospecting to Closed Won');
        }
        
        if(opp.StageName== 'Closed Won' && opp.Amount < 10000)
        {
            opp.addError('Opportunity in closed stage must have an Amount greater than or equal to 10000');
        }
    }
}