public with sharing class ResourceReservationTriggerHandler extends TriggerHandler implements ITriggerHandler {

    private Map<Id, Resource_reservation__c> newMap;
    private Map<Id, Resource_reservation__c> oldMap;
    private List<Resource_reservation__c> triggerNew;
    private List<Resource_reservation__c> triggerOld;
    
    public ResourceReservationTriggerHandler() {
        this.newMap = (Map<Id,Resource_reservation__c >) Trigger.newMap;
        this.oldMap = (Map<Id, Resource_reservation__c>) Trigger.oldMap;
        this.triggerNew = (List<Resource_reservation__c>) Trigger.New;
        this.triggerOld = (List<Resource_reservation__c>) Trigger.Old;
    }
    
    public static Boolean TriggerDisabled = false;
    
    public Boolean isDisabled() {
        return TriggerDisabled;
    }
    
    public override void beforeInsert() {
       Exercise5.CheckReservations(this.triggerNew, null);
    }

    public override void beforeUpdate() {
       Exercise5.CheckReservations(this.triggerNew, this.oldMap);
    }
    
    public override void beforeDelete() {}
    public override void afterInsert() {}
    public override void afterUpdate() {}
    public override void afterDelete() {}
    public override void afterUnDelete() {}
}