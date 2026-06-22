@isTest
private class CompetitorTriggerTest {

    @isTest
    static void testPart1_PreventDuplicateOpportunityCompetitor() {
        // 1. Setup Test Environment Data
        Account testAcc = new Account(Name = 'Test Competitor Account Alpha');
        insert testAcc;

        Opportunity testOpp = new Opportunity(
            Name = 'Test Sync Opp',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30)
        );
        insert testOpp;

        // 2. Insert the first competitor
        Competitor__c comp1 = new Competitor__c(
            Account__c = testAcc.Id,
            Opportunity__c = testOpp.Id
        );
        
        Test.startTest();
        insert comp1; 
        
        // 3. Attempt to insert a duplicate competitor
        Competitor__c comp2 = new Competitor__c(
            Account__c = testAcc.Id,
            Opportunity__c = testOpp.Id
        );

        try {
            insert comp2;
            System.assert(false, 'The trigger should have blocked this duplicate record.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('This account is already related to an opportunity'), 
                'Expected duplicate validation error, but got: ' + e.getMessage());
        }
        Test.stopTest();
    }

    // =========================================================================
    // TEST 2: Verifies Part 2 auto-replicates Quote Competitors to Opportunities
    // =========================================================================
    @isTest
    static void testPart2_SyncQuoteCompetitorToOpportunity() {
        // 1. Setup Test Environment Data
        Account testAcc = new Account(Name = 'Test Competitor Account Beta');
        insert testAcc;

        Opportunity testOpp = new Opportunity(
            Name = 'Test Sync Opp 2',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30)
        );
        insert testOpp;

        // Setup mock product and standard pricebook entry to satisfy Quote standard requirements
        Id stdPricebookId = Test.getStandardPricebookId();
        
        Product2 testProduct = new Product2(
            Name = 'Test Mock Product', 
            IsActive = true
        );
        insert testProduct;

        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = stdPricebookId,
            Product2Id = testProduct.Id,
            UnitPrice = 100,
            IsActive = true
        );
        insert pbe;

        testOpp.Pricebook2Id = stdPricebookId;
        update testOpp;

        // Create the test parent Quote
        Quote testQuote = new Quote(
            Name = 'Test Sync Quote',
            OpportunityId = testOpp.Id,
            Pricebook2Id = stdPricebookId
        );
        insert testQuote;

        // Query the Quote back from the database to ensure its relationship bindings are complete
        Quote refreshedQuote = [SELECT Id, OpportunityId FROM Quote WHERE Id = :testQuote.Id LIMIT 1];

        // 2. Create a competitor directly on the freshly queried Quote
        Competitor__c quoteComp = new Competitor__c(
            Account__c = testAcc.Id,
            Quote__c = refreshedQuote.Id
        );

        // 3. Fire the execution blocks
        Test.startTest();
        insert quoteComp;
        Test.stopTest(); // FIX: The code must complete and stop before we run database queries!

        // 4. Query the database to verify CompetitorSyncService created the matching Opp Competitor
        List<Competitor__c> oppCompetitors = [
            SELECT Id, Account__c, Opportunity__c 
            FROM Competitor__c 
            WHERE Opportunity__c = :testOpp.Id 
              AND Quote__c = null
        ];

        // Assert checks to verify the background sync completed successfully
       System.assertEquals(1, oppCompetitors.size(), 'An Opportunity competitor should have been automatically created.');
        System.assertEquals(testAcc.Id, oppCompetitors[0].Account__c, 'The automatically created competitor should point to the correct Account.');
    }
}