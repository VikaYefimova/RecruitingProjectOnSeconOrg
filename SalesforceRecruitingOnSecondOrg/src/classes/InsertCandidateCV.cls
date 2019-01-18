public with sharing class InsertCandidateCV {
    
    
    @AuraEnabled
    public static String sendCandidateCV(String fullName, String email, String status, String additionalInfo, String salary, String phone, Integer age, String imageString, List<Job_Advertisement__c> selectedJobs){
	    system.debug('fullName' + fullName);
		System.debug('email' + email);
		System.debug('status' + status);
		system.debug('image ++++     : ' + imageString);
		System.debug('selected jobs :   ' + selectedJobs);
        return 'Hello in Apex class';
    }
}