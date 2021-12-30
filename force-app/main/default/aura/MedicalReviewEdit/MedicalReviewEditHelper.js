({
    //To Toggle Expand and Collapse on Sections
    helperadd : function(component,event,secId) {
        var acc = component.find(secId);
        for(var cmp in acc) {
            $A.util.toggleClass(acc[cmp], 'slds-show');  
            $A.util.toggleClass(acc[cmp], 'slds-hide');  
        }
    },
    
    //To Populate Data From Referral And Recovery. 
    autoPopulate: function(component,event,ParentId){
        
        //Calling apex method to get the time durations.
        var dates = component.get("c.getDates");
        dates.setParams({
            "recoveryId":ParentId
        });
        dates.setCallback(this,function(response){
            //alert(response.getState())
            if(response.getState()==="SUCCESS"){
                component.set("v.dates",response.getReturnValue());
                var dates= component.get("v.dates");
                component.set("v.MedRev.Total_Cooling_Time__c",dates[0]);
                component.set("v.MedRev.Death_to_Cornea_Preservation_Time__c",dates[1]);
                component.set("v.MedRev.Death_to_Cooling_Start_Time__c",dates[2]);
                component.set("v.MedRev.Death_to_Current_Time__c",dates[3]);
            }
            else if (response.getState() === "INCOMPLETE") {
                console.log("Failed to connect Salesforce!!");
            }else if (response.getState() === "ERROR") {
                var errors = response.getError();
                if (!errors) {
                    errors = [{"message" : "Unknown Error Occured"}];
                }
                console.log(errors);
            }
        });
        $A.enqueueAction(dates);
        
        var recDetails = component.get("c.getRecoveryDetails");
        recDetails.setParams({
            "recoveryId":ParentId
        });
        recDetails.setCallback(this,function(response){
            if(response.getState()==='SUCCESS'){
                component.set("v.Rec",response.getReturnValue());
                //component.set("v.MedRev.Donor_Name__c",component.get("v.Rec").Donor_Name__c);
                component.set("v.MedRev.Referral__c",component.get("v.Rec").Referral__c);
                component.set("v.MedRev.Branch_Name__c",response.getReturnValue().Branch_Name__c);
                //alert(component.get("v.Rec").Referral__c);
                component.set("v.MedRev.Cornea_Preservation_Date_Time__c",component.get("v.Rec").Cornea_Preservation_Date_Time__c);
                component.set("v.MedRev.Tissue_Recovery_Date_Time__c",component.get("v.Rec").Tissue_recovery_date_time__c);
                component.set("v.MedRev.Date_Time_body_recovered_from_cooling__c",component.get("v.Rec").Date_Time_body_removed_from_cooling__c);
                component.set("v.MedRev.Date_Time_Body_Subjected_to_Cooling__c",component.get("v.Rec").Date_Time_body_subjected_to_cooling__c);
                component.set("v.donorAge",component.get("v.Rec.Referral__r.Age_of_Donor__c"));
                if(component.get("v.donorAge")!=null && component.get("v.donorAge")>12){
                    component.set("v.isAgeGt12",true);
                }
                component.set("v.donorGender",component.get("v.Rec.Referral__r.Gender__c"));
                component.set("v.MedRev.Date_Time_of_Death__c",component.get("v.Rec.Referral__r.Date_Time_of_Death__c"));
                component.set("v.MedRev.Primary_Cause_of_Death__c",component.get("v.Rec.Referral__r.Primary_Cause_of_Death__c")); 
                component.set("v.MedRev.Medical_Surgical_History_Summary__c",component.get("v.Rec.Referral__r.Medical_Ocular_Histor__c"));
                if(component.get("v.Rec.Referral__r.Weight__c")!=null && component.get("v.Rec.Referral__r.Weight__c")!="" && component.get("v.Rec.Referral__r.Weight__c")!='undefined'){
                    component.set("v.MedRev.Pulse_Value_PV__c",component.get("v.Rec.Referral__r.Weight__c")/0.025);
                    component.set("v.MedRev.Blood_Value__c",component.get("v.Rec.Referral__r.Weight__c")/0.015);
                }
                else{
                    component.set("v.MedRev.Pulse_Value_PV__c","");
                    component.set("v.MedRev.Blood_Value__c","");
                }
                
                if(component.get("v.Rec").Collected_By__c!=null){
                    component.set("v.sampleCollectedBy",component.get("v.Rec.Collected_By__r.Name"));
                }
                if(component.get("v.Rec").Date_Time_of_blood_sample_collection__c!=null){
                    component.set("v.sampleCollectedOn",component.get("v.Rec").Date_Time_of_blood_sample_collection__c);
                } 
            }
        });
        $A.enqueueAction(recDetails);
    },
    
    //To get the Picklist Values Dynamically.
    fetchPickListVal: function(component,fieldName,elementId) {
        component.set("v.picklistValues", "");
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.MedRev"),
            "fld": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                if(elementId == 'HBsAg'){
                    component.set("v.HBsAgpicklistValues", allValues);
                    console.log("In HBsAg "+allValues);
                }else if(elementId == 'HCV'){
                    component.set("v.HCVpicklistValues", allValues);
                    console.log("In HCV "+allValues);
                }else if(elementId == 'HIV'){
                    component.set("v.HIVpicklistValues", allValues);
                    console.log("In HIV "+allValues);
                }else if(elementId == 'Syphilis'){
                    component.set("v.SyphilispicklistValues", allValues);
                    console.log("In Syphilis "+allValues);
                }else{
                    component.set("v.picklistValues1", allValues);  
                    console.log("In reason "+allValues);
                }
            }
        });
        $A.enqueueAction(action);
    }
})