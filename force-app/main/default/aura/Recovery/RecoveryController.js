({ 
    doInit : function(component, event, helper) {
       component.set("v.dislpayNext","false");
     /*helper.fetchPickListVal(component,'Recovery_outcome__c', 'recoveryOutcome');
       helper.fetchPickListVal(component, 'Recovery_Intent__c', 'recoveryIntent');
       helper.fetchPickListVal(component, 'Eyes_or_Corneas_Recovered__c', 'eyesorcorneasrecovered');
       helper.fetchPickListVal(component, 'Death_verified_by__c', 'deathverifiedby');
       helper.fetchPickListVal(component, 'Body_Identification_Method__c', 'bodyidentificationmethod');
       helper.fetchPickListVal(component, 'Recovery_Method__c', 'recoverymethod');*/
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
        console.log('context '+JSON.stringify(context));
        console.log('context '+JSON.stringify(context.attributes.recordId));
        component.set("v.recid", context.attributes.recordId);   
   	    //Ended To get the parent ID From Related List 
        var recid=component.get("v.recid");
        var checkUserBranch = component.get("c.checkUserBranch");
        checkUserBranch.setCallback(this, function(res) {
            var returnValue = res.getReturnValue();
            if(returnValue == false){
                alert('User is not part of any branch');
                var homeEvent = $A.get("e.force:navigateToObjectHome");
                homeEvent.setParams({
                    "scope": "Recovery__c"
                });
                homeEvent.fire();
            }else{
                console.log("Hi");
                helper.checkforRecoveryRecordCount(component,event,recid);
                var action = component.get("c.getCurrentUser"); 
                action.setCallback(this, function(a) {
                    component.set("v.currentUser", a.getReturnValue()); 
                });
                $A.enqueueAction(action);
                
                if(recid!=null || recid!=undefined || recid!=" "){ 
                    component.set("v.rec.Referral__c",recid);
                    var action = component.get("c.getReferralId");
                    action.setParams({
                        "donorId":recid
                    });
                    action.setCallback(this,function(response){
                    var state=response.getState();
                    if(state==='SUCCESS'){
                    	console.log("return val "+JSON.stringify(response.getReturnValue()));
                    	if(response.getReturnValue().Referral_Outcome__c != "Approached: Consented"){
                        	alert("Referral Outcome is Not Approached: Consented We Can't Go Further To Create Recovery");
                            var homeEvent = $A.get("e.force:navigateToObjectHome");
                            homeEvent.setParams({
                                "scope": "Referral__c"
                            });
                            homeEvent.fire();
                        }else{
                            component.set("v.Ref",response.getReturnValue());
                            component.set("v.rec.Referral_ID__c",component.get("v.Ref").Name);
                            var firstName = component.get("v.Ref").First_Name__c;
                            var lastName = component.get("v.Ref").Last_Name__c;
                            if(firstName=="undefined"|| firstName==" " || firstName==null ){
                                firstName = " ";
                            }
                            if(lastName=="undefined"|| lastName==" " || lastName==null ){
                                lastName = " ";
                            }
                            var DonorName= firstName + ' ' + lastName;
                            component.set("v.rec.Donor_Name__c",DonorName);
                            component.set("v.donorGender",component.get("v.Ref").Gender__c);
                            component.set("v.donorAge",component.get("v.Ref").Age_of_Donor__c);
                            component.set("v.recoverycount",component.get("v.Ref").recoverycount__c);
                            component.set("v.deathTime",component.get("v.Ref").Date_Time_of_Death__c);
                            component.set("v.deathNotificationTime",component.get("v.Ref").Death_Notification_Consignment_Date_Time__c);
                    	}
                    }
                    });
                    $A.enqueueAction(action)
                }      
            }
        });
        $A.enqueueAction(checkUserBranch);
    }, 
    Section0 : function(component, event, helper) { 
        helper.helperadd(component,event,'Zero'); 
    },
    First : function(component, event, helper) {
        helper.helperadd(component,event,'one'); 
       },
    sectionTwo : function(component, event, helper) {
        helper.helperadd(component,event,'articleTwo');
    },
    Three : function(component, event, helper) {
        helper.helperadd(component,event,'three');
    },
    Four : function(component, event, helper) {
        helper.helperadd(component,event,'four');
          },
    Five : function(component, event, helper) {
        helper.helperadd(component,event,'five');
    },
    Six : function(component, event, helper) {
        helper.helperadd(component,event,'six');
    },
    RecoveryMethod: function(component,event,helper){
        
        var params = event.getParam('arguments');
        component.set("v.Referral", params.Referral);
        component.set("v.dislpayNext", params.dislpayNext);
        component.set("v.referralName", params.referralName);
        component.set("v.rec.Referral__c",component.get("v.Referral").Id);
        component.set("v.rec.Referral_ID__c",component.get("v.referralName"));
        var firstName = component.get("v.Referral").First_Name__c;
        var lastName = component.get("v.Referral").Last_Name__c;
        if(firstName=="undefined"|| firstName==" " || firstName==null ){
            firstName = " ";
        }
        if(lastName=="undefined"|| lastName==" " || lastName==null ){
            lastName = " ";
        }
        var DonorName= firstName + ' ' + lastName;
        component.set("v.rec.Donor_Name__c",DonorName);
        component.set("v.donorGender",component.get("v.Referral").Gender__c);
        component.set("v.recoverycount",component.get("v.Referral").recoverycount__c);
        component.set("v.donorAge",component.get("v.Referral").Age_of_Donor__c);
        component.set("v.deathTime",component.get("v.Referral").Date_Time_of_Death__c);
        component.set("v.deathNotificationTime",component.get("v.Referral").Death_Notification_Consignment_Date_Time__c);
        var action = component.get("c.getDetails");
        action.setParams({
            "refId":component.get("v.Referral").Id
        })
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state==="SUCCESS"){
              //  component.set("v.Don",response.getReturnValue()); 
                 
            }
        });
        $A.enqueueAction(action);
       
    },
    
    onSelect: function(component, event, helper) {
      var cmp= component.find("header");
       $A.util.removeClass(cmp,"slds-hide");
       $A.util.addClass(cmp,"slds-show");
        
      var sec= component.find("Zero");
      $A.util.toggleClass(sec, 'slds-hide');
      $A.util.toggleClass(sec, 'slds-show');
        
      var sec= component.find("Zero1");
      $A.util.removeClass(sec, 'slds-hide');
      $A.util.addClass(sec, 'slds-show');
        
        
      },
    saveRecovery : function(component, event, helper){
        console.log("in save recovery");
        component.set("v.isProcessing",true);
        component.set("v.DisableButton",true);
        if(component.get("v.booleanvalue")){
            component.set("v.isProcessing",false);
            var resultsToast = $A.get("e.force:showToast");
                 resultsToast.setParams({
                "type": "error",
                "message": "Enter proper date values"
            });
            resultsToast.fire();
        }
        else{
            // Logic to Save record.
       
        var newrec = component.get("v.rec");
       /* newrec.Physical_Inspection_By__c=component.get("v.donorcon").Id;
        newrec.Recovery_completed_by__c=component.get("v.donorcon1").Id;
        newrec.Assisted_by__c=component.get("v.donorcon2").Id;
        newrec.Recovery_completed_by__c=component.get("v.donorcon3").Id;
        newrec.Sclera_Preserved_By__c=component.get("v.donorcon4").Id;
        newrec.Technician_performing_physicalAssessmen__c=component.get("v.donorcon5").Id;
        newrec.Collected_By__c=component.get("v.donorcon6").Id; */
        var consults = component.get("v.consultList");
        var donorconId = component.get("v.donorcon").Id;
        var donorconId1 = component.get("v.donorcon1").Id;
        var donorconId2 = component.get("v.donorcon2").Id;
        var donorconId3 = component.get("v.donorcon3").Id;
        var donorconId4 = component.get("v.donorcon4").Id;
        var donorconId5 = component.get("v.donorcon5").Id;
        var donorconId6 = component.get("v.donorcon6").Id;
        var donorconId9 = component.get("v.donorcon9").Id;
        var donorconId10 = component.get("v.donorcon10").Id;
       
        //alert(newrec.Recovery_Intent__c);
        var action  = component.get("c.save");
        action.setParams({ 
            "recovery": newrec, "conList": consults,"firstlookup":donorconId,"secondlookup":donorconId1,
            "thirdlookup":donorconId2,"fourthlookup":donorconId1,"fifthlookup":donorconId4,
            "sixthlookup":donorconId5,"seventhlookup":donorconId6,"ninelookup":donorconId9,"tenlookup":donorconId10
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                var recovery = a.getReturnValue();
                
                //Event to show toast message "Record Saved"
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                "type": "Success",
                "message": "Record Saved"
            });
            resultsToast.fire();  
                
               //Apex Call to get the Record Name.
               var recoveryName = component.get("c.getRecoveryName");
               recoveryName.setParams({
                   "recId":recovery.Id      
               });
               recoveryName.setCallback(this, function(a) {
                   var state = a.getState();
                   if(state === "SUCCESS"){
                       var recoveryName = a.getReturnValue();
                       component.set("v.rec.Donor_Id__c",recoveryName.Name);
                   }
               });
               $A.enqueueAction(recoveryName)
                
                
                //Firing Event to pass saved record to Final component.
                var getEvent = component.getEvent("GetRecoveryID");
                getEvent.setParams({
                    "recovery":recovery
                });
                getEvent.fire();
                
                //Event to navigate to Object Home.
                var dislpayNext = component.get("v.dislpayNext");
                if(dislpayNext=="false"){          
                var homeEvt = $A.get("e.force:navigateToObjectHome");
                homeEvt.setParams({
                "scope": "Recovery__c"
               });
               homeEvt.fire();
                }  
            }
            else if (state === "ERROR") {
                component.set("v.isProcessing",false);
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
            }
        });
        $A.enqueueAction(action)
        }
        component.set("v.DisableButton",false);
    },
   
    RecoverYCount : function(component, event, helper) {
       var recoverycount =component.get("v.Referral").recoverycount__c;
        system.debug('recoverycount'+ recoverycount);
         Console.debug('recoverycount'+ recoverycount);
        if(recoverycount==0){
            
            component.set("v.recoverycount",false);
                
        }
        else{
            component.set("v.recoverycount",true);
           
        }
    }, 
    OnRecOutCome : function(component, event, helper) {
       var outcome =component.find("recOutcome").get("v.value");
        if(outcome=='Consented: Not Recovered'){
            
            component.set("v.outcomerec",false);
            $A.util.removeClass(component.find("reasonNotRecovered"),"slds-hide");
            $A.util.addClass(component.find("reasonNotRecovered"),"slds-show");      
        }
        else{
            component.set("v.outcomerec",true);
            $A.util.removeClass(component.find("reasonNotRecovered"),"slds-show");
            $A.util.addClass(component.find("reasonNotRecovered"),"slds-hide"); 
        }
    },
    tlc : function(component, event, helper) {
        var SpecEval1 =component.find("tlc").get("v.value");
        if(SpecEval1=='No'){
            component.set("v.dis","true");
        }
        else{
            component.set("v.dis","false");
        }
        if(SpecEval1=='Yes'){
            component.set("v.distlc","true");
        }
        else{
            component.set("v.distlc","false");
        }
    },
    temp : function(component, event, helper) {
        var SpecEval2 =component.find("temp").get("v.value");
        if(SpecEval2=='No'){
            component.set("v.disp","true");
        }
        else{
            component.set("v.disp","false");
        }
         if(SpecEval2=='Yes'){
            component.set("v.distemp","true");
        }
        else{
            component.set("v.distemp","false");
        }
    },
    cult : function(component, event, helper) {
        var SpecEval3 =component.find("cult").get("v.value");
        if(SpecEval3=='No'){
            component.set("v.displ","true");
        }
        else{
            component.set("v.displ","false");
        }
        if(SpecEval3=='Yes'){
            component.set("v.discult","true");
        }
        else{
            component.set("v.discult","false");
        }
    },
    Sclera : function(component, event, helper) {
        var SpecEval10 =component.find("Sclera").get("v.value");
        if(SpecEval10=='Yes'){
            component.set("v.ScleraProcessed","true");
        }
        else{
            component.set("v.ScleraProcessed","false");
        }
    },
    
    onEvidence1Change : function(component, event, helper) {
        var Surgery1 =component.find("Surgery1").get("v.value"); 
        if(Surgery1=='No'){
            
            component.set("v.evidence1",true);
        }
        else{
            component.set("v.evidence1",false);
        }
        
    },
    onEvidence2Change : function(component, event, helper) {
        var Surgery2 =component.find("Surgery2").get("v.value");      
        if(Surgery2=='No'){
            
            component.set("v.evidence2",true);
        }
        else{
            component.set("v.evidence2",false);
        }
        
    }, 
    openModel: function(component, event, helper) {
               
        component.set("v.isOpen", true);
    },
    
    closeModel: function(component, event, helper) {
       
        component.set("v.isOpen", false);
    },
    consultView: function(component, event, helper) {
                    component.set("v.di","true");

      /*  alert("consultView");
        var SpecEval9 =component.find("eight").get("v.value");
        alert(SpecEval9);
        if(SpecEval9=='abcd'){
        }
        else{
            component.set("v.di","false");
        }*/
    },
    
    savemodal: function(component, event, helper) {
                    
        var con = component.get("v.consult");
        var action = component.get("c.saveConsults");
        action.setParams({ 
            "consult": con
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {                                
                var listofconsults = [] ;
                listofconsults = component.get("v.consultList");
                listofconsults.push(a.getReturnValue());
                component.set("v.consultList",listofconsults);  
                component.set("v.consult",{});
				                
                console.log(a);
            }
        });
        $A.enqueueAction(action);          
        component.set("v.isOpen", false);        
    },
    onChange : function(component, event, helper) {
        //var tissrecDate = component.find("Trec").get("v.value"); 
          
        var deathTime = new Date(component.find("dt1").get("v.value"));        
        var tDate = new Date(component.find("Trec").get("v.value"));
        var dDate = new Date(component.get("v.deathNotificationTime"));
        if(tDate.getTime() > deathTime.getTime()){
            component.set("v.booleanvalue1", "false");            
        }
        else{
            component.set("v.booleanvalue1", "true");
        }
       /* if(tDate.getTime() < dDate.getTime()){
            component.find("Trec").set("v.value",dDate);
        } */
    },

 Change : function(component, event, helper) {
        var coolstartDate = component.find("coolStart").get("v.value");
        var coolendDate = component.find("coolEnd").get("v.value");
           if(coolendDate < coolstartDate){
               component.set("v.booleanvalue", true);
           //alert("Cooling End Date/Time should be greater than Cooling Start Time.");
        }
     else{
            component.set("v.booleanvalue", false);
        }
        
    },
    handleChange: function (cmp, event) {
        // This will contain an array of the "value" attribute of the selected options
        var selectedOptionValue = event.getParam("value");
        

    },
    focusToNextField : function(component,event, helper){
        var selectedLookupLabel = event.getParam("label");
        console.log("Testing : "+selectedLookupLabel);
        if(selectedLookupLabel == "Recovery Completed By"){
            var f1 = component.find("Trec");
            f1.focus();
        }   
        else if(selectedLookupLabel == "Assisted By"){
            var f2 = component.find("CorneaPreservationDateTime");
            f2.focus();
        }
        else if(selectedLookupLabel == "Cornea Preserved By"){
            var f3 = component.find("Sclera");
            f3.focus();
        }
        else if(selectedLookupLabel == "Sclera Preserved By"){
            var f4 = component.find("isBodyidentified");
            f4.focus();
        }
        else if(selectedLookupLabel == "Technician Performing Physical Assessment ?:"){
            var f5 = component.find("GrossPhysical");
            f5.focus();
        }
        else if(selectedLookupLabel == "Cloudhub2"){
            //alert("hiwelcome")
            var f6 = component.find("tlc");
            f6.focus();
            
        }
        else if(selectedLookupLabel == "Physical Inspection By"){
            var f7 = component.find("kitId");
            f7.focus();
        }
       
    },
    onChange1 : function(component, event, helper) {
        //var tissrecDate = component.find("Trec").get("v.value"); 
          
        var deathTime = new Date(component.find("dt1").get("v.value"));        
        var tDate = new Date(component.find("coolStart").get("v.value"));
        var dDate = new Date(component.get("v.deathNotificationTime"));
        if(tDate.getTime() > deathTime.getTime()){
            component.set("v.booleanvalue2", "false");            
        }
        else{
            component.set("v.booleanvalue2", "true");
           
        }
    },
    onChange2 : function(component, event, helper) {
        //var tissrecDate = component.find("Trec").get("v.value"); 
          
        var deathTime = new Date(component.find("dt1").get("v.value"));        
        var tDate = new Date(component.find("wbc").get("v.value"));
        var dDate = new Date(component.get("v.deathNotificationTime"));
        if(tDate.getTime() < deathTime.getTime()){
            component.set("v.booleanvalue3", "false");            
        }
        else{
            component.set("v.booleanvalue3", "true");
           
        }
    },
    onChange3 : function(component, event, helper) {
        //var tissrecDate = component.find("Trec").get("v.value"); 
          
        var deathTime = new Date(component.find("dt1").get("v.value"));        
        var tDate = new Date(component.find("wbc1").get("v.value"));
        var dDate = new Date(component.get("v.deathNotificationTime"));
        if(tDate.getTime() < deathTime.getTime()){
            component.set("v.booleanvalue4", "false");            
        }
        else{
            component.set("v.booleanvalue4", "true");
           
        }
    },
     onChange4 : function(component, event, helper) {
        //var tissrecDate = component.find("Trec").get("v.value"); 
          
        var deathTime = new Date(component.find("dt1").get("v.value"));        
        var tDate = new Date(component.find("temper").get("v.value"));
        var dDate = new Date(component.get("v.deathNotificationTime"));
        if(tDate.getTime() < deathTime.getTime()){
            component.set("v.booleanvalue5", "false");            
        }
        else{
            component.set("v.booleanvalue5", "true");
           
        }
    },
     onChange5 : function(component, event, helper) {
        //var tissrecDate = component.find("Trec").get("v.value"); 
          
        var deathTime = new Date(component.find("dt1").get("v.value"));        
        var tDate = new Date(component.find("temper2").get("v.value"));
        var dDate = new Date(component.get("v.deathNotificationTime"));
        if(tDate.getTime() < deathTime.getTime()){
            component.set("v.booleanvalue6", "false");            
        }
        else{
            component.set("v.booleanvalue6", "true");
           
        }
    },
    onChange6 : function(component, event, helper) {
        //var tissrecDate = component.find("Trec").get("v.value"); 
          
        var deathTime = new Date(component.find("dt1").get("v.value"));        
        var tDate = new Date(component.find("cult1").get("v.value"));
        var dDate = new Date(component.get("v.deathNotificationTime"));
        if(tDate.getTime() < deathTime.getTime()){
            component.set("v.booleanvalue7", "false");            
        }
        else{
            component.set("v.booleanvalue7", "true");
           
        }
    },
    onChange7 : function(component, event, helper) {
        //var tissrecDate = component.find("Trec").get("v.value"); 
          
        var deathTime = new Date(component.find("dt1").get("v.value"));        
        var tDate = new Date(component.find("cult2").get("v.value"));
        var dDate = new Date(component.get("v.deathNotificationTime"));
        if(tDate.getTime() < deathTime.getTime()){
            component.set("v.booleanvalue8", "false");            
        }
        else{
            component.set("v.booleanvalue8", "true");
           
        }
    }

   /* dateValidation1: function(component, event, helper){
        
        var tissrecDate = component.find("Trec").get("v.value");   
        var deathTime = component.find("dt").get("v.value");   
        if(new Date(tissrecDate) > new Date(deathTime)){
            component.set("v.booleanvalue1", "true");
            component.find("dt").set("v.value",{});
        }
        else{
            component.set("v.booleanvalue1", "false");
        }
    }*/
    
})