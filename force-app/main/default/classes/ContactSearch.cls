public class ContactSearch {
	public static List<Contact> searchForContacts(String lName, String postalCode)
    {
        List<Contact> contactsList = [SELECT Id, Name from Contact WHERE LastName =: lName and MailingPostalCode =: postalCode];
        return contactsList;
    }
}