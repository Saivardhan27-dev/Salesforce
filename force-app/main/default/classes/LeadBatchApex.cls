global class LeadBatchApex implements Database.Batchable<sObject> {
	global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query = 'SELECT Id, FirstName, LeadSource, Rating from Lead';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Lead> leadRecords)
    {
        for(Lead lead : leadRecords)
        {
            lead.LeadSource = 'Web';
            lead.Rating = 'Cold';
        }
        update leadRecords;
    }
    
    global void finish(Database.BatchableContext bc)
    {
        
    }
}