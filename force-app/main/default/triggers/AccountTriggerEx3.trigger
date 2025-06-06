trigger AccountTriggerEx3 on Account (after update) {
    
    List<Account> accList = [SELECT Id, Fax, Phone, (SELECT Id, Fax, Phone from Contacts) from Account where Id IN:Trigger.NewMap.Keyset()];
    
    List<Contact> conListToUpdate = new List<Contact>();
    
    if(!accList.isEmpty())
    {
        for(Account acc: accList)
        {
            if(!acc.contacts.isEmpty())
            {
                for(Contact con : acc.contacts)
                {
                    con.Phone = acc.Phone;
                    con.Fax = acc.Fax;
                    conListToUpdate.add(con);
                }
            }
        }
    }
    
    if(!conListToUpdate.isEmpty())
    {
        update conListToUpdate;
    }

}