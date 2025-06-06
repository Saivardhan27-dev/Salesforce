trigger AccountTriggerEx6 on Account (before update, before delete, before insert,after undelete) {

    if(Trigger.isBefore && Trigger.isUpdate)
    {
        for(Account acc : Trigger.new)
        {
            if(acc.CreatedDate < System.TODAY() - 6)
            {
                acc.addError('You dont have permission to update records which are created more than a week ago');
            }
        }
    }
    
    /*if(trigger.isBefore && trigger.isDelete)
    {
        Profile p = [SELECT Id, Name from Profile WHERE Name = 'System Administrator'];
        for(Account acc : Trigger.old)
        {
            if(UserInfo.getProfileId() != p.Id)
            {
                acc.addError('You dont have permission to delete an Account, please contact System Administrator');
            }
        }
    }*/
    
    if(Trigger.isBefore && Trigger.isDelete)
    {
        Set<Id> accIds = new Set<Id>();
        for(Account acc : trigger.old)
        {
            accIds.add(acc.Id);
        }
        
        for(Account acc : [SELECT Id, (Select Id from Opportunities) from Account where Id IN: accIds])
        {
            if(acc.Opportunities.size()>0)
            {
                acc.addError('You cannot delete Account when there are related opportunities');
            }
        }
    }
    
    if(trigger.isBefore && trigger.isInsert)
    {
        for(Account acc : trigger.new)
        {
            if(acc.OwnerId != null && acc.Sales_rep__c == null)
            {
                User owner = [SELECT Name from User where Id = :acc.OwnerId LIMIT 1];
                acc.Sales_rep__c = owner.Name;
            }
        }
    }
    
    if(trigger.isAfter && trigger.isUndelete)
    {
        List<Id> accIds = new List<Id>();
        List<Account> accList = new List<Account>();
        for(Account acc : trigger.new)
        {
            accIds.add(acc.Id);
        }
        
        List<Account> accountsToUpdate = [SELECT Id, Name from Account WHERE Id IN: accIds];
        
        for(Account acc:accountsToUpdate)
        {
            acc.Name = 'Restored '+acc.Name;
            accList.add(acc);
        }
        
        if(!accList.isEmpty())
            update accList;
        
    }
}