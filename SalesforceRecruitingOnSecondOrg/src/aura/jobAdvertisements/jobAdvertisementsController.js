({
	doInit : function(component, event, helper) {
        component.set("v.pageNumber", '0');
        component.set("v.fullName", "");
        component.set("v.operator", "");
        component.set("v.publishDate", "");
        component.set("v.salary", "");
		helper.getJobs(component, event);
        component.find("applyButton").set("v.disabled", true);
	},
    deselectHandler : function(component, event, helper){
        console.log("tyt");
        var jobCount = component.get("v.selectJobCount");
        component.find("selectedJobCount").set("v.value", jobCount-1);
    	var selectedJobs = component.get("v.selectedJobAdvertisements");
        if(selectedJobs.length > 0){
            component.find("applyButton").set("v.disabled", false);
        }
        else if(selectedJobs.length <= 0){
            component.find("applyButton").set("v.disabled", true);
        }
    },
    selectedJobHandler : function(component, event, helper){
        var jobCount = component.get("v.selectJobCount");
        component.find("selectedJobCount").set("v.value", jobCount+1); 
        component.find("applyButton").set("v.disabled", false);
    },
    handleCountRecordChange : function(component, event, helper){
        var selectedValue = component.find("recordsCount").get("v.value");
        component.set("v.recordsOnPage", selectedValue);
        component.set("v.pageNumber", '0');
        helper.getJobs(component, event);
    },
    applyButtonClick : function(component, event, helper){
        component.set("v.isOpen", true); 
    },
    closeModel: function(component, event, helper) {  
        component.set("v.isOpen", false);
    },
    sendCVHandler: function(component, event, helper) {
		window.setTimeout(
			$A.getCallback(function() {
				component.set("v.isOpen", false);
			}), 3000
		);
    },
    handleFileChanges: function(component, event, helper){
        var files = event.getSource().get("v.files")[0];
        if(files.size < 131072){
            if ( files.type.indexOf("image/") == 0 ) {    
                    var img = component.find("imagePreview").getElement();
                    img.src = URL.createObjectURL(files);
            }
            var imageContent = ''
            var reader = new FileReader();
            reader.onloadend = function(){
                imageContent = btoa(reader.result);
                component.set("v.image", imageContent);
            }
            reader.readAsBinaryString(files);
        }
        else if(files.size > 131072){
            alert('File uploads must be less than 128KB in size. Your file size is: ' + (Math.round(files.size/1024)) + 'KB');
        }
    },
    handleCandidateStatusChange: function(component, event, helper){
        var status = component.find("status").get("v.value");
        component.set("v.candidateStatus", status);
    },
    goToFirstPage : function(component, event, helper){
        component.set("v.pageNumber", 0);
        console.log(component.get("v.pageNumber") + " and " + component.get("v.lastPageNumber"));
        component.set("v.disablePrevious", true);
        if(component.get("v.pageNumber") != component.get("v.lastPageNumber")){
            component.set("v.disableNext", false);
        }
        else{
            component.set("v.disableNext", true);
        }
        helper.getJobs(component, event);
    },
    goToPreviousPage : function(component, event, helper){
        var pageNumber = parseInt(component.get("v.pageNumber")) - 1;
        component.set("v.pageNumber", pageNumber);
        console.log(component.get("v.pageNumber") + " and " + component.get("v.lastPageNumber"));
        if(component.get("v.pageNumber") === 0){
            component.set("v.disablePrevious", true);
        }
        else{
            component.set("v.disablePrevious", false);
        }
        if(component.get("v.pageNumber") === component.get("v.lastPageNumber")){
            component.set("v.disableNext", true);
        }
        else{
            component.set("v.disableNext", false);
        }
        helper.getJobs(component, event);
    },
    goToNextPage : function(component, event, helper){
        var pageNumber = parseInt(component.get("v.pageNumber")) + 1;
        console.log('pageNumber' + pageNumber);
        component.set("v.pageNumber", pageNumber);
        if(component.get("v.pageNumber") === component.get("v.lastPageNumber")){
            component.set("v.disableNext", true);
        }
        if(component.get("v.pageNumber") === 0){
            component.set("v.disablePrevious", true);
        }
        else{
            component.set("v.disablePrevious", false);
        }
        helper.getJobs(component, event);
    },
    goToLastPage : function(component, event, helper){
        component.set("v.pageNumber", parseInt(component.get("v.lastPageNumber")));
        component.set("v.disableNext", true);
        if(component.get("v.pageNumber") === 0){
            component.set("v.disablePrevious", true);
        }
        else{
            component.set("v.disablePrevious", false);
        }
        console.log(component.get("v.pageNumber") + " and " + component.get("v.lastPageNumber"));
        helper.getJobs(component, event);
    },
    searchRecords : function(component, event, helper){
        var fullName = event.getParam("fullName");
        component.set("v.fullName", fullName);
        var operator = '';
        if(event.getParam("operator") === 'before'){
            operator = "<";
        }
        else if(event.getParam("operator") === 'after'){
            operator = ">";
        }
        component.set("v.operator", operator);
        var date;
        if(event.getParam("publishDate") === null){
            date = '';
        }
        else{
            date = event.getParam("publishDate");
        }
        component.set("v.publishDate", date);
        var salary = event.getParam("salaryRange");
        component.set("v.salary", salary);
        if(fullName === '' && operator === '' &&  date === '' && salary === ''){
            alert("You haven't enter any criteria for search!");
        }
        else if(fullName === '' || operator === '' || date === '' || salary === ''){
            helper.getJobs(component, event);
        }
    },
    resetSearch : function(component, event, helper){
    	component.set("v.pageNumber", '0');
        component.set("v.fullName", "");
        component.set("v.operator", "");
        component.set("v.publishDate", "");
        component.set("v.salary", "");
		helper.getJobs(component, event);
	}
})