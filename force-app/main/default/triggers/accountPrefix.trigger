//Scenario 2 :
//Write a trigger to prefix Account Name with 'Mr.' whenever a new record is inserted.

trigger accountPrefix on Account (before insert) {
    for(Account acc : Trigger.new)
    {
        acc.Name = 'Mr. '+acc.Name;
    }
}