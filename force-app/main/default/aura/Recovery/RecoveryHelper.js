({
	helperadd : function(component,event,secId) {
	  var acc = component.find(secId);
        	for(var cmp in acc) {
        	$A.util.toggleClass(acc[cmp], 'slds-show');  
        	$A.util.toggleClass(acc[cmp], 'slds-hide');  
       }
	},
    //Dynamic Picklist Values Logic
   fetchPickListVal: function(component, fieldName, elementId) {
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.rec"),
            "fld": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
 
                if (allValues != undefined && allValues.length > 0) {
                    opts.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
                }
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                component.find(elementId).set("v.options", opts);
            }
        });
        $A.enqueueAction(action);
    },  
    //Recovery Record Count Logic and Display Error Message
    checkforRecoveryRecordCount : function(component,event,recid) {
        var action = component.get("c.getDonorCount");
        action.setParams({
            "parentId":recid
        });
        action.setCallback(this,function(response){
            if(response.getState()==='SUCCESS'){    
                var recordCount = response.getReturnValue();
                if(recordCount>=1){
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "type": "error",
                        "message": "Please Try To Edit The Existing Record Or Delete and Create a New Record For This Referral!"
                    });
                    resultsToast.fire();  
                    
                    var homeEvt = $A.get("e.force:navigateToURL");
                    homeEvt.setParams({
                         "url": '/lightning/r/'+recid+'/related/Recovery__r/view'
                    });
                    homeEvt.fire();
                }
                
            }
        })
        $A.enqueueAction(action)
    }
})