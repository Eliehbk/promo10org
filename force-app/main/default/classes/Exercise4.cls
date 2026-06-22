public with sharing class Exercise4 {
    
    public static void generateOfferIdentifiers(List<Offer__c> newOffers, Map<Id, Offer__c> oldMap) {
        // Sets and Lists to collect data for bulk processing
        Set<Id> targetOppIds = new Set<Id>();
        List<Offer__c> offersToProcess = new List<Offer__c>();

        // 1. Loop through all incoming records to identify which Offers are new or have shifted Opportunities
        for (Offer__c offer : newOffers) {
            // If oldMap is null, it means this is an INSERT transaction (brand new records)
            Boolean isNew = (oldMap == null);
            
            // If it's an UPDATE, check if the current Opportunity ID is different from its database state before the save
            Boolean oppChanged = (!isNew && offer.Opportunity__c != oldMap.get(offer.Id).Opportunity__c);

            // Only process records that are brand new OR have been reparented to a different Opportunity
            if (isNew || oppChanged) {
                // Ensure the Opportunity lookup field actually has a value to avoid errors
                if (offer.Opportunity__c != null) {
                    targetOppIds.add(offer.Opportunity__c); // Collect the Parent Opportunity ID for our database query
                    offersToProcess.add(offer);             // Add the Offer record to our filtered list for stamping
                }
            }
        }

        // Optimization: If no records passed our filters, exit the method early to save processing time
        if (offersToProcess.isEmpty()) {
            return;
        }

        // 2. Run a bulk query to fetch parent Opportunity details along with their CURRENT child counts from the database
        // The subquery (SELECT Id FROM Offers__r) retrieves all existing historical offers under each Opportunity
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>([
            SELECT Id, Identifier__c, (SELECT Id FROM Offers__r) 
            FROM Opportunity 
            WHERE Id IN :targetOppIds
        ]);

        // 3. Create an in-memory counter table (Scoreboard) to prevent same-batch duplicates during bulk inserts
        Map<Id, Integer> oppCurrentCountMap = new Map<Id, Integer>();
        for (Id oppId : oppMap.keySet()) {
            // Find how many historical offers already exist under this Opportunity and store it as the starting count
            oppCurrentCountMap.put(oppId, oppMap.get(oppId).Offers__r.size());
        }

        // 4. Calculate and stamp the custom identifier format on our filtered records
        for (Offer__c offer : offersToProcess) {
            // Pull the queried parent Opportunity data using the current Offer's lookup ID
            Opportunity parentOpp = oppMap.get(offer.Opportunity__c);
            
            // Ensure the parent Opportunity exists and its 3-digit Identifier__c is populated
            if (parentOpp != null && parentOpp.Identifier__c != null) {
                // Look up the current incremental number from our in-memory scoreboard map
                Integer currentCount = oppCurrentCountMap.get(offer.Opportunity__c);
                
                // Format the counter dynamically: convert the number to text and pad it with zeroes on the left up to 3 digits
                // (e.g., converts number 0 to string "000", number 12 to "012")
                String paddedCount = String.valueOf(currentCount).leftPad(3, '0');
                
                // Combine the parent Identifier prefix with the padded count (e.g., "EIT" + "-" + "000") and stamp it on the Offer
                offer.Identifier__c = parentOpp.Identifier__c + '-' + paddedCount;
                
                // CRUCIAL: Add 1 to the counter and update our in-memory scoreboard.
                // If the next Offer in this loop belongs to the same Opportunity, it will read this updated number (e.g., "001")
                oppCurrentCountMap.put(offer.Opportunity__c, currentCount + 1);
            }
        }
    }
}