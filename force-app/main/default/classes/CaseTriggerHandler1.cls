public class CaseTriggerHandler1 {

    public static void populateLatestCaseNumber(List<Case> caseRecords)
    {
        List<Account> accList = new List<Account>();
        for(Case cs : caseRecords)
        {
            if(cs.AccountId != null)
            {
                Account acc = new Account();
                acc.Id = cs.AccountId;
                acc.Latest_Case_Number__c = cs.CaseNumber;
                accList.add(acc);
            }
        }
        
        if(!accList.isEmpty())
            update accList;
    }
}