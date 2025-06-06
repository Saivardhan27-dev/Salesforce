trigger contactMailingCity on Account (after update) {
    
    if(Trigger.isAfter && Trigger.isUpdate)
    {
        Set<Id> accountIds = new Set<Id>();
        
        for(Account acc : Trigger.new)
        {
            if(acc.BillingCity != Trigger.oldMap.get(acc.Id).BillingCity) 
            {
                accountIds.add(acc.Id);
            }
        }
        
        List<Contact> listOfContacts = [SELECT Id, MailingCity, AccountId FROM Contact WHERE AccountId IN: accountIds];
        
        for(Contact contact : listOfContacts)
        {
            contact.MailingCity = Trigger.newMap.get(contact.AccountId).BillingCity;
        }
        
        if(!listOfContacts.isEmpty())
        {
            insert listOfContacts;
        }
        
    }
}