trigger ContactTriggerEx3 on Contact (before insert,before update) {
    
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate))
    {
        for(Contact con : Trigger.new)
        {
            if(con.AccountId == null)
                con.addError('Please choose account name');
        }
    }
}