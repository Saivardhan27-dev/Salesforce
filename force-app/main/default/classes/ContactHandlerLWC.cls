public with sharing class ContactHandlerLWC {
    
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(){
        List<Contact> contacts = [SELECT Id, FirstName, LastName, Email, Name FROM Contact LIMIT 10];
        return contacts;
    }
}