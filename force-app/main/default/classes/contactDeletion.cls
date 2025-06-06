@isTest
public class contactDeletion {
	@isTest
    public static void deletionTest()
    {
        String testName = 'Vardhan';
        Account acc = new Account(Name = testName);
        
        Contact con = new Contact(lastName = 'Vardhan');
        
        insert con;
        
        Contact conList = [SELECT Id, Name FROM Contact WHERE Name =: testName LIMIT 1];
        
        if(conList != NULL)
        {
            System.assertEquals(con.Name,acc.Name);
            delete conList;
        }
        
        insert acc;
        
    }
}