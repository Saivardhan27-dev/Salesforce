/**
 * @description       : 
 * @author            : Sai Vardhan Marupalla
 * @group             : 
 * @last modified on  : 07-27-2025
 * @last modified by  : Sai Vardhan Marupalla
**/

/****
 * Problem Statement:- 
 *     We need to archive 'Case' records older than one year to a custom object 'Case_Archive__c'
 *     object nightly. After archiving, the original Case records should be deleted. 
 ****/

global with sharing class CaseArchivalBatch implements Database.Batchable<sObject>, Schedulable{
    
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT Id, Subject, CreatedDate, Status FROM Case WHERE CreatedDate < :Date.TODAY().addYears(-1)]);
    }

    global void execute(Database.BatchableContext bc, List<Case> scope){

        List<Case_Archive__c> archivedCases = new List<Case_Archive__c>();
        for(Case c : scope){
            Case_Archive__c archivedCase = new Case_Archive__c();
            archivedCase.Original_Case_Id__c = c.Id;
            archivedCase.Subject__c = s.Subject;
            archivedCase.CreatedDate = Date.TODAY();
            archivedCase.Status__c = c.Status;
            archivedCases.add(archivedCase);
        }

        if(!archivedCases.isEmpty()){
            insert archivedCases;
        }
    }

    global void finish(Database.BatchableContext bc){
        List<Case> casesToDelete = [SELECT Id FROM Case WHERE CreatedDate < :Date.TODAY().addYears(-1)];
        if(!casesToDelete.isEmpty()){
            delete casesToDelete;
        }
    }

    global void execute(SchedulableContext sc){
        Database.executeBatch(this, 200);
    }
}