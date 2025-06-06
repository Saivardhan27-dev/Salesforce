public class TaskTriggerHandler {
	
   public static void preventDeletionOfTask(List<Task> taskRecords)
   {
      String profileName = [SELECT Profile.Name FROM User WHERE Id = :UserInfo.getUserId()].Profile.Name;

      for(Task tsk : taskRecords)
      {
         if(profileName != 'System Administrator')
         {
            tsk.addError('You dont have permission to delete this task. Please contact your system administrator.');
         }
      }
   }
}