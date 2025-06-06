public class AccountTriggerHandler1 {
    
    public static void createRelatedOppOrCon(List<Account> accRecords)
    {
        List<Contact> conList = new List<Contact>();
        List<Opportunity> oppList = new List<Opportunity>();
        
        for(Account acc : accRecords)
        {
            if(acc.Create_Contact__c)
            {
                Contact con = new Contact();
                con.LastName = acc.Name;
                con.AccountId = acc.Id;
                conList.add(con);
            }
            
            if(acc.Create_Opportunity__c && acc.Active__c == 'Yes')
            {
                Opportunity opp = new Opportunity();
                opp.Name = acc.Name;
                opp.StageName = 'Prospect';
                opp.CloseDate = System.today()+15;
                opp.AccountId = acc.Id;
                oppList.add(opp);
            }
        }
        
        /*if(!conList.isEmpty())
        	insert conList;
    
        if(!oppList.isEmpty())
            insert oppList;*/
    }   

    public static void updateRatingOnAccount(List<Account> accRecords, Map<Id,Account> oldMapRecords)
    {
        for(Account acc : accRecords)
        {
            if((oldMapRecords == null && acc.Industry != null && acc.Industry == 'Media') 
                || (acc.Industry == 'Media' && (acc.Industry!=oldMapRecords.get(acc.Id).Industry)))
            {
                acc.Rating = 'Hot';
            }
        }
    }
    
    public static void copyBillingToShipping(List<Account> accRecords, Map<Id,Account> oldMapRecords)
    {
        for(Account acc : accRecords)
        {
            if((oldMapRecords == null && acc.Copy_Billing_To_Shipping__c) || 
               (acc.Copy_Billing_To_Shipping__c && acc.Copy_Billing_To_Shipping__c != oldMapRecords.get(acc.Id).Copy_Billing_To_Shipping__c))
            {
                acc.ShippingCity = acc.BillingCity;
                acc.ShippingCountry = acc.BillingCountry;
                acc.ShippingState = acc.BillingState;
                acc.ShippingPostalCode = acc.BillingPostalCode;
                acc.ShippingStreet = acc.BillingStreet;
            }
        }
    }
    
    public static void createRelatedContact(List<Account> accRecords)
    {
        List<Contact> conList = new List<Contact>();
        for(Account acc : accRecords)
        {
            Contact con = new Contact();
            con.FirstName = 'Test';
            con.LastName = 'Con' + acc.Name;
            con.AccountId = acc.Id;
            conList.add(con);
        }
        
        if(!conList.isEmpty())
            insert conList;
    }
    
    public static void createRelatedOpportunity(List<Account> accRecords)
    {
        List<Opportunity> oppList = new List<Opportunity>();
        for(Account acc : accRecords)
        {
            Opportunity opp = new Opportunity();
            opp.Name = 'Opp '+acc.Name;
            opp.StageName = 'Prospect';
            opp.CloseDate = System.today()+15;
            opp.AccountId = acc.Id;
            oppList.add(opp);
        }
        
        //if(!oppList.isEmpty())
            //insert oppList;
    }
    
    public static void updateAccDescWithPhone(List<Account> accRecords, Map<Id, Account> accOldMap)
    {
        for(Account acc : accRecords)
        {
            if(acc.Phone != accOldMap.get(acc.Id).Phone)
            {
                acc.Description = 'Phone is updated! Old value : '+accOldMap.get(acc.Id).Phone + ' and New value : '+acc.Phone;
            }
        }
    }
    
    public static void updateContactsHomePhone(List<Account> accList,Map<id,Account> accOldMap)
    {
        List<Contact> conList = new List<Contact>();
        //Map<Id,Account> accMap = new Map<Id,Account>();
        Set<Id> accIds = new Set<Id>();
        
        for(Account acc : accList)
        {
            if(acc.Phone != null && acc.Phone != accOldMap.get(acc.Id).Phone)
            {
                //accMap.put(acc.Id,acc);
                accIds.add(acc.Id);
            }
        }
        
        //Using Map
        /*if(accMap.size() > 0)
        {
            for(Contact con : [SELECT Id,HomePhone,AccountId FROM Contact WHERE AccountId IN: accMap.Keyset()])
            {
                if(accMap.containsKey(con.AccountId))
                {
                    con.HomePhone = accMap.get(con.AccountId).Phone;
                    conList.add(con);
                }
            }
        }*/
        
        //Using Parent child SOQL
        
        for(Account acc : [SELECT Id,Phone, (SELECT Id, HomePhone FROM Contacts) FROM Account WHERE Id IN: accIds])
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
    
    public static void updateContactsMailingAddress(List<Account> accList, Map<Id,Account> accOldMap)
    {
        //Map<Id,Account> accMap = new Map<id,Account>();
        List<Contact> conList = new List<Contact>();
        Set<Id> accIds = new Set<Id>();
        
        for(Account acc : accList)
        {
            if(acc.BillingCity != accOldMap.get(acc.Id).BillingCity ||
               acc.BillingCountry != accOldMap.get(acc.Id).BillingCountry ||
               acc.BillingPostalCode != accOldMap.get(acc.Id).BillingPostalCode ||
               acc.BillingState != accOldMap.get(acc.Id).BillingState ||
               acc.BillingStreet != accOldMap.get(acc.Id).BillingStreet)
            {
                //accMap.put(acc.Id,acc);
                accIds.add(acc.Id);
            }
        }
        
        //Using Map
        /*for(Contact con : [SELECT Id, AccountId FROM Contact WHERE AccountID IN: accMap.Keyset()])
        {
            if(accMap.containsKey(con.AccountId))
            {
                con.MailingCity = accMap.get(con.AccountId).BillingCity;
                con.MailingCountry = accMap.get(con.AccountId).BillingCountry;
                con.MailingState = accMap.get(con.AccountId).BillingState;
                con.MailingPostalCode = accMap.get(con.AccountId).BillingPostalCode;
                con.MailingStreet = accMap.get(con.AccountId).BillingStreet;
                conList.add(con);
            }
		}*/
        
        //Using Parent Child SOQL
        
        for(Account acc : [SELECT Id, BillingCity, BillingCountry,BillingStreet,BillingState,BillingPostalCode, (SELECT Id FROM Contacts) FROM Account WHERE Id In:accIds])
        {
            if(acc.Contacts != null)
            {
                for(Contact con : acc.Contacts)
                {
                    con.MailingCity = acc.BillingCity;
                    con.MailingCountry = acc.BillingCountry;
                    con.MailingPostalCode = acc.BillingPostalCode;
                    con.MailingState = acc.BillingState;
                    con.MailingStreet = acc.BillingStreet;
                    conList.add(con);
                }
            }
        }
        
        if(!conList.isEmpty())
            update conList;   
    }
    
    public static void updateRelatedOppStage(List<Account> accRecords,Map<Id,Account> oldMapRecords)
    {
        List<Opportunity> oppList = new List<Opportunity>();
        Set<Id> accIds = new Set<Id>();
        
        for(Account acc : accRecords)
        {
            if(acc.Active__c == 'No' && oldMapRecords.get(acc.Id).Active__c == 'Yes')
            {
                accIds.add(acc.Id);
            }
        }
        
        if(!accIds.isEmpty())
        {
            for(Account acc : [SELECT Id,Active__c,(SELECT Id,StageName FROM Opportunities) FROM Account WHERE Id IN: accIds])
            {
                if(acc.Opportunities!=null)
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
        }
        
        if(!oppList.isEmpty())
            update oppList;
    }
    
    public static void preventDeletionOfAcc(List<Account> oldRecords)
    {
        for(Account acc : oldRecords)
        {
            if(acc.Active__c == 'Yes')
            {
                acc.addError(Label.Prevent_Account_Deletion);
            }
        }
    }
    
    public static void preventUpdate(List<Account> accRecords)
    {
        /*for(Account acc : accRecords)
        {
            if(acc.CreatedDate < System.today()-7)
            {
                acc.addError('You cannot update records which are created 7 days back');
            }
        }*/
    }
    
    public static void sendEmailToSysAdmin(List<Account> accRecords)
    {
        List<User> userList = [SELECT Id, Name, Email FROM User WHERE Profile.Name = 'System Administrator'];
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        for(Account acc : accRecords)
        {
            for(User u : userList)
            {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new String[]{u.Email});
                email.setSubject('New Account Created');
                email.setPlainTextBody('New Account has been created'+acc.Name);
                emailList.add(email);
            }
        }
        
        if(!emailList.isEmpty())
        {
            Messaging.sendEmail(emailList);
        }
    }

    public static void updateOppStageToClosed(List<Account> accRecords, Map<Id,Account> oldMapRecords)
    {
        Set<Id> accIds = new Set<Id>();
        for(Account acc : accRecords)
        {
            accIds.add(acc.Id);
        }

        List<Opportunity> oppList = [SELECT Id, StageName, CreatedDate, AccountId FROM Opportunity WHERE AccountId IN :accIds AND CreatedDate <=:Date.today().addDays(-30) and StageName != 'Closed Lost'];
        List<Opportunity> oppListToUpdate = new List<Opportunity>();
        for(Opportunity opp : oppList)
        {
                opp.StageName = 'Closed Lost';
        }

        if(!oppList.isEmpty())
        {
            update oppList;
        }
    }
}