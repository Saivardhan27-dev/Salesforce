@isTest
public class AccountTriggerTest{
    @isTest
    static void accountTriggerAfterInsert()
    {
        Account accountTest = new Account(Name='Test Account 1', Type='Prospect');
        
        Test.startTest();
        	insert accountTest;
        Test.stopTest();
        
        Account insertedAccount = [SELECT Id, Name From Account LIMIT 1];
        
        List<Contact> insertedContacts = [SELECT Id, Account.Name FROM Contact];
        System.assertEquals(1, insertedContacts.size(),'Only one contact should present');
        System.assertEquals(insertedAccount.Name, insertedContacts[0].Account.Name, 'Account name does not match');
    }

}