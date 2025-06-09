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
    }
    
    
    /*if(Trigger.isAfter && Trigger.isUpdate)
    {
        List<Opportunity> opps = [SELECT Id, Name, OwnerId, StageName, Owner.Email, Account.OwnerId, Account.Owner.Email FROM Opportunity WHERE Id
                                  IN: Trigger.newMap.keySet() AND StageName = 'Closed Won'];
        
        if(!opps.isEmpty())
        {
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            
            for(Opportunity opp : opps)
            {
                Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
                
                if(opp.OwnerId == opp.Account.OwnerId)
                {
                    emailMessage.setToAddresses(new List<String>{opp.Owner.Email});
                }
                else
                {
                    emailMessage.setToAddresses(new List<String>{opp.Owner.Email, opp.Account.Owner.Email});
                }
                
                emailMessage.setSubject('Opportunity -- Closed');
                emailMessage.setPlainTextBody('Below opportunity with Opportunity Id and Name is now closed won\n'+
                                              'Opportunity Id :'+opp.Id+' Opportunity Name :'+opp.Name);
                
                mails.add(emailMessage);
            }
            
            Messaging.sendEmail(mails);
        }
    }*/
    if(Trigger.isAfter && Trigger.isUpdate)
    {
        OpportunityTriggerHandler.handleActivitiesAfterUpdate(Trigger.NEW);
    }

    if(Trigger.isAfter && Trigger.isInsert){
        OpportunityTriggerHandler.insertForecastAfterOppInsert(Trigger.new);
    }
}