public class FutureMethodDemo {

    public FutureMethodDemo()
    {
        takeShower();
        haveBreakfast();
        carService();
        watchingMovie();
    }
    
    public static void takeShower()
    {
        System.debug('I am taking shower');
    }
    
    public static void haveBreakfast()
    {
        System.debug('I am having breakfast');
    }
   
    @future
    public static void carService()
    {
        System.debug('Car is being repaired');
    }
    
    public static void watchingMovie()
    {
        System.debug('I am watching movie');
    }
}