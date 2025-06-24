/********
 * @description
 * Scenario:
 * In your org, you have a custom object Leave_Request__c.
 * When a new leave request is inserted or updated with the Status__c field set to "Approved", you must:
 * 1 : Check if the employee has already taken more than 30 days of leave this year.
 * 2 : If yes, throw an error: "Leave limit exceeded for this year."
 *********/

public with sharing class LeaveRequestTriggerHandler {

    public static void checkLeaveLimitForYear(List<Leave_Request__c> leaveRequestRecords){
        
        Set<Id> employeeIds = new Set<Id>();
        for(Leave_Request__c req : leaveRequestRecords){
            if(req.Status__c = 'Approved' && req.Employee__c != null){
                employeeIds.add(req.Employee__c);
            }
        }

        Map<Id, Decimal> leaveCountMap = new Map<Id, Decimal>();
        List<AggregateResult> leaveData = [SELECT Employee__c, SUM(Duration__c) totalDays FROM Leave_Request__c
                                            WHERE Status__c = 'Approved' AND
                                                  Calendar_Year__c = :String.valueOf(Date.today().year()) AND
                                                  Employee__c IN :employeeIds
                                                  Group by Employee__c
                                            ];
                                            
        for(AggregateResult ar : leaveData){
            leaveCountMap.put((Id)ar.get('Employee__c'), (Decimal)ar.get('totalDays'));
        }

        for(Leave_Request__c leave : leaveRequestRecords){
            if(leave.Status__c == 'Approved' && leave.Employee__c != null){
                Decimal total = leaveCountMap.get(leave.Employee__c);
                total = total != null ? total + leave.Duration__c : leave.Duration__c;
                if(total > 30){
                    leave.addError('Leave Limit Exceeded for this year');
                }
            }
        }
    }
}