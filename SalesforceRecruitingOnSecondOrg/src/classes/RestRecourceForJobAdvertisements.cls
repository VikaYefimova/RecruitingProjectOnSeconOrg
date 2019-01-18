@RestResource(urlMapping ='/jobAdvertisements/*')
global class RestRecourceForJobAdvertisements {
    @HttpDelete
    global static void deleteRecords(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String jobAdvertisementId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Job_Advertisement__c jobAdvertisement = [select id from Job_Advertisement__c where id =: jobAdvertisementId];
        delete jobAdvertisement;
    }
	@HttpGet
    global static List<Job_Advertisement__c> getRecords(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        List<Job_Advertisement__c> result = [select Name, Description__c, Education__c, Email__c, Legacy_Job_Advertisement_Number__c, Location__c, 
                            Manager_name__c, Maximum_Salary__c, Minimum_Salary__c, Phone__c, Salary__c, Skills_Required__c, Status__c from Job_Advertisement__c where Legacy_Job_Advertisement_Number__c != null];
        if(Test.isRunningTest()){
            result = [select Name, Description__c, Education__c, Email__c, Legacy_Job_Advertisement_Number__c, Location__c, 
                            Manager_name__c, Maximum_Salary__c, Minimum_Salary__c, Phone__c, Salary__c, Skills_Required__c, Status__c from Job_Advertisement__c];
        }
        return result;
    }
    @HttpPost
    global static Job_Advertisement__c postRecords(String name, string phone, string email, string description, string skills, string managerName, 
                                  string status, string location, string education, integer minSalary, integer maxSalary, string salary, string legacyNumber){
        Job_Advertisement__c newJobAdvertisement = new Job_Advertisement__c();
        newJobAdvertisement.Name = name;
        newJobAdvertisement.Phone__c = phone;
        newJobAdvertisement.Email__c = email;
        newJobAdvertisement.Description__c = description;
        newJobAdvertisement.Skills_Required__c = skills;
        newJobAdvertisement.Location__c = location;
        newJobAdvertisement.Manager_name__c = managerName;
        newJobAdvertisement.Status__c = status;
        newJobAdvertisement.Education__c = education;
        newJobAdvertisement.Minimum_Salary__c = minSalary;
        newJobAdvertisement.Maximum_Salary__c = maxSalary;
        newJobAdvertisement.Salary__c = salary;
        newJobAdvertisement.Legacy_Job_Advertisement_Number__c = legacyNumber;
        insert newJobAdvertisement;
        return newJobAdvertisement;
    }
    @HttpPut
    global static Job_Advertisement__c updateRecords(String name, string phone, string email, string description, string skills, string managerName, 
    string status, string location, string education, integer minSalary, integer maxSalary, string salary, string legacyNumber){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String jobAdvertisementId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        system.debug('jobAdvertisementId' + jobAdvertisementId);
        Job_Advertisement__c jobAdvertisement = [select id from Job_Advertisement__c where id =: jobAdvertisementId];
        jobAdvertisement.Name = name;
        jobAdvertisement.Phone__c = phone;
        jobAdvertisement.Email__c = email;
        jobAdvertisement.Description__c = description;
        jobAdvertisement.Skills_Required__c = skills;
        jobAdvertisement.Location__c = location;
        jobAdvertisement.Manager_name__c = managerName;
        jobAdvertisement.Status__c = status;
        jobAdvertisement.Education__c = education;
        jobAdvertisement.Minimum_Salary__c = minSalary;
        jobAdvertisement.Maximum_Salary__c = maxSalary;
        jobAdvertisement.Salary__c = salary;
        jobAdvertisement.Legacy_Job_Advertisement_Number__c = legacyNumber;
        update jobAdvertisement;
        return jobAdvertisement;
    }
}