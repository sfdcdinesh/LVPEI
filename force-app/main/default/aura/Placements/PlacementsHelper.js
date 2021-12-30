({
    //Code for Hide and Show Sections
	helperadd : function(component,event,secId) {
	  var acc = component.find(secId);
        	for(var cmp in acc) {
        	$A.util.toggleClass(acc[cmp], 'slds-show');  
        	$A.util.toggleClass(acc[cmp], 'slds-hide');  
       }
	},
    
    //To prevent creation of more than 1 Placement record for the corresponding Request
    checkforPlacementRecordCount : function(component,event,recid) {
        var action = component.get("c.getPlacementCount");
        action.setParams({
            "parentId":recid
        });
        action.setCallback(this,function(response){
            if(response.getState()==='SUCCESS'){    
                var recordCount = response.getReturnValue();
                console.log("response is "+JSON.stringify(response.getReturnValue()));
                if(recordCount >= 1){
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "type": "warning",
                        "message": "Please Try To Edit The Existing Record Or Delete and Create a New Record For This Donor!"
                    });
                    resultsToast.fire();  
                    
                    var homeEvt = $A.get("e.force:navigateToURL");
                    homeEvt.setParams({
                         "url": '/lightning/r/'+recid+'/related/Placement__r/view'
                    });
                    homeEvt.fire();
                }
                
            }
        })
        $A.enqueueAction(action)
    },
})