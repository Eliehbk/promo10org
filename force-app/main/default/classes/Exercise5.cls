/**
@Description:this class check for reservation overlap and throw anerror in case true
@Author: Elie habka
@Company: EI-Technologies
@Last Modified : 19-06-2026
@Last Modified By  : Elie habka
@Test Class: Exercise5Test
*/
public with sharing class Exercise5 {
    public static void CheckReservations(List<Resource_reservation__c> newreservation, Map<Id, Resource_reservation__c> oldMap) {
    //created a set of strings to store the resrved resources"type of equipment we are trying to reserve"
    Set<String> resToProcess = new Set<String>();
    Datetime mindate;
    datetime maxdate;
for(Resource_reservation__c res :newreservation){
    //checking if its insert or update
 boolean isnew=(oldMap==null);
// checking if the important fields are changed 
Boolean resChanged = (!isNew &&(res.start_date__c != oldMap.get(res.Id).start_date__c|| res.end_date__c != oldMap.get(res.Id).end_date__c||res.reserved_resources__c != oldMap.get(res.Id).reserved_resources__c));
 //getting the exact reserved resources then getting the maximum date and minimum date so we can make the query results even smaller 
if(reschanged||isnew){
resToProcess.add(res.reserved_resources__c);
if(res.start_date__c<mindate){
mindate=res.start_date__c;
}
if(res.end_date__c>maxdate){
maxdate=res.start_date__c;
}
}
    }

if (resToProcess.isEmpty()) {
            return;
    }
    
List<Resource_reservation__c> restocheck = [SELECT start_date__c, end_date__c 
FROM Resource_reservation__c where reserved_resources__c
 in :resToProcess
 AND start_date__c <= :mindate
 AND end_date__c >= :maxdate ] ;
//getting the exact resource
//checking for overlap
for(Resource_reservation__c rp:newreservation){
for(Resource_reservation__c rc:restocheck ){
   // if(rp.reserved_resources__c==rc.reserved_resources__c){
    if ((rp.start_date__c<rc.end_date__c && rp.start_date__c>rc.start_date__c )||(rp.end_date__c<rc.end_date__c && rp.end_date__c>rc.start_date__c )){
rp.addError('the resource is already reserved');
    }
//}
}}
     }
        }