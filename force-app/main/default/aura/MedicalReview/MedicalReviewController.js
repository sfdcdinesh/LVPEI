({  
    // function call on component Load
    doInit: function(component,event,helper){
        var checkUserBranch = component.get("c.checkUserBranch");
        checkUserBranch.setCallback(this, function(res) {
            var returnValue = res.getReturnValue();
            if(returnValue == false){
                alert('User is not part of any branch');
                var homeEvent = $A.get("e.force:navigateToObjectHome");
                homeEvent.setParams({
                    "scope": "Medical_Review__c"
                });
                homeEvent.fire();
            }else{
                component.set("v.dislpayNext","false");
                
                //To get Picklist Values Dynamically
                helper.fetchPickListVal(component, 'HBsAG__c','HBsAg');
                helper.fetchPickListVal(component, 'HCV__c','HCV');
                helper.fetchPickListVal(component, 'HIV_I_II__c','HIV');
                helper.fetchPickListVal(component, 'Syphilis__c','Syphilis');
                helper.fetchPickListVal(component, 'Reason_Donor_is_Ineligible__c','InElReason');
              
                //To get the Current Logged-In User
                var action = component.get("c.getCurrentUser"); 
                action.setCallback(this, function(a) {
                    component.set("v.currentUser", a.getReturnValue()); 
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
                component.set("v.recId", context.attributes.recordId);   
                //Ended To get the parent ID From Related List 
                var recid=component.get("v.recId");
                helper.checkforMedicalRecordCount(component,event,recid);  
                component.set("v.MedRev.Recovery__c",recid);
                helper.autoPopulate(component,event,recid," ");
            }
        });
        $A.enqueueAction(checkUserBranch);
    },
    
    //Public Aura Method,fired after recovery save.
    MedicalReviewMethod: function(component,event,helper){  
        var params = event.getParam('arguments');
        if(params!=null){
        component.set("v.Recovery", params.Recovery);
        component.set("v.dislpayNext", params.dislpayNext);
        }  
       helper.autoPopulate(component,event," ",component.get("v.Recovery")); 
    },  
    
    //Event Handler to get the blood,colloid,crystalloid details.
    getBloodData: function(component,event,helper){
        var bloodData = event.getParam("bloodData");
        var colloidData = event.getParam("colloidData");
        var crystalloidData = event.getParam("crystalloidData");
        var bloodCount;
        var colloidCount;
        var crystalloidCount;
        if(bloodData[0].Blood_Product__c!=null){
        component.set("v.bloodProduct",bloodData);
        bloodCount = component.get("v.bloodProduct").length;
        component.set("v.MedRev.Total_Blood_Products_Transfused_in_48H__c",bloodCount);
        }
        if(colloidData[0].Colloid__c!=null){
        component.set("v.colloid",colloidData);
        colloidCount = component.get("v.colloid").length;
        component.set("v.MedRev.Total_colloid_transfused_in_48H__c",colloidCount);
        }
        if(crystalloidData[0].Crystalloid__c!=null){
        component.set("v.crystalloid",crystalloidData);
        var crystalloidCount = component.get("v.crystalloid").length;
        component.set("v.MedRev.Total_Crystalloid_Infused_in_1H__c",crystalloidCount);
        }     
        var PV = component.get("V.MedRev.Pulse_Value_PV__c");
        var BV = component.get("V.MedRev.Blood_Value__c");
        var bloodSample = component.find("bloodSample");
       
        //sending record count to child component through aura method
        var successMessage = "Data Recorded";
        bloodSample.RecordCount(bloodCount,colloidCount,crystalloidCount,successMessage);
    
        //Calculation to decide the eligibility of blood sample.
        if((bloodCount!=""|| colloidCount!="" || crystalloidCount!="") && (bloodCount>0|| colloidCount>0|| crystalloidCount>0)){
            var totalCount = bloodCount + colloidCount + crystalloidCount;
            var Count = colloidCount + crystalloidCount;
            if(PV<totalCount || PV<Count){
                component.set("v.MedRev.Sample_Rejected__c","Yes");
            }
            else{
                component.set("v.MedRev.Sample_Rejected__c","No");
            }
        }        
    },
    
    //Event Handler to get the Tissue Evaluation details 
   //to display in the table in the Tissue Deatils Section
    getTissueDetail: function(component,event,helper){
        var tissue = event.getParam("tissue");
        var closeModal = event.getParam("closeModal");
        tissue.Name = tissue.Donor_ID__c +' '+ tissue.Eye__c +'-' + tissue.Tissue_Type__c[0];
        component.set("v.tissueId",tissue.Name);
        component.set("v.tissueData",tissue);
        component.set("v.callTissueEvaluation", closeModal);
        var listofTissues = [] ;
        listofTissues = component.get("v.tissueList");
        listofTissues.push(component.get("v.tissueData"));
        component.set("v.tissueList",listofTissues);
        component.set("v.tissueData",{});
        var listLength = component.get("v.tissueList").length;
        if(listLength>0){
            var previousEyeType = component.get("v.tissueList");
            var eyeType = previousEyeType[0].Eye__c;
            if(eyeType=='OD'){
                component.set("v.eyeType","OS");
            }
            else{
                component.set("v.eyeType","OD");
            }
        }
     },
  //From section0 to section06,expand and collapse for all the sections.  
  section0 : function(component, event, helper) {
        helper.helperadd(component,event,'Zero'); 
       } ,
  section01 : function(component, event, helper) {
        helper.helperadd(component,event,'One'); 
       } ,
  section02 : function(component, event, helper) {
      helper.helperadd(component,event,'Two');
    },
  section03 : function(component, event, helper) {
      helper.helperadd(component,event,'Three');
    },
  section04 : function(component, event, helper) {
      helper.helperadd(component,event,'Four');
    },
  section05 : function(component, event, helper) {
      helper.helperadd(component,event,'Five');
    },
  section06 : function(component, event, helper) {
      helper.helperadd(component,event,'Six');
    },
    
    // Tissue Import Information Section
    section07 : function(component, event, helper) {
      helper.helperadd(component,event,'Seven');
    },
 
    //Handler to warn user for HIV,HBsAG etc Tests if selected as '+ve'
    HBsAGWarning: function(component,event,helper){
       var HBsAg = component.find("HBsAg").get("v.value");    
        if(HBsAg=='Negative'){
            var alert1= component.find("testResult");
            $A.util.removeClass(alert1,"slds-show");
            $A.util.addClass(alert1,"slds-hide");
        }
        else{
            var alert1= component.find("testResult");
            $A.util.removeClass(alert1,"slds-hide");
            $A.util.addClass(alert1,"slds-show");
            component.find("DE").set("v.value","Ineligible"); 
        }  
    },
    HCVWarning: function(component,event,helper){
      var HCV = component.find("HCV").get("v.value");
      if(HCV=='Negative'){
            var alert1= component.find("testResult");
            $A.util.removeClass(alert1,"slds-show");
            $A.util.addClass(alert1,"slds-hide");
        }
        else{
            var alert1= component.find("testResult");
            $A.util.removeClass(alert1,"slds-hide");
            $A.util.addClass(alert1,"slds-show");
            component.find("DE").set("v.value","Ineligible"); 
        }
    },
    HIVWarning: function(component,event,helper){
        var HIV = component.find("HIV").get("v.value");
        if(HIV=='Negative'){
           var alert1= component.find("testResult");
           $A.util.removeClass(alert1,"slds-show");
           $A.util.addClass(alert1,"slds-hide");
            
       }
        else{
            var alert1= component.find("testResult");
            $A.util.removeClass(alert1,"slds-hide");
            $A.util.addClass(alert1,"slds-show");
            component.find("DE").set("v.value","Ineligible"); 
        }    
    },
    SyphilisWarning: function(component,event,helper){
        var Syphilis = component.find("Syphilis").get("v.value");
        if(Syphilis=='Negative'){
           var alert1= component.find("testResult"); 
           $A.util.removeClass(alert1,"slds-show");
           $A.util.addClass(alert1,"slds-hide");
        }
        else{
            var alert1= component.find("testResult");
            $A.util.removeClass(alert1,"slds-hide");
            $A.util.addClass(alert1,"slds-show");
            component.find("DE").set("v.value","Ineligible"); 
        } 
     },
      
    eligibleWarning : function(component,event,helper){
       var HBsAg = component.find("HBsAg").get("v.value");
       var HCV = component.find("HCV").get("v.value");
       var HIV = component.find("HIV").get("v.value");
       var Syphilis = component.find("Syphilis").get("v.value");
       var eligible= component.find("DE").get("v.value");
       var testsPositive ='';
        
        if(HBsAg=='Positive' || HBsAg=='Indetermine' || HBsAg=='Pending'){
            testsPositive = 'HBsAg';
        }
        if(HCV=='Positive' || HCV=='Indetermine' || HCV=='Pending'){
            if(testsPositive==''){
                testsPositive='HCV';
            }
            else{
                testsPositive =testsPositive+',HCV';
            }
        }
        if(HIV=='Positive' || HIV=='Indetermine' || HIV=='Pending'){
            if(testsPositive==''){
                testsPositive='HIV';
            }
            else{
                testsPositive =testsPositive+',HIV';
            }
        }
        if(Syphilis=='Positive' || Syphilis=='Indetermine' || Syphilis=='Pending'){
           if(testsPositive==''){
             testsPositive='Syphilis';
            }
            else{
             testsPositive =testsPositive+',Syphilis';
            }           
        }
        
        if((HBsAg!='Negative' || HCV!='Negative' || HIV!='Negative' || Syphilis!='Negative') && eligible=='Eligible'){
            var resultsToast = $A.get("e.force:showToast");
                 resultsToast.setParams({
                "type": "Warning",
                "message": "Can't select 'Eligible' as" + ' ' +testsPositive+ ' '+ "is selected other than Negative in the 1st Section." 
            });
            resultsToast.fire();
            component.find("DE").set("v.value","Ineligible");
        }
        
        
       
        
    },
    
   
    
    // Tissue Import Information Section Rendered Condition.
    OnTissueImpPick : function(component, event, helper) {
        var tissueImp =component.find("tissueImp").get("v.value");
        if(tissueImp=='Yes'){
            component.set("v.displayTissueImp","true");
        }
        else{
            component.set("v.displayTissueImp","false");
        }
    },
    
    //To close the tissue evaluation dailog on pressing cross symbol.
    closeModel: function(component,event,helper){
      component.set("v.callTissueEvaluation",false);    
    },
    
    //To close the Warning Alert of HIV etc Tests on pressing cross symbol.
    closeAlert: function(component,event,helper){
        var alert= component.find("testResult");
         $A.util.removeClass(alert,"slds-show");
        $A.util.addClass(alert,"slds-hide");
    },
    
    //To open the Tissue Evaluation dailog and send
    //required data through aura method on pressing + icon in Tissue Details Section
    openTissueEvaluation: function(component,event,helper){
      var listLength = component.get("v.tissueList").length;
      if(listLength==2){
          component.set("v.errorMessage","Not More Than 2 Records Are Allowed For The same Donor.")
        }
        else{
      var eyeType = "";
      component.set("v.callTissueEvaluation",true); 
        if(component.get("v.eyeType")!=null || component.get("v.eyeType")!=""){
            eyeType = component.get("v.eyeType");
        }
          
      var tissueEvalCmp = component.find("tissueEvalCmp");
      tissueEvalCmp.getDetails(component.get("v.MedRevRet.Id"),component.get("v.MedRev.Donor_Name_Id__c"),component.get("v.MedRev.Donor_Name__c"),component.get("v.donorAge"),component.get("v.donorGender"),component.get("v.MedRev.Death_Date_Time__c"),component.get("v.MedRev.Tissue_Imported__c"),component.get("v.RecoveryId"),eyeType,true);
        }   
    },
     // Lookup Tab Index
    focusToNextField : function(component,event, helper){
        var selectedLookupLabel = event.getParam("label");
        console.log("Testing : "+selectedLookupLabel);
        if(selectedLookupLabel == "Person Collected By"){
            var f1 = component.find("Date");
            f1.focus();
        }   
        else if(selectedLookupLabel == "Person Collected By:"){
            var f2 = component.find("DateTime");
            f2.focus();
        }
        else if(selectedLookupLabel == "Hemodilution Done By"){
            var f3 = component.find("HemodilutionDoneOn");
            f3.focus();
        }
        else if(selectedLookupLabel == "Serology Test Done By"){
            var f4 = component.find("SerologyReview");
            f4.focus();

        }
         else if(selectedLookupLabel == "Serology Test Approved By"){
            var f5 = component.find("HBsAg");
            f5.focus();

        }
        else if(selectedLookupLabel == "Medical Review Completed By"){
            var f6 = component.find("PA");
            f6.focus();

        }
    },
    //To Save the Medical Review Record
    saveMedicalReview: function(component,event,helper){
        
      // button disable   
      var button = component.find('save');
      button.set('v.disabled',true);
      var MedicalReview = component.get("v.MedRev"); //to get Medical Review Record
      var BloodProducts = component.get("v.bloodProduct"); //to get Blood Products list of Records
      var Colloid = component.get("v.colloid"); //to get colloid list of Records
      var Crystalloid = component.get("v.crystalloid");  //to get crystalloid list of Records
      var donorconId  = component.get("v.donorcon").Id;   //Hemo Done By lookup
      var donorconId1 = component.get("v.donorcon1").Id; //Serology Done By lookup
      var donorconId2 = component.get("v.donorcon2").Id; //Serology Approved By lookup
      var donorconId3 = component.get("v.donorcon3").Id; //Medical Review Completed By lookup
      var donorconId4 = component.get("v.donorcon4").Id; //Person Collected By lookup
      var MedRevId = null;      
     //calling apex class with the parameters to save the records.
      var action = component.get("c.saveDetails");
        action.setParams({
            "MedicalReview":MedicalReview,
            "firstlookup":donorconId,
            "secondlookup":donorconId1,
            "thirdlookup":donorconId2,
            "fourthlookup":donorconId3,
            "fifthlookup":donorconId4,
            "bloodProduct":BloodProducts,
            "colloid":Colloid,
            "crystalloid":Crystalloid,
            "medicalReviewID":MedRevId
           });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
             component.set("v.displayTissuetbl","true");    
             component.set("v.MedRevRet",response.getReturnValue());  
            //To show Record Saved Message    
            var resultsToast = $A.get("e.force:showToast");
                 resultsToast.setParams({
                "type": "Success",
                "message": "Record Saved"
            });
            resultsToast.fire();
                button.set('v.disabled',false);
                /* var navEvt = $A.get("e.force:navigateToSObject");
                		navEvt.setParams({
                   		"recordId": MedRevRet.Id
               			 });
                		navEvt.fire();*/
            

            
            //To navigate to object home if not in the path.
            var dislpayNext = component.get("v.dislpayNext");
            if(dislpayNext=="false"){ 
            var homeEvt = $A.get("e.force:navigateToObjectHome");
            homeEvt.setParams({
            "scope": "Medical_Review__c"
            });
            homeEvt.fire();
            }
            }
            
            //else conditions to log errors if record is not saved successfully.
            else if (state === "INCOMPLETE") {
                console.log("Failed to connect Salesforce!!");
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                "type": "error",
                "message": "Failed to connect Salesforce!!"
            });
            resultsToast.fire();
                button.set('v.disabled',false);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (!errors) {
                    errors = [{"message" : "Unknown Error Occured"}];
            }
                console.log(errors);
                var resultsToast = $A.get("e.force:showToast");
                
                resultsToast.setParams({
                "type": "error",
                "message": "Something Wrong"
            });
            resultsToast.fire();
                button.set('v.disabled',false);
            }
        })
        $A.enqueueAction(action);
                  
    },
    Hemo : function(component, event, helper) {
        //var tissrecDate = component.find("Trec").get("v.value"); 
          
        var deathTime = new Date(component.find("dt1").get("v.value"));        
        var tDate = new Date(component.find("HemodilutionDoneOn").get("v.value"));
        var dDate = new Date(component.get("v.deathNotificationTime"));
        if(tDate.getTime() > deathTime.getTime()){
            component.set("v.booleanvalue", "false");            
        }
        else{
            component.set("v.booleanvalue", "true");
           
        }
    },
    ser : function(component, event, helper) {
        //var tissrecDate = component.find("Trec").get("v.value"); 
          
        var deathTime = new Date(component.find("dt1").get("v.value"));        
        var tDate = new Date(component.find("SerologyReview").get("v.value"));
        var dDate = new Date(component.get("v.deathNotificationTime"));
        if(tDate.getTime() > deathTime.getTime()){
            component.set("v.booleanvalue1", "false");            
        }
        else{
            component.set("v.booleanvalue1", "true");
           
        }
    },
    mrev : function(component, event, helper) {
        //var tissrecDate = component.find("Trec").get("v.value"); 
          
        var deathTime = new Date(component.find("dt1").get("v.value"));        
        var tDate = new Date(component.find("mreview").get("v.value"));
        var dDate = new Date(component.get("v.deathNotificationTime"));
        if(tDate.getTime() > deathTime.getTime()){
            component.set("v.booleanvalue2", "false");            
        }
        else{
            component.set("v.booleanvalue2", "true");
           
        }
    },
})