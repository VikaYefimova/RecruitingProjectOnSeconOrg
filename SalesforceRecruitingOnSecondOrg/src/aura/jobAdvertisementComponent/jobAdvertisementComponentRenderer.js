({
	afterRender  : function(component, helper) {
    var ret = this.superAfterRender ();
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
                var selectButton = component.find("buttonSelectJob");
        	    selectButton.set("v.label", "Deselect");
                //console.log("label " + component.find("buttonSelectJob").get("v.label"));
                //selectButton.set("v.label", "Deselect");
            }
        }
    return ret;
	},
})