public class ApexRestCalloutDemo {
    
    public static void getUsersFromExternalSystem(){
        
        //GET Users
        /*HTTP httpObj = new HTTP();
        HTTPRequest req = new HTTPRequest();
        
        req.setEndpoint('https://reqres.in/api/users');
        req.setHeader('Content-Type','application/json');
        req.setMethod('GET');
        
        HTTPResponse res = new HTTPResponse();
        res = httpObj.send(req);
        
        System.debug('****Response Body --- '+res.getBody());*/
        
        //Create User
        HTTP httpObj = new HTTP();
        HTTPRequest req = new HTTPRequest();
        
        req.setEndpoint('https://reqres.in/api/users');
        req.setHeader('Content-Type','application/json');
        req.setMethod('POST');
        req.setBody('{"name": "Sai","job": "Developer"}');
        HTTPResponse res = new HTTPResponse();
        res = httpObj.send(req);
    	System.debug('****Response Body --- '+res.getBody());
    }
}