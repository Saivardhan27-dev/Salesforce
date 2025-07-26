/**
 * @description       : 
 * @author            : Sai Vardhan Marupalla
 * @group             : 
 * @last modified on  : 07-26-2025
 * @last modified by  : Sai Vardhan Marupalla
**/
public with sharing class LeadTriggerHandler1 {

    public static void updateLeadNameOnAccCon(List<Lead> leadRecords, Map<Id, Lead> oldMap){
        
        Set<Id> covertedLeadIds = new Set<Id>();
        List<Account> accountsToUpdate = new List<Account>();
        List<Contact> contactsToUpdate = new List<Contact>();

        for(Lead leadRec : leadRecords){
            if(leadRec.IsConverted == true && leadRec.ConvertedAccountId != null && oldMap.get(leadRec.Id).IsConverted == false && oldMap.get(leadRec.Id).ConvertedAccountId == null){
                covertedLeadIds.add(leadRec.Id);
            }
        }

        if(!covertedLeadIds.isEmpty()){
            for(Lead lead : [SELECT Id, ConvertedAccountId, ConvertedContactId, Name FROM Lead WHERE Id IN : covertedLeadIds]){
                if(lead.ConvertedAccountId != null){
                    Account acc = new Account();
                    Id = lead.ConvertedAccountId;
                    Description = 'Converted Lead Id : '+ lead.Id + ' Name : ' + lead.Name;
                    accountsToUpdate.add(acc);
                }

                if(lead.ConvertedContactId != null){
                    Contact con = new Contact();
                    con.Id = lead.ConvertedContactId;
                    con.Description = 'Converted Lead Id : ' + lead.Id + ' Name : ' + lead.Name;
                    contactsToUpdate.add(con);  
                }
            }
        }

        if(!accountsToUpdate.isEmpty()){
            update accountsToUpdate;
        }
        
        if(!contactsToUpdate.isEmpty()){
            update contactsToUpdate;
        }
    }
}