public class Exercise2 {
    public static void countContactOccurences(List<Contact> triggerNew, Map<Id, Contact> oldMap) {
        Set<Id> accountIds = new Set<Id>();
        
        // 1. Loop and filter to gather Account IDs (Same as your working trigger)
        for (Contact c : triggerNew) {
            if (oldMap == null) {
                if (c.AccountId != null) {
                    accountIds.add(c.AccountId);
                }
            } else {
                Contact oldContact = oldMap.get(c.Id);
                if (c.AccountId != oldContact.AccountId || 
                    c.FirstName != oldContact.FirstName || 
                    c.LastName != oldContact.LastName) {
                    
                    if (c.AccountId != null) {
                        accountIds.add(c.AccountId);
                    }
                    if (c.AccountId != oldContact.AccountId && oldContact.AccountId != null) {
                        accountIds.add(oldContact.AccountId);
                    }
                }
            }
        }
        
        // 2. Execute calculation if Account IDs exist
        if (!accountIds.isEmpty()) {
            updateAccountCounters(accountIds);
        }
    }

    private static void updateAccountCounters(Set<Id> accountIds) {
        List<Account> accountsToUpdate = new List<Account>();
        
        // 3. Simple Parent-to-Child Subquery
        // We fetch the accounts and filter their nested contacts directly inside the query
        List<Account> accountsWithContacts = [
            SELECT Id, contact_count__c, 
                   (SELECT Id FROM Contacts WHERE FirstName = null OR LastName = 'Smith') 
            FROM Account 
            WHERE Id IN :accountIds
        ];
        
        // 4. Calculate total count by checking the size of the inner list
        for (Account acc : accountsWithContacts) {
            // .size() gets the precise count of the matching records returned in the subquery
            acc.contact_count__c = acc.Contacts.size(); 
            accountsToUpdate.add(acc);
        }
        
        // 5. Commit to database
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}