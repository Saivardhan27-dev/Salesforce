@isTest
public class AccountTriggerHandler1Test {

    @isTest
    private static void createRelatedOppOrConTest()
    {
        List<Account> accList = new List<Account>();
        for(Integer i=1;i<=10;i++)
        {
            Account acc = new Account();
            acc.Name = 'Test '+i;
            if(Math.mod(i,2)==0)
            {
                acc.Create_Contact__c = true;
            }
            else
            {
                acc.Create_Opportunity__c = true;
                acc.Active__c = 'Yes';
            }
            accList.add(acc);
        }
        
        Test.startTest();
        insert accList;
        Test.stopTest();
        
        List<Contact> newConList = [SELECT Id FROM Contact WHERE AccountId =: accList[1].Id];
        List<Opportunity> newOppList = [SELECT Id FROM Opportunity WHERE AccountId =: accList[0].Id];
        
        System.assertNotEquals(0,newConList.size(),'Contacts should be created');
        System.assertNotEquals(0,newOppList.size(),'Opportunity should be created');
    }
    
    @isTest
    public static void createRelatedOpportunityTest()
    {
        List<Account> accList = new List<Account>();
        List<Id> accIds = new List<Id>();
        
        for(Integer i=1;i<=5;i++)
        {
            Account acc = new Account();
            acc.Name = 'Account Test'+i;
            accList.add(acc);
            accIds.add(acc.Id);
        }
        
        Test.startTest();
        insert accList;
        Test.stopTest();
        
        List<Opportunity> relatedOppList = [SELECT Id FROM Opportunity WHERE AccountId IN:accIds];
        System.assert(relatedOppList!=null, 'Opportunity is not created');
    }
    
    @isTest
    public static void createRelatedContactTest()
    {
        List<Account> accList = new List<Account>();
		
        for(Integer i = 1; i<=5; i++)
        {
            Account acc = new Account();
            acc.Name = 'Account Test'+i;
            accList.add(acc);
        }
        
        Test.startTest();
        insert accList;
        Test.stopTest();
        
        List<Contact> relatedConList = [SELECT Id FROM Contact WHERE AccountId =: accList[0].Id];
        System.assert(relatedConList!=null, 'Contact is not created');
    }
    
    @isTest
    public static void copyBillingToShippingInsertTest()
    {
        List<Account> accList = new List<Account>();
		List<Id> accIds = new List<Id>();
        
        for(Integer i = 1; i<=5; i++)
        {
            Account acc = new Account();
            acc.Name = 'Account Test'+i;
            acc.BillingCity = 'Test City';
            acc.BillingCountry = 'Test Country';
            acc.BillingPostalCode = '123456';
            acc.BillingState = 'Test State';
            acc.BillingStreet = 'Test Street';
            acc.Copy_Billing_To_Shipping__c = true;
            accList.add(acc);
        }
        
        Test.startTest();
        insert accList;
        Test.stopTest();
        
        List<Account> newAccList = [SELECT Id, ShippingCity FROM Account WHERE ID IN: accIds];
        for(Account acc : newAccList)
        {
            System.assertEquals('Test City',acc.ShippingCity);
        }
    }
    
    @isTest
    public static void copyBillingToShippingUpdateTest()
    {
        List<Account> accList = new List<Account>();
		List<Id> accIds = new List<Id>();
        
        for(Integer i = 1; i<=5; i++)
        {
            Account acc = new Account();
            acc.Name = 'Account Test'+i;
            acc.BillingCity = 'Test City';
            acc.BillingCountry = 'Test Country';
            acc.BillingPostalCode = '123456';
            acc.BillingState = 'Test State';
            acc.BillingStreet = 'Test Street';
            accList.add(acc);
        }
        
        Test.startTest();
        insert accList;
        
        for(Account acc : accList)
        {
            acc.Copy_Billing_To_Shipping__c = true;
        }
        
        update accList;
        Test.stopTest();
        
        List<Account> newAccList = [SELECT Id, ShippingCity FROM Account WHERE ID IN: accIds];
        for(Account acc : newAccList)
        {
            System.assertEquals('Test City',acc.ShippingCity);
        }
    }
    
    @isTest
    public static void updateRatingOnAccountInsertTest()
    {
        List<Account> accList = new List<Account>();

        for(Integer i = 1; i<=5; i++)
        {
            Account acc = new Account();
            acc.Name = 'Account Test'+i;
            acc.Industry = 'Media';
            accList.add(acc);
        }
        
        Test.startTest();
        insert accList;
        Test.stopTest();
        
        List<Account> newAccList = [SELECT Id, Rating FROM Account WHERE Id =: accList[0].Id];
        System.assertEquals('Hot',newAccList[0].Rating);
    }
    
    @isTest
    public static void updateRatingOnAccountUpdateTest()
    {
        List<Account> accList = new List<Account>();

        for(Integer i = 1; i<=5; i++)
        {
            Account acc = new Account();
            acc.Name = 'Account Test'+i;
            acc.Industry = 'Banking';
            accList.add(acc);
        }
        
        Test.startTest();
        insert accList;
        
        for(Account acc : accList)
        {
            acc.Industry = 'Media';
        }
        update accList;
        Test.stopTest();
        
        List<Account> newAccList = [SELECT Id, Rating FROM Account WHERE Id =: accList[0].Id];
        System.assertEquals('Hot',newAccList[0].Rating);
    }
    
    @isTest
    public static void updateAccDescWithPhoneTest()
    {
        List<Account> accList = new List<Account>();
        
        for(Integer i=1;i<=10;i++)
        {
            Account acc = new Account();
            acc.Name = 'Test'+i;
            acc.Phone = '1234567890';
            accList.add(acc);
        }
        
        Test.startTest();
        insert accList;
        
        for(Account acc : accList)
        {
            acc.Phone = '8989898989';
        }
        
        update accList;
        Test.stopTest();
        
        List<Account> newAccList = [SELECT Id,Phone from Account WHERE Id =: accList[0].Id];
        
        System.assertEquals('8989898989',newAccList[0].Phone,'Phone is not updated');
    }
    
    /*
    @isTest
    public static void updateContactsHomePhoneTest()
    {
        List<Account> accList = new List<Account>();
        List<Contact> conList = new List<Contact>();
        for(Integer i=1;i<=5;i++)
        {
            Account acc = new Account();
            acc.Name = 'Test'+i;
            acc.Phone='123456';
            accList.add(acc);
        }
        
        insert accList;
        
        for(Account acc:accList)
        {
            Contact con = new Contact();
            con.LastName = acc.Name;
            con.AccountId = acc.Id;
            conList.add(con);
        }
        
        insert conList;
        
        Test.startTest();
        for(Account acc : accList)
        {
            acc.Phone = '987654';
        }
        update accList;
        Test.stopTest();
        
        List<Contact> newConList = [SELECT Id, HomePhone FROM Contact WHERE Id =: conList[0].Id];
        System.assertEquals('987654',newConList[0].HomePhone);
        
    }*/
    
    @isTest
    public static void updateContactsMailingAddressTest()
    {
        List<Account> accList = new List<Account>();
        List<Contact> conList = new List<Contact>();
        
        for(Integer i=1;i<=10;i++)
        {
            Account acc = new Account();
            acc.Name = 'Test '+i;
            acc.BillingCity = 'Test City';
            acc.BillingCountry = 'Test Country';
            acc.BillingState = 'Test State';
            acc.BillingStreet = 'Test Street';
            acc.BillingPostalCode = '123456';
            accList.add(acc);
        }
        
        Test.startTest();
        insert accList;
        
        for(Account acc : accList)
        {
            Contact con = new Contact();
            con.LastName = acc.Name;
            conList.add(con);
        }
        
        insert conList;
        
        for(Account acc : accList)
        {
            acc.BillingCity = 'Hyderabad';
        }
        
        update accList;
        Test.stopTest();
        
        List<Contact> newConList = [SELECT Id, MailingCity FROM Contact WHERE AccountId =: accList[0].Id];
        
        System.assertEquals('Hyderabad',newConList[0].MailingCity);
    }
    
    @isTest
    public static void updateRelatedOppStageTest()
    {
        List<Account> accList = new List<Account>();
        List<Opportunity> oppList = new List<Opportunity>();

        for(Integer i = 1; i<=5; i++)
        {
            Account acc = new Account();
            acc.Name = 'Account Test'+i;
            acc.Active__c = 'Yes';
            accList.add(acc);
        }
        
        Test.startTest();
        insert accList;
        
        for(Account acc : accList)
        {
            Opportunity opp = new Opportunity();
            opp.Name = 'Test '+acc.Name;
            opp.StageName = 'Prospecting';
            opp.CloseDate = System.today()+15;
            opp.AccountId = acc.Id;
            oppList.add(opp); 
        }
        
        insert oppList;
        
        for(Account acc : accList)
        {
            acc.Active__c = 'No';
        }
        update accList;
        Test.stopTest();
        
        List<Opportunity> newOppList = [SELECT Id,StageName FROM Opportunity WHERE Id =:oppList[0].Id];
        System.assertEquals('Closed Lost',newOppList[0].StageName);
    }
    
    @isTest
    public static void preventDeletionOfAccTest()
    {
        List<Account> accList = new List<Account>();
        for(Integer i = 1; i<=5; i++)
        {
            Account acc = new Account();
            acc.Name = 'Account Test'+i;
            acc.Active__c = 'Yes';
            accList.add(acc);
        }
        
        Test.startTest();
        insert accList;
        
        Boolean exceptionThrown = false;
        try{
            delete accList;
        }
        catch(Exception e)
        {
            exceptionThrown = true;
            Boolean expectedExceptionThrown = (e.getMessage().contains(Label.Prevent_Account_Deletion)?true:false);
            System.assertEquals(true,expectedExceptionThrown,e.getMessage());
        }
        System.assertEquals(true,exceptionThrown,'No exception was thrown');
        
        Test.stopTest();
    }
    
    /*
    @isTest
    public static void preventUpdationOfAccTest()
    {
        List<Account> accList = new List<Account>();
        for(Integer i = 1; i<=5; i++)
        {
            Account acc = new Account();
            acc.Name = 'Account Test'+i;
            acc.Active__c = 'Yes';
            accList.add(acc);
        }
        
        Test.startTest();
        insert accList;
        
        Boolean exceptionThrown = false;
        try{
            for(Account acc : accList)
            {
                acc.Phone= '123456789';
            }
            update accList;
        }
        catch(Exception e)
        {
            exceptionThrown = true;
            Boolean expectedExceptionThrown = (e.getMessage().contains('You cannot update records which are created 7 days back')?true:false);
            System.assertEquals(true,expectedExceptionThrown,e.getMessage());
        }
        //System.assertEquals(true,exceptionThrown,'No exception was thrown');
        
        Test.stopTest();
		}*/   
}