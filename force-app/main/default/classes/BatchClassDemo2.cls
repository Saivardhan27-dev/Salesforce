public class BatchClassDemo2 implements Database.Batchable<sObject> {
	
    public Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator('select Id, Name from Account');
    }
    
    public void execute(Database.BatchableContext bc, List<Account> accListFromStartMethod)
    {
        for(Account acc: accListFromStartMethod)
        {
            String prefix = 'Batch Updated-';
            if(acc.Name.startsWith(prefix))
            {
                acc.Name = acc.Name.substring(prefix.length());
            }
        }
        
        update accListFromStartMethod;
    }
    
    public void finish(Database.BatchableContext bc)
    {
        System.debug('Batch class execution completed');
    }
}