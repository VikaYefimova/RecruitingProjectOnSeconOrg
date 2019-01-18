trigger triggerForDeleteSelectedJobs on Job_Advertisement__c (after update) {
    for(Job_Advertisement__c job : Trigger.new){
        for(Job_Advertisement__c oldJob : Trigger.old){
            if(job.Status__c == 'Archived' && job.Status__c != oldJob.Status__c){
                List<Selected_Job__c> selectedJobs = [select id from Selected_Job__c where Job_Advertisement__c =: job.Id];
                delete selectedJobs;
            }
        }
    }
}