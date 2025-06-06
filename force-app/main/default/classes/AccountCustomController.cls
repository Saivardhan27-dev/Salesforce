public class AccountCustomController {

    public PageReference savetheRecord() {
        update account;
        return null;
    }

   
    public final Account account;
    public AccountCustomController()
    {
        account = [select id,Name,Site from Account where Id=: ApexPages.currentPage().getParameters().get('id')];
    }
    
    public Account getAccount(){
        return account;
    }
    
}