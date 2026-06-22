@isTest
private class CourseDeliveryTriggerHandler_Test {

    @testSetup
    private static void testSetupObjectDataFactory() {
        // Run Setup Object creation inside an isolated context
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = [SELECT Id FROM User WHERE profileId = :p.Id LIMIT 1];
        
        System.runAs(u) {
            Test.loadData(Holiday.sObjectType, 'Test_Holidays');
        }

        // Insert non-setup mock parent record
        Course__c testCourse = new Course__c(Name = 'Test Course 1', Status__c = 'Active');
        insert testCourse;
    }

    @isTest
    private static void insertCourseDeliverySuccess() {
        Course__c course = [SELECT Id FROM Course__c LIMIT 1];

        // Let's dynamically find a date that is definitely NOT a holiday in our setup data
        Set<Date> staticHolidays = new Set<Date>();
        for (Holiday h : [SELECT ActivityDate FROM Holiday]) {
            staticHolidays.add(h.ActivityDate);
        }

        // Start with a random date and move forward until we find a free day
        Date safeDate = Date.newInstance(2026, 10, 1);
        while (staticHolidays.contains(safeDate)) {
            safeDate = safeDate.addDays(1);
        }

        Course_Delivery__c courseDelivery = new Course_Delivery__c(
            Course__c = course.Id,
            Start_Date__c = safeDate
        );

        Test.startTest();
        Database.SaveResult insertionResult = Database.insert(courseDelivery, false);
        Test.stopTest();
        
        // Assert that the record saved with absolutely 0 errors
        System.assertEquals(true, insertionResult.isSuccess(), 'The Course Delivery should have saved successfully on a non-holiday date.');
    }

    @isTest
    private static void insertCourseDeliveryFailure() {
        Course__c course = [SELECT Id FROM Course__c LIMIT 1];
        List<Holiday> holidays = [SELECT ActivityDate FROM Holiday LIMIT 1];
        
        // If the static resource loaded correctly, we have at least one holiday to test against
        if (!holidays.isEmpty()) {
            Course_Delivery__c badDelivery = new Course_Delivery__c(
                Course__c = course.Id,
                Start_Date__c = holidays[0].ActivityDate
            );

            Test.startTest();
            Database.SaveResult insertionResult = Database.insert(badDelivery, false);
            Test.stopTest();

            // Assert that the save FAILED because it's a holiday
            System.assertEquals(false, insertionResult.isSuccess(), 'The Course Delivery save should have failed on a holiday.');
        }
    }
}