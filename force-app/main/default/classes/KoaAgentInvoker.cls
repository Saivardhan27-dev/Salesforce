public with sharing class KoaAgentInvoker {
    public KoaAgentInvoker() {
        // Constructor
    }
    
    /**
     * Method to process chat messages from users by invoking the Koa agent
     * @param userMessage The message entered by the user
     * @param sessionId The session ID from previous conversations (can be null for first message)
     * @return Map<String, String> containing the agent response and session ID
     */
    @AuraEnabled
    public static Map<String, String> processMessage(String userMessage, String sessionId) {
        try {
            return invokeKoaAgent(userMessage, sessionId);
        } catch (Exception e) {
            throw new AuraHandledException('Error processing message: ' + e.getMessage());
        }
    }
    
    /**
     * Method to invoke the Koa agent using Invocable.Action
     * @param userMessage The message entered by the user
     * @param sessionId The session ID from previous conversations (can be null for first message)
     * @return Map<String, String> containing the agent response and session ID
     */
    public static Map<String, String> invokeKoaAgent(String userMessage, String sessionId) {
        Map<String, String> responseMap = new Map<String, String>();
        
        try {
            // Create an instance of the invocable action with type 'generateAiAgentResponse' and name 'Koa_Service_Agent'
            Invocable.Action action = Invocable.Action.createCustomAction('generateAiAgentResponse', 'Koa_Service_Agent');
            
            // Set the required parameters
            action.setInvocationParameter('userMessage', userMessage);
            
            // Set the session ID parameter if provided from a previous conversation
            if (String.isNotBlank(sessionId)) {
                action.setInvocationParameter('sessionId', sessionId);
                System.debug('Using existing Session Id: ' + sessionId);
            } else {
                System.debug('No sessionId provided, will create a new session');
            }
            
            // Execute the action
            List<Invocable.Action.Result> results = action.invoke();
            Invocable.Action.Result result = results[0];
            
            // Handle the response
            if (result.isSuccess()) {
                // Retrieve the agent response
                String agentResponse = (String)result.getOutputParameters().get('agentResponse');
                String newSessionId = (String)result.getOutputParameters().get('sessionId');
                
                // Check if we got a valid session ID back
                if (String.isBlank(newSessionId)) {
                    System.debug('Warning: No sessionId returned from agent');
                    // If the original session ID was valid, use it
                    if (String.isNotBlank(sessionId)) {
                        newSessionId = sessionId;
                    }
                }
                
                // Log the session ID for debugging
                System.debug('Output Session Id: ' + newSessionId);
                System.debug('Output Agent Response: ' + agentResponse);
                
                // Add both values to the response map
                responseMap.put('response', agentResponse);
                responseMap.put('sessionId', newSessionId);
                
                return responseMap;
            } else {
                List<Invocable.Action.Error> actionErrors = result.getErrors();
                List<String> errorMessages = new List<String>();
                
                // Convert action errors to strings
                for (Invocable.Action.Error err : actionErrors) {
                    errorMessages.add(err.getMessage());
                }
                
                String errorMessage = 'Agent invocation failed: ' + String.join(errorMessages, ', ');
                System.debug(errorMessage);
                
                // Check if error is related to session - this helps client-side detection
                Boolean isSessionError = false;
                if (!errorMessages.isEmpty()) {
                    for (String errorMsg : errorMessages) {
                        if (errorMsg != null &&
                            errorMsg.toLowerCase().contains('session') &&
                            (errorMsg.toLowerCase().contains('expired') ||
                            errorMsg.toLowerCase().contains('invalid') ||
                        errorMsg.toLowerCase().contains('not found'))) {
                            isSessionError = true;
                            break;
                        }
                    }
                }
                
                // Add error message to the response map
                if (isSessionError) {
                    responseMap.put('response', 'Session expired. Please start a new conversation.');
                } else {
                    responseMap.put('response', 'Sorry, I encountered an error. Please try again later.');
                }
                
                responseMap.put('sessionId', ''); // Empty session ID for error
                return responseMap;
            }
        } catch (Exception e) {
            String errorMsg = e.getMessage();
            System.debug('Error invoking Koa agent: ' + errorMsg);
            
            // Check if the error message contains information about the session
            Boolean isSessionError = false;
            if (errorMsg != null) {
                String lowerErrorMsg = errorMsg.toLowerCase();
                isSessionError = lowerErrorMsg.contains('session') &&
                    (lowerErrorMsg.contains('expired') ||
                    lowerErrorMsg.contains('invalid') ||
                    lowerErrorMsg.contains('not found'));
            }
            
            // Create error response with more specific message
            if (isSessionError) {
                responseMap.put('response', 'Session expired. Please start a new conversation.');
            } else {
                // Don't expose detailed error message to end users for security
                responseMap.put('response', 'Sorry, I encountered a technical issue. Please try again later.');
            }
            
            responseMap.put('sessionId', ''); // Empty session ID for error
            return responseMap;
        }
    }
}