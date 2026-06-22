@isTest
private class Exercise2Test {

    @isTest
    static void testContactCountingLogic() {
        // 1. Setup Test Accounts
        Account testAcc1 = new Account(Name = 'Test Account 1');
        Account testAcc2 = new Account(Name = 'Test Account 2');
        insert new List<Account>{testAcc1, testAcc2};
        
        List<Contact> testContacts = new List<Contact>();
        
        // Match Criteria 1: FirstName is null (Should be counted)
        testContacts.add(new Contact(LastName = 'Jones', AccountId = testAcc1.Id)); 
        
        // Match Criteria 2: LastName is Smith (Should be counted)
        testContacts.add(new Contact(FirstName = 'John', LastName = 'Smith', AccountId = testAcc1.Id)); 
        
        // Does NOT Match Criteria: Both names filled, not Smith (Should NOT be counted)
        testContacts.add(new Contact(FirstName = 'Alex', LastName = 'Doe', AccountId = testAcc1.Id)); 
        
        // 2. Test Insert Execution
        Test.startTest();
        insert testContacts;
        Test.stopTest();
        
        // Verify Account 1 has exactly 2 matching contacts
        Account updatedAcc1 = [SELECT contact_count__c FROM Account WHERE Id = :testAcc1.Id];
        System.assertEquals(2, updatedAcc1.contact_count__c, 'Account 1 should find 2 matching contacts after insertion.');
        
        // 3. Test Update Execution (Change 'Alex Doe' to 'Alex Smith' -> matches criteria now)
        testContacts[2].LastName = 'Smith';
        update testContacts[2];
        
        // Verify Account 1 count scales up to 3
        updatedAcc1 = [SELECT contact_count__c FROM Account WHERE Id = :testAcc1.Id];
        System.assertEquals(3, updatedAcc1.contact_count__c, 'Account 1 count should increase to 3 after name change.');
        
        // 4. Test Account Swap Execution (Move 'John Smith' from Account 1 over to Account 2)
        testContacts[1].AccountId = testAcc2.Id;
        update testContacts[1];
        
        // Verify Account 1 drops down from 3 to 2
        updatedAcc1 = [SELECT contact_count__c FROM Account WHERE Id = :testAcc1.Id];
        System.assertEquals(2, updatedAcc1.contact_count__c, 'Account 1 count should decrease after losing a contact.');
        
        // Verify Account 2 scales up from 0 to 1
        Account updatedAcc2 = [SELECT contact_count__c FROM Account WHERE Id = :testAcc2.Id];
        System.assertEquals(1, updatedAcc2.contact_count__c, 'Account 2 count should increase after gaining a contact.');
    }
}