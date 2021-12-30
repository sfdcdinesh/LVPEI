({
    // Function Call on Component Load
    doInit: function(component,event,helper){
        component.set("v.dislpayNext","false");
        var objDetails = component.get("v.newRef");
        var controllingFieldAPI = component.get("v.controllingFieldAPI");
        var dependingFieldAPI = component.get("v.dependingFieldAPI");    
        //$("#deathtime").attr("tabindex","1");
        //document.getElementById("deathtime").tabIndex = "1";
        //To get the current logged-in user
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
                var action = component.get("c.getCurrentUser");
                action.setCallback(this, function(a){
                    component.set("v.currentUser", a.getReturnValue());
                });
                $A.enqueueAction(action);
                
                var branch = component.get("c.getBranch");
                branch.setCallback(this, function(res){
                    console.log(JSON.stringify(res.getReturnValue()));
                    component.set("v.Branch", res.getReturnValue());
                });
                $A.enqueueAction(branch);
            }
        });
        $A.enqueueAction(checkUserBranch);
        helper.fetchPicklistValuess(component,objDetails,controllingFieldAPI,dependingFieldAPI);
    },
   
   
    afterScriptsLoaded : function(component, event, helper){
        //alert("hi");
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
        alert('GM' +component.get("v.dislpayNext"))
    },
    //Save Referral Functionality
    createReferral : function(component,event) {
        //added
        var button = component.find('Referralsave');
        button.set('v.disabled',true);
        //
        var newAcc = component.get("v.newRef");
        var donarconId = component.get("v.donarcon").Id;
        var donarconId1 = component.get("v.donarcon1").Id;
        var donarconId2 = component.get("v.donarcon2").Id;
        var donarconId3 = component.get("v.donarcon3").Id;
        var action = component.get("c.saveReferrall");
        action.setParams({
            "referral": newAcc,
            "ContactId":donarconId,
            "secondlookup":donarconId1,
            "thirdlookup":donarconId2,
            "fourthlookup":donarconId3
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
           // added
            if(state =="ERROR"){
                 button.set('v.disabled',false);
                alert('Please fill the required fields');
            }
            //O
            if(state === "SUCCESS") {
                button.set('v.disabled',false);
                var referral = a.getReturnValue();
                component.set("v.recordId",referral.Id);
               
                //Toast Message to show "Record Saved".
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "type": "Success",
                    "message": "Record Saved"
                   
                });    
                resultsToast.fire();
               
                //Apex Call to get the Record Name.
                var referralName = component.get("c.getReferralName");
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
                        //added1
                        var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": referral.Id
                });
                navEvt.fire();
                        //1
                    }              
                });
                $A.enqueueAction(referralName)
               
                //Record ID & SF ID Functionality  (End)
               
                //FireEvent
            }
            else if (state === "ERROR") {
               
                var errors = a.getError();
                if (!errors) {
                    errors = [{"message" : "Unknown Error Occured"}];
                }
                console.log(errors);
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "type": "error",
                    "message": "Please Fill Required Fields"
                });
                resultsToast.fire();
                button.set('v.disabled',false);
              }
           
        });
        $A.enqueueAction(action)
    },
   
    //Code for Hide and Show Specular Evaluation
    OnSpecPick1 : function(component, event, helper) {
        var SpecEval =component.find("SpecEval").get("v.value");
        if(SpecEval=="Other Diseases"){
            component.set("v.display","true");
        }
        else{
            component.set("v.display","false");
        }
    },
 
    //Code for Hide and Show Donor on a Ventilator
    OnVentilPick : function(component, event, helper) {
        var Venval =component.find("Venval").get("v.value");
        if(Venval=="Yes"){
            component.set("v.display1","true");
        }
        else{
            component.set("v.display1","false");
        }
       
    },
    //Code for Hide and Show Relation
    Relation : function(component, event, helper) {
        var rel =component.find("Relation").get("v.value");
        if(rel=="Other"){
            component.set("v.display19","true");
        }
        else{
            component.set("v.display19","false");
        }
       
    },
    //Code for Hide and Show Fluids
    OnfluidPick : function(component, event, helper) {
        var Fluidval =component.find("Fluidval").get("v.value");
        if(Fluidval=="Yes"){
            component.set("v.display2","true");
        }
        else{
            component.set("v.display2","false");
        }
       
    },
    //Age Calculation
    ageCalculation: function(component, event, helper){
        var dobYear = $A.localizationService.formatDate(dob, "YYYY");
        var today = $A.localizationService.formatDate(new Date(), "YYYY");
        var age = today-dobYear;
        //alert(age);
        component.set('v.newRef.Age_of_Donor__c',age);
       
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
            var dobYear = $A.localizationService.formatDate(dob, "YYYY");
            var today = $A.localizationService.formatDate(new Date(), "YYYY");
            var age = today-dobYear;
            //alert(age);
           // component.set('v.newRef.Age_of_Donor__c',age);
           
        }
    },
   
    //Date validation for Death Notification Date Time to Death Date Time
    dateValidation: function(component, event, helper){
        var consignmentDate = component.find("deathtime").get("v.value");  
        var deathTime = component.find("datettimenotification").get("v.value");  
        if(new Date(consignmentDate) < new Date(deathTime)){
            component.set("v.booleanvalue", "true");
            //component.find("datettimenotification").set("v.value",{});
        }
        else{
            component.set("v.booleanvalue", "false");
        }
    },
     //Date validation for Death Date Time to Blood Given Date/Time
   
  /*  datebloodValidation: function(component, event, helper){
       
        var bloodgivendate = component.find("bloodgivendate").get("v.value");  
        var deathTime = component.find("datettimenotification").get("v.value");  
        if(new Date(bloodgivendate) > new Date(deathTime)){
            alert("Please enter the Blood Given Date less than deathTime Date");
            component.set("v.booleanvalue", "true");
            component.find("datettimenotification").set("v.value",{});
        }
        else{
            component.set("v.booleanvalue", "false");
        }
    }, */
   
         //Date validation for Death Date Time to IV Fluid Date/Time

  /*  IvFluidValidation: function(component, event, helper){
       
        var IvFluidDate = component.find("IvFluidDate").get("v.value");  
        var deathTime = component.find("datettimenotification").get("v.value");  
        if(new Date(IvFluidDate) > new Date(deathTime)){
            alert("Please enter the IV Fluid Date less than deathTime Date");
            component.set("v.booleanvalue", "true");
            component.find("datettimenotification").set("v.value",{});
        }
        else{
            component.set("v.booleanvalue", "false");
        }
    },*/
    /* Deathtimenotify:function(component,event,helper){
              var datetime = component.find("deathtime").get("v.value");  
  var timenotify = component.find("datettimenotification").get("v.value");
        if(timenotify>datetime){
            alert('Please select valid time');
            component.find("datettimenotification").set("v.value",null);
             }
        else{
             }
       
    },*/
    //Code for Hide and show Sign/Symptoms of Systemic Infection
    OnsignPick : function(component, event, helper) {
        var Signval =component.find("Signval").get("v.value");
        if(Signval=="Yes"){
            component.set("v.display3","true");
        }
        else{
            component.set("v.display3","false");
        }
       
    },
    //Code for Hide and show Blood Sample
    OnBloodPick : function(component, event, helper) {
        var Bloodval =component.find("Bloodval").get("v.value");
        if(Bloodval=="Yes"){
            component.set("v.display4","true");
        }
        else{
            component.set("v.display4","false");
        }
       
    },
    //Code for Hide and show Transfered from Other Facility
    OnFalicityPick : function(component, event, helper) {
        var Falicityval =component.find("Falicityval").get("v.value");
        if(Falicityval=="Yes"){
            component.set("v.display5","true");
        }
        else{
            component.set("v.display5","false");
        }
       
    },
    //Code for Hide and show Medico Legal Facility
    OnMedicolegalPick : function(component, event, helper) {
        var Medicoval =component.find("Medicoval").get("v.value");
        if(Medicoval=="Yes"){
            component.set("v.display6","true");
        }
        else{
            component.set("v.display6","false");
        }
       
    },
    //Code for Hide and show Autopsy Done
    OnAutospyPick : function(component, event, helper) {
        var Autospyval =component.find("Autospyval").get("v.value");
        if(Autospyval=="Yes"){
            component.set("v.display11","true");
        }
        else{
            component.set("v.display11","false");
        }
       
    },
    //Code for Hide and show Approchednotconsented
    OnApprochednotconsented : function(component, event, helper) {
        var Otherreasonval =component.find("Otherreasonval").get("v.value");
        if(Otherreasonval=="Other reason"){
            component.set("v.display12","true");
        }
        else{
            component.set("v.display12","false");
        }
       
    },
    //Code for Hide and show suitable
    Onsuitable : function(component, event, helper) {
        var Othersuitableval =component.find("Othersuitableval").get("v.value");
        if(Othersuitableval=="Other"){
            component.set("v.display13","true");
        }
        else{
            component.set("v.display13","false");
        }
       
    },
    //Code for Hide and show Not Screened
    Onnotscreened : function(component, event, helper) {
        var Othernotscreenval =component.find("Othernotscreenval").get("v.value");
        if(Othernotscreenval=="Other"){
            component.set("v.display14","true");
        }
        else{
            component.set("v.display14","false");
        }
       
    },
    //Code for Hide and show Screened Pick
    Onscreenedpick : function(component, event, helper) {
        var Otherscreenpickval =component.find("Otherscreenpickval").get("v.value");
        if(Otherscreenpickval=="Other"){
            component.set("v.display15","true");
        }
        else{
            component.set("v.display15","false");
        }
       
    },
    //Code for Hide and show Isolation
    Onisolationpick : function(component, event, helper) {
        var Otherisolationval =component.find("Otherisolationval").get("v.value");
        if(Otherisolationval=="Yes"){
            component.set("v.display17","true");
        }
        else{
            component.set("v.display17","false");
        }
       
    },
    //Code for Hide and show Religious Pick
    Onreligiouspick : function(component, event, helper) {
        var Otherreligiousval =component.find("Otherreligiousval").get("v.value");
        if(Otherreligiousval=="Other"){
            component.set("v.display18","true");
        }
        else{
            component.set("v.display18","false");
        }
       
    },
    //Code for Hide and show Referral Outcome
    OnRecoveronePick : function(component, event, helper) {
        var Coveroneval =component.find("Coveroneval").get("v.value");
        component.set("v.referralOutcome",Coveroneval);
        if(Coveroneval=="Screened Not Suitable"){
            component.set("v.display7","true");
        }
        else{
            component.set("v.display7","false");
        }
        if(Coveroneval=="Suitable: Not Approched"){
            component.set("v.display8","true");
        }
        else{
            component.set("v.display8","false");
        }
        if(Coveroneval=="Approached: Not Consented"){
            component.set("v.display9","true");
        }
        else{
            component.set("v.display9","false");
        }
        if(Coveroneval=="Not Screened"){
            component.set("v.display16","true");
        }
        else{
            component.set("v.display16","false");
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
    //Dependent Fields
    onControllerFieldChange: function(component, event, helper) {    
        var controllerValueKey = event.getSource().get("v.value"); // get selected controller field value
        var depnedentFieldMap = component.get("v.depnedentFieldMap");
       
        if (controllerValueKey != '--- None ---') {
            var ListOfDependentFields = depnedentFieldMap[controllerValueKey];
           
            if(ListOfDependentFields.length > 0){
                component.set("v.bDisabledDependentFld" , false);  
                helper.fetchDepValues(component, ListOfDependentFields);    
            }else{
                component.set("v.bDisabledDependentFld" , true);
                component.set("v.listDependingValues", ['--- None ---']);
            }  
           
        } else {
            component.set("v.listDependingValues", ['--- None ---']);
            component.set("v.bDisabledDependentFld" , true);
        }
    },
    //Location Hide and Show
    OnSpecPick : function(component, event, helper) {
        var SpecEval =component.find("location").get("v.value");
        if(SpecEval=='Other'){
            component.set("v.display20","true");
        }
        else{
            component.set("v.display20","false");
        }
    },
   
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
    dateValidation1: function(component, event, helper){
       
        var admissionDate = component.find("admissiondate").get("v.value");  
        var deathTime = component.find("datettimenotification").get("v.value");  
        if(new Date(admissionDate) > new Date(deathTime)){
            component.set("v.booleanvalue1", "true");
           // component.find("datettimenotification").set("v.value",{});
        }
        else{
            component.set("v.booleanvalue1", "false");
        }
    },
    dateValidationn: function(component, event, helper){
        var consignmentDate = component.find("deathtime").get("v.value");  
        var deathTime = component.find("datettimenotification").get("v.value");  
        if(new Date(consignmentDate) < new Date(deathTime)){
            component.set("v.booleanvalue1", "true");
            //component.find("datettimenotification").set("v.value",{});
        }
        else{
            component.set("v.booleanvalue1", "false");
        }
    },
   
    
    /* buttonAction: function(component,event,helper){
    let button = component.find('disablebuttonid');
    button.set('v.disabled',true);
  },*/
    OnReferralSource1: function() {
        var rs =component.get("v.newRef.Referral_Source__c");
        var DonationCounselor = document.getElementByName("Donation Counselor/Volunteer").Id;
        var SecondaryDonationCounselor = document.getElementByName("Secondary Donation Counselor/Volunteer").Id;
        if (rs == 'Family initiated')
        {
            DonationCounselor.setAttribute("readonly","true");
            SecondaryDonationCounselor.setAttribute("readonly","true");
        }
       
    },
})