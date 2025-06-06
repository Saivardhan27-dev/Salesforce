public class CaseTriggerHandler {
	public static void handleBeforeDelete(List<Case> oldRecords)
    {
        Id currentUserProfileId = UserInfo.getProfileId();
        Id sysAdminProfileId = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;
        
        for(Case casRec : oldRecords)
        {
            if(currentUserProfileId != sysAdminProfileId)
            {
                casRec.addError('You dont have permission to delete Case. Contact your System Administrator');
            }
        }
    }
}