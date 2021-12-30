({
    // Function Call on Component Load
    doInit: function(component, event, helper) {
        var checkUserBranch = component.get("c.checkUserBranch");
        checkUserBranch.setCallback(this, function(res) {
            var returnValue = res.getReturnValue();
            if(returnValue == false){
                alert('User is not part of any branch');
                var homeEvent = $A.get("e.force:navigateToObjectHome");
                homeEvent.setParams({
                    "scope": "Request__c"
                });
                homeEvent.fire();
            }else{
                helper.fetchPickListVal(component, 'Request_Type__c', 'reqtype');
                helper.fetchPickListVal(component, 'Intended_Outcome__c', 'io');
                helper.fetchPickListVal(component, 'Request_Source__c', 'reqso');
                //get the value of current User
                var action = component.get("c.getCurrentUser"); 
                action.setCallback(this, function(a) {
                    component.set("v.runningUser", a.getReturnValue()); 
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
                component.set("v.req.Tissue_Evaluation__c",component.get("v.recid"));
            }
        });
        $A.enqueueAction(checkUserBranch);
    },
    
    //Code for Change Picklist
    onPicklistChange: function(component, event, helper) {
        // get the value of select option
      //  alert(event.getSource().get("v.value"));
    },
    
    //Surgery Date Time Validation
    validate: function(component, event, helper) {
        var stardateTime=component.find("startTime").get("v.value");
        //console.log(stardateTime);
        var enddateTime=component.find("endTime").get("v.value");
        
        if(new Date(stardateTime)>new Date(enddateTime)) {
            // alert("Please enter valid date");
            component.set("v.req.Surgery_Date_Time__c", " ");
            component.set("v.booleanvalue", "true");
            
              }
              
        else{
            component.set("v.booleanvalue", "false");
        }
    },
    
    //Expand and Collapse Sections
	sectionOne : function(component, event, helper) {
        helper.helperadd(component,event,'articleOne'); 
       },
     sectionTwo : function(component, event, helper) {
      helper.helperadd(component,event,'articleTwo');
    },
    sectionThree : function(component, event, helper) {
      helper.helperadd(component,event,'articleThree');
    },
    sectionFour : function(component, event, helper) {
      helper.helperadd(component,event,'articleFour');
    },
    sectionFive : function(component, event, helper) {
      helper.helperadd(component,event,'articleFive');
    },
    
    //Code for Hide and Show Pre-cut Needed
         OnSpecPick : function(component, event, helper) {
		var SpecEval =component.find("pcn").get("v.value");
        if(SpecEval=='DSAEK'){
            component.set("v.display","true");
        }
        else{
            component.set("v.display","false");
        }
    },
    
    //Code for Hide and Show Surgery
    OnPick : function(component, event, helper) {
		var Spec =component.find("surgy").get("v.value");
        if(Spec=='PK')
        {
            component.set("v.req.Surgery_Type_ALK__c" , '');
            component.set("v.req.Surgery_Sub_Type_EK__c" , '');
            
        }
        else{}
        
        if(Spec=='EK'){
            component.set("v.disp","true");
            component.set("v.req.Surgery_Type_ALK__c" , '');
            
        }
        else{
            component.set("v.disp","false");
        }
         if(Spec=='ALK'){
            component.set("v.disp1","true");
             component.set("v.req.Surgery_Sub_Type_EK__c" , '');
        }
        else{
            component.set("v.disp1","false");
        }
        if(Spec=='Other'){
            component.set("v.dispO","true");
            component.set("v.req.Surgery_Type_ALK__c" , '');
            component.set("v.req.Surgery_Sub_Type_EK__c" , '');
        }
        else{
            component.set("v.dispO","false");
        }
        
    },
    
    //Code for Hide and Show Tissue Type
    OnTissueType : function(component, event, helper) {
		var Spec =component.find("tistp").get("v.value");
        if(Spec=='Sclera'){
            component.set("v.display1","true");
        }
        else{
            component.set("v.display1","false");
        }
    },
    
    //Code for Hide and Show Request Type
    openTissueEvaluation: function(component,event,helper){
      component.set("v.callTissueEvaluation",true); 
      var RequestType = component.find("reqtype").get("v.value");
      var placementCmp = component.find("placementCmp");
      placementCmp.getDetails(component.get("v.ReqId"),component.get("v.RequestName"),component.get("v.Request.Requesting_Surgeon__r.Name"),RequestType);
    },
    
    //Close Modal
   closeModel: function(component, event, helper) {
        component.set("v.callTissueEvaluation", false);
    },
    
    // Lookup Tab Index
    focusToNextField : function(component,event, helper){
        var selectedLookupLabel = event.getParam("label");
        console.log("Testing : "+selectedLookupLabel);
        if(selectedLookupLabel == "Requesting Organization"){
            var f1 = component.find("startTime");
            f1.focus();
        } 
        else if(selectedLookupLabel == "Requesting Surgeon"){
            var f2 = component.find("surnote");
            f2.focus();
        }
        else if(selectedLookupLabel == "Surgery Location"){
            var f3 = component.find("endTime");
            f3.focus();
        }
        else if(selectedLookupLabel == "Eye Bank Performing Pre-cut"){
            var f4 = component.find("CutParameters");
            f4.focus();
        }
        else if(selectedLookupLabel == "Medical Record ID"){
            var f5 = component.find("save");
            f5.focus();
        }
    },
    
    //Save Request Functionality
    SaveERMval : function(component, event, helper){
    	component.set("v.saveInProgress", true);
        var newReq = component.get("v.req");
        console.log("req "+JSON.stringify(newReq));
        var ReqconId = component.get("v.Reqcon").Id;
        var Reqcon1Id = component.get("v.Reqcon1").Id;
        var Reqcon2Id = component.get("v.Reqcon2").Id;
        var Reqcon3Id = component.get("v.Reqcon3").Id; 
        var donarcon4Id = component.get("v.donarcon4").Id;
        var donar = component.get("v.donarcon4");
        
        var action  = component.get("c.save");
        action.setParams({ 
            "Reqval": newReq,"ReqOrglookup":ReqconId ,"ReqSurlookup":Reqcon1Id,
            "SurLoclookup":Reqcon2Id,"EyeBPPClookup":Reqcon3Id,"fifthlookup":donarcon4Id,
            "con" : donar
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            console.log("state is "+JSON.stringify(state));
            if (state === "SUCCESS") {
                var name = a.getReturnValue();
                component.set("v.Request",name);
                component.set("v.displayPlacement","true");
                
            /*resultsToast.fire();  
                var homeEvt = $A.get("e.force:navigateToObjectHome");
                homeEvt.setParams({
                "scope": "Request__c"
               });
               homeEvt.fire();*/
                component.set("v.ReqId",name.Id);
                var requestName = component.get("c.getRequestName");
                requestName.setParams({
                   "reqId":name.Id      
               });
               requestName.setCallback(this, function(a) {
                   var state = a.getState();
                   if(state === "SUCCESS"){
                       var requestName = a.getReturnValue();
                       component.set("v.RequestName",requestName.Name);          
                       var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "type": "Success",
                    "message": "Record Saved"
                });
                       resultsToast.fire();
                       console.log(component.get("v.ReqId"));
                       component.set("v.saveInProgress", false);
                       /*var recordPage = $A.get("e.force:navigateToSObject");
	                   recordPage.setParams({
	                        "recordId": component.get("v.ReqId")
	                    });
	                    recordPage.fire();*/
                       }
               		});
               		$A.enqueueAction(requestName)
                   }
                   else {
            		console.log('Error, save failed'+JSON.stringify(a.getError()));
            		var errorEvent = $A.get("e.force:showToast");
            		errorEvent.setParams({
                        "title": "Error",
                        "type": "error",
                        "message": "There was a problem saving the record. Kindly verify if all required fields have been filled",
                        "mode": "sticky"
                	});
                    errorEvent.fire();
                    component.set("v.saveInProgress", false);                    
            	
            }
        });
        $A.enqueueAction(action)
    },
    
    //DOB Calculation
    dateofbirthCalculation: function(component, event, helper){
        var ageval = component.find("Age").get("v.value");   
        var dob = component.find("DateofBirth").get("v.value");   
        
        // var dobYear = $A.localizationService.formatDate(dob, "YYYY");
        if(ageval!=null){
            var today = new Date();
            today=$A.localizationService.formatDate(today, "YYYY");
            var dateOfBirth = today-ageval;
            currentMonth = $A.localizationService.formatDate(new Date(), "MM");
            dateOfBirth=currentMonth+'/'+'01/'+dateOfBirth;
            dateOfBirth=$A.localizationService.formatDate(dateOfBirth, "yyyy-MM-dd");
            component.set('v.req.DOB__c',dateOfBirth);
        }
        else if(dob!= null){
            var dobYear = $A.localizationService.formatDate(dob, "YYYY");
            var today = $A.localizationService.formatDate(new Date(), "YYYY");
            var age = today-dobYear;
            //alert(age);
            component.set('v.req.Age__c',age);
            
        }
    }
 })