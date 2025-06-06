public class CreateContactQueueable implements Queueable{
	
    private List<Account> storingAccounts;
    
    public CreateContactQueueable(List<Account> accountsFromTrigger)
    {
        this.storingAccounts = accountsFromTrigger;
    }
    
    public void execute(QueueableContext qCont)
    {
        List<Contact> conList = new List<Contact>();
        
        for(Account acc:storingAccounts)
        {
            Contact con = new Contact();
            con.lastName = acc.Name;
            con.AccountId = acc.Id;
			conList.add(con);            
        }
        
        if(conList.size() > 0)
        {
            insert conList;
        }
    }
}