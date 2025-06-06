public class BatchContactDemo implements Database.Batchable<sObject>{
    
    public Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator('select id, name from Contact');
    }
    
    public void execute(Database.BatchableContext bc, List<Contact> contactListFromStartMethod)
    {
        for(Contact con : contactListFromStartMethod)
        {
            con.LastName = 'Batch Updated-'+con.Name;
        }
        update contactListFromStartMethod;
    }
    
    public void finish(Database.BatchableContext bc)
    {
        
    }

}