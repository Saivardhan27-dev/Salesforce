trigger OpportunityTriggerEx1 on Opportunity (before insert) {
    
    for(Opportunity opp : Trigger.new)
    {
        if(opp.Amount != null && opp.Amount>100000)
        {
            opp.Description = 'Hot Opportunity';
        }
    }
}