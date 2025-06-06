public class PositionTriggerHandler {
	
    public static void createTask(List<Position__c> positionList)
    {
        List<Task> taskList = new List<Task>();
        User testUser = [SELECT Id FROM User WHERE Alias = 'tuser' LIMIT 1];
        Id testUserId = testUser.Id;
        for(Position__c pos : positionList)
        {
            if(pos.Status__c == 'New Position')
            {
                Task t = new Task();
                t.Subject = 'Follow up';
                t.ActivityDate = System.TODAY() + 7;
                t.WhatId = pos.Id;
                t.Status = 'Not Started';
                t.OwnerId = testUserId;
                
                taskList.add(t);
            }
        }
        
        if(!taskList.isEmpty())
        {
            insert taskList;
        }
    }
}