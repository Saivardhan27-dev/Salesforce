//Scenario 3 :
//Whenever a new record is created in account object. Before this new record is inserted into Account, 
//delete all the contacts records with this account name.

trigger contactDeletion on Account (before insert) {
    List<String> accNamesList = new List<String>();
    
    for(Account acc: Trigger.new)
    {
        accNamesList.add(acc.Name);
    }
    
    List<Contact> delContacts = [SELECT Id, Name FROM Contact WHERE Name IN: accNamesList];
    
    delete delContacts;
}