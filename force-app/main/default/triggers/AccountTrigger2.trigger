/**
 * @description       : 
 * @author            : Sai Vardhan Marupalla
 * @group             : 
 * @last modified on  : 07-27-2025
 * @last modified by  : Sai Vardhan Marupalla
**/

/****
 * Problem Statement:- 
 *     In the Account object, how would you prevent creation of duplicate accounts based on a 
 *     custom field 'GST_Number__c' field using Apex?
 ****/


trigger AccountTrigger2 on Account (before insert) {
    if(Trigger.isInsert && Trigger.isBefore) {
        AccountTrigger2Handler.findDuplicateBasedOnGST(Trigger.new);
    }
}