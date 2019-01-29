({
	deselectHandler : function(component, event, helper){
        console.log("tyt");
        var jobCount = component.get("v.selectJobCount");
        console.log("jobCount  " + jobCount);
        component.find("selectedJobCount").set("v.value", jobCount-1);
    	var selectedJobs = component.get("v.selectJobCount");
        if(selectedJobs > 0){
            component.find("applyButton").set("v.disabled", false);
        }
        else if(selectedJobs <= 0){
            component.find("applyButton").set("v.disabled", true);
        }
    },
    selectedJobHandler : function(component, event, helper){
        var jobCount = component.get("v.selectJobCount");
        component.find("selectedJobCount").set("v.value", jobCount+1); 
        component.find("applyButton").set("v.disabled", false);
    },
    applyButtonClick : function(component, event, helper) {
        console.log(component.get("v.selectJobCount"));
        var applyForJobEvent = $A.get("e.c:applyForJob");
        applyForJobEvent.fire();
    }
})