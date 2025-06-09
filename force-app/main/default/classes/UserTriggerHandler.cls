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

    /***************
     * @description
     * When a User's role is changed, log the old and new roles in a custom object called UserChangeHistory__c.
     * This should only happen when the UserRoleId is changed.
     ****************/
    public static void createUserChangeHistortyUponRoleChange(List<User> newUserRecords, Map<Id,User> oldMapRecords){

        List<UserChangeHistory__c> userChangeHistoryList = new List<UserChangeHistory__c>();
        if(!newUserRecords.isEmpty()){
            for(User newUser : newUserRecords){
                if(newUser.UserRoleId != oldMapRecords.get(newUser.Id).UserRoleId){
                    UserChangeHistory__c userChangeRecord = new UserChangeHistory__c();
                    userChangeRecord.User__c = newUser.Id;
                    userChangeRecord.Old_Role__c = oldMapRecords.get(newUser.Id).UserRoleId;
                    userChangeRecord.New_Role__c = newUser.UserRoleId;
                    userChangeRecord.Changed_By__c = UserInfo.getUserId();
                    userChangeRecord.Changed_Timestamp__c = System.now();
                    userChangeHistoryList.add(userChangeRecord);
                }
            }
        }

        if(!userChangeHistoryList.isEmpty()){
            try{
                insert userChangeHistoryList;
            }catch(DmlException e){
                System.debug('Error inserting user change history records: ' + e.getMessage());
            }
        }
    }
}