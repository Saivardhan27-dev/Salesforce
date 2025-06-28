trigger opportunityTrigger on Opportunity (before delete,after update,before update,after delete,after insert) {
    
    if(Trigger.isAfter && Trigger.isDelete)
    {
          OpportunityTriggerHandler.handleActivitiesAfterDelete(Trigger.old);
    }
    
    if(Trigger.isBefore && Trigger.isDelete)
    {
        Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        
        for(opportunity opp : Trigger.old)
        {
            if(System.userInfo.getProfileId() == adminProfile.Id && (opp.StageName == 'Closed Won' || opp.StageName == 'Closed Lost'))
            {
                opp.addError('You do not have sufficient access to delete the closed opportunities');
            }
        }
    }
    
    if(Trigger.isBefore && Trigger.isUpdate)
    {
        OpportunityTriggerHandler.handleActivitiesBeforeUpdate(Trigger.NEW, Trigger.OldMap);
        OpportunityTriggerHandler.checkProductsBefClosedWon(Trigger.new, Trigger.oldMap);
    }
    
    if(Trigger.isAfter && Trigger.isUpdate)
    {
        OpportunityTriggerHandler.handleActivitiesAfterUpdate(Trigger.NEW);
    }

    if(Trigger.isAfter && Trigger.isInsert){
        OpportunityTriggerHandler.insertForecastAfterOppInsert(Trigger.new);
        OpportunityTriggerHandler.setAccTypeHighIfOppGT1lakh(Trigger.new);
        OpportunityTriggerHandler.assignOppToSalesManager(Trigger.new);
    }
}