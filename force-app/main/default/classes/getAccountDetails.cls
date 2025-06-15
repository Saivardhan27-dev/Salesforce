public with sharing class getAccountDetails {
    
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(){
        return [SELECT Id, Name, Phone, Type, Total_Opportunities_Amount__c FROM Account LIMIT 5];
    }
}