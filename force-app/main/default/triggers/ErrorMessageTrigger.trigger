trigger ErrorMessageTrigger on Error_Message__e (after insert) {

    List<Error_Log__c> errs = new List<Error_Log__c>();
    
    // TODO #1: Loop through trigger.new and create Error_Log__c records 
    // for each platform event and add to the errs list
    for (Error_Message__e event : Trigger.new) {
        Error_Log__c log = new Error_Log__c();
        log.Source__c = event.Source_Component__c;
        log.Message__c = event.Error_Message__c;
        
        errs.add(log);
    }
     
    if (!errs.isEmpty()) {
        insert errs;
    }
}