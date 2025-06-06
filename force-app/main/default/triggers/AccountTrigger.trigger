trigger AccountTrigger on Account (before insert, after insert, before update,after update, before delete, after delete, after undelete) {
    
    
    if(trigger.isAfter && trigger.isUndelete)
    {
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        for(Account accNew: Trigger.New)
        {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> emailAddress = new List<String>();
            emailAddress.add(Userinfo.getUserEmail());
            mail.setToAddresses(emailAddress);
            mail.setSubject('Account has been restored successfully '+accNew.Name);
            mail.setPlainTextBody('Hello');
            mails.add(mail);
        }
        Messaging.sendEmail(mails);
    }
    
    
    if(trigger.isAfter && trigger.isDelete)
    {
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        for(Account accOld: Trigger.Old)
        {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> emailAddress = new List<String>();
            emailAddress.add(Userinfo.getUserEmail());
            mail.setToAddresses(emailAddress);
            mail.setSubject('Account has been deleted successfully '+accOld.Name);
            mail.setPlainTextBody('Hello');
            mails.add(mail);
        }
        Messaging.sendEmail(mails);
    }
    
    
    if(trigger.isBefore && trigger.isDelete)
    {
        for(Account accOld : Trigger.old)
        {
            if(accOld.Active__c == 'Yes')
                accOld.addError('You cannot delete active account');
        }
    }
    
    
    if(trigger.isAfter && trigger.isUpdate)
    {
        
        AccountTriggerHandler.handleAfterUpdateActivities(Trigger.NEW, Trigger.oldMap);
        
        /*Set<Id> accIdsWhichGotBillingAddressChanged = new Set<Id>();
        for(Account accNew : Trigger.new)
        {
            Account accOld = trigger.oldMap.get(accNew.id);
            if(accNew.BillingStreet != accOld.BillingStreet)
            {
                accIdsWhichGotBillingAddressChanged.add(accNew.Id);
            }
        }
        
        List<Account> accsWithContacts = [SELECT id, name, billingcity, billingstreet, billingstate, billingcountry, (SELECT id,name from Contacts) from Account where ID IN: accIdsWhichGotBillingAddressChanged];
        List<Contact> contsListToUpdate = new List<Contact>();
        
        for(Account acc : accsWithContacts)
        {
            List<Contact> consOfTheLoopedAccount = acc.contacts;
            for(Contact con: consOfTheLoopedAccount)
            {
                con.MailingStreet = acc.BillingStreet;
                con.MailingCity = acc.BillingCity;
                con.MailingState = acc.BillingState;
                con.MailingCountry = acc.BillingCountry;
                contsListToUpdate.add(con);
            }
        }
        
        if(contsListToUpdate.size() > 0)
            update contsListToUpdate;
    }
    */
    }
    
    if(trigger.isBefore && trigger.isUpdate)
    {   
        /*for(Account accNew : trigger.new)
        {
            Account accOld = Trigger.oldMap.get(accNew.id);
            if(accNew.Name != accOld.Name)
            {
                accNew.addError('Account Name cannot be modified/changed once it is created');
            }
        }*/
        AccountTriggerHandler.handleBeforeUpdateActivities(Trigger.NEW, Trigger.oldMap);
        
    }
    
    
    if(trigger.isAfter && trigger.isInsert)
    {
        /*List<Contact> conListToInsert = new List<Contact>();
        for(Account acc : Trigger.new)
        {
            Contact con = new Contact();
            con.LastName = acc.Name;
            con.AccountId = acc.Id;
            conListToInsert.add(con);
        }
        
        if(conListToInsert.size() > 0)
            insert conListToInsert;*/
        
        AccountTriggerHandler.handleAfterInsertActivities(Trigger.NEW,Trigger.oldMap);
    }


    if(trigger.isBefore && trigger.isInsert)
    {
        for(Account acc : Trigger.new)
        {
            //Scenario 2 :
            if(acc.AnnualRevenue < 1000)
                acc.addError('Annual Revenue cannot be less than 1000');
            //Scenario 1 : Prepopulate Shipping address with billing address if shipping address if empty
            if(acc.ShippingCity == null)
                acc.ShippingCity = acc.BillingCity;
            if(acc.ShippingCountry == null)
                acc.ShippingCountry = acc.BillingCountry;
            if(acc.ShippingState == null)
                acc.ShippingState = acc.BillingState;
            if(acc.ShippingStreet == null)
                acc.ShippingStreet = acc.BillingStreet;
            if(acc.ShippingPostalCode == null)
                acc.ShippingPostalCode = acc.BillingPostalCode;
        }
    }
    
}