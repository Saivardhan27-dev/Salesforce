public class BatchClassDemo implements Database.Batchable<sObject>{
	
    public Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator('select id,Name from Account');
    }
    
    public void execute(Database.BatchableContext bc,List<Account> recordsFromStartMethod)
    {
        for(Account acc: recordsFromStartMethod)
        {
            acc.Name = 'Batch Updated-'+acc.Name;
        }
        update recordsFromStartMethod;
    }
    
    public void finish(Database.BatchableContext bc)
    {
        System.debug('Batch job completed!..........');
        Database.executeBatch(new BatchContactDemo(),200);
    }
}