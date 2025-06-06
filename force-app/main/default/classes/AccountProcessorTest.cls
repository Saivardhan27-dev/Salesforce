@isTest
public class AccountProcessorTest {

    @isTest
    public static void countContactsTest()
    {
        Account acc = new Account();
        acc.Name = 'Test';
        insert acc;
        
        Contact con1 = new Contact();
        con1.LastName = 'Test1';
        con1.AccountId = acc.Id;
        
        Contact con2 = new Contact();
        con2.LastName = 'Test2';
        con2.AccountId = acc.Id;
        
        List<Id> accList = new List<Id>();
        accList.add(acc.Id);
        
        Test.startTest();
        AccountProcessor.countContacts(accList);
        Test.stopTest();
        
    }
}