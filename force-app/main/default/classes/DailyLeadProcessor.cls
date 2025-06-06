public class DailyLeadProcessor implements Schedulable{

    public void execute(SchedulableContext ctx) {
        
        List<Lead> leadLists = [SELECT Id, LeadSource FROM Lead WHERE LeadSource = '' LIMIT 200];
        
        for(Lead l : leadLists){
            l.LeadSource = 'Dreamforce';
        }
        
        update leadLists;
    }
}