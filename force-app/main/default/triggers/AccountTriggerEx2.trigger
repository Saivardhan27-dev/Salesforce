trigger AccountTriggerEx2 on Account (before delete) {
    
    if(Trigger.isBefore && Trigger.isDelete)
    {
         Set<Id> accountIds = Trigger.oldMap.keySet();
        List<Contact> contactsList = [SELECT Id, AccountId from Contact WHERE AccountId IN: accountIds];
        if(!contactsList.isEmpty())
        {
            for(Contact con : contactsList)
            {
                con.AccountId = null;
            }
        }
        update contactsList;
    }
}