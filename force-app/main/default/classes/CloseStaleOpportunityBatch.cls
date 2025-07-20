/******
 * CloseStaleOpportunityBatch.cls
 * This class implements a batch job to close stale opportunities
 * that have been in the 'In Progress' stage for more than three months.
 * It updates their stage to 'Closed Lost' and sets a reason.
 ******/
global with sharing class CloseStaleOpportunityBatch implements Database.Batchable<SObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        Date threeMonthsAgo = System.today().addMonths(-3);
        return Database.getQueryLocator([SELECT Id, StageName, LastModifiedDate FROM Opportunity WHERE StageName = 'In Progress' AND LastModifiedDate <=:threeMonthsAgo]);
    }

    global void execute(Database.BatchableContext bc, List<Sobject> scope){
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        for(SObject s : scope){
            Opportunity opp = (Opportunity) s;
            opp.StageName = 'Closed Lost';
            opp.Reason__c = 'Stale Opportunity';
            oppsToUpdate.add(opp);
        }

        if(!oppsToUpdate.isEmpty()){
            update oppsToUpdate;
        }

    global void finish(Database.BatchableContext bc){
        System.debug('Stale Opportunities batch job completed');
    }
}