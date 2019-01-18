@isTest
public class TestForGetCountsOfRecordsEndpoint {
	@isTest
    public static void getCountOfRecordsTest(){
        List<CandidateCV__c> testCandidateCV = TestDataFactory.createCandidatesCV(2);
        List<job_Advertisement__c> testJobAdvertisement = TestDataFactory.createJobAdvertisements(3, 'Active', 40, 50);
        TestDataFactory.createSelectedJob(testCandidateCV[0].id, testJobAdvertisement[0].id, 1);
        TestDataFactory.createSelectedJob(testCandidateCV[1].id, testJobAdvertisement[1].id, 1);
        TestDataFactory.createSelectedJob(testCandidateCV[1].id, testJobAdvertisement[2].id, 1);
        TestDataFactory.createSelectedJob(testCandidateCV[0].id, testJobAdvertisement[1].id, 1);
        TestDataFactory.createSelectedJob(testCandidateCV[0].id, testJobAdvertisement[2].id, 1);
        List<Integer> expectedList = new List<Integer>();
        expectedList.add(2);
        expectedList.add(5);
        expectedList.add(2);
        RestRequest request = new RestRequest();
        request.requestURI = 'https://eu16.salesforce.com/services/apexrest/recordsCount';
        request.httpMethod = 'GET';
        RestContext.request = request;
        List<Integer> listOfData = RestRecourceForGetCountOfRecords.getCountOfRecords();
        system.assertEquals(expectedList, listOfData);
    }
}