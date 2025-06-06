@isTest
public class accountPrefix {
	@isTest
    public static void testPrefix()
    {
        Account acc = new Account(Name = 'Vardhan');
        acc.Name = 'Mr. '+acc.Name;
        insert acc;
    }
}