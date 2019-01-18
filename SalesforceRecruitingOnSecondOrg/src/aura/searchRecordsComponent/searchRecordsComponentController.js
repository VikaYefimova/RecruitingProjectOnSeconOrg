({
	doOnChangeOperator : function(component, event, helper) {
		var operator = component.find("operator").get("v.value");
        component.set("v.dateOperator", operator);
	},
    doOnChangeSalary : function(component, event, helper) {
		var operator = component.find("salaryRange").get("v.value");
        component.set("v.salary", operator);
	},
    searchRecods : function(component, event, helper){
        console.log("full name  " + component.find("fullName").get("v.value"));
        console.log("search date operator   " + component.get("v.dateOperator"));
        console.log("public date" + component.get("v.publishDate"));
        console.log("public date" + component.get("v.salary"));
        var searchRecords = component.getEvent("searchRecordsEvent");
        searchRecords.setParams({
            fullName : component.find("fullName").get("v.value"),
            operator : component.get("v.dateOperator"),
            publishDate: component.get("v.publishDate"),
            salaryRange: component.get("v.salary")
        });
        searchRecords.fire();
	},
    resetResults: function(component, event, helper){
        var resetSearchEvent = component.getEvent("resetSearchResults");
        resetSearchEvent.fire();
        component.find("fullName").set("v.value", "");
        component.find("fieldDate").set("v.value", "");
        component.set("v.dateOperator", "");
        component.set("v.salary", "");
    },
    checkValidity : function(component, event, helper) {
        var inputCmp = component.find("fieldDate");
        inputCmp.setCustomValidity("");
        var value = inputCmp.get("v.value");
        console.log('value: '+value);
        var lowerRange = new Date("2018-09-05");
        var higherRange = new Date("2020-09-22");
        if(!inputCmp.checkValidity()){
        if(Date.parse(value)){
        if (Date.parse(value) < lowerRange) {
        inputCmp.setCustomValidity("Select correct date range");
        }else if (Date.parse(value) > higherRange){
        inputCmp.setCustomValidity("Select correct date range");
        }
        }else{
        inputCmp.setCustomValidity();
        }
        }
        inputCmp.reportValidity();
	}
})