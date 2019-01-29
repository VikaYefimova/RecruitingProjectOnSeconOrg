({
	buttonClick : function(component, event, helper) {
        if(component.find("buttonIcon").get("v.iconName") === 'utility:chevronup'){
            var buttonIcon = component.find("buttonIcon").set("v.iconName", "utility:chevrondown");
            var childForm = component.find("childPart");
        	$A.util.toggleClass(childForm, "slds-hide");
        }
        else{
            var childForm = component.find("childPart");
            $A.util.toggleClass(childForm, "slds-hide");
            var buttonIcon = component.find("buttonIcon").set("v.iconName", "utility:chevronup");
            
        }
	},
    selectJob : function(component, event, helper) {
        var selectButton = component.find("buttonSelectJob");
        var selectedJobs = component.get("v.selectedJobs");
        var arrayOfJobs = component.get("v.jobs");
        if(selectButton.get("v.label") === "Select"){
           selectedJobs.push(component.get("v.job"));
           component.set("v.selectedJobs", selectedJobs); 
           selectButton.set("v.label", "Deselect");
           var selectjobEvent = $A.get("e.c:SelectJob");
           selectjobEvent.fire();
        }
        else if(selectButton.get("v.label") === "Deselect"){
            console.log("salary: " + component.get("v.selectedJob.Salary__c"));
            var currentJob = component.get("v.job");
            var selectedJobIndex = null;
            for(var i=0; i<selectedJobs.length; i++){
                if(component.get("v.job.Id") === selectedJobs[i].Id){
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
	},
    selectedJobsChange : function(component, event, helper){
        console.log('i in change select');
        var selectedJobs = component.get("v.selectedJobs");
        var selectedJobflag = false;
        var currentJob = component.get("v.job");
        var stringForFind = "Id";
        var index = JSON.stringify(currentJob).indexOf(stringForFind);
        var currentJobId = JSON.stringify(currentJob).slice(index+5, index+5+18);
        for(var i=0; i<selectedJobs.length; i++){
            index = JSON.stringify(selectedJobs[i]).indexOf(stringForFind);
            var jobId = JSON.stringify(selectedJobs[i]).slice(index+5, index+5+18);
            if(currentJobId === jobId){
               selectedJobflag = true;
               break;
            }
        }
        if(!selectedJobflag){
            var selectButton = component.find("buttonSelectJob");
        	selectButton.set("v.label", "Select");
        }
    },
})