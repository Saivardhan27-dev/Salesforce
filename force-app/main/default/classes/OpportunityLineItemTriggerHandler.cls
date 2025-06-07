public with sharing class OpportunityLineItemTriggerHandler {
    
    public static void createAssetOnProductInsert(List<OpportunityLineItem> oppLineItemList) {
        Set<Id> OpportunityIds = new Set<Id>();
        if(!oppLineItemList.isEmpty()){
            for(OpportunityLineItem oli : oppLineItemList){
                if(oli.OpportunityId != null){
                    OpportunityIds.add(oli.OpportunityId);
                }
            }
        }

        List<Opportunity> oppList = [SELECT Id, AccountId FROM Opportunity WHERE Id IN: OpportunityIds];
        List<Asset> assetList = new List<Asset>();

        if(!oppList.isEmpty()){
            for(Opportunity opp : oppList){
                Asset assetRecord = new Asset();
                assetRecord.AccountId = opp.AccountId;
                assetRecord.Name = opp.Account.Name + ' - ' + 'Asset';
                assetList.add(assetRecord);
            }
        }

        if(!assetList.isEmpty()){
            try {
                insert assetList;
            } catch (DmlException e) {
                System.debug('Error inserting assets: ' + e.getMessage());
            }
        }
    }
}