({
	getJobs : function(component, event) {
		var action = component.get("c.getJobs");
        action.setParams({
            queryLimit : component.get("v.recordsOnPage"),
            pageNumber : component.get("v.pageNumber"),
            fullName : component.get("v.fullName"),
            operator : component.get("v.operator"),
            salaryRange : component.get("v.salary"),
            publishDate : component.get("v.publishDate")
        })
        action.setCallback(this, function(response){
            var jobs = response.getReturnValue().searchRecords;
            if(jobs.length > 0){
                var lastPage = Math.ceil(response.getReturnValue().countOfRecords / component.get("v.recordsOnPage")) - 1;
                component.set("v.lastPageNumber", lastPage);
                component.set("v.jobAdvertisements", jobs);
                component.set("v.noRecordsFlag", false);
            }
            else if(jobs.length == 0){
                component.set("v.jobAdvertisements", jobs);
                component.set("v.noRecordsFlag", true);
            }
        });
        $A.enqueueAction(action);
	}
})