public with sharing class OpportunityController 
{
    @AuraEnabled
    public static List<Opportunity> getOpportunities(){
        List<Opportunity> opportunities = [select id,name from Opportunity];
        return opportunities;
    }
}