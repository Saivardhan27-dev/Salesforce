trigger ContactTriggerEx2 on Contact (before insert, before update) {

    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate))
    {
        for(Contact con : Trigger.new)
        {
            if(con.Email == null)
            {
                con.Email.addError('Email is mandatory');
            }
            
            if(con.Phone == null)
            {
                con.Phone.addError('Phone is mandatory');
            }
        }
    }
}