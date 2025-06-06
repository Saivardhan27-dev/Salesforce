trigger AccountContact on Account (after update) {
    
    if(Trigger.isUpdate && Trigger.isAfter)
    {
        List<Id> accountIds = new List<Id>();
        for(Account account : Trigger.new)
        {
            if(account.OwnerId != Trigger.oldMap.get(account.Id).OwnerId)
            {
                accountIds.add(account.Id);
            }
        }
        
        if(accountIds.size() != 0)
        {
            List<Contact> contacts = [SELECT Id, Name FROM Contact WHERE AccountId IN : accountIds];
            for(Contact con : contacts)
            {
                con.OwnerId = Trigger.newMap.get(con.AccountId).OwnerId;
            }
            update contacts; 
        }
    }
}