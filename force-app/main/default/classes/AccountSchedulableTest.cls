@isTest
public class AccountSchedulableTest {

    @isTest
    static void testHere()
    {
        TestDataFactory.createAccount();
        String cronExp = '0 0 10 15 3 ?';
        AccountSchedulable accSch = new AccountSchedulable();
        
        Test.startTest();
        Id jobId = System.Schedule('Schedule1',cronExp,accSch);
        Test.stopTest();
        
        Integer count = [SELECT count() FROM Account WHERE CreatedDate=TODAY];
        System.assertEquals(0,count);
        
        CronTrigger cronTrig = [SELECT Id,cronExpression from CronTrigger WHERE Id =: jobId];
        System.assertEquals(cronExp,cronTrig.CronExpression);
    }
}