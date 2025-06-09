public with sharing class EventTriggerHandler {
    /***************
     * @description
     * When an Event is rescheduled (StartDateTime is changed), log the original and new date/time in a
     * custom object called Audit__c.
     * This should happen only when the StartDateTime is changed.
     ****************/
    public static void createAuditUponStartDateUpdate(List<Event> eventList, Map<Id,Event> oldMapRecords){
        List<Audit__c> auditList = new List<Audit__c>();
        if(!eventList.isEmpty()){
            for(Event newEvent : eventList){
                if(event.StartDate != oldMapRecords.get(newEvent.Id).StartDate){
                    Audit__c auditRecord = new Audit__c();
                    auditRecord.Event__c = newEvent.Id;
                    auditRecord.Old_Start_Date__c = oldMapRecords.get(newEvent.Id).StartDate;
                    auditRecord.New_Start_Date__c = newEvent.StartDate;
                    auditList.add(auditRecord);
                }
            }
        }

        if(!auditList.isEmpty()){
            try{
                insert auditList;
            }catch(DmlException e){
                System.debug('Error inserting audit records:'+e.getMessage());
            }
        }
    }
}