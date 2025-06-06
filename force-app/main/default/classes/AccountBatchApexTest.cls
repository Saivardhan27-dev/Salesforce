@isTest
public class AccountBatchApexTest {
	
    @isTest static void testHere()
    {
        TestDataFactory.createAccount();
        AccountBatchApex aba = new AccountBatchApex();
        
        Test.startTest();
        Id JobId = Database.executeBatch(aba,20);
        Test.stopTest();
        
        User u = [SELECT Id from User WHERE Alias = 'cuser'];
        Account acc = [SELECT Id, OwnerId FROM Account];
        
        System.assertEquals(u.Id,acc.Id);
    }
}