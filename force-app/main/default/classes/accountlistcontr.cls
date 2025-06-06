public class accountlistcontr {

    public ApexPages.StandardSetController acct
    {    
        get{
            if(acct==null)
            {
                acct = new ApexPages.StandardSetController(Database.getQueryLocator([select name,AccountNumber from Account]));
            }
            return acct;
        }
        set;
    }

    public List<Account> getAccounts() {
        return (List<Account>)acct.getRecords();
    }

}