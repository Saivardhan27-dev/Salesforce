public class TaskTriggerHandler {
	
   public static void preventDeletionOfTask(List<Task> taskRecords){
      String profileName = [SELECT Profile.Name FROM User WHERE Id = :UserInfo.getUserId()].Profile.Name;

      for(Task tsk : taskRecords){
         if(profileName != 'System Administrator'){
            tsk.addError('You dont have permission to delete this task. Please contact your system administrator.');
         }
      }
   }

   /**********
    * Description:
    * When a Task is created and marked as "Call" type, update the related Lead’s Status to "Contacted" — 
    * but only if the Lead is not already in that status.
    **********/
   public static void setLeadStatusToContacted(List<Task> taskRecords){
      Set<Id> leadIds = new Set<Id>();
      for(Tasl tsk : taskRecords){
         if(tsk.WhoId != null && tsk.Type == 'Call' && tsk.WhoId.startsWith('00Q')){
            leadIds.add(tsk.WhoId);
         }
      }

      List<Lead> leadsToUpdate = [SELECT Id, Status FROM Lead WHERE Id IN:leadIds AND Status != 'Contacted'];
      if(!leadRecords.isEmpty()){
         for(Lead ld : leadsToUpdate){
            ld.Status = 'Contacted';
         }
      }

      if(!leadRecords.isEmpty()){
         try{
            update leadRecords;
         }catch(Exception e){
            System.debug('Error while updating lead records ' + e.getMessage());
         }
      }
	
   }
}