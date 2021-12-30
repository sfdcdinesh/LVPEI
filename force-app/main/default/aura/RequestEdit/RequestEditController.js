({
    // Function Call on Component Load
    doInit: function(component, event, helper) {
        
        helper.fetchPickListVal(component, 'Request_Type__c', 'reqtype');
        helper.fetchPickListVal(component, 'Intended_Outcome__c', 'io');
        helper.fetchPickListVal(component, 'Request_Source__c', 'reqso');
        //console.log("Request data " +JSON.stringify(component.get("v.req")));
        
        //get the value of current User
        var action = component.get("c.getCurrentUser"); 
        action.setCallback(this, function(a) {
            component.set("v.runningUser", a.getReturnValue()); 
        });
        $A.enqueueAction(action);
        
        //To get the Patient details and the lookups
        var action = component.get("c.getEmrDetails");
        action.setParams({
            "reqID":component.get("v.recordId")  
        });
        action.setCallback(this,function(response){
          /*  // added
            if(response.getState() ==="ERROR"){
                 button.set('v.disabled',false);
                alert('Please fill the required fields');
            }
            //*/
            if(response.getState()==="SUCCESS"){
               // button.set('v.disabled',false);
                component.set("v.lookupList",response.getReturnValue());
                var lookupList = component.get("v.lookupList");
                if(lookupList['con1']!=null){
                    component.set("v.Reqcon",lookupList['con1']); 
                    
                }
                else{
                    component.set("v.Reqcon1",{});
                    
                }
                if(lookupList['con2']!=null){
                    component.set("v.Reqcon1",lookupList['con2']);  
                    
                }
                else{
                    component.set("v.Reqcon1",{});   
                }
                if(lookupList['con3']!=null){
                    component.set("v.Reqcon2",lookupList['con3']);
                }
                else{
                    component.set("v.Reqcon2",{});   
                }
                if(lookupList['con4']!=null){
                    component.set("v.Reqcon3",lookupList['con4']);
                    
                }
                else{
                    component.set("v.Reqcon3",{});   
                }
                if(lookupList['emr']!=null){
                    component.set("v.donarcon4",lookupList['emr']);
                    
                }
                else{
                    component.set("v.donarcon4",{});   
                }
            }
            
        });
        $A.enqueueAction(action);
    },
    //Code for Change Picklist
    onPicklistChange: function(component, event, helper) {
        // get the value of select option
        //  alert(event.getSource().get("v.value"));
    },
    //Surgery Date Time Validation
    validate: function(component, event, helper) {
        var stardateTime=component.find("startTime").get("v.value");
        var enddateTime=component.find("endTime").get("v.value");
        
        
        
        if(new Date(stardateTime)>new Date(enddateTime)) {
            // alert("Please enter valid date");
            
            component.set("v.req.Surgery_Date_Time__c", " ");
            component.set("v.booleanvalue", "true");
            
        }
        else{
          // button.set('v.disabled',false);
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
    
    /* OnSpecPick : function(component, event, helper) {
		var SpecEval =component.find("pcn").get("v.value");
        if(SpecEval=='DSAEK'){
            component.set("v.display","true");
        }
        else{
            component.set("v.display","false");
        }
    },*/
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
    /*OnTissueType : function(component, event, helper) {
		var Spec =component.find("tistp").get("v.value");
        if(Spec=='Sclera'){
            component.set("v.display1","true");
        }
        else{
            component.set("v.display1","false");
        }
    },*/
    //Code for Hide and Show Request Type
    openTissueEvaluation: function(component,event,helper){
        component.set("v.callTissueEvaluation",true); 
    },
    //Close Modal
    closeModel: function(component, event, helper) {
        component.set("v.callTissueEvaluation", false);
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
    },

    
//Save Request Functionality
    SaveERMval : function(component, event, helper){
        /*var button = component.find("save");
        button.set("v.disabled",true);		*/
        component.set("v.saveInProgress", true);
        if(component.get("v.Req") !== null)	
        	var newReq = component.get("v.req");
        if(component.get("v.Reqcon") !== null)
        	var ReqconId = component.get("v.Reqcon").Id;
        if(component.get("v.Reqcon1") !== null)
        	var Reqcon1Id = component.get("v.Reqcon1").Id;
        if(component.get("v.Reqcon2") !== null)
        	var Reqcon2Id = component.get("v.Reqcon2").Id;
        if(component.get("v.Reqcon3") !== null)
        	var Reqcon3Id = component.get("v.Reqcon3").Id; 
        if(component.get("v.donarcon4") !== null)
        	var donarcon4Id = component.get("v.donarcon4").Id;
        if(component.get("v.donarcon4") !== null)
        	var donar = component.get("v.donarcon4");
        
       
        
        var action  = component.get("c.save");
            action.setParams({ 
                "Reqval": newReq,"ReqOrglookup":ReqconId ,"ReqSurlookup":Reqcon1Id,
                "SurLoclookup":Reqcon2Id,"EyeBPPClookup":Reqcon3Id,"fifthlookup":donarcon4Id,
                "con" : donar, "reqID":component.get("v.recordId")
            });    
    
   /* //Save Request Functionality
    SaveERMval : function(component, event, helper){
        var newReq = component.get("v.req");
        var button = component.find("save");
        	button.set("v.disabled",true);
          }
         //var newReq = component.get("v.req");
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
                "con" : donar, "reqID":component.get("v.recordId")
            });*/
            action.setCallback(this, function(a) {
                // added
            /*if(state =="ERROR"){
                button.set('v.disabled',false);
                alert('Please fill the required fields');
            }*/
            //
                var state = a.getState();
                if (state === "SUCCESS") {
                    var name = a.getReturnValue();
                    component.set("v.displayPlacement","true");
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "type": "Success",
                        "message": "Record Updated"
                    });
                    resultsToast.fire();
                    component.set("v.saveInProgress", false);
                    var homeEvt = $A.get("e.force:navigateToObjectHome");
                    homeEvt.setParams({
                        "scope": "Request__c"
                    });
                    homeEvt.fire();
                    //button.set("v.disabled",false);  
                }
                else {
            		console.log('Error, save failed');
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
        }	 
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
   
})