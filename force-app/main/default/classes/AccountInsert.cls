@isTest
public class AccountInsert 
{
	@isTest
    public static void testInsert()
    {
        String addError;
        String myName = 'Vardhan';
        Account acc = new Account (Name = myName);
        List<Account> listAcc = [SELECT Id, Name FROM Account WHERE Name =: myName];
        if(listAcc.size()<1)
        {
            System.assertEquals(0,listAcc.size());
            insert acc;
        }
        else
        {
            addError = 'Existing';
        }
        System.assertEquals('Existing',addError);
    }
}