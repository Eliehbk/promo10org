public with sharing class OfferTriggerHandler extends TriggerHandler implements ITriggerHandler {

    private Map<Id, Offer__c> newMap;
    private Map<Id, Offer__c> oldMap;
    private List<Offer__c> triggerNew;
    private List<Offer__c> triggerOld;
    
    public OfferTriggerHandler() {
        this.newMap = (Map<Id, Offer__c>) Trigger.newMap;
        this.oldMap = (Map<Id, Offer__c>) Trigger.oldMap;
        this.triggerNew = (List<Offer__c>) Trigger.New;
        this.triggerOld = (List<Offer__c>) Trigger.Old;
    }
    
    public static Boolean TriggerDisabled = false;
    
    public Boolean isDisabled() {
        return TriggerDisabled;
    }
    
    public override void beforeInsert() {
        Exercise4.generateOfferIdentifiers(this.triggerNew, null);
    }

    public override void beforeUpdate() {
        Exercise4.generateOfferIdentifiers(this.triggerNew, this.oldMap);
    }
    
    public override void beforeDelete() {}
    public override void afterInsert() {}
    public override void afterUpdate() {}
    public override void afterDelete() {}
    public override void afterUnDelete() {}
}