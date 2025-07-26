/**
 * @description       : 
 * @author            : Sai Vardhan Marupalla
 * @group             : 
 * @last modified on  : 07-26-2025
 * @last modified by  : Sai Vardhan Marupalla
**/

/****
 * Problem Statement:- 
 *     After a Lead is converted successfully, Account and Contact records are created. 
 *     You need to update the Description field of both the Account and the Contact with the original Lead’s Id and Name.
 ****/



trigger LeadTrigger1 on Lead (after update){
    if(Trigger.isUpdate && Trigger.isAfter){
        LeadTriggerHandler1.updateLeadNameOnAccCon(Trigger.new, Trigger.oldMap);
    }
}

