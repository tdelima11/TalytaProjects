trigger PropertyAddress on pba__Property__c (after insert) {

    PropertyAddressTriggerHandler.manageProperties(trigger.new);
}