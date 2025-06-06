@isTest
public class LeadProcessorTest {
	
    @isTest
    public static void updateLeadSource(){
        List<Lead> leadLists = new List<Lead>();
        for(integer i=0;i<200;i++){
            Lead l = new Lead();
            l.LastName = 'l'+(i+1);
            l.Company = 'Test'+(i+1)+'Company';
            l.Status = 'Open - Not Contacted';
            leadLists.add(l);
        }
        
        insert leadLists;
        
        Test.startTest();
        LeadProcessor lp = new LeadProcessor();
        Id batchId = Database.executeBatch(lp);
        Test.stopTest();
        Lead testLead = [SELECT LeadSource FROM Lead LIMIT 1];
        // after the testing stops, assert records were updated properly
        System.assertEquals('Dreamforce', testLead.LeadSource);
    }
}