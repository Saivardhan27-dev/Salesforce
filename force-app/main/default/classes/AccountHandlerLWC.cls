public with sharing class AccountHandlerLWC {
    
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(){
        List<Account> accounts = [SELECT Id, Name, Type, Industry, AnnualRevenue FROM Account LIMIT 10];
    }
}