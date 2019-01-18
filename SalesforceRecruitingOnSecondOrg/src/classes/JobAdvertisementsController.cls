public with sharing class JobAdvertisementsController {
    public static Set<Id> selectedJobIds = new Set<Id>();
    public static String mainsearchPart = 'select Name, Salary__c, Location__c, Education__c, Description__c, Manager_name__c, Email__c, Phone__c from Job_Advertisement__c where Status__c != \'Archived\'';
    public static String searchCriteriaPart = '';
    public static String finishsearchPart = ' limit :searchLimit OFFSET :offsetsize';
	@AuraEnabled
    public static wrapJobAdvertisements getJobs(Integer queryLimit, Integer pageNumber, String fullName, String operator, String salaryRange, String publishDate){
        system.debug('queryLimit' + queryLimit);
        Integer searchLimit = Integer.valueOf(queryLimit);
        Integer offsetsize = Integer.valueOf(pageNumber) * searchLimit;
        searchCriteriaPart = searchByName(searchCriteriaPart, fullName);
        searchCriteriaPart = searchBySalary(searchCriteriaPart, salaryRange);
        searchCriteriaPart = searchByPublishDate(searchCriteriaPart, publishDate, operator);
        Integer total = Database.countQuery('select count() from Job_Advertisement__c where Status__c != \'Archived\'' + searchCriteriaPart);
        List<Job_Advertisement__c> results = Database.query(mainsearchPart + searchCriteriaPart + finishsearchPart);
        wrapJobAdvertisements jobs = new wrapJobAdvertisements(total, results);
        system.debug('name ' + fullName + 'operator' + operator + 'salary' + salaryRange + 'publishDate ' + publishDate);
        system.debug('jobs  ' + jobs);
        return jobs;
    }
    public static String searchByName(String searchQuery, String name){
        if(!String.isEmpty(name)){
            searchQuery= searchQuery + ' AND Name LIKE \'%'+name+'%\'';
        }
        return searchQuery;
    }
    public static String searchBySalary(String searchQuery, String salaryRange){
        if(!String.isEmpty(salaryRange)){
            searchQuery= searchQuery + ' AND Salary__c LIKE \'' + salaryRange +'\'';
        }
        return searchQuery;
    }
    public static String searchByPublishDate(String searchQuery, String publishDate, String operator){
        if(!String.isEmpty(publishDate) && operator != ''){
            if(operator == '<'){
                searchQuery= searchQuery + ' AND DAY_ONLY(CreatedDate) <= ' + publishDate;
            }
            else if(operator == '>'){
                searchQuery= searchQuery + ' AND DAY_ONLY(CreatedDate) >= ' + publishDate;
            }
        }
        return searchQuery;
    }
    @AuraEnabled
    public static List<Job_Advertisement__c> getSelectedJobs(String selectedJobId){
        List<Job_Advertisement__c> selectedJobs = [select id, Name, Location__c, Description__c, Education__c, Salary__c, Manager_name__c, Phone__c, Email__c from Job_Advertisement__c where id in :getSelectedId(selectedJobId)];
        return selectedJobs;
    }
    private static Set<Id> getSelectedId(Id selectedId){
        selectedJobIds.add(selectedId);
        return selectedJobIds;
    }
    
    public class wrapJobAdvertisements{
        @AuraEnabled
        public Integer countOfRecords;
        @AuraEnabled
        public List<Job_Advertisement__c> searchRecords = new List<Job_Advertisement__c>();
        
        public wrapJobAdvertisements(Integer count, List<Job_Advertisement__c> records){
            countOfRecords = count;
            searchRecords = records;
        }
    }
}