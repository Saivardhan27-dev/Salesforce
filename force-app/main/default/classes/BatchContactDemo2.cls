public class BatchContactDemo2 implements Database.Batchable<sObject>{

    public Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator('select Id, LastName from Contact');
    }
    
    public void execute(Database.BatchableContext bc, List<Contact> contactsFromStartMethod)
    {
        
        for(Contact con : contactsFromStartMethod)
        {
            con.LastName = con.Name;
                
        }
        update contactsFromStartMethod;
    }
    
    public void finish(Database.BatchableContext bc)
    {
        System.debug('Batch class completed');
    }
}