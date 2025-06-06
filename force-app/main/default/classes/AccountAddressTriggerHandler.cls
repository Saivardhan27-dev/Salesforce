public class AccountAddressTriggerHandler {
	
    public static void AccountAddressBeforeUpdate(List<Account> newAccounts)
    {
       	for(Account a : newAccounts)
        {
            if(a.Match_Billing_Address__c == true && a.BillingPostalCode != null)
            {
                a.ShippingPostalCode = a.BillingPostalCode;
            }
        }
    }
}