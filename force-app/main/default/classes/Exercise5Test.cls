@isTest
public with sharing class Exercise5Test {

@testSetup
    static void setupData() {
         Resource_reservation__c res1 = new Resource_reservation__c(
            start_date__c = Datetime.valueOf('2026-06-19 14:30:00'),
            end_date__c = Datetime.valueOf('2026-06-19 16:30:00'),
            reserved_resources__c = 'room1',
            	description__c = 'ghgh',
                Name='res1'
        );
        insert res1; 
    }

    @isTest
     static void testSingleOfferInsertion() {
         
        Resource_reservation__c res2 = new Resource_reservation__c(
            start_date__c = Datetime.valueOf('2026-06-19 17:21:00'),
            end_date__c = Datetime.valueOf('2026-06-19 18:30:00'),
            reserved_resources__c = 'room1',
            	description__c = 'hghg',
                Name='res2'
        );
        
        Test.startTest();
         insert res2;
        Test.stopTest();

 Resource_reservation__c targetResources = [SELECT Id, start_date__c, end_date__c,reserved_resources__c,description__c,Name FROM Resource_reservation__c LIMIT 1];

        Test.startTest();
        targetResources.Name = 'Updated Name';
        update targetResources; 
        Test.stopTest();

 Resource_reservation__c updatedAccount = [SELECT Id, start_date__c, end_date__c,reserved_resources__c,description__c,Name FROM Resource_reservation__c WHERE Id = :targetResources.Id];

    }
}