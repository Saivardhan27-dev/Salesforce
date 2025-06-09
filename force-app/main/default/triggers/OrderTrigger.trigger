trigger OrderTrigger on Order (after insert) {
    OrderTriggerHandler.createDevileryUponOrderCreation(Trigger.new);
}