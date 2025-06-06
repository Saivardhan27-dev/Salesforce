public class UserTriggerHandler {
    
    @future
	public static void assignSalesPermissionSet(Set<Id> newUserIds)
    {
        PermissionSet salesUserPermissionSet = [SELECT Id FROM PermissionSet WHERE Name = 'Sales_User_Permissions'];
        
        List<PermissionSetAssignment> psAssignments = new List<PermissionSetAssignment>();
        
        if(salesUserPermissionSet != null)
        {
            for(Id userId : newUserIds)
            {
                psAssignments.add(new PermissionSetAssignment(PermissionSetId = salesUserPermissionSet.Id, AssigneeId = userId));
            }
        }
        
        if(psAssignments!=null)
        {
            insert psAssignments;
        }
    }
}