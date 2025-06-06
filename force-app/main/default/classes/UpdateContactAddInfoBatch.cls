global class UpdateContactAddInfoBatch implements Database.Batchable<sObject>
{
	global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator('Select Id,BillingStreet,BillingCity,BillingState,BillingPostalCode,(Select Id,MailingStreet,MailingCity,MailingState,MailingPostalCode from Contacts) FROM Account WHERE BillingState=\'TX\'');
    }
    
    global void execute(Database.BatchableContext bc,List<Account> scope)
    {
        Map<Id,Account> accMap = new Map<Id,Account>();
        List<Contact> conList = new List<Contact>();
        for(Account acc:scope)
        {
            accMap.put(acc.Id,acc);
        }
        
        for(Contact con : [SELECT Id,AccountId,MailingStreet,MailingCity,MailingState,MailingPostalCode from Contact WHERE AccountId IN: accMap.keySet()])
        {
            if(accMap.containsKey(con.AccountId))
            {
                con.MailingStreet = accMap.get(con.AccountId).BillingStreet;
                con.MailingCity = accMap.get(con.AccountId).BillingCity;
                con.MailingState = accMap.get(con.AccountId).BillingState;
                con.MailingPostalCode = accMap.get(con.AccountId).BillingPostalCode;
                conList.add(con);
            }
        }
        update conList;
    }
    
    global void finish(Database.BatchableContext bc)
    {
        
    }
}