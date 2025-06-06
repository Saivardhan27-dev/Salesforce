public class AccountProcessor {
	
    @future
    public static void countContacts(List<Id> accountIds)
    {
        List<Account> accounts = [SELECT Id,Name FROM Account WHERE Id IN:accountIds];
        List<Account> updateAccounts = new List<Account>();
        for(Account acc : accounts)
        {
            acc.Number_Of_Contacts__c = [SELECT COUNT() FROM Contact WHERE AccountId =: acc.Id];
            updateAccounts.add(acc);
        }
        
        update updateAccounts;
    }
}