trigger PositionTrigger on Position__c (after insert) {
	
    if(Trigger.isAfter)
    {
        if(Trigger.isInsert)
        {
            PositionTriggerHandler.createTask(Trigger.new);
        }
    }
    
}