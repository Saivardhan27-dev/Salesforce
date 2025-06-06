trigger AccountTriggerEx4 on Account (after update) {
    
    if(Trigger.isAfter && Trigger.isUpdate)
    {
        Set<Id> accountIdsSet = new Set<Id>();
        List<Contact> conList = new List<Contact>();
        
        for(Account acc : Trigger.new)
        {
            if(acc.Phone != null && acc.Phone != Trigger.oldMap.get(acc.Id).phone)
            {
                accountIdsSet.add(acc.Id);
            }
        }
        
        for(Account acc : [SELECT Id, Phone, (select Id, HomePhone from Contacts) from Account where Id IN: accountIdsSet])
        {
            if(acc.Contacts!=null)
            {
                for(Contact con : acc.Contacts)
                {
                    con.HomePhone = acc.Phone;
                    conList.add(con);
                }
            }
        }
        
        if(!conList.isEmpty())
            update conList;
    }
}