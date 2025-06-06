public class InvokeAccFromFlowToDelOpps {
	
    @InvocableMethod(label='Delete Related Opportunities'
                    description = 'Delete Related Opportunities for the given Record Ids'
                    category = 'Account')
    public static void deleteOpportunities(List<String> Ids)
    {
        List<Opportunity> oppList = [SELECT ID FROM Opportunity WHERE AccountID =: Ids AND StageName = 'Closed Won'];
        delete oppList;
    }
}