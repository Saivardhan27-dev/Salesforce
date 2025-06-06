public class AccountSchedulable implements Schedulable{
	
    public void execute(SchedulableContext sc)
    {
        List<Account> accList = [SELECT Id FROM Account WHERE CreatedDate = TODAY];
        delete accList;
    }
}