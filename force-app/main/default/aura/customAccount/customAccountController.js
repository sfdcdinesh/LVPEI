({
    validate : function(component, event, helper) {
        var inputCmp;
        var hcrphospital;
        var organisation;
        var transhospital;
        var hospital1;
    	var conrole = component.get("v.contactRole");
        console.log("contact role is "+conrole);
        var resultsToast = $A.get("e.force:showToast");
        	resultsToast.setParams({
                "type": "error",
                "message": 'Please select any one of contact role.'
        });
        if(conrole === "unitOrganisation"){
        	inputCmp = component.find("inputCmp").get("v.value");
        	console.log("inputCmp is "+inputCmp);
        	hcrphospital = component.find("hcrphospital").get("v.value");
        	console.log("hcrphospital is "+hcrphospital);
        	organisation = component.find("organisation").get("v.value");
        	console.log("organisation is "+organisation);
        	transhospital = component.find("transhospital").get("v.value");
        	console.log("transhospital is "+transhospital);    
        }else if(conrole !== "unitOrganisation"){
        	hospital1 = component.find("hospital1").get("v.value");
        	console.log("hospital1 is "+hospital1);    
        }
        
        
        if(conrole === "unitOrganisation" && inputCmp === false && hcrphospital === false && organisation === false && transhospital === false){
        	resultsToast.fire();  
            event.preventDefault();
        }else if(hospital1 === false){
            resultsToast.fire();
            event.preventDefault();
        }
    },
    
    handleSuccess : function(component, event, helper) {
        var payload = event.getParams().response;
        console.log("payload is "+JSON.stringify(payload));
        console.log("Payload id is "+payload.id);
        var action = component.get("c.fetchAccount");
        action.setParams({
        	"AccId" : payload.id
        });
        action.setCallback(this,function(response){
        	if(response.getState() === 'SUCCESS'){
                var result = response.getReturnValue();
                console.log("result is "+JSON.stringify(result));
        		var compEvent = component.getEvent("oSelectedRecordEvent");
                compEvent.setParams({
                    "recordByEvent" : result,
                    "recordName" : result.Name,
                    "recordId" : result.id
                });
                compEvent.fire();
                var customlookup = component.get("v.CustomLookup");
        		customlookup.closecompacc();
            }else if(response.getState() === 'ERROR'){
                console.log("error is "+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },
    
    CancelCreate:  function(component, event, helper) {
        var getevt = component.getEvent("test");
        getevt.setParams({
            "closeit":"false"
        });
        getevt.fire();
    },
    
    validateFields : function(component,event,helper){
        var zipcodeVal = component.find("zipcode").get("v.value");
        if(zipcodeVal != null){
            if(isNaN(zipcodeVal)){               
                component.set("v.eMsg","Please enter a valid format.");
                component.find("savebtn").set("v.disabled",true);
            }        
            else if(zipcodeVal.length > 10){
                component.set("v.eMsg","Zipcode is too long.");
                component.find("savebtn").set("v.disabled",true);
            }else{
                component.set("v.eMsg","");
                component.find("savebtn").set("v.disabled",false);
            } 
        }
    }
})