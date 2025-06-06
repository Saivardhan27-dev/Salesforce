@isTest
public class OpportunityTrigger1HandlerTest {
    
    @isTest
    public static void updateDescBasedOnStageInsertTest()
    {
        List<Opportunity> oppList = new List<Opportunity>();
        for(Integer i=1;i<=5;i++)
        {
            Opportunity opp = new Opportunity();
            opp.Name = 'Test '+i;
            opp.StageName = 'Prospecting';
            opp.CloseDate = System.TODAY() + 15;
            opp.Amount = 100000;
            oppList.add(opp);
        }
        
        Test.startTest();
        insert oppList;
        Test.stopTest();
        
        List<Opportunity> newOppList = [SELECT Id, Description FROM Opportunity WHERE Id =: oppList[0].Id];
        System.assertEquals('Opportunity is Open',newOppList[0].Description);
    }
    
    @isTest
    public static void updateDescBasedOnStageUpdateTest()
    {
        List<Opportunity> oppList = new List<Opportunity>();
        for(Integer i=1;i<=10;i++)
        {
            Opportunity opp = new Opportunity();
            opp.Name = 'Test '+i;
            opp.StageName = 'Prospecting';
            opp.CloseDate = System.TODAY() + 15;
            opp.Amount = 100000;
            oppList.add(opp);
        }
        
        Test.startTest();
        insert oppList;
        
        Integer count = 1;
        for(Opportunity opp : oppList)
        {
            if(count<=5)
            {
                opp.StageName = 'Closed Won';
            }
            else
            {
                opp.StageName = 'Closed Lost';
            }
            count++;
        }
        
        update oppList;
        Test.stopTest();
        
        List<Opportunity> newOppList = [SELECT Id, Description FROM Opportunity WHERE Id IN: oppList];
        
        System.assertEquals('Opportunity is Closed Won',newOppList[0].Description);

        System.assertEquals('Opportunity is Closed Lost', newOppList[6].Description);
    }
    
    @isTest
    public static void updateLatestAmountOnAccTest()
    {
        List<Account> accList = new List<Account>();
        List<Opportunity> oppList = new List<Opportunity>();
        
        for(Integer i=1;i<=5;i++)
        {
            Account acc = new Account();
            acc.Name = 'Account Test'+i;
            accList.add(acc);
        }
        
        insert accList;
        
        for(Account acc : accList)
        {
            Opportunity opp = new Opportunity();
            opp.Name = acc.Name;
            opp.StageName = 'Prospecting';
            opp.CloseDate = System.today()+15;
            opp.Amount = 350000;
            opp.AccountId = acc.Id;
            oppList.add(opp);
            
        }
        
        Test.startTest();
        insert oppList;
        Test.stopTest();
        
        List<Account> updatedAccList = [SELECT Id, Recent_Opportunity_Amount__c FROM Account WHERE Id =: accList[0].Id];
        
        System.assertEquals(350000,updatedAccList[0].Recent_Opportunity_Amount__c);
    }

    @isTest
    public static void updateOppDescriptionTest()
    {
        List<Opportunity> oppList = new List<Opportunity>();
        List<Id> oppIds = new List<Id>();
        for(Integer i=9;i<=13;i++)
        {
            Opportunity opp = new Opportunity();
            opp.Name = 'Opportunity Test'+i;
            opp.StageName = 'Prospecting';
            opp.CloseDate = System.TODAY()+15;
            opp.Amount = 355000;
            oppIds.add(opp.Id);
            oppList.add(opp);
        }
        
        Test.startTest();
        insert oppList;
        Test.stopTest();
        
        List<Opportunity> newOppList = [SELECT Id, Description FROM Opportunity WHERE Id IN: oppIds];
        for(Opportunity opp : newOppList)
        {
            System.assertEquals('Opportunity is Open',opp.Description);
        }
    }
    
    @isTest
    public static void createTaskTest()
    {
        List<Opportunity> oppList = new List<Opportunity>();
        
        for(Integer i=1;i<=10;i++)
        {
            Opportunity opp = new Opportunity();
            opp.Name = 'Test '+i;
            opp.StageName = 'Prospect';
            opp.CloseDate = System.TODAY()+15;
            opp.Amount = 30000;
            oppList.add(opp);
        }
        
        Test.startTest();
        insert oppList;
        
        for(Opportunity opp : oppList)
        {
            opp.StageName = 'Value Proposition';
        }
        
        update oppList;
        Test.stopTest();
        
        List<Task> newTaskList = [SELECT Id FROM Task WHERE WhatId =: oppList[0].Id];
        
        System.assertEquals(1,newTaskList.size());
    }
    
    /*@isTest
    public static void validationOnAmountTest()
    {
        List<Opportunity> oppList = new List<Opportunity>();
        
        for(Integer i=1;i<=10;i++)
        {
            Opportunity opp = new Opportunity();
            opp.Name = 'Test '+i;
            opp.StageName = 'Prospect';
            opp.CloseDate = System.TODAY()+15;
            oppList.add(opp);
        }
        
        Test.startTest();
        Boolean exceptionThrown = false;
        try
        {
            insert oppList;
        }
        catch(Exception e)
        {
            exceptionThrown = true;
            Boolean expectedExceptionThrown = (e.getMessage().contains('Amount cannot be null')?true:false);
            System.assertEquals(true,expectedExceptionThrown,e.getMessage());
        }
        
        Test.stopTest();
    }*/
        
}