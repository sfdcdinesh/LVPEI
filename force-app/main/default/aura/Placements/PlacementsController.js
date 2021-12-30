({
    //Function Call on Component Load
    doInit: function(component, event, helper) {
        var action = component.get("c.getCurrentUser"); 
        action.setCallback(this, function(a) {
            var result = a.getReturnValue();
            component.set("v.runningUser", result.user); 
            component.set("v.branchAddress", result.branchAddress); 
        });
        $A.enqueueAction(action);
        
        
        //To get the parent ID From Related List 
        var Parameter = 'inContextOfRef';
        Parameter = Parameter.replace(/[\[\]]/g, "\\$&");
        var url = window.location.href;
        var regex = new RegExp("[?&]" + Parameter + "(=1\.([^&#]*)|&|#|$)");
        var results = regex.exec(url);
        if (!results) return null;
        if (!results[2]) return '';
        var value = decodeURIComponent(results[2].replace(/\+/g, " "));
        var context = JSON.parse(window.atob(value));
        component.set("v.recid", context.attributes.recordId);   
        //Ended To get the parent ID From Related List 
        var recid=component.get("v.recid");
        helper.checkforPlacementRecordCount(component,event,recid);  
        if(recid!=null || recid!=undefined || recid!=" "){ 
            component.set("v.placement.Request__c",recid);
            var action = component.get("c.getRequestDetails");
            action.setParams({
                "reqId":recid
            });
            action.setCallback(this,function(response){
                if(response.getState()==='SUCCESS'){
                    component.set("v.Request",response.getReturnValue());
                    component.set("v.placement.Request_ID__c",component.get("v.Request.Name"));
                    component.set("v.RequestType",component.get("v.Request.Request_Type__c"));
                    component.set("v.placement.Requesting_Surgeon__c",component.get("v.Request.Requesting_Surgeon__r.Name"));                       
                }
            });
            $A.enqueueAction(action)
        }
    },
    //Getting Request Details
    getDetails: function(component, event, helper) {
        var params = event.getParam('arguments');
        if(params!=null){
            component.set("v.ReqId", params.ReqId);         
            component.set("v.RequestName", params.RequestName);   
            component.set("v.placement.Requesting_Surgeon__c", params.RequestSurgeon);   
            component.set("v.RequestType", params.RequestType); 
        }
        component.set("v.placement.Request_ID__c", component.get("v.RequestName"));   
        component.set("v.placement.Request__c",component.get("v.ReqId"));
        
    },
    //Save Placement
    SavePlacement : function(component, event, helper) {
        //alert("Function Invoked!!");
        var newPlacement = component.get("v.placement");
        var tissueReturn = component.get("v.tissueReturn");
        var lookuptissue;
        if(component.get("v.tissuelookup") != null){
            lookuptissue = component.get("v.tissuelookup").Id;
        }
        console.log(lookuptissue);
        var lookupcontact;
        if(component.get("v.contactlookup") != null){
            lookupcontact = component.get("v.contactlookup").Id;
        }
        console.log(lookupcontact);
        var lookuprequest;
        if(component.get("v.requestlookup") != null){
            lookuprequest = component.get("v.requestlookup").Id;
        }
        console.log(lookuprequest);
        var lookuptocontact;
        if(component.get("v.tocontactlookup") != null){
            lookuptocontact = component.get("v.tocontactlookup").Id;
        }  
        console.log(lookuptocontact);
        var action = component.get("c.savePlacement");
        action.setParams({
            "p" : newPlacement, "tissue" : lookuptissue, "contact" : lookupcontact,
            "request" : lookuprequest, "tocontact" : lookuptocontact, "tissueReturn" : tissueReturn
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                component.set("v.plac",a.getReturnValue());
                component.set("v.recordId",component.get("v.plac").Id);
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "type": "Success",
                    "message": "Record Saved"
                });
                resultsToast.fire();
                component.set("v.displayPrintBtn",true);
                //To get the created record name
                var placName = component.get("c.getPlacementName");
                placName.setParams({
                    "placId":component.get("v.plac").Id
                    
                });
                placName.setCallback(this, function(a) {
                    var state = a.getState();
                    if(state === "SUCCESS"){
                        var placName = a.getReturnValue();
                        component.set("v.placName",placName.Name);    
                    }
                });
                $A.enqueueAction(placName)
                 var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": component.get("v.plac").Id
                });
                navEvt.fire();
                /*var homeEvt = $A.get("e.force:navigateToObjectHome");
                homeEvt.setParams({
                    "scope": "Placement__c"
                });
                homeEvt.fire();*/
            }else if(state === "INCOMPLETE"){
            	console.log("state is incomplete");
            }else if(state === "ERROR"){
                console.log("state is error");
            }
        });
        $A.enqueueAction(action)
    },
    //Open Modal
    openModel: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.isOpen", true); 
        component.set("v.viewreport", true);
        var picklistvals = [];        
        picklistvals.push({label: "Tissue Evaluation Form",
                           value: "Tissue Evaluation Form"});
        picklistvals.push({label: "Request Form",
                           value: "Request Form"});
        picklistvals.push({label: "Print Shipping Label",
                           value: "Print Shipping Label"});
        component.set("v.GenreList", picklistvals);
    },    
    handleGenreChange: function (component, event, helper) {
        //Get the Selected values   
        var selectedValues = event.getParam("value");
        
        //Update the Selected Values  
        component.set("v.selectedGenreList", selectedValues);
    },
    //Close Modal
    goback : function(component, event, helper){
        component.set("v.viewreport", true); 
    },
    //PDF Download
    downloadpdf : function(component, event, helper){
        var recordId = component.get("v.ref.Id");
        window.open('/apex/DownloadReportasPDF?refid='+recordId, '_blank');        
    },
    //Tissue Return PDF Form
    tissueReturndownloadpdf : function(component, event, helper){
        var tisRecordId = component.get("v.tissueReturnId");
        window.open('/apex/TissueReturnChecklistFormPdf?tisrtrnid='+tisRecordId, '_blank');        
    },   
    //Code for Shipping Label Report
    viewReport : function(component, event, helper) {
        var a1 = component.find("TDForm").get("v.value");
        var a2 = component.find("ARForm").get("v.value");
        var a3 = component.find("ACForm").get("v.value");
        var a4 = component.find("RIForm").get("v.value");
        var a5 = component.find("RQForm").get("v.value");
        var a6 = component.find("SLForm").get("v.value");
        var placement = component.get("v.plac");
        var placementId = component.get("v.recordId");
        //alert(placementId)
        window.open('/apex/DownloadReportasPDF?placId='+placementId+'&tisCheck='+a1+'&ARCheck='+a2+'&ACCheck='+a3+'&RICheck='+a4+'&RQCheck='+a5+
                    '&SLCheck='+a6, '_blank');  
        //component.set("v.viewreport", false);
        
    },
    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpen", false);
    }, 
    //Code for Sections Expand and Collapse
    one : function(component, event, helper) {
        helper.helperadd(component,event,'one');
    },
    two : function(component, event, helper) {
        helper.helperadd(component,event,'two');
    },
    three : function(component, event, helper) {
        helper.helperadd(component,event,'three');
    },
    openModelreturn: function(component, event, helper) {
        component.set("v.tisRtrn.Sent_to__c",component.get("v.placement.Requesting_Surgeon__c"));       
        component.set("v.isOpened", true);
    },
    
    closeModelReturn: function(component, event, helper) {
        
        component.set("v.isOpened", false);
    },
    //Tissue Return Save
    saveTissueReturn: function(component, event, helper) {
        
        var ret = component.get("v.tisRtrn");
        /*     if(component.get("v.CompletedBylookup") != null){
            lookupCompletedBy = component.get("v.CompletedBylookup").Id;
        }
        console.log(lookupCompletedBy); */
        var action =component.get("c.saveReturn");
        action.setParams({ 
            "tissueReturn": ret, /* "CompletedBy" : lookupCompletedBy */
        });
        action.setCallback(this,function(response){
            if(response.getState()==='SUCCESS'){
                alert(response.getState())
                var tisRtrn = response.getReturnValue();
                component.set("v.tissueReturnId",tisRtrn.Id);
                component.set("v.tissueReturn",tisRtrn);
            }
        })
        $A.enqueueAction(action);          
        
    },
    //Validation for DateTime Returned
    Change : function(component, event, helper) {
        var datetimesent = component.find("datesent").get("v.value");
        var datetimereturned = component.find("datereturn").get("v.value");
        var milliseconds = datetimesent.getTime() - datetimereturned.getTime();
        var seconds = milliseconds/(60*60);
        var hours = seconds/1000;
        
        if(hours > 0){
            if(hours > 24.0){
                alert('Tissue needs to be re-evaluated before distributing to any surgeon');
            }
            else{
                
            }
        }
        else{
            alert('DateTime Returned should not be Less than DateTime Sent');
        }
        
    },
    
    // Lookup Tab Index
    focusToNextField : function(component,event, helper){
        debugger;
        var selectedLookupLabel = event.getParam("label");
        var tissueid = event.getParam("recordId");
        console.log("Testing : "+selectedLookupLabel);
        if(selectedLookupLabel == "Select Tissue:"){
            var f1 = component.find("TisDisp");
            f1.focus();
        }   
        else if(selectedLookupLabel == "To"){
            var f2 = component.find("save");
            f2.focus();
        }
       /* var action = component.get("c.getDisposition");
        action.setParams({ 
            "tissueid": tissueid
        });
        action.setCallback(this,function(response){
            if(response.getState()==='SUCCESS'){
                var tissuedata= response.getReturnValue();
                var placementdata=component.get('v.placement');
                placementdata.Tissue_Disposition__c=tissuedata.Tissue_Disposition__c;
                component.set('v.placement',placementdata);
            }
        });
        $A.enqueueAction(action);*/
    }
    
    
})