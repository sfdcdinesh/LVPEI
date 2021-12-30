({
    //To Toggle Expand and Collapse on Sections
    helperadd : function(component,event,secId) {
        var acc = component.find(secId);
        for(var cmp in acc) {
            $A.util.toggleClass(acc[cmp], 'slds-show');  
            $A.util.toggleClass(acc[cmp], 'slds-hide');  
        }
    },
    
    //To prevent creation of more than 1 MR record for the corresponding Donor
    checkforMedicalRecordCount : function(component,event,recid) {
        var action = component.get("c.getMedicalCount");
        action.setParams({
            "parentId":recid
        });
        action.setCallback(this,function(response){
            if(response.getState()==='SUCCESS'){    
                var recordCount = response.getReturnValue();
                if(recordCount>=1){
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "type": "warning",
                        "message": "Please Try To Edit The Existing Record Or Delete and Create a New Record For This Donor!"
                    });
                    resultsToast.fire();  
                    
                    var homeEvt = $A.get("e.force:navigateToURL");
                    homeEvt.setParams({
                        "url": '/lightning/r/'+recid+'/related/Medical_Review__r/view'
                    });
                    homeEvt.fire();
                }
                
            }
        })
        $A.enqueueAction(action)
    },
    //To Populate Data From Referral And Recovery. 
    autoPopulate: function(component,event,recoveryId,Recovery){
        var recId="";
        
        //Through the Path
        if(Recovery!=" "){
            recId = Recovery.Id;
            component.set("v.MedRev.Recovery__c",recId);
            component.set("v.RecoveryId",recId);
        }
        //Through Related List
        else{
            recId = recoveryId;  
            component.set("v.RecoveryId",recId);
        }
        
        //Calling apex method to get the time durations.
        var populatedates = component.get("c.getDates");
        populatedates.setParams({
            "recoveryId":recId
        });
        populatedates.setCallback(this,function(response){
            if(response.getState()==='SUCCESS'){
                component.set("v.dates",response.getReturnValue());
                var dates1= component.get("v.dates");
                component.set("v.MedRev.Total_Cooling_Time__c",dates1[0]);
                component.set("v.MedRev.Death_to_Cornea_Preservation_Time__c",dates1[1]);
                console.log(dates1[1]);
                console.log(component.get("v.MedRev.Death_to_Cornea_Preservation_Time__c"));
                component.set("v.MedRev.Death_to_Cooling_Start_Time__c",dates1[2]);
                component.set("v.MedRev.Death_to_Current_Time__c",dates1[3]);
            }
        });
        $A.enqueueAction(populatedates);
        
        var recDetails = component.get("c.getRecoveryDetails");
        recDetails.setParams({
            "recoveryId":recId
        });
        recDetails.setCallback(this,function(response){
            if(response.getState()==="SUCCESS"){
                component.set("v.Rec",response.getReturnValue());
                var mName = 'MR-'+response.getReturnValue().Name;
                component.set("v.MedRev.Name",mName);
                component.set("v.MedRev.Branch_Name__c",response.getReturnValue().Branch_Name__c);
                component.set("v.BranchName",response.getReturnValue().Branch_Name__c);
                component.set("v.MedRev.Donor_Name_Id__c",component.get("v.Rec").Name);
                component.set("v.MedRev.Donor_Name__c",component.get("v.Rec").Donor_Name__c);
                component.set("v.donorAge",component.get("v.Rec.Referral__r.Age_of_Donor__c"));
                if(component.get("v.donorAge")!=null && component.get("v.donorAge")>12){
                    component.set("v.isAgeGt12",true);
                }
                component.set("v.donorGender",component.get("v.Rec.Referral__r.Gender__c"));
                component.set("v.MedRev.Date_Time_of_Death__c",component.get("v.Rec.Referral__r.Date_Time_of_Death__c"));
                component.set("v.MedRev.Cornea_Preservation_Date_Time__c",component.get("v.Rec").Cornea_Preservation_Date_Time__c);
	                component.set("v.MedRev.Tissue_Recovery_Date_Time__c",component.get("v.Rec").Tissue_recovery_date_time__c);
                component.set("v.MedRev.Date_Time_body_recovered_from_cooling__c",component.get("v.Rec").Date_Time_body_removed_from_cooling__c);
                component.set("v.MedRev.Date_Time_Body_Subjected_to_Cooling__c",component.get("v.Rec").Date_Time_body_subjected_to_cooling__c);
                component.set("v.MedRev.Primary_Cause_of_Death__c",component.get("v.Rec.Referral__r.Primary_Cause_of_Death__c"));
                component.set("v.MedRev.MedicalSurgical_History_Summary__c",component.get("v.Rec.Referral__r.Medical_Ocular_Histor__c"));
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
                }else if(elementId == 'HCV'){
                    component.set("v.HCVpicklistValues", allValues);
                }else if(elementId == 'HIV'){
                    component.set("v.HIVpicklistValues", allValues);
                }else if(elementId == 'Syphilis'){
                    component.set("v.SyphilispicklistValues", allValues);
                }else{
                    component.set("v.picklistValues1", allValues);  
                }
            }
        });
        $A.enqueueAction(action);
    }
})