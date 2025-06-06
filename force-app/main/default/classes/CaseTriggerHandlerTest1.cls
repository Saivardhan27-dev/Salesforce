@isTest
public class CaseTriggerHandlerTest1{

    @isTest
    private static void populateLatestCaseNumberTest()
    {
        List<Account> accList = new List<Account>();
        
        for(Integer i=1;i<=5;i++)
        {
            Account acc = new Account();
            acc.Name = 'Account Test '+i;
            accList.add(acc);
        }
        
        insert accList;
        
        List<Case> caseList = new List<Case>();
        
        for(Account acc : accList)
        {
            Case cs = new Case();
            cs.Status = 'New';
            cs.Origin = 'Phone';
            cs.AccountId = acc.Id;
            caseList.add(cs);
        }
        
        Test.startTest();
        insert caseList;
        Test.stopTest();
        
        List<Account> updatedAccList = [SELECT Id, Latest_Case_Number__c FROM Account WHERE Id =: accList[0].Id];
        
        List<Case> updatedCaseList = [SELECT Id, CaseNumber FROM Case WHERE Id =: caseList[0].Id];
        
        System.assertEquals(updatedCaseList[0].CaseNumber, updatedAccList[0].Latest_Case_Number__c);
    }
}