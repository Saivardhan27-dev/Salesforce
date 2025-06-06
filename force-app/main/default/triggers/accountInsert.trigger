//Scenario 1 :
//When we are trying to insert the record into an object If there is any record existing with the same account name it should prevent duplicate record.

trigger accountInsert on Account (before insert) {
    for(Account acc : Trigger.new)
    {
        List<Account> accList = [SELECT Id, Name FROM Account WHERE Name =: acc.Name];
        if(accList.size() > 0)
        {
            acc.Name.addError('Account already exist');
        }
    }
}