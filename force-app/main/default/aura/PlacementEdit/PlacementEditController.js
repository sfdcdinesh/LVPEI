({
    //Function Call on Component Load
     doInit: function(component, event, helper) {
        //To get the Current User
        var action = component.get("c.getCurrentUser"); 
        action.setCallback(this, function(a) {
            var result = a.getReturnValue();
            component.set("v.runningUser", result.user); 
            component.set("v.branchAddress", result.branchAddress); 
           // component.set("v.runningUser", a.getReturnValue()); 
        });
        $A.enqueueAction(action);
         
       //To populate the lookups
        var action0 = component.get("c.getLookups");
        action0.setParams({
            "placID":component.get("v.recordId")  
        });
        action0.setCallback(this,function(response){
            if(response.getState()==="SUCCESS"){
                console.log("response "+JSON.stringify(response.getReturnValue()));
                component.set("v.lookupList",response.getReturnValue());
                var lookupList = component.get("v.lookupList");
                if(lookupList['con1']!=null){
                component.set("v.tissuelookup",lookupList['con1']); 
                }
                else{
                component.set("v.tissuelookup",{});   
                }
                if(lookupList['con2']!=null){
                component.set("v.contactlookup",lookupList['con2']);  
                }
                else{
                component.set("v.contactlookup",{});   
                }
                if(lookupList['con3']!=null){
                component.set("v.tocontactlookup",lookupList['con3']);
                }
                else{
                component.set("v.tocontactlookup",{});   
                }              
            }
        });
        $A.enqueueAction(action0);
         
       //To get the required details for the Tissue-Return Form
       var action1 = component.get("c.getPlacementDetails");
        action1.setParams({
            "placID":component.get("v.recordId")  
        });
        action1.setCallback(this,function(response){
            if(response.getState()==="SUCCESS"){
                console.log("response is "+JSON.stringify(response.getReturnValue()));
                component.set("v.plac",response.getReturnValue());
                component.set("v.tisRtrn.Tissue_ID__c",component.get("v.placement.Select_Tissue__c"));
                component.set("v.tisRtrn.Tissue_Id1__c",component.get("v.placement.Select_Tissue__r.Name"));
                component.set("v.tisRtrn.Sent_to__c",component.get("v.placement.Requesting_Surgeon__c")); 
                component.set("v.tisRtrn.Date_Time_Sent__c",component.get("v.placement.ETD_Date_Time__c"));          
            }
        });
        $A.enqueueAction(action1)
        
        //Get Request Details
		var placement = component.get("v.placement");
        var action2 = component.get("c.getRequestDetails");
        action2.setParams({
             "reqId" : placement.Request__c
        });
         action2.setCallback(this,function(res){
             if(res.getState() === "SUCCESS"){
                 console.log("res state is SUCCESS");
                 component.set("v.RequestType",res.getReturnValue().Request_Type__c);
             }else if(res.getState() === "INCOMPLETE"){
                 console.log("res state is INCOMPLETE");
             }else if(res.getState() === "ERROR"){
                 console.log("res state is ERROR");
             }
         });
         $A.enqueueAction(action2)
    },
    
    //Save Placement
    clickCreate : function(component, event, helper) {
        var newPlacement = component.get("v.placement");
        var tissueReturn = component.get("v.tisRtrn");
        var lookuptissue = '';
        if(component.get("v.tissuelookup") != null){
            lookuptissue = component.get("v.tissuelookup").Id;
        }
        console.log(lookuptissue);
        var lookupcontact = '';
        if(component.get("v.contactlookup") != null){
            lookupcontact = component.get("v.contactlookup").Id;
        }
        console.log(lookupcontact);
        var lookuprequest = '';
        if(component.get("v.requestlookup") != null){
            lookuprequest = component.get("v.requestlookup").Id;
        }
        var lookuptocontact = '';
        if(component.get("v.tocontactlookup") != null){
            lookuptocontact = component.get("v.tocontactlookup").Id;
        }    debugger;                                
        var action = component.get("c.savePlacement");
        action.setParams({
            "p" : newPlacement, "tissue" : lookuptissue, "contact" : lookupcontact,
            "request" : lookuprequest, "tocontact" : lookuptocontact,"tissueReturn" : tissueReturn, "placeID":component.get("v.recordId")
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
            	var name = a.getReturnValue();
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                	"type": "Success",
                	"message": "Record Updated"
            	});
            	resultsToast.fire();
            	window.location.reload();
                /*var homeEvt = $A.get("e.force:navigateToObjectHome");
                homeEvt.setParams({
                "scope": "Placement__c"
                });
                homeEvt.fire();*/
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
    goback : function(component, event, helper){
        component.set("v.viewreport", true); 
    },
    //PDF Download
    downloadpdf : function(component, event, helper){
        var recordId = component.get("v.ref.Id");
        window.open('/apex/DownloadReportasPDF?refid='+recordId, '_blank');        
    },    
    //View Tissue Return Checklist Button Functionality
    tissueReturndownloadpdf : function(component, event, helper){
       var RecordId = component.get("v.recordId");
        console.log(RecordId);
       window.open('/apex/TissueReturnChecklistFormPdf?tisrtrnid='+RecordId, '_blank');        
   },  
    //Code for Shipping Label Report
    viewReport : function(component, event, helper){
       var a1 = component.find("TDForm").get("v.value");
        var a2 = component.find("ARForm").get("v.value");
        var a3 = component.find("ACForm").get("v.value");
        var a4 = component.find("RIForm").get("v.value");
        var a5 = component.find("RQForm").get("v.value");
        var a6 = component.find("SLForm").get("v.value");
        var placement = component.get("v.plac");
        var placementId = component.get("v.recordId");
        window.open('/apex/DownloadReportasPDF?placId='+placementId+'&tisCheck='+a1+'&ARCheck='+a2+'&ACCheck='+a3+'&RICheck='+a4+'&RQCheck='+a5+
                    '&SLCheck='+a6, '_blank');         
    },
    tissue :  function(component, event, helper){
        //alert(component.find("tiss").get("v.value"));
    },
    reqst :  function(component, event, helper){
       // alert(component.find("req").get("v.value"));
    },
    shipp : function(component, event, helper){
        //alert(component.find("ship").get("v.value"));
    },
    //Close Modal
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
    // Tissue Return
     openModelreturn: function(component, event, helper) {        
        component.set("v.isOpened", true);
    },
    
        closeModelReturn: function(component, event, helper) {
       
        component.set("v.isOpened", false);
    },
    //Code for Saving Modal
    savemodal: function(component, event, helper) {
        component.set("v.tisRtrn.Placement__c",component.get("v.recordId"));          
        var ret = component.get("v.tisRtrn");
        var CompletedBylookup = component.get("v.CompletedBylookup").Id;
        var action = component.get("c.saveReturn");
        action.setParams({ 
            "tissueReturn": ret,"CompletedBylookup":CompletedBylookup
        });
        action.setCallback(this,function(response){
            if(response.getState()==='SUCCESS'){
                var resultsToast = $A.get("e.force:showToast");
                 resultsToast.setParams({
                "type": "Success",
                "message": "Record Saved"
            });
            resultsToast.fire();
            
                var tisRtrn = response.getReturnValue();
                component.set("v.tissueReturn",tisRtrn);
                component.set("v.RcdId",tisRtrn.Id);
                var tissueReturnId = component.getEvent("tissueReturnId");
                tissueReturnId.setParams({
                    "tissueReturnId":tisRtrn.Id
                });
                tissueReturnId.fire();
            }
        })
        
        $A.enqueueAction(action);          
        component.set("v.isOpened", false);        
    }, 
    //Getting Tissue Return ID
    getTissueReturnId: function(component, event, helper) {
        var tissueReturnId = event.getParam("tissueReturnId");
        component.set("v.RcdId",tissueReturnId);
        
    },
    
          // Lookup Tab Index
    focusToNextField : function(component,event, helper){
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
      /*  var action = component.get("c.getDisposition");
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
    },
    
    navigateToRequest: function(component, event, helper) {
        console.log("in navigation");
        var navEvt = $A.get("e.force:navigateToSObject");
        var a = component.get('v.placement').Request__c;
        navEvt.setParams({
        	"recordId": a,
            "slideDevName": "detail"
        });
        navEvt.fire();    
	},
})