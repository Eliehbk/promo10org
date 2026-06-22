@isTest
private class Exercise4Test {

    @isTest
    static void testSingleOfferInsertion() {
        // ARRANGE: Create a parent Opportunity with a 3-digit Identifier
        Opportunity opp = new Opportunity(
            Name = 'Test Opp 1',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            Identifier__c = 'EIT'
        );
        insert opp;

        // ACT: Insert the very first Offer for this Opportunity
        Offer__c firstOffer = new Offer__c(
            Opportunity__c = opp.Id
        );
        
        Test.startTest();
        insert firstOffer;
        Test.stopTest();

        // ASSERT: Verify the identifier was automatically stamped as EIT-000
        Offer__c queriedOffer = [SELECT Identifier__c FROM Offer__c WHERE Id = :firstOffer.Id];
        System.assertEquals('EIT-000', queriedOffer.Identifier__c, 'The first offer should start with index 000');
    }

    @isTest
    static void testBulkOfferInsertion() {
        // ARRANGE: Create a parent Opportunity
        Opportunity opp = new Opportunity(
            Name = 'Bulk Test Opp',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            Identifier__c = 'XYZ'
        );
        insert opp;

        // Create a batch list of 5 brand new offers to insert at the exact same time
        List<Offer__c> bulkOffers = new List<Offer__c>();
        for (Integer i = 0; i < 5; i++) {
            bulkOffers.add(new Offer__c(Opportunity__c = opp.Id));
        }

        // ACT: Execute the bulk database operation
        Test.startTest();
        insert bulkOffers;
        Test.stopTest();

        // ASSERT: Pull all created offers ordered by their system ID/creation sequence
        List<Offer__c> queriedOffers = [SELECT Identifier__c FROM Offer__c WHERE Opportunity__c = :opp.Id ORDER BY Id ASC];
        
        // Verify that the code incremented them sequentially in memory without duplicate numbering
        System.assertEquals(5, queriedOffers.size(), 'All 5 offers should have been saved');
        System.assertEquals('XYZ-000', queriedOffers[0].Identifier__c);
        System.assertEquals('XYZ-001', queriedOffers[1].Identifier__c);
        System.assertEquals('XYZ-002', queriedOffers[2].Identifier__c);
        System.assertEquals('XYZ-003', queriedOffers[3].Identifier__c);
        System.assertEquals('XYZ-004', queriedOffers[4].Identifier__c);
    }

    @isTest
    static void testOfferReparenting() {
        // ARRANGE: Create two distinct parent Opportunities with different identifiers
        Opportunity oppA = new Opportunity(
            Name = 'Opp A',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            Identifier__c = 'AAA'
        );
        Opportunity oppB = new Opportunity(
            Name = 'Opp B',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            Identifier__c = 'BBB'
        );
        insert new List<Opportunity>{oppA, oppB};

        // Insert two initial historical offers under Opportunity BBB so its starting count is 2
        List<Offer__c> historicalOffers = new List<Offer__c>{
            new Offer__c(Opportunity__c = oppB.Id),
            new Offer__c(Opportunity__c = oppB.Id)
        };
        insert historicalOffers; // These will be BBB-000 and BBB-001

        // Insert a brand new offer under Opportunity AAA (Gets stamped as AAA-000)
        Offer__c movingOffer = new Offer__c(Opportunity__c = oppA.Id);
        insert movingOffer;

        // ACT: Change the parent lookup field from Opportunity AAA to Opportunity BBB
        movingOffer.Opportunity__c = oppB.Id;
        
        Test.startTest();
        update movingOffer;
        Test.stopTest();

        // ASSERT: Verify that moving the offer automatically re-triggered the code, 
        // read Opp B's current child count (2), and stamped it with the new sequential index (BBB-002)
        Offer__c checkedOffer = [SELECT Identifier__c FROM Offer__c WHERE Id = :movingOffer.Id];
        System.assertEquals('BBB-002', checkedOffer.Identifier__c, 'The identifier should dynamically recalculate based on the new parent sequence');
    }
}