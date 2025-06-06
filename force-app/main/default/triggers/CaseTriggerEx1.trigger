trigger CaseTriggerEx1 on Case (after insert) {
    
    if(Trigger.isAfter && Trigger.isInsert)
    {
        List<Account> accList = new List<Account>();
        for(Case cs : Trigger.NEW)
        {
            if(cs.AccountId != null)
            {
                Account acc = new Account();
                acc.Latest_Case_Number__c = cs.CaseNumber;
                acc.Id = cs.AccountId; 
                accList.add(acc);
            }
        }
        
        if(!accList.isEmpty())
        {
            update accList;
        }
    }
}