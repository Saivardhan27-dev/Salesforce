trigger userTrigger on User (after insert) {
    
    if(Trigger.isAfter && Trigger.isInsert)
    {
        Set<Id> userIds = new Set<Id>();
        
        Profile salesProfile = [SELECT Id FROM Profile WHERE Name = 'Custom: Sales Profile' LIMIT 1];
        
        for(User user : Trigger.new)
        {
            if(user.Id == salesProfile.Id)
            {
                userIds.add(user.Id);
            }
        }
        
        if(userIds!=null)
        {
            UserTriggerHandler.assignSalesPermissionSet(userIds);
        }
    }
}