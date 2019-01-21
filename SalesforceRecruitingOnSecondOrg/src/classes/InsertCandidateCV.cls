public with sharing class InsertCandidateCV {
	public static Boolean uploadImageFlag = false;
	public static Boolean insertCVFlag = false;
	public static Boolean insertSelectedJobs = false;

	@AuraEnabled
	public static String sendCandidateCV(String fullName, String email, String status, String additionalInfo, String salary, String phone, Integer age, String imageString, List<Job_Advertisement__c> selectedJobs) {
		List<Selected_Job__c> jobs = new List<Selected_Job__c> ();
		List<CandidateCV__c> candidates = [select Id, Name FROM CandidateCV__c WHERE Email__c = :email limit 1];
		Blob photo = EncodingUtil.base64Decode(imageString);
		String sendingCVResult = '';
		if (candidates.size() == 0) {
			CandidateCV__c candidate = insertCandidateRecord(fullName, email, status, phone, age);
			try {
				insert candidate;
				insertCVFlag = true;
				jobs = insertSelectedJobs(candidate.Id, selectedJobs, age, status, phone, additionalInfo, salary);
				upsert jobs External_Number__c;
				insertSelectedJobs = true;

			}
			catch(DmlException e) {
				System.debug(e);
			}
			uploadCandidatesImage(photo, candidate.Name, candidate.Id);
		}
		else if (candidates.size() > 0) {
			for (CandidateCV__c can : candidates) {
				can.Email__c = email;
			}
			try {
				update candidates;
				insertCVFlag = true;
				jobs = insertSelectedJobs(candidates[0].Id, selectedJobs, age, status, phone, additionalInfo, salary);
				upsert jobs External_Number__c;
				insertSelectedJobs = true;
				sendEmailNotification(jobs, email);
			}
			catch(DMLException e) {
				system.debug('exception: ' + e);
				insertCVFlag = false;
				insertSelectedJobs = false;
			}
			id documentid = [select ContentDocumentId from ContentDocumentLink where LinkedEntityId = :candidates[0].id].ContentDocumentId;
			ContentVersion candidatesImage = [select id from ContentVersion where ContentDocumentId = :documentid And isLatest = True];
			updateCandidateImage(candidatesImage, photo);

		}
		if (uploadImageFlag && insertCVFlag && insertSelectedJobs) {
			sendingCVResult = 'Successful';
		}
		else if (!uploadImageFlag || !insertCVFlag || !insertSelectedJobs) {
			sendingCVResult = 'Error';
		}
		return sendingCVResult;
	}
	public static CandidateCV__c insertCandidateRecord(String fullName, String email, String status, String phone, Integer age) {
		String result = '';
		CandidateCV__c candidate = new CandidateCV__c();
		candidate.Name = fullName;
		candidate.Email__c = email;
		candidate.Candidate_Age__c = age;
		candidate.Phone__c = phone;
		candidate.Status__c = status;
		return candidate;
	}
	public static List<Selected_Job__c> insertSelectedJobs(Id candidateId, List<Job_Advertisement__c> selectedJobs, Integer candidateAge, String status, String phone, String additionalInfo, String salary) {
		List<Selected_Job__c> jobs = new List<Selected_Job__c> ();
		for (Job_Advertisement__c job : selectedJobs) {
			Selected_Job__c selectedJOb = new Selected_Job__c();
			selectedJOb.Job_Advertisement__c = job.Id;
			selectedJOb.CandidateCV__c = candidateId;
			selectedJOb.Candidate_Age__c = candidateAge;
			selectedJOb.Candidate_Salary__c = salary;
			selectedJob.Candidate_Status__c = status;
			selectedJob.Candidate_Phone__c = phone;
			selectedJob.Additional_Info__c = additionalInfo;
			selectedJob.External_Number__c = String.valueOf(candidateId) + String.valueOf(job.Id);
			jobs.add(selectedJob);
		}
		return jobs;
	}
	public static ContentVersion uploadCandidatesImage(Blob file, String candidateName, id recId) {
		ContentVersion image = new ContentVersion();
		image.VersionData = file;
		image.title = candidateName;
		image.PathOnClient = '/image.jpg';
		image.IsMajorVersion = false;
		image.Candidate_Number__c = recId;
		try {
			insert image;
			ContentDocumentLink relatedFile = new ContentDocumentLink();
			Id contentid = [select ContentDocumentId from ContentVersion where Candidate_Number__c = :recId LIMIT 1].ContentDocumentId;
			relatedFile.ContentDocumentId = contentid;
			relatedFile.LinkedEntityId = recId;
			relatedFile.ShareType = 'I';
			insert relatedFile;
			uploadImageFlag = true;
			System.debug('image upload');
		}
		catch(DMLException e) {
			system.debug('image not upload');
			system.debug(e);
			uploadImageFlag = false;
		}
		return image;
	}
	public static ContentVersion updateCandidateImage(ContentVersion candidateImage, Blob file) {
		candidateImage.VersionData = file;
		try {
			update candidateImage;
			uploadImageFlag = true;
			system.debug('update');
		}
		catch(DMLException e) {
			system.debug('not update');
			uploadImageFlag = false;
		}
		return candidateImage;
	}
	public static void sendEmailNotification(List<Selected_Job__c> selectedJobs, String email) {
		String mailBody = 'Your resume received and will be reviewed soon. Your selected Jobs are: &nbsp;';
		String[] toAddresses = new String[] { email };
		for (Selected_Job__c job : selectedJobs) {
			Job_Advertisement__c title = [select Name from Job_Advertisement__c where id = :job.Job_Advertisement__c];
			String recordName = title.Name;
			mailBody = mailBody + recordName + '&nbsp;';
		}
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		mail.setToAddresses(toAddresses);
		mail.setSubject('Resume received');
		mail.setHtmlBody(mailBody);
		try {
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
		} catch(exception e) {
			system.debug('email was not send: ' + e);
		}
	}
}