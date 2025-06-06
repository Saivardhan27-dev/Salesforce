public class AccountHandler {
	public static Account insertNewAccount(String accName)
    {
        Account acc = new Account(Name = accName);
        try
        {
            insert acc;
        }
        catch(DMLException e)
        {
            return null;
        }
        
        return acc;
    }
}