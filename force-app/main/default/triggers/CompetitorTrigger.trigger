trigger CompetitorTrigger on Competitor__c (before insert, before update, after insert, after update) {
    // This allows your handler framework to run during all phases of the record lifecycle!
    new CompetitorTriggerHandler().run(); 
}