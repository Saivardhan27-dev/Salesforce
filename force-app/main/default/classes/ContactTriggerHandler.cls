public class ContactTriggerHandler {
	
    /*public static void handleBeforeInsert(List<Contact> newRecords)
    {
        for(Contact conRecord : newRecords)
        {
            if(conRecord.AccountId == null)
            {
                conRecord.addError('Parent Information is mandatory for contact creation');
            }
        }
    }*/
    
    public static void handleBeforeInsert(List<Contact> newRecords)
    {
        List<Contact> existRecords = [SELECT Id, LastName, Phone, Email FROM Contact LIMIT 50000];
        
        for(Contact con : newRecords)
        {
            for(Contact existCon : existRecords)
            {
                if(con.LastName == existCon.LastName && con.Email == existCon.Email && con.Phone == existCon.Phone)
                {
                    con.addError('Duplicate found!');
                }
            }
        }
    }
    
    public static void handleAfterUpdate(List<Contact> newRecords, Map<Id,Contact> oldMapRecords)
    {
        List<Id> accountIdsToInform = new List<Id>();
        for(Contact con : newRecords)
        {
            if(con.AccountId!=null)
            {
                if(con.Email != oldMapRecords.get(con.Id).Email || con.Phone != oldMapRecords.get(con.Id).Phone)
                {
                    accountIdsToInform.add(con.AccountId);
                }
            }
        }
        
        List<String> emailAddressList = new List<String>();
        List<Account> accountRecords = [SELECT OwnerId, Owner.Email from Account WHERE Id IN:accountIdsToInform];
        for(Account acc : accountRecords)
        {
            emailAddressList.add(acc.Owner.Email);
        }
        
        if(!emailAddressList.isEmpty())
        {
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>();
            for(Id accId : accountIdsToInform)
            {
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.toAddresses = emailAddressList;
                message.optOutPolicy = 'FILTER';
                message.subject = 'Contact email or Phone is changed';
                message.plainTextBody = 'The email or phone information of your child contact has been modified. Please Confirm!!';
                messages.add(message);
            }
            
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        }
        
    }
    
    public static void handleAfterInsert(List<Contact> conList)
    {
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        for(Contact con : conList)
        {
            if(con.Email != null)
            {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new String[] {con.Email});
                email.setSubject('New Contact '+con.Name+' is created..' );
                email.setPlainTextBody('New Contact '+con.Name+' is created!!');
                emailList.add(email);
            }
        }
        
        if(!emailList.isEmpty())
        {
            Messaging.sendEmail(emailList);
        }
    }
    
}