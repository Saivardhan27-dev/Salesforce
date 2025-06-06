@isTest
public class MyIterableTest {
	
    @IsTest 
    static void testIterableForLoop()
    {
        List<String> strings = new List<String>{'Hello','World'};
        
        MyIterable myItr = new MyIterable(strings);
        
        for(String str : myItr)
        {
            System.debug(str);
        }
    }
}