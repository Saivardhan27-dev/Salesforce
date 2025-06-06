@RestResource (Urlmapping = '/AccountContactApi')
global class AccountConApi {
	
    @httpPost
    global static void saveAccContFromExtSys(){
        
        //Initiate req and res
        RestRequest req = RestContext.Request;
        RestResponse res = RestContext.Response;
        
        //Parsing JSON body into String
        String body = req.requestBody.toString(); //{"CustomerName":"Salesforce","isAccount":"true"};
        MyJsonCls myObj = (MyJsonCls) JSON.deserialize(body,MyJsonCls.Class);
        
        System.debug('****'+myObj.CustomerName+'******'+myObj.isAccount);
        
        if(myObj.isAccount == true){
            Account acc = new Account(Name = myObj.CustomerName);
            insert acc;
        }
        else if(myObj.isAccount == false)
        {
            Contact con = new Contact(LastName = myObj.CustomerName);
            insert con;
        }
    }
}