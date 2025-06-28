public class CaseTriggerHandler {
	public static void handleBeforeDelete(List<Case> oldRecords)
    {
        Id currentUserProfileId = UserInfo.getProfileId();
        Id sysAdminProfileId = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;
        
        for(Case casRec : oldRecords)
        {
            if(currentUserProfileId != sysAdminProfileId)
            {
                casRec.addError('You dont have permission to delete Case. Contact your System Administrator');
            }
        }
    }

    /****************
     * description:
     * When a Case is created and its Priority = High, automatically create a Task for the case owner to follow up within 1 day.
     * - But here's the twist:
     * If the Account linked to the case is marked VIP, escalate the case instead of creating the task.
     ****************/
    public static void createFollowUpTaskOrEscalateCase(List<Case> newRecords, Map<Id, Case> oldMap){

        List<Case> casesToUpdate = new List<Case>();
        List<Task> tasksToInsert = new List<Task>();

        if(!newRecords.isEmpty()){
            for(Case cs : newRecords){
                if(cs.Priority == 'High'){
                    if(cs.AccountId != NULL && cs.Account.VIP__c){
                        cs.Status = 'Escalated';
                        casesToUpdate.add(cs);
                    }
                }
                else{
                    Task followUpTask = new Task();
                    followUpTask.Subject = 'Follow up on high priority case';
                    followUpTask.WhatId = cs.Id;
                    followUpTask.OwnerId = cs.OwnerId;
                    followUpTask.DueDate = System.today().addDays(1);
                    tasksToInsert.add(followUpTask);
                }
            }
        }

        if(!casesToUpdate.isEmpty()){
            update casesToUpdate;
        }

        if(!tasksToInsert.isEmpty()){
            insert tasksToInsert;
        }
    }

    /****************
     * description:
     * When a Case is escalated, send an email notification to the case owner.
     ****************/
    public static void sendEmailWhenCaseEscalated(List<Case> newRecords, Map<Id, Case> oldMap){
        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();
        if(!newRecords.isEmpty()){
            for(Case cs : newRecords){
                if(cs.Status == 'Escalated' && oldMap.containsKey(cs.Id) && oldMap.get(cs.Id).Status != 'Escalated'){
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    email.setToAddresses(new String[] {cs.Owner.Email});
                    email.setSubject('Case Escalated: ' + cs.Subject);
                    email.setPlainTextBody('Dear ' + cs.Owner.Name + ',\n\nThe case with subject "' + cs.Subject + '" has been escalated. Please take necessary action.\n\nBest regards,\nSupport Team');
                    emailsToSend.add(email);
                }
            }
        }   
        if(!emailsToSend.isEmpty()){
            Messaging.sendEmail(emailsToSend);
        }
    }
}