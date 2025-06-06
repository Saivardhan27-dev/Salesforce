global class AccountBatchApex implements Database.Batchable<sObject>{
	
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        // String query = 'SELECT Id, OwnerId FROM Account';
        //return Database.getQueryLocator(query);
        return Database.getQueryLocator('SELECT Id, OwnerId FROM Account');
    }
    
    global void execute(Database.BatchableContext bc, List<Account> accRecords)
    {
        User user = [SELECT Id from User WHERE Alias = 'cuser'];
        for(Account acc : accRecords)
        {
            acc.OwnerId = user.Id;
        }
        
        update accRecords;
    }
    
    global void finish(Database.BatchableContext bc)
    {
        
    }
}