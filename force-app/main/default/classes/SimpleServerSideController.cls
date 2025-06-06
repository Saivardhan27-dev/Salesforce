public with sharing class SimpleServerSideController {
	
    @AuraEnabled
    public static String serverEcho(String firstName)
    {
        return ('Hello from the server '+firstName);
    }
}