public with sharing class OrderTriggerHandler {
    /**************
     * @description
     * When an order is created with the status 'Activated', a delivery record is created.
     * Link the Delivery__c to the Order via a lookup ans set a default Estimated Delivery Date to 7 days from today.
     * Also, set the status of the Delivery__c to 'Scheduled'.
     **************/
    public static void createDevileryUponOrderCreation(List<Order> orderRecords){
        List<Delivery__c> deliveryList = new List<Delivery__c>();
        for(Order order : orderRecords){
            if(order.Status = 'Activated'){
                Delivery__c delivery = new Delivery__c();
                delivery.Order__c = order.Id;
                delivery.Status__c = 'Scheduled';
                delivery.Expected_Delivery_Date__c = System.today().addDays(7);
                deliveryList.add(delivery);
            }
        }

        if(!deliveryList.isEmpty()){
            try{
                insert deliveryList;
            }catch(DmlException e){
                System.debug('Error inserting deliveries: ' + e.getMessage());
            }
        }
    }
}