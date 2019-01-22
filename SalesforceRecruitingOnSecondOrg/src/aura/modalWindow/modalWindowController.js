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
		if(component.find("fullName").get("v.value") && component.find("email").get("v.value") && component.find("age").get("v.value") && component.find("phone").get("v.value") && component.get("v.image")){
			component.set("v.noFieldComplete", false);
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
				if(response.getReturnValue() === 'Successful'){
					component.set("v.cvSendingSuccessfull", true);
                    component.set("v.errorCVSending", false);
					component.getEvent("sendCVSuccessful").fire();

				}
				else if(response.getReturnValue() != 'Successful'){
					component.set("v.errorCVSending", true);
                    component.set("v.noFieldComplete", false);
				}
			});
			$A.enqueueAction(action);
		}
		else if(!component.find("fullName").get("v.value") || !component.find("email").get("v.value") || !component.find("age").get("v.value") || !component.find("phone").get("v.value") || !component.get("v.image")){
			console.log('error in fields');
			component.set("v.noFieldComplete", true);
		}
    },
    validate : function(component, event, helper) {
        console.log("hello in validation");
        var pattern = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;;
        var emailField = component.find("leadEMail");
        var emailFieldValue = component.find("leadEMail").get("v.value");
        console.log(emailField.match(pattern));
        if(!$A.util.isEmpty(emailFieldValue)){
        if(emailFieldValue.match(pattern)){
            //$A.util.removeClass(emailField, 'validateField');
            emailField.set("v.errors", [{message: null}]);
            $A.util.removeClass(emailField, 'slds-has-error');
        }
        else if(!emailFieldValue.match(pattern)){
            //$A.util.addClass(emailField, 'validateField');
            emailField.set("v.errors", [{message: "Please Enter a Valid Email Address"}]);
            $A.util.addClass(emailField, 'slds-has-error');
            //sValidEmail = false;
        }
        }
    }
})