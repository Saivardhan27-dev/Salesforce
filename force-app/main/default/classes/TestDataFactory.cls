@isTest
public class TestDataFactory {

    public static void createAccount()
    {
        Account acc = new Account();
        acc.Name = 'Batch Class Demo';
        acc.Phone = '0987897678';
        acc.Industry = 'Banking';
        
        insert acc;
    }
}