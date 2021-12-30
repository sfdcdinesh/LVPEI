({
    saveContact : function(component,event,helper) {
        var contact = component.get("v.Con");
        var requr = false;
        var conrole = component.get("v.contactRole");
        console.log("contact role is "+conrole);
        var resultsToast = $A.get("e.force:showToast");
        	resultsToast.setParams({
                "type": "error",
                "message": 'Please select any one of contact role.'
        });
        if(component.get("v.Con").EK_Circulator__c === false && component.get("v.Con").QA_Manager__c === false && 
           component.get("v.Con").EK_Technician__c === false && component.get("v.Con").Serology_Technician__c === false &&
           component.get("v.Con").Eye_Bank_Manager__c === false && component.get("v.Con").Slit_Lamp_Technician__c === false && 
           component.get("v.Con").Eye_Bank_Staff__c === false && component.get("v.Con").Specular_Technician__c === false &&
           component.get("v.Con").HCRP_Counselor__c === false && component.get("v.Con").Transplant_Hospital__c === false && 
           component.get("v.Con").HCRP_Hospital__c === false && component.get("v.Con").Transplant_Surgeon__c === false &&
           component.get("v.Con").HCRP_Manager__c === false && component.get("v.Con").Volunteer__c === false && 
           component.get("v.Con").Hospital_Staff__c === false && component.get("v.Con").Recovery_Technician__c === false &&
           component.get("v.Con").Microbiologist__c === false && component.get("v.Con").Distribution_Assistant__c === false && 
           component.get("v.Con").Organisation_Hospital__c === false)
        {
        	resultsToast.fire();  
        }else{
            requr = true;
        }

        if(requr === true)
        {
            var d = component.get("v.donorcon.Id");
            
            var action = component.get("c.saveContact");
            action.setParams({
                "con" : contact
            });
            action.setCallback(this,function(response){
                if(response.getState()==='SUCCESS'){
                    console.log("response success"+JSON.stringify(response.getReturnValue()));
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "type": "Success",
                        "message": 'Contact Saved Successfully'
                    });
                    resultsToast.fire();
                    console.log("after message fire");
                    //Close child component
                    var customlookup = component.get("v.CustomLookup");
        			customlookup.closecomp();
                    console.log("after modal close");
                    //Set Newly created contact to lookup
                    // get the selected record from list
                    console.log("before saving return value");  
                    var getSelectRecord = response.getReturnValue();
                    console.log("after saving return value");
                    console.log("newly created contact is "+JSON.stringify(getSelectRecord));
                    // call the event   
                    var compEvent = component.getEvent("oSelectedRecordEvent");
                    console.log("after getting event ....");
                    // set the Selected sObject Record to the event attribute.  
                    compEvent.setParams({
                    	"recordByEvent" : getSelectRecord,
                        "recordName" : getSelectRecord.Name,
                        "recordId" : getSelectRecord.Id
                    });  
                    // fire the event
                    console.log("before event fire....");  
                    compEvent.fire();
                    console.log("after event fire....");
                }             
            });
            $A.enqueueAction(action);
    }
    }
})