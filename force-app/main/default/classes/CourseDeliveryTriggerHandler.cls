public class CourseDeliveryTriggerHandler {

    private static Set<Date> allHolidays = new Set<Date>();

    static {
        for (Holiday h : [SELECT ActivityDate FROM Holiday]) {
            allHolidays.add(h.ActivityDate);
        }
    }

    public static void preventInvalidCourseDeliveries(List<Course_Delivery__c> newCourseDeliveryList,
                                                      Map<ID, Course_Delivery__c> oldCourseDeliveryMap) {
        
        for (Course_Delivery__c cd : newCourseDeliveryList) {
            if (oldCourseDeliveryMap == null || oldCourseDeliveryMap.get(cd.Id)?.Start_Date__c != cd.Start_Date__c) {   
                if ( allHolidays.contains(cd.Start_Date__c) ) {
                    
                    // 1. Throw the page validation error
                    cd.Start_Date__c.addError('The course start date cannot fall on a holiday.');
                    
                    // 2. TODO #1: Create and publish the Platform Event immediately
                    Error_Message__e evt = new Error_Message__e();
                    evt.Source_Component__c = 'CourseDeliveryTriggerHandler';
                    evt.Error_Message__c = 'Attempted to schedule course on holiday: ' + cd.Start_Date__c;
                    
                    EventBus.publish(evt);
                }
            }
        }
    }
}