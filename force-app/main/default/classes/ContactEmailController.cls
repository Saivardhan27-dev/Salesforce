/**
* @File Name : ContactEmailController .cls
* @Description :
* @Author :
* @Last Modified By :
* @Last Modified On : December 16, 2024
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | December 16, 2024 |   | Initial Version
**/

public class ContactEmailController  {
	@AuraEnabled(cacheable=true)
    public static List<Contact> getContacts() {
        return [SELECT Id, Name, Email FROM Contact LIMIT 100];
    }
}