public with sharing class accountActionController {
     @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(String filterType) {
         if (filterType=='recent') {return[SELECT Id, Name, Description FROM Account ORDER BY CreatedDate DESC LIMIT 10];}
         if (filterType=='hot'){return[SELECT Id, Name, Description FROM Account WHERE Rating ='Hot' LIMIT 10];}
         return[SELECT Id, Name, Description FROM Account WHERE Phone = NULL LIMIT 10];
    }

    @AuraEnabled
    public static void updateDescription(Id accountId, String descText) {
        update new Account(Id = accountId, Description = descText);
    }
}