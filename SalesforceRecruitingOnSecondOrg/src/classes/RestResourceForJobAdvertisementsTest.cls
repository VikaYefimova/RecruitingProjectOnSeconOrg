@isTest
public class RestResourceForJobAdvertisementsTest {
    static Job_Advertisement__c createTestRecord(){
        Job_Advertisement__c testRecord = new Job_Advertisement__c
            (Name='Test Record', 
             Education__c = 'Diiploma', 
             Skills_Required__c = 'skills');
        insert testRecord;
        return testRecord;
    }
    @isTest
    public static void testGetRecords(){
        List<Job_Advertisement__c> job = TestDataFactory.createJobAdvertisements(3, 'Active', 50, 75);
        RestRequest request = new RestRequest();
        request.requestURI = 'https://eu16.salesforce.com/services/apexrest/jobAdvertisements/';
        request.httpMethod = 'GET';
        RestContext.request = request;
        List<Job_Advertisement__c> result = RestRecourceForJobAdvertisements.getRecords();
        //system.assert(result.size() == 1);
        system.assertEquals(3, result.size());
        System.assertEquals('Test data 0', result[0].Name);
    }
    @isTest
    public static void testCreateRecord(){
        Job_Advertisement__c newRecord = RestRecourceForJobAdvertisements.postRecords
            ('Test', '0995686910', 'vika@mail.com', 'description', 
             'skills', 'managerName', 'status', 'location', 'education', 
             120, 200, '120-200', 'hjhkjhkhk12fjyuyt0');
        Job_Advertisement__c result = [select id, Name from Job_Advertisement__c];
        System.assertEquals(newRecord.id, result.id);
        System.assertEquals(newRecord.Name, result.Name);
    }
    @isTest
    public static void testUpdateRecord(){
        Job_Advertisement__c newRecord = createTestRecord();
        RestRequest request = new RestRequest();
        request.requestURI = 'https://eu16.salesforce.com/services/apexrest/jobAdvertisements/' + newRecord.id;
        request.httpMethod = 'PUT';
        RestContext.request = request;
        newRecord = RestRecourceForJobAdvertisements.updateRecords('Test', '0995686910', 'vika@mail.com', 'newDescription', 
             'newSkills', 'managerName', 'status', 'location', 'education', 
             120, 200, '120-200', 'hjhkjhkhk12fjyuyt0');
        Job_Advertisement__c result = [select id, Name, Email__c, Phone__c, Skills_Required__c from Job_Advertisement__c];
        System.assertEquals(newRecord.id, result.id);
        System.assertEquals('Test', result.Name);
        System.assertEquals('vika@mail.com', result.Email__c);
        System.assertEquals('newSkills', result.Skills_Required__c);
        System.assertEquals('0995686910', result.Phone__c);
    }
    @isTest
    public static void testDeleteRecord(){
        Job_Advertisement__c newRecord = createTestRecord();
        RestRequest request = new RestRequest();
        request.requestURI = 'https://eu16.salesforce.com/services/apexrest/jobAdvertisements/' + newRecord.id;
        request.httpMethod = 'DELETE';
        RestContext.request = request;
        RestRecourceForJobAdvertisements.deleteRecords();
        List<Job_Advertisement__c> result = [select id from Job_Advertisement__c];
        System.assertEquals(0, result.size());
    }
}