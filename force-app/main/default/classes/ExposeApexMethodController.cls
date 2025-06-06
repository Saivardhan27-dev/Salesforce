public with sharing class ExposeApexMethodController {
    
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(){
        
        List<Contact> contactList = [SELECT Id, Name FROM Contact LIMIT 5];
        return contactList;
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactsByName(String Name)
    {
        String  strName = '%'+Name+'%';
        List<Contact> contactList = [SELECT Id,Name FROM Contact WHERE Name LIKE : strName LIMIT 5];
        return contactList;
    }
}