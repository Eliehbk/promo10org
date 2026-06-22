public with sharing class CompetitorTriggerHandler extends TriggerHandler implements ITriggerHandler {

    private Map<Id, Competitor__c> newMap;
    private Map<Id, Competitor__c> oldMap;
    private List<Competitor__c> TriggerNew;
    private List<Competitor__c> TriggerOld;
    
    public CompetitorTriggerHandler() {
        this.newMap = (Map<Id, Competitor__c>) Trigger.newMap;
        this.oldMap = (Map<Id, Competitor__c>) Trigger.oldMap;
        this.TriggerNew = (List<Competitor__c>) Trigger.New;
        this.TriggerOld = (List<Competitor__c>) Trigger.Old;
    }
    
    public static Boolean TriggerDisabled = false;
    
    public Boolean isDisabled() {
        return TriggerDisabled;
    }
    
    // BEFORE PHASES: Executes Part 1 (File 1)
    public override void beforeInsert() {
        Exercise3.checkCompetitorLinks(this.TriggerNew, this.oldMap, this.newMap);
    }
    
    public override void beforeUpdate() {
        Exercise3.checkCompetitorLinks(this.TriggerNew, this.oldMap, this.newMap);
    }
    
    // AFTER PHASES: Executes Part 2 (File 2)
    public override void afterInsert() {
       CompetitorSyncService.assignCompetitorToAccount(this.TriggerNew, null);
    }
    
    public override void afterUpdate() {
       CompetitorSyncService.assignCompetitorToAccount(this.TriggerNew, this.oldMap);
    }
    
    public override void beforeDelete() {}
    public override void afterDelete() {}
    public override void afterUnDelete() {}
}