trigger AccountTriggerEx5 on Account (after update) {
    
    /*if(Trigger.isAfter && Trigger.isUpdate)
    {
        Map<Id,Account> accMap = new Map<Id,Account>();
        List<Contact> conList = new List<Contact>();
        
        for(Account acc : Trigger.new)
        {
            if((acc.BillingStreet != Trigger.oldMap.get(acc.Id).BillingStreet) || 
               (acc.BillingCity != Trigger.oldMap.get(acc.Id).BillingCity) ||
               (acc.BillingState != Trigger.oldMap.get(acc.Id).BillingState) ||
               (acc.BillingCountry != Trigger.oldMap.get(acc.Id).BillingCountry) ||
               (acc.BillingPostalCode != Trigger.oldMap.get(acc.Id).BillingPostalCode))
            {
                accMap.put(acc.Id,acc);
            }
        }
        
        for(Contact con : [select id,AccountId from Contact where AccountId IN:accMap.Keyset()])
        {
            if(accMap.containsKey(con.AccountId))
            {
                con.MailingCity = accMap.get(con.AccountId).BillingCity;
                con.MailingStreet = accMap.get(con.AccountId).BillingStreet;
                con.MailingState = accMap.get(con.AccountId).BillingState;
                con.MailingCountry = accMap.get(con.AccountId).BillingCountry;
                con.MailingPostalCode = accMap.get(con.AccountId).BillingPostalCode;
                conList.add(con);
            }
        }
        
        if(!conList.isEmpty())
            update conList;
    }*/
    
    
    /*if(Trigger.isAfter && Trigger.isUpdate)
    {
        
        Set<Id> accIdsSet = new Set<Id>();
        List<Contact> conList = new List<Contact>();
        
        for(Account acc : Trigger.new)
        {
            if((acc.BillingStreet != Trigger.oldMap.get(acc.Id).BillingStreet) || 
               (acc.BillingCity != Trigger.oldMap.get(acc.Id).BillingCity) ||
               (acc.BillingState != Trigger.oldMap.get(acc.Id).BillingState) ||
               (acc.BillingCountry != Trigger.oldMap.get(acc.Id).BillingCountry) ||
               (acc.BillingPostalCode != Trigger.oldMap.get(acc.Id).BillingPostalCode)
              )
            {
                accIdsSet.add(acc.Id);
            }
        }
        
        List<Account> accList = [SELECT Id, BillingStreet,BillingCity,BillingState,BillingCountry,BillingPostalCode, (select Id from Contacts) from Account Where Id IN: accIdsSet];
        for(Account acc : accList)
        {
            if(acc.Contacts != null)
            {
                for(Contact con : acc.Contacts)
                {
                    con.MailingStreet = acc.BillingStreet;
                    con.MailingCity = acc.BillingCity;
                    con.MailingState = acc.BillingState;
                    con.MailingCountry = acc.BillingCountry;
                    con.MailingPostalCode = acc.BillingPostalCode;
                    conList.add(con);
                }
            }
        }
        
        if(!conList.isEmpty())
            update conList;
    }*/
    
    /*if(Trigger.isAfter && Trigger.isUpdate)
    {
        Set<Id> accountIds = new Set<Id>();
        List<Opportunity> oppList = new List<Opportunity>();
        for(Account acc : trigger.new)
        {
            if(acc.Active__c == 'No' && acc.Active__c != Trigger.oldMap.get(acc.Id).Active__c)
            {
                accountIds.add(acc.Id);
            }
        }
        
        List<Account> accList = [SELECT Id, Active__c,(select Id, StageName from Opportunities) from Account where ID IN: accountIds];
        for(Account acc : accList)
        {
            if(acc.Opportunities != null)
            {
                for(Opportunity opp : acc.Opportunities)
                {
                    if(opp.StageName != 'Closed Won' && opp.StageName != 'Closed Lost')
                    {
                        opp.StageName = 'Closed Lost';
                        oppList.add(opp);
                    }
                }
            }
        }
        
        if(!oppList.isEmpty())
            update oppList;
    }*/
    
    if(trigger.isAfter && trigger.isUpdate)
    {
        Map<Id,Account> accMap = new Map<Id,Account>();
        List<Opportunity> oppListToUpdate = new List<Opportunity>();
        
        for(Account acc : Trigger.new)
        {
            if(acc.Active__c == 'No' && acc.Active__c != trigger.oldMap.get(acc.Id).Active__c)
            {
                accMap.put(acc.Id, acc);
            }
        }
        
        List<Opportunity> oppList = [SELECT Id, StageName, AccountId from Opportunity where AccountId IN: accMap.Keyset()];
        for(Opportunity opp : oppList)
        {
            if(accMap.containsKey(opp.AccountId) && opp.StageName != 'Closed Won' && opp.StageName != 'Closed Lost')
            {
                opp.StageName = 'Closed Lost';
                oppListToUpdate.add(opp);
            }
        }
        
        if(!oppListToUpdate.isEmpty())
            update oppListToUpdate;
    }
}