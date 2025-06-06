public class StudentTriggerHandler {
    
	public static void updateStudentCountOnClass(List<Student__c> stuList)
    {
        Set<Id> stuIds = new Set<Id>();
        for(Student__c stu : stuList)
        {
            if(stu.Class__c != null)
            {
                stuIds.add(stu.Class__c);
			}
        }
        
        List<Class__c> classList = [SELECT Id,Number_of_Students__c, (SELECT Id FROM Students__r) FROM Class__c WHERE Id IN:stuIds];
        
        for(Class__c cls : classList)
        {
            cls.Number_of_Students__c = cls.Students__r.size();
        }
        
        if(!classList.isEmpty())
        {
            update classList;
        }
    }
    
    public static void afterStudentDeletion(List<Student__c> stuList)
    {
        Set<Id> stuIds = new Set<Id>();
        for(Student__c stu : stuList)
        {
            if(stu.Class__c != null)
            {
                stuIds.add(stu.Class__c);
			}
        }
        
        List<Class__c> classList = [SELECT Id,Number_of_Students__c, (SELECT Id FROM Students__r) FROM Class__c WHERE Id IN:stuIds];
        
        for(Class__c cls : classList)
        {
            cls.Number_of_Students__c = cls.Students__r.size();
        }
        
        if(!classList.isEmpty())
        {
            update classList;
        }
    }
    
    public static void afterStudentUpdation(List<Student__c> studList, Map<Id,Student__c> studMap)
    {
        Set<Id> stuIds = new Set<Id>();
        
        for(Student__c stu : studList)
        {
            if(stu.Class__c != studMap.get(stu.Id).Class__c)
            {
                stuIds.add(studMap.get(stu.Id).Class__c);
            }
        }
        
        List<Class__c> classList = [SELECT Id, Number_of_Students__c,(SELECT Id FROM Students__r) FROM Class__c WHERE Id IN:stuIds];
        
        for(Class__c cls : classList)
        {
            cls.Number_of_Students__c = cls.Students__r.size();
        }
        
        if(!classList.isEmpty())
        {
            update classList;
        }
    }
}