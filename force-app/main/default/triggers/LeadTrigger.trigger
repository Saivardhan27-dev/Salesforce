trigger LeadTrigger on Lead (before update, after insert,before delete) {
    
    if(Trigger.isDelete && Trigger.isBefore)
    {
        LeadTriggerHandler.handleActivitiesBeforeDelete(Trigger.OLD);
    }
    /*
    if(Trigger.isBefore && Trigger.isUpdate)
    {
        for(Lead leadRec : Trigger.NEW)
        {
            leadRec.Status = 'Working-Contacted';
        }
    }
    */
    
    /*if(Trigger.isBefore && Trigger.isUpdate)
    {
        for(Lead leadRec : Trigger.NEW)
        {
            if(leadRec.Industry == 'Healthcare')
            {
                leadRec.LeadSource = 'Purchased List';
                leadRec.SICCode__c = '1100';
                leadRec.Primary__c = 'Yes';
            }
        }
    }*/
    
    if(Trigger.isInsert && Trigger.isAfter)
    {
        LeadTriggerHandler.handleActivitiesAfterInsert(Trigger.new);
    }
    
}