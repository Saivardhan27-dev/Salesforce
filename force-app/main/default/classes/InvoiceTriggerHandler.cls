public with sharing class InvoiceTriggerHandler {
    /***************
     * @description
     * When an invoice is inserted, auotmatically create a related payment record
     * with status 'Pending' and the same amount as the invoice.
     * Also, in before insert, throw an error if the invoice amount is less than or equal to zero.
     ****************/
    public static void checkIfAmountLessThanZero(List<Invoice> invoiceRecords) {
        if(!invoiceRecords.isEmpty()){
            for(Invoice inv : invoiceRecords){
                if(inv.Amount <= 0){
                    inv.addError('Invoice amount must be greater than zero.');
                }
            }
        }
    }

    public static void createPaymentUponInvoiceCreation(List<Invoice> invoiceRecords){
        List<Payment> paymentList = new List<Payment>();
        if(!invoiceRecords.isEmpty()){
            for(Invoice inv : invoiceRecords){
                Payment payment = new Payment();
                payment.Invoice__c = inv.Id;
                payment.Amount = inv.Amount;
                payment.Status__c = 'Pending';
                payment.DueDate__c = inv.Due_Date__c;
                paymentList.add(payment);
            }
        }

        if(!paymentList.isEmpty()){
            try{
                insert paymentList;
            }catch(DmlException e){
                System.debug('Error inserting payment records: ' + e.getMessage());
            }
        }
    }
}