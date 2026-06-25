public with sharing class accountController2 {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
        return [
            SELECT Id, Name, Industry, Phone ,Rating
            FROM Account 
            LIMIT 20
        ];
    }
}