@isTest
public class TestForDeleteSelectedJobsTrigger {
	@isTest
    public static void deleteSelectedJobsWhenJObsIsArchivedTest(){
        CandidateCV__c testCandidate = new CandidateCV__c(Name = 'TestCV TestCandidate', Email__c = 'testcvemail@mail.com');
        insert testCandidate;
        List<Job_Advertisement__c> job = TestDataFactory.createJobAdvertisements(1, 'Active', 50, 75);
        Selected_Job__c testJob = new Selected_Job__c(CandidateCV__c = testCandidate.id, Job_Advertisement__c = job[0].id);
        insert testJob;
        Job_Advertisement__c testJobAdvertisement = [select id from Job_Advertisement__c];
        Test.startTest();
        testJobAdvertisement.Status__c = 'Archived';
        update testJobAdvertisement;
        Test.stopTest();
        List<Selected_Job__c> testSelectedJobs = [select id from Selected_Job__c];
        system.assertEquals(0, testSelectedJobs.size());
        system.assertEquals('Archived', testJobAdvertisement.Status__c);
    }
}