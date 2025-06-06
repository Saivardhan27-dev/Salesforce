trigger associatedContactDeletion on Account (before delete) {
    if(Trigger.isDelete && Trigger.isBefore)
    {
        Map<Id, Account> mapOfConAcc = new Map<Id, Account>([SELECT Id, (SELECT Id FROM Contacts) FROM Account WHERE Id IN :Trigger.oldMap.keySet()]);
        
        for(Account acc : Trigger.old)
        {
            if(!mapOfConAcc.get(acc.Id).Contacts.isEmpty())
            {
                acc.addError('Account with associated contacts cannot be deleted');
            }
        }
    }
}