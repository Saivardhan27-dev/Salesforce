public with sharing class ContactManager{
    @AuraEnabled(cacheable=true)
    // public static List<Contact> getContact(){
    //     return [SELECT id,LastName,Phone FROM Contact LIMIT 20];
    // } 

    public static List<Contact> getContact(Integer numberOfRecords){
        return [SELECT id,LastName,Phone FROM Contact LIMIT:numberOfRecords];
    } 
}