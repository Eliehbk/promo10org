public with sharing class CompetitorSyncService {
    public static void assignCompetitorToAccount(List<Competitor__c> newList, Map<Id,Competitor__c> oldMap){

        // BULK FIX: Group your competitors into lists so they don't overwrite each other during trigger phases
        Map<Id, List<Competitor__c>> quoteIdToCompetitorsMap = new Map<Id, List<Competitor__c>>();

        // Looping over the new list of competitors
        for(Competitor__c comp : newList){

            // If old map is null or quote has been changed and the quote and account are filled in
            if((oldMap == null || oldMap.get(comp.Id).Quote__c != comp.Quote__c) && comp.Quote__c != null && comp.Account__c != null){

                // Initialize the nested list if this Quote ID is new to the map
                if(!quoteIdToCompetitorsMap.containsKey(comp.Quote__c)){
                    quoteIdToCompetitorsMap.put(comp.Quote__c, new List<Competitor__c>());
                }
                // Add the competitor to the matching Quote tracking group
                quoteIdToCompetitorsMap.get(comp.Quote__c).add(comp);
            }
        }

        // If the map is not empty
        if(!quoteIdToCompetitorsMap.isEmpty()){

            // The competitor list that will be inserted
            List<Competitor__c> compList = new List<Competitor__c>();

            // Query the quotes and explicitly retrieve the parent Opportunity details
            for(Quote quote : [SELECT Id, OpportunityId FROM Quote WHERE Id IN :quoteIdToCompetitorsMap.keySet()]){

                // Grab all competitors tied to this specific Quote row
                List<Competitor__c> relatedComps = quoteIdToCompetitorsMap.get(quote.Id);

                if (relatedComps != null) {
                    for (Competitor__c originalComp : relatedComps) {
                        
                        // Create the matching Opportunity competitor record safely
                        Competitor__c comp = new Competitor__c(); 
                        comp.Account__c = originalComp.Account__c;
                        comp.Opportunity__c = quote.OpportunityId;
                        
                        // Note: comp.Name line omitted because the field is an Auto-Number handled by your org settings!

                        compList.add(comp);
                    }
                }
            }

            // Execute the copy database insert safely
            if(!compList.isEmpty()){
                Database.insert(compList, false);
            }
        }
    }
}