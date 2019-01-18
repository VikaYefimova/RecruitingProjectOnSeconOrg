@isTest
public class TestDataFactory {
    public static List<Job_Advertisement__c> createJobAdvertisements(integer numberOfRecords, string status, Integer minSalary, Integer maxSalary){
        List<Job_Advertisement__c> listOfTestData = new List<Job_Advertisement__c>();
        for(integer i = 0; i< numberOfRecords; i++){
            Job_Advertisement__c testData = new Job_Advertisement__c();
            testData.Name = 'Test data ' + i;
            testData.Minimum_Salary__c = minSalary;
            testData.Maximum_Salary__c = maxSalary;
            testData.Status__c = status;
            if(minSalary != 0 && maxSalary != 0){
                testData.Salary__c = minSalary +'K-'+maxSalary+'K';
            }
            else if(minSalary != 0 && maxSalary == 0){
                testData.Salary__c = minSalary +'K+';
            }
            else if(minSalary == 0 && maxSalary == 0){
                testData.Salary__c = '';
            }
            listOfTestData.add(testData);
        }
        insert listOfTestData;
        return listOfTestData;
    }
    public static List<CandidateCV__c> createCandidatesCV(Integer numberOfRecords){
        List<CandidateCV__c> listOfTestData = new List<CandidateCV__c>();
        for(integer i = 0; i< numberOfRecords; i++){
            CandidateCV__c testData = new CandidateCV__c();
            testData.Name = 'Test data ' + i;
            testData.Email__c = 'testdata'+i+'@mail.com';
            listOfTestData.add(testData);
        }
        insert listOfTestData;
        return listOfTestData;
    }
    public static List<Selected_Job__c> createSelectedJob(id candidateId, id jobId, integer numberOfRecords){
        List<Selected_Job__c> listOfTestData = new List<Selected_Job__c>();
        for(integer i = 0; i< numberOfRecords; i++){
            Selected_Job__c testData = new Selected_Job__c();
            testData.CandidateCV__c = candidateId;
            testData.Job_Advertisement__c = jobId;
            listOfTestData.add(testData);
        }
        insert listOfTestData;
        return listOfTestData;
    }
}