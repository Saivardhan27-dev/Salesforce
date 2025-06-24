trigger LeaveRequestTrigger on Leave_Request__c (before insert, before update) {

    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        LeaveRequestTriggerHandler.handleLeaveRequest(Trigger.new);
    }
}