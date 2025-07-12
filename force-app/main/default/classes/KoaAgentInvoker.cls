public with sharing class KoaAgentInvoker {
   @AuraEnabled(cacheable=false)
   public static Map<String, String> invokeAgentKoaMethod(String message, String sessionId) {
       Invocable.Action action = Invocable.Action.createCustomAction('generateAiAgentResponse','Koa_Cars_Service_Agent');
        action.setInvocationParameter('userMessage', message);
       if (String.isNotBlank(sessionId)) {
           action.setInvocationParameter('sessionId', sessionId);
       }
        List<Invocable.Action.Result> responses = action.invoke();
        Invocable.Action.Result response = responses[0];
       Map<String, String> result = new Map<String, String>();
       result.put('reply', (String)response.getOutputParameters().get('reply'));
       result.put('sessionId', (String)response.getOutputParameters().get('sessionId'));
       return result;
   }
}