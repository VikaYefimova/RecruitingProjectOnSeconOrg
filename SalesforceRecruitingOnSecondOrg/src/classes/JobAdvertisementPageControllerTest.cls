@isTest
public class JobAdvertisementPageControllerTest {
	@isTest
    public static void JobAdvertisementPageForSiteConstructorTest(){
        List<Job_Advertisement__c> job = TestDataFactory.createJobAdvertisements(15, 'Active', 50, 75);
        JobAdvertisementPageForSiteController testController = new JobAdvertisementPageForSiteController();
        testController.next();
        testController.first();
        System.assertEquals('select Name,Minimum_Salary__c, Maximum_Salary__c, Salary__c, Manager_name__c, Phone__c, Status__c, Location__c, Description__c, Email__c, Education__c, Skills_Required__c from Job_Advertisement__c LIMIT :rec OFFSET :OffsetSize', testController.allSearchQuery);
    	System.assertEquals(10 ,testController.jobs.size());
        System.assertEquals(0, testController.pageNumber);
    }
    @isTest
    public static void getDateTest(){
        PageReference pageRef = Page.JobAdvertisementPageForSite;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('date', '2018-10-12');
        JobAdvertisementPageForSiteController testController = new JobAdvertisementPageForSiteController();
        testController.getDate();
        System.assertEquals('2018-10-12', testController.publishDate);
    }
    @isTest
    public static void getJobAdvertisementIdTest(){
        PageReference pageRef = Page.JobAdvertisementPageForSite;
        Test.setCurrentPage(pageRef);
        List<Job_Advertisement__c> job = TestDataFactory.createJobAdvertisements(3, 'Active', 50, 75);
        Set<Id> jobId = new Set<Id>();
        jobId.add(job[0].id);
        pageRef.getParameters().put('jobId', job[0].id);
        JobAdvertisementPageForSiteController testController = new JobAdvertisementPageForSiteController();
        testController.selectJobAdverisementsIds();
        system.assertEquals(jobId, testController.listOfSelectedJobsIds);
    }
    @isTest
    public static void deleteJobAdvertisementIdTest(){
        PageReference pageRef = Page.JobAdvertisementPageForSite;
        Test.setCurrentPage(pageRef);
        List<Job_Advertisement__c> job = TestDataFactory.createJobAdvertisements(3, 'Active', 50, 75);
        Set<Id> jobId = new Set<Id>();
        jobId.add(job[0].id);
        pageRef.getParameters().put('jobId', job[0].id);
        JobAdvertisementPageForSiteController testController = new JobAdvertisementPageForSiteController();
        testController.selectJobAdverisementsIds();
        pageRef.getParameters().put('jobId', job[1].id);
        testController.deleteSelectedJobId();
        system.assertEquals(jobId, testController.listOfSelectedJobsIds);
    }
    @isTest
    public static void updateRecordListTest(){
        JobAdvertisementPageForSiteController testController = new JobAdvertisementPageForSiteController();
        List<Job_Advertisement__c> job = TestDataFactory.createJobAdvertisements(3, 'Active', 50, 75);
        testController.updateRecordList();
        System.assertEquals(job, testController.jobs);
    }
    @isTest
    public static void updateRecordListWithoutRecords(){
        JobAdvertisementPageForSiteController testController = new JobAdvertisementPageForSiteController();
        List<Job_Advertisement__c> job = [select name, Status__c from Job_Advertisement__c];
        testController.updateRecordList();
        System.assertEquals(job, testController.jobs);
        System.assertEquals(false, !testController.noRecords);
    }
    @isTest
    public static void clearTest(){
        JobAdvertisementPageForSiteController testController = new JobAdvertisementPageForSiteController();
        List<Job_Advertisement__c> job = TestDataFactory.createJobAdvertisements(3, 'Active', 50, 75);
        testController.noRecords = true;
        testController.searchQuery = 'test';
        testController.clear();
        System.assertEquals(false, testController.noRecords);
        System.assertEquals('', testController.searchQuery); 
    }
    @isTest
    public static void searchByNameTest(){
        JobAdvertisementPageForSiteController testController = new JobAdvertisementPageForSiteController();
        testController.nameOfTheVacancy = 'test';
        String expextedFirst = ' where Name LIKE \'%test%\'';
        System.assertEquals(expextedFirst, testController.searchByName(testController.searchQuery));
    }
    @isTest
    public static void searchByNameTestWhenSearchQueryIsNotEmpty(){
        JobAdvertisementPageForSiteController testController = new JobAdvertisementPageForSiteController();
        testController.nameOfTheVacancy = 'test';
        testController.searchQuery = 'testquery +';
        String expextedFirst = 'testquery + AND Name LIKE \'%test%\'';
        System.assertEquals(expextedFirst, testController.searchByName(testController.searchQuery));
    }
    @isTest
    public static void searchByPublishedDateWhenOperatorBefore(){
        JobAdvertisementPageForSiteController testController = new JobAdvertisementPageForSiteController();
        testController.publishDate = 'testDate';
        testController.operator = '<';
        String expextedFirst = ' where DAY_ONLY(CreatedDate) <= testDate';
        System.assertEquals(expextedFirst, testController.searchByPublishedDate(testController.searchQuery));
    }
    @isTest
    public static void searchByPublishedDateWhenOperatorAfter(){
        JobAdvertisementPageForSiteController testController = new JobAdvertisementPageForSiteController();
        testController.publishDate = 'testDate';
        testController.operator = '>';
        String expextedFirst = ' where DAY_ONLY(CreatedDate) >= testDate';
        System.assertEquals(expextedFirst, testController.searchByPublishedDate(testController.searchQuery));
    }
    @isTest
    public static void searchByPublishedDateWhenSearchQueryNotEmpty(){
        JobAdvertisementPageForSiteController testController = new JobAdvertisementPageForSiteController();
        testController.publishDate = 'testDate';
        testController.searchQuery = 'test +';
        testController.operator = '<';
        String expextedFirst = 'test + AND DAY_ONLY(CreatedDate) <= testDate';
        System.assertEquals(expextedFirst, testController.searchByPublishedDate(testController.searchQuery));
    }
    @isTest
    public static void searchBySalaryRange(){
        JobAdvertisementPageForSiteController testController = new JobAdvertisementPageForSiteController();
        testController.salaryRange = '50K-55K';
        String expextedFirst = ' where Salary__c LIKE \'50K-55K\'';
        System.assertEquals(expextedFirst, testController.searchBySalaryRange(testController.searchQuery));
    }
    @isTest
    public static void searchBysalaryRangeWhenSearchQueryNotEmpty(){
        JobAdvertisementPageForSiteController testController = new JobAdvertisementPageForSiteController();
        testController.searchQuery = 'test +';
        testController.salaryRange = '50K-55K';
        String expextedFirst = 'test + AND Salary__c LIKE \'50K-55K\'';
        System.assertEquals(expextedFirst, testController.searchBySalaryRange(testController.searchQuery));
    }
    @isTest
    public static void searchRecordsWhenOnlyNameEntered(){
        JobAdvertisementPageForSiteController testController = new JobAdvertisementPageForSiteController();
        List<Job_Advertisement__c> job = TestDataFactory.createJobAdvertisements(3, 'Active', 50, 75);
        testController.nameOfTheVacancy = 'test';
        testController.searchRecords();
        System.assertEquals(3, testController.jobs.size());
    }
    @isTest
    public static void searchRecordWhenOnlyPublisDateEntered(){
        PageReference pageRef = Page.JobAdvertisementPageForSite;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('date', '2018-10-12');
        JobAdvertisementPageForSiteController testController = new JobAdvertisementPageForSiteController();
        testController.operator = '<';
        List<Job_Advertisement__c> job = TestDataFactory.createJobAdvertisements(3, 'Active', 50, 75);
        testController.searchRecords();
        System.assertEquals(0, testController.jobs.size());
    }
    @isTest
    public static void searchRecordWhenOnlySalaryRangeChoose(){
        JobAdvertisementPageForSiteController testController = new JobAdvertisementPageForSiteController();
        List<Job_Advertisement__c> job = TestDataFactory.createJobAdvertisements(3, 'Active', 50, 75);
        List<Job_Advertisement__c> elseJob = TestDataFactory.createJobAdvertisements(4, 'Active', 90, 75);
        List<Job_Advertisement__c> anotherJob = TestDataFactory.createJobAdvertisements(3, 'Active', 120, 0);
        testController.salaryRange = '90K-75K';
        testController.searchRecords();
        System.assertEquals(4, testController.jobs.size());
    }
    @isTest
    public static void searchRecordWhenNameAndDateEntered(){
        PageReference pageRef = Page.JobAdvertisementPageForSite;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('date', '2018-10-12');
        JobAdvertisementPageForSiteController testController = new JobAdvertisementPageForSiteController();
        testController.operator = '>';
        testController.nameOfTheVacancy = 'data 2';
        List<Job_Advertisement__c> job = TestDataFactory.createJobAdvertisements(3, 'Active', 50, 75);
        List<Job_Advertisement__c> elseJob = TestDataFactory.createJobAdvertisements(3, 'Active', 50, 75);
        testController.searchRecords();
        System.assertEquals(2, testController.jobs.size());
    }
    @isTest
    public static void searchRecordWhenAllCriteriasEntered(){
        PageReference pageRef = Page.JobAdvertisementPageForSite;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('date', '2018-10-12');
        JobAdvertisementPageForSiteController testController = new JobAdvertisementPageForSiteController();
        testController.operator = '>';
        testController.salaryRange='120K+';
        testController.nameOfTheVacancy = 'data';
        List<Job_Advertisement__c> job = TestDataFactory.createJobAdvertisements(3, 'Active', 50, 75);
        List<Job_Advertisement__c> elseJob = TestDataFactory.createJobAdvertisements(3, 'Active', 120, 0);
        testController.searchRecords();
        System.assertEquals(3, testController.jobs.size());
    }
    @isTest
    public static void updatePageTest(){
        List<Job_Advertisement__c> job = TestDataFactory.createJobAdvertisements(20, 'Active', 80, 120);
        JobAdvertisementPageForSiteController test = new JobAdvertisementPageForSiteController();
        test.nameOfTheVacancy = 'test';
        test.rec = 5;
        test.updatePage();
        System.assertEquals(20, test.totalRecs);
        System.assertEquals(5, test.jobs.size());
    }
    @isTest
    public static void goToFirstPageTest(){
        List<Job_Advertisement__c> job = TestDataFactory.createJobAdvertisements(20, 'Active', 80, 120);
        JobAdvertisementPageForSiteController test = new JobAdvertisementPageForSiteController();
        test.first();
        System.assertEquals(0, test.pageNumber);
        System.assertEquals(0, test.OffsetSize);
    }
    @isTest
    public static void goToNextPageTest(){
        List<Job_Advertisement__c> job = TestDataFactory.createJobAdvertisements(15, 'Active', 80, 120);
        JobAdvertisementPageForSiteController test = new JobAdvertisementPageForSiteController();
        test.rec = 5;
        test.next();
        System.assertEquals(1, test.pageNumber);
        System.assertEquals(5, test.OffsetSize);
    }
    @isTest
    public static void goToPreviousPageTest(){
        List<Job_Advertisement__c> job = TestDataFactory.createJobAdvertisements(15, 'Active', 80, 120);
        JobAdvertisementPageForSiteController test = new JobAdvertisementPageForSiteController();
        test.rec = 5;
        test.next();
        test.next();
        test.previous();
        System.assertEquals(1, test.pageNumber);
        System.assertEquals(5, test.OffsetSize);
    }
    @isTest
    public static void goToLastPageTest(){
        List<Job_Advertisement__c> job = TestDataFactory.createJobAdvertisements(15, 'Active', 80, 120);
        JobAdvertisementPageForSiteController test = new JobAdvertisementPageForSiteController();
        test.rec = 5;
        test.last();
        System.assertEquals(2, test.pageNumber);
        System.assertEquals(10, test.OffsetSize);
    }
    @isTest
    public static void lastPageNumberTest(){
        List<Job_Advertisement__c> job = TestDataFactory.createJobAdvertisements(22, 'Active', 80, 120);
        JobAdvertisementPageForSiteController test = new JobAdvertisementPageForSiteController();
        test.rec = 5;
        System.assertEquals(4, test.lastPageNumber());
    }
    @isTest
    public static void disableNextButtonTest(){
        List<Job_Advertisement__c> job = TestDataFactory.createJobAdvertisements(22, 'Active', 80, 120);
        JobAdvertisementPageForSiteController test = new JobAdvertisementPageForSiteController();
        test.rec = 5;
        test.next();
        test.next();
        test.next();
        test.next();
        test.next();
        System.assert(test.getDisableNxt());
    }
    @isTest
    public static void notDisableNextButton(){
        List<Job_Advertisement__c> job = TestDataFactory.createJobAdvertisements(22, 'Active', 80, 120);
        JobAdvertisementPageForSiteController test = new JobAdvertisementPageForSiteController();
        test.rec = 5;
        test.next();
        test.next();
        System.assert(!test.getDisableNxt());
    }
    @isTest
    public static void disablePreviousButton(){
        List<Job_Advertisement__c> job = TestDataFactory.createJobAdvertisements(22, 'Active', 80, 120);
        JobAdvertisementPageForSiteController test = new JobAdvertisementPageForSiteController();
        test.rec = 5;
        System.assert(test.getDisablePrv());
    }
    @isTest
    public static void notDisablePreviousButton(){
        List<Job_Advertisement__c> job = TestDataFactory.createJobAdvertisements(22, 'Active', 80, 120);
        JobAdvertisementPageForSiteController test = new JobAdvertisementPageForSiteController();
        test.rec = 5;
        test.next();
        System.assert(!test.getDisablePrv());
    }
    @isTest
    public static void testSearchAndRecordsManagingFlow(){
        PageReference pageRef = Page.JobAdvertisementPageForSite;
        Test.setCurrentPage(pageRef);
        Date testDate = date.today().addDays(3);
        String stringTestDate = testDate.year()+'-'+testDate.month()+'-'+(testDate.day());
        List<Job_Advertisement__c> job = TestDataFactory.createJobAdvertisements(15, 'Active', 50, 75);
        List<Job_Advertisement__c> job2 = TestDataFactory.createJobAdvertisements(15, 'Active', 75, 90);
        Set<Id> jobId = new Set<Id>();
        JobAdvertisementPageForSiteController test = new JobAdvertisementPageForSiteController();
        test.next();
        test.first();
        System.assertEquals('select Name,Minimum_Salary__c, Maximum_Salary__c, Salary__c, Manager_name__c, Phone__c, Status__c, Location__c, Description__c, Email__c, Education__c, Skills_Required__c from Job_Advertisement__c LIMIT :rec OFFSET :OffsetSize', test.allSearchQuery);
    	System.assertEquals(10 ,test.jobs.size());
        System.assertEquals(0, test.pageNumber);
        system.assertEquals(30, test.totalRecs);
        pageRef.getParameters().put('date', stringTestDate);
        test.operator = '>';
        test.searchRecords();
        system.assertEquals(true, test.noRecords);
        system.assertEquals(0, test.totalRecs);
        pageRef.getParameters().put('date', stringTestDate);
        test.operator = '<';
        test.salaryRange = '75K-90K';
        test.searchRecords();
        system.assertEquals(false, test.noRecords);
        system.assertEquals(15, test.totalRecs);
        system.assertEquals(0, test.pageNumber);
        system.assertEquals(1, test.lastPageNumber());
        test.next();
        system.assertEquals(1, test.pageNumber);
        system.assertEquals(true, test.getDisableNxt());
        system.assertEquals(false, test.getDisablePrv());
        system.assertEquals(15, test.totalRecs);
        test.rec = 5;
        test.updatePage();
        system.assertEquals(0, test.pageNumber);
        system.assertEquals(false, test.getDisableNxt());
        system.assertEquals(true, test.getDisablePrv());
        system.assertEquals(2, test.lastPageNumber());
        system.assertEquals(15, test.totalRecs);
        system.assertEquals(5, test.rec);
        system.assertEquals(0, test.OffsetSize);
        pageRef.getParameters().put('jobid', job2[0].id);
        test.selectJobAdverisementsIds();
        id firstId = job2[0].id;
        jobId.add(firstId);
        system.assertEquals(jobId, test.listOfSelectedJobsIds);
        test.next();
        pageRef.getParameters().put('jobid', job2[4].id);
        test.selectJobAdverisementsIds();
        id secondId = job2[4].id;
        jobId.add(secondId);
        system.assertEquals(jobId, test.listOfSelectedJobsIds);
        system.assertEquals(1, test.pageNumber);
        system.assertEquals(15, test.totalRecs);
        system.assertEquals(5, test.rec);
        system.assertEquals(5, test.OffsetSize);
        test.next();
        pageRef.getParameters().put('jobid', job2[9].id);
        test.selectJobAdverisementsIds();
        id thirdId = job2[9].id;
        jobId.add(thirdId);
        system.assertEquals(jobId, test.listOfSelectedJobsIds);
        system.assertEquals(3, test.listOfSelectedJobsIds.size());
        system.assertEquals(2, test.pageNumber);
        system.assertEquals(15, test.totalRecs);
        system.assertEquals(5, test.rec);
        system.assertEquals(10, test.OffsetSize);
        pageRef.getParameters().put('jobid', firstId);
        test.deleteSelectedJobId();
        Set<Id> afterDeleteJobId = new Set<Id>();
        afterDeleteJobId.add(secondId);
        afterDeleteJobId.add(thirdId);
        system.assertEquals(afterDeleteJobId, test.listOfSelectedJobsIds);
        system.assertEquals(2, test.listOfSelectedJobsIds.size());
        system.assertEquals(2, test.pageNumber);
        system.assertEquals(15, test.totalRecs);
        system.assertEquals(5, test.rec);
        system.assertEquals(10, test.OffsetSize);
        test.previous();
        system.assertEquals(afterDeleteJobId, test.listOfSelectedJobsIds);
        system.assertEquals(2, test.listOfSelectedJobsIds.size());
        system.assertEquals(1, test.pageNumber);
        system.assertEquals(15, test.totalRecs);
        system.assertEquals(5, test.rec);
        system.assertEquals(5, test.OffsetSize);
        test.clear();
        system.assertEquals(afterDeleteJobId, test.listOfSelectedJobsIds);
        system.assertEquals(2, test.listOfSelectedJobsIds.size());
        system.assertEquals(0, test.pageNumber);
        system.assertEquals(30, test.totalRecs);
        system.assertEquals(5, test.rec);
        system.assertEquals(0, test.OffsetSize);
    }
    @isTest
    public static void uploadCandidateImageTest(){
        CandidateCV__c testCandidate = new CandidateCV__c(Name = 'Test Candidate', Email__c = 'testcandidate@mail.com');
        insert testCandidate;
        PageReference pageReference = Page.JobAdvertisementPageForSite;
        Test.setCurrentPage(pageReference);
        JobAdvertisementPageForSiteController test = new JobAdvertisementPageForSiteController();
        Blob file = Blob.valueOf('Image for uploaded in test');
        ContentVersion testImage = test.uploadCandidatesImage(file, testCandidate.Name, testCandidate.id);
        system.assert(test.uploadImageFlag);
        system.assertEquals(testImage.Candidate_Number__c, testCandidate.id);
        system.assertEquals(testImage.Title, testCandidate.Name);
    }
    @isTest
    public static void notUploadCandidateImageTest(){
        CandidateCV__c testCandidate = new CandidateCV__c(Name = 'Test Candidate', Email__c = 'testcandidate@mail.com');
        insert testCandidate;
        PageReference pageReference = Page.JobAdvertisementPageForSite;
        Test.setCurrentPage(pageReference);
        JobAdvertisementPageForSiteController test = new JobAdvertisementPageForSiteController();
        Blob file;
        ContentVersion testImage = test.uploadCandidatesImage(file, testCandidate.Name, testCandidate.id);
        system.assert(!test.uploadImageFlag);
    }
    @isTest
    public static void updateCandidateImageTest(){
        CandidateCV__c testCandidate = new CandidateCV__c(Name = 'Test Candidate', Email__c = 'testcandidate@mail.com');
        insert testCandidate;
        PageReference pageReference = Page.JobAdvertisementPageForSite;
        Test.setCurrentPage(pageReference);
        JobAdvertisementPageForSiteController test = new JobAdvertisementPageForSiteController();
        Blob file = Blob.valueOf('Image for uploaded in test');
        ContentVersion testImage = test.uploadCandidatesImage(file, testCandidate.Name, testCandidate.id);
        Blob fileForUpdate = Blob.valueOf('Image for updating in test');
        testImage = test.updateCandidateImage(testImage, fileForUpdate);
        system.assert(test.uploadImageFlag);
    }
    @isTest
    public static void imageNotUpdatingTest(){
        CandidateCV__c testCandidate = new CandidateCV__c(Name = 'Test Candidate', Email__c = 'testcandidate@mail.com');
        insert testCandidate;
        PageReference pageReference = Page.JobAdvertisementPageForSite;
        Test.setCurrentPage(pageReference);
        JobAdvertisementPageForSiteController testController = new JobAdvertisementPageForSiteController();
        Blob file = Blob.valueOf('Image for uploaded in test');
        ContentVersion testImage = testController.uploadCandidatesImage(file, testCandidate.Name, testCandidate.id);
        ContentVersion testContentVersion = [select ContentDocumentId from ContentVersion];
        List<ContentDocument> imageDocument = [select id from ContentDocument where id =: testContentVersion.ContentDocumentId];
        delete imageDocument;
        Blob fileForUpdate;
        Test.startTest();
        testImage = testController.updateCandidateImage(testImage, fileForUpdate);
        Test.stopTest();
        system.assert(!testController.uploadImageFlag);
    }
    @isTest
    public static void sendEmailForNewCandidateTest(){
        CandidateCV__c testCandidate = new CandidateCV__c(Name = 'Test Candidate', Email__c = 'testcandidate@mail.com');
        insert testCandidate;
        List<String> email = new List<String>();
        email.add(testCandidate.Email__c);
        PageReference pageReference = Page.JobAdvertisementPageForSite;
        Test.setCurrentPage(pageReference);
        List<Job_Advertisement__c> job = TestDataFactory.createJobAdvertisements(2, 'Active', 50, 75);
		Selected_Job__c testJOb1 = new Selected_job__c(CandidateCV__c = testCandidate.id, Job_Advertisement__c = job[0].id);
        insert testJOb1;
        Selected_Job__c testJOb2 = new Selected_job__c(CandidateCV__c = testCandidate.id, Job_Advertisement__c = job[1].id);
        insert testJOb2;
        List<Selected_Job__c> selectedJobs = new List<Selected_Job__c>();
        selectedJobs.add(testJOb1);
        selectedJobs.add(testJOb2);
        JobAdvertisementPageForSiteController testController = new JobAdvertisementPageForSiteController();
        testController.sendEmailNotification(selectedJobs, email);
        System.assertEquals(1, Limits.getEmailInvocations());
    }
    @isTest
    public static void notSendEmailForNewCandidateTest(){
        CandidateCV__c testCandidate = new CandidateCV__c(Name = 'Test Candidate', Email__c = 'testcandidate@mail.com');
        insert testCandidate;
        List<String> email = new List<String>();
        PageReference pageReference = Page.JobAdvertisementPageForSite;
        Test.setCurrentPage(pageReference);
        List<Job_Advertisement__c> job = TestDataFactory.createJobAdvertisements(2, 'Active', 50, 75);
		Selected_Job__c testJOb1 = new Selected_job__c(CandidateCV__c = testCandidate.id, Job_Advertisement__c = job[0].id);
        insert testJOb1;
        Selected_Job__c testJOb2 = new Selected_job__c(CandidateCV__c = testCandidate.id, Job_Advertisement__c = job[1].id);
        insert testJOb2;
        List<Selected_Job__c> selectedJobs = new List<Selected_Job__c>();
        selectedJobs.add(testJOb1);
        selectedJobs.add(testJOb2);
        JobAdvertisementPageForSiteController testController = new JobAdvertisementPageForSiteController();
        testController.sendEmailNotification(selectedJobs, email);
        System.assertEquals(0, Limits.getEmailInvocations());
    }
    @isTest
    public static void addSelectedJobTest(){
		CandidateCV__c testCandidate = new CandidateCV__c(Name = 'Test Candidate', Email__c = 'testcandidate@mail.com');
        insert testCandidate;
		List<Job_Advertisement__c> job = TestDataFactory.createJobAdvertisements(3, 'Active', 50, 75);
        Set<Id> selectedJobsIds = new Set<Id>();
        selectedJobsIds.add(job[0].id);
        selectedJobsIds.add(job[1].id);
        selectedJobsIds.add(job[2].id);
        JobAdvertisementPageForSiteController testController = new JobAdvertisementPageForSiteController();
        List<Selected_Job__c> selectedJobs = testController.addSelectedJobs(selectedJobsIds, testCandidate.Id, 35, '48K', 'Employed', '0557894210', 'test info for selected job record');
        system.assertEquals(3, selectedJobs.size());
        system.assertEquals(job[0].id, selectedJobs[0].Job_Advertisement__c);
        system.assertEquals(job[1].id, selectedJobs[1].Job_Advertisement__c);
        system.assertEquals(job[2].id, selectedJobs[2].Job_Advertisement__c);
    }
    @isTest
    public static void sendCVwhenCandidateIsNewTest(){
        List<Job_Advertisement__c> job = TestDataFactory.createJobAdvertisements(3, 'Active', 50, 75);
        PageReference pageRef = Page.JobAdvertisementPageForSite;
        Test.setCurrentPage(pageRef);
        Blob file = Blob.valueOf('image for upload in test');
        String stringFile = EncodingUtil.base64Encode(file);
        pageRef.getParameters().put('name', 'TestCV Test');
        pageRef.getParameters().put('email', 'testcvemail@mail.com');
        pageRef.getParameters().put('phone', '0568967810');
        pageRef.getParameters().put('age', '23');
        pageRef.getParameters().put('salary', '46K');
        pageRef.getParameters().put('status', 'Unemployed');
        pageRef.getParameters().put('indo', 'additional info in test');
        pageRef.getParameters().put('photo', stringFile);
        JobAdvertisementPageForSiteController testController = new JobAdvertisementPageForSiteController();
        testController.listOfSelectedJobsIds.add(job[0].id);
        testController.listOfSelectedJobsIds.add(job[1].id);
        testController.listOfSelectedJobsIds.add(job[2].id);
        testController.sendCV();
        List<CandidateCV__c> testCandidates = [select id, Name, Candidate_Age__c, Email__c, Status__c from CandidateCV__c];
        Integer selJobsCount = [select count() from Selected_Job__c where CandidateCV__c in :testCandidates];
        List<Apexpages.Message> msgs = ApexPages.getMessages();
		boolean b = false;
        for(Apexpages.Message msg:msgs){
    	if (msg.getDetail().contains('Your CV was send successfuly!')) b = true;
		}
		system.assert(b);
        system.assertEquals(1, testCandidates.size());
        system.assertEquals(3, selJobsCount);
        system.assert(testController.insertCVRecordFlag);
        system.assert(testController.insertSelectedJobRecordFlag);
        system.assert(testController.uploadImageFlag);
    }
    @isTest
    public static void sendCVwhenCandidateIsNewAndCVWasNotSendTest(){
        //change method for called cathc in sendCV method in controller class!
        List<Job_Advertisement__c> job = TestDataFactory.createJobAdvertisements(3, 'Active', 50, 75);
        PageReference pageRef = Page.JobAdvertisementPageForSite;
        Test.setCurrentPage(pageRef);
        Blob file = Blob.valueOf('image for upload in test');
        String stringFile = EncodingUtil.base64Encode(file);
        pageRef.getParameters().put('name', 'TestCV Test');
        pageRef.getParameters().put('phone', '0568967810');
        pageRef.getParameters().put('age', '23');
        pageRef.getParameters().put('salary', '46K');
        pageRef.getParameters().put('status', 'Unemployed');
        pageRef.getParameters().put('indo', 'additional info in test');
        pageRef.getParameters().put('photo', stringFile);
        JobAdvertisementPageForSiteController testController = new JobAdvertisementPageForSiteController();
        testController.listOfSelectedJobsIds.add(job[0].id);
        testController.listOfSelectedJobsIds.add(job[1].id);
        testController.listOfSelectedJobsIds.add(job[2].id);
        testController.sendCV();
        List<CandidateCV__c> testCandidates = [select id, Name, Candidate_Age__c, Email__c, Status__c from CandidateCV__c];
        List<Apexpages.Message> msgs = ApexPages.getMessages();
		boolean b = false;
        for(Apexpages.Message msg:msgs){
    	if (msg.getDetail().contains('Your CV was not send!')) b = true;
		}
		system.assert(b);
        system.assertEquals(0, testCandidates.size());
        system.assert(!testController.insertCVRecordFlag);
        system.assert(!testController.insertSelectedJobRecordFlag);
        system.assert(!testController.uploadImageFlag);
    }
    @isTest
    public static void sendCVWhenCandidateNotNewTest(){
        CandidateCV__c testCandidate = new CandidateCV__c(Name = 'TestCV TestCandidate', Email__c = 'testcvemail@mail.com');
        insert testCandidate;
        List<Job_Advertisement__c> job = TestDataFactory.createJobAdvertisements(3, 'Active', 50, 75);
        Selected_Job__c testJob = new Selected_Job__c(CandidateCV__c = testCandidate.id, Job_Advertisement__c = job[0].id);
        string canId = testCandidate.id;
        string jobId = job[0].id;
        testJob.External_Number__c = canId + jobId;
        insert testJob;
        PageReference pageRef = Page.JobAdvertisementPageForSite;
        Test.setCurrentPage(pageRef);
        Blob file = Blob.valueOf('image for upload in test');
        String stringFile = EncodingUtil.base64Encode(file);
        pageRef.getParameters().put('name', 'TestCV Test');
        pageRef.getParameters().put('email', 'testcvemail@mail.com');
        pageRef.getParameters().put('phone', '0568967810');
        pageRef.getParameters().put('age', '23');
        pageRef.getParameters().put('salary', '46K');
        pageRef.getParameters().put('status', 'Unemployed');
        pageRef.getParameters().put('indo', 'additional info in test');
        pageRef.getParameters().put('photo', stringFile);
        JobAdvertisementPageForSiteController testController = new JobAdvertisementPageForSiteController();
        testController.uploadCandidatesImage(file, testCandidate.Name, testCandidate.Id);
        testController.listOfSelectedJobsIds.add(job[0].id);
        testController.listOfSelectedJobsIds.add(job[1].id);
        testController.listOfSelectedJobsIds.add(job[2].id);
        testController.sendCV();
        List<CandidateCV__c> testCandidates = [select id, Name, Candidate_Age__c, Email__c, Status__c from CandidateCV__c];
        List<Selected_Job__c> selJobsCount = [select id, External_Number__c from Selected_Job__c where CandidateCV__c in :testCandidates];
        system.debug('count: ' + selJobsCount);
        List<Apexpages.Message> msgs = ApexPages.getMessages();
		boolean b = false;
        for(Apexpages.Message msg:msgs){
    	if (msg.getDetail().contains('Your CV was send successfuly!')) b = true;
		}
		system.assert(b);
        system.assertEquals(1, testCandidates.size());
        system.assertEquals(3, selJobsCount.size());
        system.assert(testController.insertSelectedJobRecordFlag);
        system.assert(testController.uploadImageFlag);
    }
    @isTest
    public static void sendCVWhenCandidateNotNewAndCVWillNotSendTest(){
        CandidateCV__c testCandidate = new CandidateCV__c(Name = 'TestCV TestCandidate', Email__c = 'testcvemail@mail.com');
        insert testCandidate;
        List<Job_Advertisement__c> job = TestDataFactory.createJobAdvertisements(3, 'Active', 50, 75);
        PageReference pageRef = Page.JobAdvertisementPageForSite;
        Test.setCurrentPage(pageRef);
        Blob file = Blob.valueOf('image for upload in test');
        String stringFile = EncodingUtil.base64Encode(file);
        pageRef.getParameters().put('name', 'TestCV Test');
        pageRef.getParameters().put('email', 'testcvemail@mail.com');
        pageRef.getParameters().put('phone', '0568967810');
        pageRef.getParameters().put('age', '23');
        pageRef.getParameters().put('salary', '46K');
        pageRef.getParameters().put('status', 'Unemployed');
        pageRef.getParameters().put('indo', 'additional info in test');
        pageRef.getParameters().put('photo', stringFile);
        JobAdvertisementPageForSiteController testController = new JobAdvertisementPageForSiteController();
        testController.uploadCandidatesImage(file, testCandidate.Name, testCandidate.Id);
        testController.listOfSelectedJobsIds.add(testCandidate.Id);
        testController.sendCV();
        List<CandidateCV__c> testCandidates = [select id, Name, Candidate_Age__c, Email__c, Status__c from CandidateCV__c];
        Integer selJobsCount = [select count() from Selected_Job__c where CandidateCV__c in :testCandidates];
        List<Apexpages.Message> msgs = ApexPages.getMessages();
		boolean b = false;
        for(Apexpages.Message msg:msgs){
            system.debug('message: ' + msg.getDetail());
    	if (msg.getDetail().contains('Your CV was not send!')) b = true;
		}
		system.assert(b);
        system.assertEquals(1, testCandidates.size());
        system.assertEquals(0, selJobsCount);
        system.assert(!testController.insertSelectedJobRecordFlag);
        system.assert(testController.uploadImageFlag);
    }
}