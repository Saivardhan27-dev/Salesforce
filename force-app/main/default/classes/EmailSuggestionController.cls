/**
* @File Name : EmailSuggestionController.cls
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

public with sharing class EmailSuggestionController {
    @AuraEnabled(cacheable=true)
    public static List<RecipientWrapper> fetchRecipients(String searchTerm) {
        List<RecipientWrapper> results = new List<RecipientWrapper>();
        // Search Contacts, Leads, and Users with the email or name
        for (Contact c : [SELECT Name, Email FROM Contact WHERE Email LIKE :('%' + searchTerm + '%') LIMIT 10]) {
            results.add(new RecipientWrapper(c.Name, c.Email));
        }
        for (Lead l : [SELECT Name, Email FROM Lead WHERE Email LIKE :('%' + searchTerm + '%') LIMIT 10]) {
            results.add(new RecipientWrapper(l.Name, l.Email));
        }
        for (User u : [SELECT Id, Name, Username FROM User WHERE Username LIKE :('%' + searchTerm + '%')]) {
            results.add(new RecipientWrapper(u.Name, u.Username));
        }
        return results;
    }

    public class RecipientWrapper {
        @AuraEnabled public String name;
        @AuraEnabled public String email;
        
        public RecipientWrapper(String name, String email) {
            this.name = name;
            this.email = email;
        }
    }
}