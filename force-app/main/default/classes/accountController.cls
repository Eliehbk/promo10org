public with sharing class accountController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(Integer limitNumber) {
        if (limitNumber == null || limitNumber <= 0) {
            return new List<Account>();
        }
        
        return [
            SELECT Id, Name, Industry, Phone 
            FROM Account 
            WITH USER_MODE
            LIMIT :limitNumber
        ];
    }
}