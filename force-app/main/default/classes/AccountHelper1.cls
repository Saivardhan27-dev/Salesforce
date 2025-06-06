public with sharing class AccountHelper1 {
    
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountData()
    {
        return [SELECT id, Name, Industry, Rating FROM Account with USER_MODE];
    }
}