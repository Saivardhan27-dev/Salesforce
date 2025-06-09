public with sharing class AssetTriggerHandler {

    /********** 
    * @description
    * When an Asset is created and linked to a Case, update the Case Summary field with the Asset Name and Serial Number.
    * This should only happen if the Asset was not previously linked to a Case.
    ***********/
    public static void updateAssetSummaryOnCase(List<Asset> assetRecords, Map<Id,Asset> oldMapRecords){
        Map<Id, String> caseSummaryMap = new Map<Id,String>();
        List<Case> caseListToUpdate = new List<Case>();
        if(!assetRecords.isEmpty()){
            for(Asset newAsset : assetRecords){
                if(newAsset.RelatedCase__c != null && oldMapRecords.get(newAsset.Id).RelatedCase__c == null){
                    String summary = newAsset.Name + ' (' + newAsset.SerialNumber + ')'
                    caseSummaryMap.put(newAsset.RelatedCase__c, summary);
                }
            }
        }

        List<Case> caseList = [SELECT Id, Summary FROM Case WHERE Id In:caseSummaryMap.keySet()];
        for(Case caseRecord : caseList){
            if(caseSummaryMap,containsKey(caseRecord.Id)){
                caseRecord.Summary = caseSummaryMap.get(caseRecord.Id);
                caseListToUpdate.add(caseRecord);
            }
        }

        if(!caseListToUpdate.isEmpty()){
            try{
                update caseListToUpdate;
            }catch(DmlException e){
                System.debug('Error updating case records: ' + e.getMessage());
            }
        }
    }
}