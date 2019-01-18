({
	deselectJob : function(component, event, helper) {
        console.log("salary: " + component.get("v.selectedJob.Salary__c"));
        var selectedJobs = component.get("v.selectedJobs");
        var currentJob = component.get("v.selectedJob");
        var selectedJobIndex = null;
        /*var stringForFind = "Id";
        console.log("id:    " + currentJob);
        var index = JSON.stringify(currentJob).indexOf(stringForFind);
        console.log("index find : " + index);
        var string = JSON.stringify(currentJob).slice(index+5, index+5+18);
        console.log(string);*/
        //var index = JSON.stringify(currentJob).indexOf(stringForFind);
        for(var i=0; i<selectedJobs.length; i++){
            if(component.get("v.selectedJob.Id") === selectedJobs[i].Id){
                console.log("hi i here");
                selectedJobIndex = i;
            }
        }
        selectedJobs.splice(selectedJobIndex, 1);
        console.log("selected jobs: " + selectedJobs);
        component.set("v.selectedJobs", selectedJobs);
        var deselectJobEvent = $A.get("e.c:DeselectJob");
        deselectJobEvent.fire();
	}
})