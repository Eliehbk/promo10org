public with sharing class AccountOppController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountList() {
        return [
            SELECT Id, Name 
            FROM Account 
            WITH SECURITY_ENFORCED 
            ORDER BY Name ASC 
            LIMIT 50
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOppsByAccount(Id accountId) {
        if (accountId == null) {
            return new List<Opportunity>();
        }
        return [
            SELECT Id, Name, StageName, Amount 
            FROM Opportunity 
            WHERE AccountId = :accountId 
            WITH SECURITY_ENFORCED
            ORDER BY CloseDate DESC
            LIMIT 50
        ];
    }
}