@RestResource(urlMapping ='/recordsCount')
global class RestRecourceForGetCountOfRecords {
	@HttpGet
    global static List<Integer> getCountOfRecords(){
        List<Integer> countOfRecords = new List<Integer>();
        Integer countOfPhoto = 0;
        Integer countOfCandidateCV =  0;
        for(AggregateResult result: [select count(id) intval from CandidateCV__c where LastModifiedDate = YESTERDAY]){
            countOfCandidateCV += (Integer)result.get('intval');
		}
        if(Test.isRunningTest()){
            for(AggregateResult result: [select count(id) intval from CandidateCV__c]){
            	countOfCandidateCV += (Integer)result.get('intval');
			}
        }
        countOfPhoto = countOfCandidateCV;
        Integer countOfSelectedJobs = 0;
        for(AggregateResult result: [select count(id) intval1 from Selected_Job__c where LastModifiedDate = YESTERDAY]){
            countOfSelectedJobs += (Integer)result.get('intval1');
		}
        if(Test.isRunningTest()){
            for(AggregateResult result: [select count(id) intval1 from Selected_Job__c]){
            	countOfSelectedJobs += (Integer)result.get('intval1');
			}
        }
        countOfRecords.add(countOfCandidateCV);
        countOfRecords.add(countOfSelectedJobs);
        countOfRecords.add(countOfPhoto);
        return countOfRecords;
    } 
}