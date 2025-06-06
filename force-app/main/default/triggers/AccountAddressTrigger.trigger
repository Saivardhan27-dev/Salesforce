trigger AccountAddressTrigger on Account (before update) {
    
    if(Trigger.isBefore && Trigger.isUpdate)
    {
        for(Account a : Trigger.NEW)
        {
            if(a.Match_Billing_Address__c == true && a.BillingPostalCode != null)
            {
                a.ShippingPostalCode = a.BillingPostalCode;
            }
        }
    }
}