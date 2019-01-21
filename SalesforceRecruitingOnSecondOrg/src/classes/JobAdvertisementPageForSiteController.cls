public class JobAdvertisementPageForSiteController {
    public List<Job_Advertisement__c> jobs {get; set;}
    public String publishDate {get; set;}
    public String nameOfTheVacancy {get; set;}
    public String salaryRange {get; set;}
    public String operator {get; set;}
    public Integer rec{get; set;}
    public integer totalRecs {get; set;}
    @TestVisible
    integer OffsetSize= 0;
    @TestVisible
    Integer pageNumber = 0;
    public Set<Id> listOfSelectedJobsIds = new Set<Id>();
    public String mainPartSearchQuery = 'select Name,Minimum_Salary__c, Maximum_Salary__c, Salary__c, Manager_name__c, Phone__c, Status__c, Location__c, Description__c, Email__c, Education__c, Skills_Required__c from Job_Advertisement__c';
    public String searchQueryFinishPart = ' LIMIT :rec OFFSET :OffsetSize';
    public string searchQuery = '';
    public string allSearchQuery ='';
    public boolean noRecords {get; set;}
    public String candidateName {get; set;}
    public Integer candidateAge {get; set;}
    public String candidateSalary {get; set;}
    public String candidateStatus {get; set;}
    public String candidatePhone {get; set;}
    public String candidateEmail {get; set;}
    public String candidateInfo {get; set;}
    public String candidatePhotoString {get; set;}
    public Boolean uploadImageFlag {get; set;}
    public Boolean insertCVRecordFlag {get; set;}
    public Boolean insertSelectedJobRecordFlag {get; set;}
    //public Blob photo{get; set;}
    public JobAdvertisementPageForSiteController(){
        rec = 10;
        allSearchQuery = mainPartSearchQuery + searchquery +  searchQueryFinishPart;
        jobs = Database.query(allSearchQuery);
        updateTotalRecords();
        uploadImageFlag = false;
        insertCVRecordFlag = false;
        insertSelectedJobRecordFlag = false;
    }
    public void getDate(){
        publishDate = ApexPages.currentPage().getParameters().get('date');
    }
    public void selectJobAdverisementsIds(){
        listOfSelectedJobsIds.add(ApexPages.currentPage().getParameters().get('jobId'));
    }
    public void deleteSelectedJobId(){
        Id jobId = ApexPages.currentPage().getParameters().get('jobId');
        listOfSelectedJobsIds.remove(jobId);
    }
    public String searchByName(String searchQuery){
        if(!String.isEmpty(nameOfTheVacancy)){
            if(searchQuery!=''){
            	searchQuery += ' AND ';
            }
            else{
                searchQuery +=' where ';
            }
            searchQuery= searchQuery + 'Name LIKE \'%'+nameOfTheVacancy+'%\'';
        }
        return searchQuery;
    }
    public String searchByPublishedDate(String searchQuery){
        if(!String.isEmpty(publishDate) && operator != null){
            if(searchQuery!=''){
            	searchQuery += ' AND ';
            }
            else{
                searchQuery +=' where ';
            }
            if(operator == '<'){
                searchQuery= searchQuery + 'DAY_ONLY(CreatedDate) <= ' + publishDate;
            }
            else if(operator == '>'){
                searchQuery= searchQuery + 'DAY_ONLY(CreatedDate) >= ' + publishDate;
            }
        }
        return searchQuery;
    }
    public String searchBySalaryRange(String searchQuery){
        if(!String.isEmpty(salaryRange)){
            if(searchQuery!=''){
            	searchQuery += ' AND ';
            }
            else{
                searchQuery +=' where ';
            }
            searchQuery= searchQuery + 'Salary__c LIKE \'' + salaryRange +'\'';
        }
        return searchQuery;
    }
    public void searchRecords(){
        searchQuery = '';
        noRecords = false;
        publishDate = ApexPages.currentPage().getParameters().get('date');
        if(!String.isEmpty(nameOfTheVacancy) || !String.isEmpty(publishDate) || !String.isEmpty(salaryRange)){
            searchQuery = searchByName(searchQuery);
            searchQuery = searchByPublishedDate(searchQuery);
            searchQuery = searchBySalaryRange(searchQuery);
            updateRecordList();
        }
    }
    @TestVisible
    private void updateRecordList() {
        allSearchQuery = mainPartSearchQuery + searchQuery + searchQueryFinishPart;
        updateTotalRecords();
        jobs = Database.query(allSearchQuery);
    }
    public void clear(){
        noRecords = false;
        searchquery = '';
        system.debug('hello');
        updateRecordList();
    }
    @TestVisible
    private PageReference updateTotalRecords() {
        totalRecs = Database.countQuery('select count() from Job_Advertisement__c ' + searchquery);
        if(totalRecs == 0){
            noRecords= true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No records found!'));
        }
        else{
           pageNumber = 0;
           updateOffset(); 
        }
        return null;
    }
    public PageReference updatePage() {
        jobs.clear();
        updateTotalRecords();
        allSearchQuery = mainPartSearchQuery + searchquery + searchQueryFinishPart;
        jobs = Database.query(allSearchQuery);
        return null;
    }

    public PageReference first() {
        pageNumber = 0;
        updateOffset();
        retrievePageRecords(rec);
        return null;
    }
    public PageReference previous() {
        pageNumber--;
        updateOffset();
        retrievePageRecords(rec);
        return null;
    }
    public PageReference next() {
        pageNumber++;
        updateOffset();
        retrievePageRecords(rec);
        return null;
    }
    public PageReference last() {
        pageNumber = lastPageNumber();
        updateOffset();
        retrievePageRecords(math.mod(totalRecs,rec));
        return null;
    }

    public Boolean getDisableNxt() {
        if(pageNumber >= lastPageNumber())
            return true;
        else
            return false;
    }
    public Boolean getDisablePrv(){
        if(pageNumber <= 0)
            return true;
        else
            return false;
    }
	@TestVisible
    private void updateOffset() {
        OffsetSize = rec * pageNumber;
    }
	@TestVisible
    private void retrievePageRecords(integer recordsOnPage) {
        allSearchQuery = mainPartSearchQuery + searchquery + searchQueryFinishPart;
        jobs = Database.query(allSearchQuery);
    }
    @TestVisible
    private integer lastPageNumber() {
        return (integer)(((totalRecs*1.0) / (rec *1.0)).round(RoundingMode.UP) -1);
    }
    public void sendCV(){
        Profile sys_adm_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' limit 1];
	    User sys_adm = [SELECT id, Email FROM User WHERE ProfileId = :sys_adm_profile.id];
        candidateEmail = ApexPages.currentPage().getParameters().get('email');
        candidatePhotoString = ApexPages.currentPage().getParameters().get('photo');
        candidatePhotoString = candidatePhotoString.removeStart('data:image/jpeg;base64,');
        candidateAge = Integer.valueOf(ApexPages.currentPage().getParameters().get('age'));
        candidateSalary = ApexPages.currentPage().getParameters().get('salary');
        candidateStatus = ApexPages.currentPage().getParameters().get('status');
        candidatePhone = ApexPages.currentPage().getParameters().get('phone');
        candidateInfo = ApexPages.currentPage().getParameters().get('info');
        candidateName = ApexPages.currentPage().getParameters().get('name');
        Blob photo = EncodingUtil.base64Decode(candidatePhotoString);
        List<CandidateCV__c> candidateEmailList = [select id, Name from CandidateCV__c where Email__c =: candidateEmail limit 1];
        if(candidateEmailList.size() > 0){
            for(CandidateCV__c can: candidateEmailList){
               can.Email__c = candidateEmail;
            }
            system.debug('new list: ' + listOfSelectedJobsIds);
            List<Selected_Job__c> selectedJobs = new List<Selected_Job__c>();
            try{
                update candidateEmailList;
                selectedJobs = addSelectedJobs(listOfSelectedJobsIds, candidateEmailList[0].id, candidateAge, candidateSalary, candidateStatus, candidatePhone, candidateInfo);
                upsert selectedJobs External_Number__c;
                insertSelectedJobRecordFlag = true;
                List<String> emails = new List<String>();
                emails.add(candidateEmail);
                sendEmailNotification(selectedJobs, emails);
            }
            catch(DMLException e){
                system.debug('exception: ' + e);
                insertSelectedJobRecordFlag = false;
            }
            id documentid = [select ContentDocumentId from ContentDocumentLink where LinkedEntityId =: candidateEmailList[0].id].ContentDocumentId;
        	ContentVersion candidatesImage = [select id from ContentVersion where ContentDocumentId =: documentid And isLatest = True];
            updateCandidateImage(candidatesImage, photo);
            if(insertSelectedJobRecordFlag && uploadImageFlag){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Your CV was send successfuly!'));
            }
            else if(!insertSelectedJobRecordFlag || !uploadImageFlag){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Your CV was not send!'));
            }
        }
        else if(candidateEmailList.size() == 0){
            system.debug('hello');
            CandidateCV__c ccv = new CandidateCV__c();
            ccv.Name = candidateName;
            ccv.Email__c = candidateEmail;
            ccv.Phone__c = candidatePhone;
            ccv.Status__c = candidateStatus;
            ccv.OwnerId = sys_adm.id;
            ccv.Candidate_Age__c = candidateAge;
            List<Selected_Job__c> selectedJobs = new List<Selected_Job__c>();
            try{
                insert ccv;
                selectedJobs = addSelectedJobs(listOfSelectedJobsIds, ccv.id, candidateAge, candidateSalary, candidateStatus, candidatePhone, candidateInfo);
				insert selectedJobs;                
                insertCVRecordFlag = true;
                insertSelectedJobRecordFlag = true;
            }
            catch(DMLException e){
                system.debug('exception: ' + e);
                insertCVRecordFlag = false;
				insertSelectedJobRecordFlag = false;                
            }
            uploadCandidatesImage(photo, ccv.Name, ccv.Id);
            if(insertSelectedJobRecordFlag && uploadImageFlag && insertCVRecordFlag){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Your CV was send successfuly!'));
                List<String> emails = new List<String>();
                emails.add(ccv.Email__c);
                sendEmailNotification(selectedJobs, emails);
            }
            else if(!insertSelectedJobRecordFlag || !uploadImageFlag || !insertCVRecordFlag){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Your CV was not send!'));
            }
        }
    }
    public List<Selected_Job__c> addSelectedJobs(Set<Id> selectedJobId, id candidateId, Integer candidateage,
                 String candidateSalary, String candidateStatus, String candidatePhone, String candidateInfo){
        
        List<Selected_Job__c> selectedJobs = new List<Selected_Job__c>();
        for(Id selctedJObId : selectedJobId){
            string selJobId = selctedJObId;
            string canId = candidateId;
            Selected_Job__c selectedJOb = new Selected_Job__c();
            selectedJOb.Job_Advertisement__c = selctedJObId;
            selectedJOb.CandidateCV__c = candidateId;
            selectedJOb.Candidate_Age__c = candidateage;
            selectedJOb.Candidate_Salary__c = candidateSalary;
            selectedJob.Candidate_Status__c = candidateStatus;
            selectedJob.Candidate_Phone__c = candidatePhone;
            selectedJob.Additional_Info__c = candidateInfo;
            selectedJob.External_Number__c = canId+selJobId;
            selectedJobs.add(selectedJob);
        }
        return  selectedJobs;                                            
    }
    public ContentVersion uploadCandidatesImage(Blob file, String candidateName, id recId){
        ContentVersion image = new ContentVersion();
        image.VersionData = file;
        image.title = candidateName;
        image.PathOnClient = '/image.jpg';
        image.IsMajorVersion = false;
        image.Candidate_Number__c = recId;
        try{
            insert image;
            ContentDocumentLink relatedFile = new ContentDocumentLink();
            Id contentid = [select ContentDocumentId from ContentVersion where Title =: candidateName LIMIT 1].ContentDocumentId;
            relatedFile.ContentDocumentId = contentid;
            relatedFile.LinkedEntityId = recId;
            relatedFile.ShareType = 'I';
            insert relatedFile;
            System.debug('image upload');
            uploadImageFlag = true;
        }
        catch(DMLException e){
            system.debug('image not upload');
            system.debug(e);
            uploadImageFlag = false;
        }
        return image;
    }
    public ContentVersion updateCandidateImage(ContentVersion candidateImage, Blob file){
        candidateImage.VersionData = file;
        try{
            update candidateImage;
            uploadImageFlag = true;
            system.debug('update');
        }
        catch(DMLException e){
            system.debug('not update');
            uploadImageFlag = false;
        }
        return candidateImage;
    }
    public void sendEmailNotification(List<Selected_Job__c> selectedJobs, List<String> email){
        String mailBody = 'Your resume received and will be reviewed soon. Your selected Jobs are: &nbsp;';
        for(Selected_Job__c job : selectedJobs){
            Job_Advertisement__c title = [select Name from Job_Advertisement__c where id =: job.Job_Advertisement__c];
            system.debug('title: ' + title);
            String recordName = title.Name;
            mailBody = mailBody + recordName + '&nbsp;'; 
            
        }
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(email);
        mail.setSubject('Resume received');
        mail.setHtmlBody(mailBody);
        try{
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }catch(exception e){
            system.debug('email was not send: ' + e);
        }
    }
}