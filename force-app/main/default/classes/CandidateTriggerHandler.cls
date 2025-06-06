public class CandidateTriggerHandler {

    public static void sendEmail(List<Candidate__c> candidateList, Map<Id,Candidate__c> oldMap)
    {
        List<Messaging.Email> emailList = new List<Messaging.Email>();
        for(Candidate__c can : candidateList)
        {
            if((oldMap==null && can.Email__c != null) || (oldMap!=null && can.Email__c != null && oldMap.get(can.Id).Email__c == null))
            {
                Messaging.SingleEmailMessage emailMsg = new Messaging.SingleEmailMessage();
    
                String[] toAddress = new String[]{can.Email__c};
                emailMsg.setToAddresses(toAddress);
                
                String emailSubject = 'Welcome '+can.First_Name__c;
                emailMsg.setSubject(emailSubject);
                
                String disName = 'Sai Vardhan';
                emailMsg.setSenderDisplayName(disName);
                
                String content = 'Hi ' + can.First_Name__c + ',<br/><br/>'+
                    'Welcome to Salesforce Ecosystem! <br/><br/>'+
                    'Happy learning! <br/><br/>'+
                    'Thank you! <br/><br/>'; 
                emailMsg.setHtmlBody(content);
                emailList.add(emailMsg);
            }
		}
        Messaging.sendEmail(emailList);
	}
}