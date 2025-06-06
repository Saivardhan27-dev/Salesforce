public class StringListTest {
    
	public static List<String> generateStringList(Integer numOfStrings)
    {
        List<String> stringsList = new List<String>();
        for(Integer i=0;i<numOfstrings;i++)
        {
            stringsList.add('Test '+i);
        }
        return stringsList;
    }
}