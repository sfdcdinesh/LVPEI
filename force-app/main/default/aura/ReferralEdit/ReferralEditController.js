({
    // Function Call on Component Load
    doInit: function(component,event,helper){
        console.log('recordId>>>>>>',component.get("v.recordId"));
        var checkUserBranch = component.get("c.checkUserBranch");
        checkUserBranch.setCallback(this, function(res) {
            var returnValue = res.getReturnValue();
            if(returnValue == false){
                alert('User is not part of any branch');
                var homeEvent = $A.get("e.force:navigateToObjectHome");
                homeEvent.setParams({
                    "scope": "Referral__c"
                });
                homeEvent.fire();
            }else{
                var objDetails = component.get("v.newRef");
                var controllingFieldAPI = component.get("v.controllingFieldAPI");
                var dependingFieldAPI = component.get("v.dependingFieldAPI");     
                //$("#deathtime").attr("tabindex","1");
                //document.getElementById("deathtime").tabIndex = "1";
                //helper.fetchPicklistValuess(component,objDetails,controllingFieldAPI,dependingFieldAPI);
                
                var action = component.get("c.fetchIntialData");
                action.setParams({
                    "refId": component.get("v.recordId"),
                    'sobj' : objDetails,
                    'contfiled': controllingFieldAPI,
                    'depentfield': dependingFieldAPI 
                });
                action.setCallback(this,function(response){
                    var state = response.getState();
                    if(state ==="SUCCESS"){
                        console.log("respone state is success");
                        var result = response.getReturnValue();
                        console.log("result>>>>>>>>",result);
                        //set current user details first
                        component.set("v.currentUser", result.CurrentUser); 
                        console.log("user result is "+JSON.stringify(result.CurrentUser));
                        
                        //set referral details
                        console.log("referral result is "+JSON.stringify(result.referral));
                        component.set('v.disabled',false);
                        var ref = result.referral;
                        component.set("v.newRef",ref);              
                        console.log("referral assigned");
                        
                        component.set("v.depnedentFieldMap",result.DependentPicklst);
                        
                        //set Referral method and source values 
                        var contrlopt = [];
                        contrlopt.push({
                            label: "--None--",
                            value: ""
                        });
                        console.log("controlling field values is "+contrlopt);
                        for(var i=0;i< result.referralmethVals.length;i++){
                            contrlopt.push({label: result.referralmethVals[i], value: result.referralmethVals[i]});
                        }
                        component.set('v.listControllingValues',contrlopt);
                        
                        //Set dependent values based on controlling value
                        var controllerValueKey = component.get("v.newRef").Referral_Method__c;
                        var depnedentFieldMap = component.get("v.depnedentFieldMap");
                        console.log("controll value "+controllerValueKey);
                        if (controllerValueKey != "") {
                            var ListOfDependentFields = depnedentFieldMap[controllerValueKey];
                            console.log("dependent values "+ListOfDependentFields);
                            if(ListOfDependentFields.length > 0){
                                component.set("v.bDisabledDependentFld" , false);  
                                helper.fetchDepValues(component, ListOfDependentFields);    
                            }else{
                                component.set("v.bDisabledDependentFld" , true); 
                                component.set("v.listDependingValues", [{label: "--None--",value: ""}]);
                            }  
                            
                        } else {
                            component.set("v.listDependingValues", [{label: "--None--",value: ""}]);
                            component.find("dependentFld").set("v.value", "--None--");
                            component.set("v.bDisabledDependentFld" , true);
                        }
                        
                        //set lookup values 
                        console.log("lookups result is "+JSON.stringify(result.lookups));
                        component.set("v.lookupList",result.lookups);
                        var lookupList = component.get("v.lookupList");
                        if(lookupList['con1'] != null){
                            component.set("v.donarcon",lookupList['con1']); 
                        }
                        else{
                            component.set("v.donarcon",{});   
                        }
                        if(lookupList['con2'] != null){
                            component.set("v.donarcon1",lookupList['con2']);  
                        }
                        else{
                            component.set("v.donarcon1",{});   
                        }
                        if(lookupList['con3'] != null){
                            component.set("v.donarcon2",lookupList['con3']);
                        }
                        else{
                            component.set("v.donarcon2",{});   
                        }
                        if(lookupList['con4']!=null){
                            component.set("v.donarcon3",lookupList['con4']);
                        }
                        else{
                            component.set("v.donarcon3",{});   
                        }
                        
                    }else if(state ==="INCOMPLETE"){
                        console.log("respone state is incomplete");    
                    }else if(state ==="ERROR"){
                        console.log("respone state is error");
                    }
                });
                $A.enqueueAction(action); 
            }
        });
        $A.enqueueAction(checkUserBranch);  
    },
    
    afterScriptsLoaded : function(component, event, helper){
        // alert("hi");
    },
    //Code for Collapse and Expand Sections
    sectionOne : function(component, event, helper) {
        helper.helperadd(component,event,'One'); 
    }, 
    sectionTwo : function(component, event, helper) {
        helper.helperadd(component,event,'Two');
    },
    sectionThree : function(component, event, helper) {
        helper.helperadd(component,event,'Three');
    },
    sectionFour : function(component, event, helper) {
        helper.helperadd(component,event,'Four');
    },
    sectionFive : function(component, event, helper) {
        helper.helperadd(component,event,'Five');
    },
    sectionSix : function(component, event, helper) {
        helper.helperadd(component,event,'Six');
    },
    ReferralMethod: function(component,event,helper){
        var params = event.getParam('arguments');
        component.set("v.dislpayNext", params.dislpayNext);
    },
    //Save Referral Functionality
    createReferral : function(component,event) {
        var button = component.find('disablebuttonid');
        button.set('v.disabled',true);
        var newAcc = component.get("v.newRef");
        console.log("New referral record "+JSON.stringify(newAcc));
        if(component.get("v.donarcon") !== null)
        	var donarconId = component.get("v.donarcon").Id;
        if(component.get("v.donarcon1") !== null)
        	var donarconId1 = component.get("v.donarcon1").Id;
        if(component.get("v.donarcon2") !== null)
	        var donarconId2 = component.get("v.donarcon2").Id;
        if(component.get("v.donarcon3") !== null)
        	var donarconId3 = component.get("v.donarcon3").Id;
      
        var action = component.get("c.saveReferrall");
        action.setParams({ 
            "referral": newAcc,
            "ContactId":donarconId,
            "secondlookup":donarconId1,
            "thirdlookup":donarconId2,
            "fourthlookup":donarconId3,
            "referralID":component.get("v.recordId")
            
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if(state =="ERROR"){
                 button.set('v.disabled',false);
                alert('Please fill the required fields');
            }
            
            if(state === "SUCCESS") {
               button.set('v.disabled',false);
                var referral = a.getReturnValue();
                component.set("v.recordId",referral.Id);
                
                //Toast Message to show "Record Saved".
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "type": "Success",
                    "message": "Record Updated"
                });     
                resultsToast.fire();
                
                var referralName = a.getReturnValue();
                component.set("v.newRef.Referral_ID__c",referralName.Name);
                component.set("v.recordName",referralName.Name);
                        
                var getEvent = component.getEvent("refEvent");
                getEvent.setParams({
                	"referral":referral,
                    "referralOutcome":referral.Referral_Outcome__c,
                    "referralName":component.get("v.recordName")
                });
                getEvent.fire();
                
                var homeEvt = $A.get("e.force:navigateToObjectHome");
                homeEvt.setParams({
                	"scope": "Referral__c"
                });
                homeEvt.fire();
                
                //Apex Call to get the Record Name.
                /*var referralName = component.get("c.getReferralName");
                referralName.setParams({
                    "refId":referral.Id  
                });
                referralName.setCallback(this, function(a) {
                    var state = a.getState();
                    if(state === "SUCCESS"){
                        var referralName = a.getReturnValue();
                        component.set("v.newRef.Referral_ID__c",referralName.Name);
                        component.set("v.recordName",referralName.Name);
                        
                        var getEvent = component.getEvent("refEvent");
                        getEvent.setParams({
                            "referral":referral,
                            "referralOutcome":referral.Referral_Outcome__c,
                            "referralName":component.get("v.recordName")
                        });
                        getEvent.fire();
                    }               
                });
                $A.enqueueAction(referralName)
                
                //Record ID & SF ID Functionality  (End)
                
                //FireEvent*/
            }
        });
        $A.enqueueAction(action)
    },
    
    /* OnSpecPick1 : function(component, event, helper) {
        var SpecEval =component.find("SpecEval").get("v.value");
        if(SpecEval=="Other Diseases"){
            component.set("v.display","true");
        }
        else{
            component.set("v.display","false");
        }
    },
    
    OnVentilPick : function(component, event, helper) {
        var Venval =component.find("Venval").get("v.value");
        if(Venval=="Yes"){
            component.set("v.display1","true");
        }
        else{
            component.set("v.display1","false");
        }
        
    },
    Relation : function(component, event, helper) {
        var rel =component.find("Relation").get("v.value");
        if(rel=="Other"){
            component.set("v.display19","true");
        }
        else{
            component.set("v.display19","false");
        }
        
    },
    OnfluidPick : function(component, event, helper) {
        var Fluidval =component.find("Fluidval").get("v.value");
        if(Fluidval=="Yes"){
            component.set("v.display2","true");
        }
        else{
            component.set("v.display2","false");
        }
        
    },*/
    //Age Calculation
    ageCalculation: function(component, event, helper){
        
        var dobYear = $A.localizationService.formatDate(dob, "YYYY");
        var today = $A.localizationService.formatDate(new Date(), "YYYY");
        var age = today-dobYear;
        //alert(age);
        component.set('v.newRef.Age_of_Donor__c',age);
       // button.set('v.disabled',false);  
        
        
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
            
            component.set('v.newRef.Date_of_Birth__c',dateOfBirth);
        }
        else if(dob!= null){
          //  button.set('v.disabled',false);
            var dobYear = $A.localizationService.formatDate(dob, "YYYY");
            var today = $A.localizationService.formatDate(new Date(), "YYYY");
            var age = today-dobYear;
            //alert(age);
            component.set('v.newRef.Age_of_Donor__c',age);
            
        }
    },
   
    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpen", false);
    },
    
    likenClose: function(component, event, helper) {
        // Display alert message on the click on the "Like and Close" button from Model Footer 
        // and set set the "isOpen" attribute to "False for close the model Box.
        // alert('Thank You :)');
        component.set("v.isOpen", false);
    },
    //Concatinate Donar First and Last Name
    donorFullName: function(component,event,helper){
        var fname = component.find("FirstName").get("v.value");
        var lname = component.find("LastName").get("v.value");
        if(fname=="undefined"|| fname==" " ||  fname==null){
            fname=" ";
        }
        else if(lname=="undefined" || lname==" " || lname==null) {
            lname=" ";
        }
        component.set("v.donorName",fname+ ' ' + lname);   
    },
    //Open Modal
    openModel: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.Open", true); 
        component.set("v.viewreport", true);
        var picklistvals = [];        
        
        picklistvals.push({label: "Donor",
                           value: "Donor"});
        component.set("v.GenreList", picklistvals);
    },
    //Close Modal
    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.Open", false);
    }, 
    //PDF Download
    downloadpdf : function(component, event, helper){
        var recordId = component.get("v.recordId");
        window.open('/apex/ReferralWorksheetPdf?referralid='+recordId, '_blank');        
    }, 
    //Unit Type Hide and Show
    Onunittypepick : function(component, event, helper) {
        var Otherunittypeval =component.find("Otherunittypeval").get("v.value");
        if(Otherunittypeval=="Others"){
            component.set("v.display1","true");
        }
        else{
            component.set("v.display1","false");
        }
        
    },
    //Relation Hide and Show
    Onrelationpick : function(component, event, helper) {
        var Otherrelationval =component.find("Otherrelationval").get("v.value");
        if(Otherrelationval=="Other"){
            component.set("v.display2","true");
        }
        else{
            component.set("v.display2","false");
        }       
    },
    //Date Format
    dateFormat: function(component, event, helper){
        var dob = component.find("deathtime").get("v.value");   
        var dobYear = $A.localizationService.formatDate(dob, "DD/MM/YYYY");
        component.set('v.newRef.Death_Notification_Consignment_Date_Time__c',dobYear);        
    },
    //Controller Field Change for Dependent Values
    onControllerFieldChange: function(component, event, helper) {     
        var controllerValueKey = event.getSource().get("v.value"); // get selected controller field value
        var depnedentFieldMap = component.get("v.depnedentFieldMap");
        console.log("controll value "+controllerValueKey);
        if (controllerValueKey != "") {
            var ListOfDependentFields = depnedentFieldMap[controllerValueKey];
            console.log("dependent values "+ListOfDependentFields);
            if(ListOfDependentFields.length > 0){
                component.set("v.bDisabledDependentFld" , false);  
                helper.fetchDepValues(component, ListOfDependentFields);    
            }else{
                component.set("v.bDisabledDependentFld" , true); 
                component.set("v.listDependingValues", [{label: "--None--",value: ""}]);
            }  
            
        } else {
            component.set("v.listDependingValues", [{label: "--None--",value: ""}]);
            component.find("dependentFld").set("v.value", "--None--");
            component.set("v.bDisabledDependentFld" , true);
        }
    }/*,
     OnSpecPick : function(component, event, helper) {
        var SpecEval =component.find("location").get("v.value");
        if(SpecEval=='Other'){
            component.set("v.display20","true");
        }
        else{
            component.set("v.display20","false");
        }
    },*/
    ,
    // Lookup Tab Index
    focusToNextField : function(component,event, helper){
        var selectedLookupLabel = event.getParam("label");
        console.log("Testing : "+selectedLookupLabel);
        if(selectedLookupLabel == "Donation Counselor/Volunteer"){
            var f1 = component.find("phoneNumberofCaller");
            f1.focus();
        }   
        else if(selectedLookupLabel == "Secondary Donation Counselor/Volunteer"){
            var f2 = component.find("text1");
            f2.focus();
        }
            else if(selectedLookupLabel == "Unit/Organization/Hospital Name"){
                var f3 = component.find("specialinstructions");
                f3.focus();
            }
                else if(selectedLookupLabel == "Medico-Legal Facility"){
                    var f4 = component.find("medicolegalhosp");
                    f4.focus();
                    
                }
    },
    //Date validation for Death Notification Date Time to Death Date Time
    dateValidation: function(component, event, helper){
        var admissionDate = component.find("admissiondate").get("v.value");
        var consignmentDate = component.find("consignmentTime").get("v.value");   
        /* var z = event.getSource();
        var auraId = z.getLocalId();
        alert(auraId)*/
        var deathTime = component.find("datettimenotification").get("v.value");   
        if(new Date(consignmentDate) < new Date(deathTime)){
            component.set("v.booleanvalue", "true");
            //component.find("datettimenotification").set("v.value",{});
        }
        else{
            component.set("v.booleanvalue", "false");
            //button.set('v.disabled',false);
        }
    },
     dateValidationn: function(component, event, helper){
        var consignmentDate = component.find("consignmentTime").get("v.value");   
        var deathTime = component.find("datettimenotification").get("v.value");   
        if(new Date(consignmentDate) < new Date(deathTime)){
            component.set("v.booleanvalue2", "true");
            //component.find("datettimenotification").set("v.value",{});
        }
        else{
            component.set("v.booleanvalue2", "false");
           // button.set('v.disabled',false);
        }
    },
    dateValidation11: function(component, event, helper){
        var admissionDate = component.find("admissiondate").get("v.value");   
        var deathTime = component.find("datettimenotification").get("v.value");   
        if(new Date(admissionDate) > new Date(deathTime)){
            component.set("v.booleanvalue1", "true");
            //component.find("datettimenotification").set("v.value",{});
        }
        else{
            component.set("v.booleanvalue1", "false");
           // button.set('v.disabled',false);
        }
         
    }
})