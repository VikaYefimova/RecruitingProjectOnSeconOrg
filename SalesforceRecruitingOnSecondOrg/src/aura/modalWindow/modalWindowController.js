({
	closeModel : function(component, event, helper) {
		var closeEvent = component.getEvent("closeWindow");
        closeEvent.fire();
	},
    handleFileChanges : function(component, event, helper){
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
    handleCandidateStatusChange : function(component, event, helper){
        var status = component.find("status").get("v.value");
        component.set("v.candidateStatus", status);
    },
    sendCV : function(component, event, helper) {
        //console.log('image     ' + component.get("v.image"));
        console.log(component.find("fullName").get("v.value") + " " + component.find("age").get("v.value"));
        console.log("selected jobs " + JSON.stringify(component.get("v.selectedJobs")));
        var action = component.get("c.sendCandidateCV");
		action.setParams({
			fullName : component.find("fullName").get("v.value"),
			email : component.find("email").get("v.value"),
			status : component.get("v.candidateStatus"),
			additionalInfo : component.find("comments").get("v.value"),
			salary : component.find("salary").get("v.value"),
			phone : component.find("phone").get("v.value"),
			age : component.find("age").get("v.value"),
			imageString : component.get("v.image"),
            selectedJobs : component.get("v.selectedJobs")
		});
		action.setCallback(this, function(response){
			console.log("response was sent!!!");
            console.log(response.getReturnValue());
		});
		$A.enqueueAction(action);
    },
})