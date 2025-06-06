@isTest
public class LeadBatchApexTest {

    @testSetUp static void createData()
    {
        Lead l = new Lead();
        l.FirstName = 'Sai';
        l.LastName = 'Vardhan';
        l.Company = 'Test Company';
        insert l;
    }
    
    @isTest
    static void performTesting()
    {
        LeadBatchApex lba = new LeadBatchApex();
        Test.startTest();
        Id JobId = Database.executeBatch(lba,10);
        Test.stopTest();
        
        Lead testLeads = [SELECT Rating,LeadSource FROM Lead];
        
        System.assertEquals('Web',testLeads.LeadSource);
        System.assertEquals('Cold',testLeads.Rating);
        
    }
}