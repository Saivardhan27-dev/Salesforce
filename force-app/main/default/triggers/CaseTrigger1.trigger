trigger CaseTrigger1 on Case (before insert,after insert,after update) {

    if(trigger.isInsert && trigger.isAfter)
    {
        CaseTriggerHandler1.populateLatestCaseNumber(Trigger.new);
    }

    
}