trigger InvoiceTrigger on Invoice (before insert,after insert) {
    if(Trigger.isBefore && Trigger.isInsert){
        InvoiceTriggerHandler.checkIfAmountLessThanZero(Trigger.new);
    }

    if(Trigger.isAfter && Trigger.isInsert){
        InvoiceTriggerHandler.createPaymentUponInvoiceCreation(Trigger.new);
    }
}