public class AccountTriggerHandler {
	
    public static void handleAfterInsertActivities(List<Account> newRecords, Map<Id,Account> oldMapRecords)
    {
    	/*List<Contact> conList = new List<Contact>();
        for(Account acc: newRecords)
        {
            if(acc.Create_N_Contacts__c!=null)
            {
                for(Integer i=0;i<acc.Create_N_Contacts__c;i++)
                {
                    Contact con = new Contact();
                    con.LastName = acc.Name + i;
                    con.AccountId = acc.Id;
                    conList.add(con);
                }
            }
        }
        
        if(!conList.isEmpty())
        {
            insert conList;
        }*/
        
        
    }
    
    public static void handleBeforeUpdateActivities(List<Account> newRecords, Map<Id,Account> oldMap)
    {
        /*for(Account accRecord : newRecords)
        {
            if(accRecord.Industry == 'Agriculture' && accRecord.Type == 'Prospect')
            {
  				if(oldMap.get(accRecord.Id).Ownership != accRecord.Ownership && accRecord.Ownership == 'Private')
                {
                    accRecord.addError('Ownership cannot be modified');
                }
            }
        }*/
    }
    
    public static void handleAfterUpdateActivities(List<Account> newRecords, Map<Id,Account> oldMapRecords)
    {
        /*Map<Id,String> accToWebsiteMap = new Map<Id,String>();
        List<Id> addAccIdList = new List<Id>();
        
        for(Account acc : newRecords)
        {
            if(acc.Website != oldMap.get(acc.Id).Website)
            {
                accToWebsiteMap.put(acc.Id,acc.Website);
                addAccIdList.add(acc.Id);
            }
        }
        
        if(accToWebsiteMap.keySet().size() > 0)
        {
            List<Contact> addConToUpdate = new List<Contact>();
            List<Contact> conRecords = [SELECT Id, FirstName, AccountId FROM Contact WHERE AccountId IN: addAccIdList];
            for(Contact con : conRecords)
            {
                con.Website__c = accToWebsiteMap.get(con.AccountId);
                addConToUpdate.add(con);
            }
            
            if(addConToUpdate.size() > 0)
            {
                update addConToUpdate;
            }
        }*/
    
        
        /*List<Id> accIds = new List<Id>();
        for(Account acc : newRecords)
        {
            if(acc.Industry != oldMapRecords.get(acc.Id).Industry && acc.Industry == 'Biotechnology')
            {
                accIds.add(acc.Id);
            }
        }
        
        if(!accIds.isEmpty())
        {
            callAsynchApex(accIds);
        }
        
    }*/
        
            Set<Id> accList = new Set<Id>();
            for(Account acc: newRecords)
            {
                if(acc.BillingCountry != oldMapRecords.get(acc.Id).BillingCountry)
                {
                    accList.add(acc.Id);
                }
            }
            
            List<Contact> contactList = new List<Contact>();
            List<Account> accConList = [SELECT Id, BillingCountry, (SELECT Id, MailingCountry from Contacts) from Account where Id In: accList];
            for(Account acc : accConList)
            {
                if(acc.Contacts!=null)
                {
                    for(Contact con : acc.Contacts)
                    {
                        con.MailingCountry =acc.BillingCountry;
                        contactList.add(con);
                    }
                }
            }
            
            if(!contactList.isEmpty())
                update contactList;
    }
    
    @future
    public static void callAsynchApex(List<Id> accountIds)
    {
        List<Contact> updateContactList = new List<Contact>();
        List<Contact> conList = [SELECT Id, LeadSource FROM Contact WHERE AccountId IN: accountIds];
        for(Contact con : conList)
        {
            con.LeadSource = 'Web';
            updateContactList.add(con);
        }
        
        if(!updateContactList.isEmpty())
            update updateContactList;
    }

}