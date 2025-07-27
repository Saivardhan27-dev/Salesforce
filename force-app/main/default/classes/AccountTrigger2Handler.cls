/**
 * @description       : 
 * @author            : Sai Vardhan Marupalla
 * @group             : 
 * @last modified on  : 07-27-2025
 * @last modified by  : Sai Vardhan Marupalla
**/

public with sharing class AccountTrigger2Handler {
    public static void findDuplicateBasedOnGST(List<Account> newAccounts){

        Set<String> gstNumbers = new Set<String>();

        for(Account acc : newAccounts){
            if(acc.GST_Number__c != null){
                gstNumbers.add(acc.GST_Number__c);
            }
        }

        List<Account> existingAccounts = [SELECT Id, GST_Number__c FROM Account WHERE GST_Number__c IN : gstNumbers];
        Map<String, Account> gstAccountMap = new Map<String, Account>();
        for(Account existingAcc : existingAccounts){
            gstAccountMap.put(existingAcc.GST_Number__c, existingAcc);
        }

        for(Account acc : newAccounts){
            if(gstAccountMap.containsKey(acc.GST_Number__c)){
                acc.GST_Number__c.addError('Account with this GST Number already exists: ' + acc.GST_Number__c);
            }
        }
    }
}