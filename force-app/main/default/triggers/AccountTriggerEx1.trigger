trigger AccountTriggerEx1 on Account (before insert,before update, before delete,after insert,after update) {
    
    /*for(Account acc : Trigger.NEW)
    {
        if(acc.Industry == 'Banking' || acc.Industry == 'Healthcare')
        {
            acc.Rating = 'Hot';
        }
    }*/
    
    /*if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate))
    {
        for(Account acc: Trigger.new)
        {
            if(acc.Industry == 'Banking')
                acc.AnnualRevenue = 5000000;
            else if(acc.Industry == 'Finance')
                acc.AnnualRevenue = 4000000;
            else if(acc.Industry == 'Insurance')
                acc.AnnualRevenue = 3500000;
            else if(acc.Industry == 'Healthcare')
                acc.AnnualRevenue = 2500000;
            else
                acc.AnnualRevenue = 500000;
        }
    } */
    
    /*if(Trigger.isBefore && Trigger.isDelete)
    {
        for(Account acc: trigger.old)
        {
            if(acc.Active__c == 'yes')
                acc.addError('Active Account cannot be deleted');
        }
    }*/
    
    if(Trigger.isBefore && Trigger.isInsert)
    {
        /*for(Account acc : Trigger.NEW)
        {
            if(acc.Industry != null && acc.Industry == 'Insurance')
            {
                acc.Rating = 'Hot';
            }
        }*/
        
        for(Account acc : Trigger.new)
        {
            if(acc.Copy_Billing_To_Shipping__c  == true)
            {
                acc.ShippingCity = acc.BillingCity;
                acc.ShippingCountry = acc.BillingCountry;
                acc.ShippingPostalCode = acc.BillingPostalCode;
                acc.ShippingState = acc.BillingState;
                acc.ShippingStreet = acc.BillingStreet;
            }
        }
    }
    
    if(Trigger.isAfter && Trigger.isInsert)
    {
        List<Opportunity> oppList = new List<Opportunity>();
        List<Contact> conList = new List<Contact>();
        
        for(Account acc : Trigger.new)
        {
            if(acc.Create_Opportunity__c && acc.Active__c == 'Yes')
            {
                Opportunity opp = new Opportunity();
                opp.Name = acc.Name;
                opp.CloseDate = Date.TODAY() + 30;
                opp.StageName = 'Prospecting';
                opp.Amount = 1000000;
                opp.AccountId = acc.Id;
                oppList.add(opp);
            }
            if(acc.Create_Contact__C)
            {
                Contact con = new Contact();
                con.LastName = acc.Name;
                con.AccountId = acc.Id;
                conList.add(con);
            }
        }
        
        if(!oppList.isEmpty())
            insert oppList;
        
        
        if(!conList.isEmpty())
            insert conList;
        
    }
    
    if(trigger.isBefore && trigger.isUpdate)
    {
        for(Account acc : Trigger.new)
        {
            if(acc.Phone != Trigger.oldMap.get(acc.Id).phone)
            {
                acc.Description = 'Phone is updated! Old value : '+Trigger.oldMap.get(acc.Id).phone+' New value : '+acc.Phone;
            }
        }
    }
    
    if(trigger.isAfter && trigger.isUpdate)
    {
        Map<Id,Account> accMap = new Map<Id,Account>();
        List<Contact> contactsToBeInserted = new List<Contact>();
        
        for(Account acc : Trigger.new)
        {
            if(acc.Phone!= null && acc.Phone!=Trigger.oldMap.get(acc.Id).Phone && Trigger.oldMap!=null)
            {
                accMap.put(acc.Id,acc);
            }
        }
        
        for(Contact con : [SELECT Id, HomePhone, AccountId from Contact where AccountId IN: accMap.KeySet()])
        {
            if(accMap.containsKey(con.AccountId))
            {
                con.HomePhone = accMap.get(con.AccountId).Phone;
                contactsToBeInserted.add(con);
            }
        }
        //System.debug('my'+contactsToBeInserted);
        if(!contactsToBeInserted.isEmpty())
            update contactsToBeInserted;
    }
    
    
    
}