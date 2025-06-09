trigger AssetTrigger on Asset (after update) {
    if(Trigger.isAfter && Trigger.isUpdate){
        AssetTriggerHandler.updateAssetSummaryOnCase(Trigger.new, Trigger.oldMap);
    }
}