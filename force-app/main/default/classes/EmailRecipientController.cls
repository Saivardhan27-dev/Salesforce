/**
* @File Name : EmailRecipientController.cls
* @Description :
* @Author :
* @Last Modified By :
* @Last Modified On : December 17, 2024
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | December 17, 2024 |   | Initial Version
**/

public with sharing class EmailRecipientController {
    @AuraEnabled(cacheable=true)
    public static List<Map<String, String>> searchRecipients(String searchTerm) {
        List<Map<String, String>> results = new List<Map<String, String>>();

        // Search for Contacts, Leads, and Users with the search term
        String searchPattern = '%' + searchTerm + '%';

        // Query for Contacts
        List<Contact> contacts = [SELECT Id, Name, Email FROM Contact WHERE Name LIKE :searchPattern OR Email LIKE :searchPattern];
        for (Contact c : contacts) {
            results.add(new Map<String, String>{'Id' => c.Id, 'Name' => c.Name, 'Email' => c.Email});
        }

        // Query for Leads
        List<Lead> leads = [SELECT Id, Name, Email FROM Lead WHERE Name LIKE :searchPattern OR Email LIKE :searchPattern];
        for (Lead l : leads) {
            results.add(new Map<String, String>{'Id' => l.Id, 'Name' => l.Name, 'Email' => l.Email});
        }

        // Query for Users
        List<User> users = [SELECT Id, Name, Username FROM User WHERE Name LIKE :searchPattern OR Username LIKE :searchPattern];
        for (User u : users) {
            results.add(new Map<String, String>{'Id' => u.Id, 'Name' => u.Name, 'Email' => u.Username});
        }

        return results;
    }
}