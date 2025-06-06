public class EmailTemplateUtility {
    public static void sendEmailWithTemplate(Id templateId, List<Id> targetObjectIds, String subjectOverride) {
        // List to hold email messages
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
 
        // Fetch the email template details
        EmailTemplate template = [SELECT Id, Name FROM EmailTemplate WHERE Id = :templateId LIMIT 1];
 
        for (Id targetObjectId : targetObjectIds) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setTargetObjectId(targetObjectId); // e.g., Contact or Lead ID
            email.setTemplateId(templateId);
            email.setSaveAsActivity(true); // Ensures the email gets logged
 
            // Override the subject if provided
            if (subjectOverride != null) {
                email.setSubject(subjectOverride);
            }
 
            emails.add(email);
        }
 
        // Send the emails
        Messaging.sendEmail(emails);
 
        // Query the newly created EmailMessages
        List<EmailMessage> emailMessages = [SELECT Id FROM EmailMessage WHERE Incoming = false];
 
        // Populate custom fields on EmailMessage
        for (EmailMessage emailMessage : emailMessages) {
            emailMessage.Email_Template_Name__c = template.Name;
            emailMessage.Email_Template_Id__c = template.Id;
        }
 
        // Update EmailMessage records
        update emailMessages;
    }
}