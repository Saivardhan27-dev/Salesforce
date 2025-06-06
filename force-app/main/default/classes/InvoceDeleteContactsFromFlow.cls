public class InvoceDeleteContactsFromFlow {

    @InvocableMethod(label='Send Email to Contact' description='Send Email to Contact' category='Case')
    public static void sendEmailToContact(List<Requests> requestList)
    {
        String contactId = requestList.get(0).contactId;
        String caseNumber = requestList.get(0).caseNumber;
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[]{contactId};
        message.subject = 'Your case has been recieved!.'+caseNumber;
        message.plainTextBody = 'Your case has been recieved!.';
        message.setSaveAsActivity(true);
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>{message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        if(results[0].success)
        {
            System.debug('The email was sent successfully.');
        }
        else
        {
            System.debug('The email failed to send: '+results[0].errors[0].message);
        }
    }
    
    public class Requests
    {
        @InvocableVariable(label='Record Id' description='The id of the case record' required=true)
        public String caseId;
        @InvocableVariable(label='Contact Record Id' description='The id of the Contact record' required=true)
        public String contactId;
        @InvocableVariable(label='Case Number' description='The Case Number' required=true)
        public String caseNumber;
    }
}