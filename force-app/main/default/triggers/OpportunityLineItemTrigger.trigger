trigger OpportunityLineItemTrigger on OpportunityLineItem (after insert) {
    if(trigger.isAfter && trigger.isInsert){
        OpportunityLineItemTriggerHandler.createAssetOnProductInsert(Trigger.new); 
    }
}