({
    //Functionality for Upload Image
    handleuploadedImage : function(component,event,helper){
        const getImage = event.getParam("image");
        var firstimg = event.getParam("firstimg");
        if(firstimg==true){
            component.set("v.imageholding", getImage);
            var img = component.find("imagePreview").getElement();
            img.src = URL.createObjectURL(component.get("v.imageholding"));
        }
        else{
            //button.set('v.disabled',false);
            component.set("v.imageholding1", getImage);
            var img = component.find("imagePreview1").getElement();
            img.src = URL.createObjectURL(component.get("v.imageholding1"));
        }
        alert('Your File is Uploaded Successfully');
    },
    
    handleFilesChange: function(component, event, helper) {
        var eventname = event.getSource().get("v.name");
        console.log("event source is "+eventname);
        var fileName = 'No File Selected..';
        var imageName = "";
        var firstImage;
        var fileInput;
        var file;
        if(eventname === "specEval"){
            component.set("v.imageName",eventname);
            console.log("file name is "+component.get("v.imageName"));
            firstImage = true;
            if (event.getSource().get("v.files").length > 0) {
                fileName = event.getSource().get("v.files")[0]['name'];
            }
            component.set("v.fileNamespecEval", fileName);
            fileInput = component.find("fileId").get("v.files");
            component.set("v.uploadedFiles",fileInput.length);
            file = fileInput[0];
        }else if(eventname === "postCut"){
            component.set("v.imageName1",eventname);
            console.log("file name is "+component.get("v.imageName1"));
            firstImage = false;
            if (event.getSource().get("v.files").length > 0) {
                fileName = event.getSource().get("v.files")[0]['name'];
            }
            component.set("v.fileNamepostCut", fileName);
            fileInput = component.find("fileId1").get("v.files");
            component.set("v.uploadedFiles1",fileInput.length);
            file = fileInput[0];
        }
        
        console.log("first image is  "+firstImage);
        
        if(firstImage == true){
            console.log("in if");
            component.set("v.imageholding", file);
            var img = component.find("imagePreview").getElement();
            img.src = URL.createObjectURL(component.get("v.imageholding"));
        }else{
            console.log("in else");
            // button.set('v.disabled',false);
            component.set("v.imageholding1", file);
            var img = component.find("imagePreview1").getElement();
            img.src = URL.createObjectURL(component.get("v.imageholding1"));
        }
        alert('Your File is Uploaded Successfully');
    },
    
    doSave: function(component, event, helper) {
        console.log("in do save method ");
        var eventname = event.getSource().get("v.name");
        if(eventname === "specEvalSave"){
            if (component.find("fileId").get("v.files").length > 0) {
                console.log("in do save method if");
                helper.uploadHelper(component, event);
                console.log("in do save method if after helper");    
            }
        }else if(eventname === "postCutSave"){
            if (component.find("fileId1").get("v.files").length > 0) {
                console.log("in do save method if");
                helper.uploadHelper(component, event);
                console.log("in do save method if after helper");    
            }
        }else{
            console.log("in do save method else");
            alert('Please Select a Valid File');
        }
    },
    
    
    //Function Call on Component Load
    doInit: function(component, event, helper) {
        var today = new Date();
        component.set("v.datetime", today.toISOString());
        var checkUserBranch = component.get("c.checkUserBranch");
        checkUserBranch.setCallback(this, function(res) {
            var returnValue = res.getReturnValue();
            if(returnValue == false){
                alert('User is not part of any branch');
                var homeEvent = $A.get("e.force:navigateToObjectHome");
                homeEvent.setParams({
                    "scope": "Tissue_Evaluation__c"
                });
                homeEvent.fire();
            }else{
                component.set("v.dislpayNext","false");
                
                component.set("v.tisEval.Cut_Type__c" ,"EK");
                component.set("v.tisEval.Tissue_Processed_for__c" ,"DSAEK");
                
                //To get the Parent ID From Related List
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
                var recid=component.get("v.recId");
                //check for more than 2 records
                helper.checkforTissueRecordCount(component,event,recid);        
                var parent = recid;
                
                if(parent=='a0u'){
                    //From RecoveryI
                    component.set("v.tisEval.Recovery__c",recid);
                    var action= component.get("c.getDonorId");
                    action.setParams({
                        "recid":recid
                    });
                    action.setCallback(this,function(response){
                        var state=response.getState();
                        if(state==='SUCCESS'){
                            component.set("v.Rec",response.getReturnValue());
                            component.set("v.tisEval.Donor_ID__c",component.get("v.Rec").Name);
                            component.set("v.DonorName",component.get("v.Rec").Donor_Name__c);
                            component.set("v.DonorAge",component.get("v.Rec.Referral__r.Age_of_Donor__c"));
                            component.set("v.DonorGender",component.get("v.Rec.Referral__r.Gender__c"));
                            component.set("v.DeathDateTime",component.get("v.Rec.Referral__r.Date_Time_of_Death__c"));
                            //var datelocal = moment(new Date(), "DDMMYYYY").add('15', 'minutes');
                            //var startDateTime = datelocal.toISOString();
                            //component.set("v.TissRecoveryDate",startDateTime);
                            // component.set("v.Recoveryintent",component.get("v.Rec").Recovery_Intent__c);
                            //component.set("v.tisEval.Date_Time_Processed__c",component.get("v.TissRecoveryDate"));
                            component.set("v.tisEval.Date_Time_Processed__c",component.get("v.datetime"));
                            //component.set("v.tisEval.Outcome_Slit_Lamp_Date_Time__c",component.get("v.TissRecoveryDate"));
                            component.set("v.tisEval.Outcome_Slit_Lamp_Date_Time__c",component.get("v.datetime"));
                            /*  component.set("v.tisEval.Media_Lot__c",component.get("v.Rec").Media_Lot__c);
                    component.set("v.tisEval.New_Media_Expiry_Date__c",component.get("v.Rec").Preservation_media_expiration_date__c);
                    component.set("v.tisEval.Preservation_Medium__c",component.get("v.Rec").Preservation_Medium__c); */
                        }        
                    });
                    
                    
                    $A.enqueueAction(action);  
                    
                }
                
                else{
                    //From Medical Review
                    component.set("v.tisEval.Medical_Review__c",recid);
                    var action= component.get("c.getDonorId");
                    action.setParams({
                        "recid":recid
                    });
                    action.setCallback(this,function(response){
                        var state=response.getState();
                        if(state==='SUCCESS'){
                            
                            component.set("v.Med",response.getReturnValue());
                            component.set("v.tisEval.Branch_Name__c",response.getReturnValue().Branch_Name__c);
                            component.set("v.tisEval.Donor_ID__c",component.get("v.Med.Donor_Name_Id__c"));
                            component.set("v.tisEval.Recovery__c",component.get("v.Med.Recovery__c"));    
                            component.set("v.DonorName",component.get("v.Med.Recovery__r.Donor_Name__c"));
                            component.set("v.tisEval.Recovery_Intent__c",component.get("v.Med.Recovery__r.Recovery_Intent__c"));
                            component.set("v.DonorAge",component.get("v.Med.Recovery__r.Referral__r.Age_of_Donor__c"));
                            component.set("v.DonorGender",component.get("v.Med.Recovery__r.Referral__r.Gender__c"));
                            component.set("v.DeathDateTime",component.get("v.Med.Death_Date_Time__c"));
                            component.set("v.tisEval.Media_Lot__c",component.get("v.Med.Recovery__r.Media_Lot__c"));
                            
                            //var datelocal = moment(new Date(), "DDMMYYYY").add('15', 'minutes');
                            //var startDateTime = datelocal.toISOString();
                            
                            //component.set("v.TissRecoveryDate",startDateTime);
                            //component.set("v.tisEval.Date_Time_Processed__c",component.get("v.TissRecoveryDate"));
                            component.set("v.tisEval.Date_Time_Processed__c",component.get("v.datetime"));
                            component.set("v.tisEval.Outcome_Slit_Lamp_Date_Time__c",component.get("v.Med.Recovery__r.Tissue_recovery_date_time__c"));  
                            //alert(component.get("v.tisEval.Outcome_Slit_Lamp_Date_Time__c"))
                            /*    component.set("v.tisEval.Media_Expiration_Date__c",component.get("v.Med.Recovery__r.Cornea_Preservation_Date_Time__c")); */
                            component.set("v.tisEval.Preservation_Date_Time__c",component.get("v.Med.Recovery__r.Cornea_Preservation_Date_Time__c"));
                        }
                    });
                    $A.enqueueAction(action)    
                }
                
                var action4 = component.get("c.getCurrentUser");
                action4.setCallback(this, function(a){
                    var HBsAG = component.get("v.Med.HBsAG__c");
                    console.log(HBsAG);
                    var HCV = component.get("v.Med.HCV__c");
                    var HIV = component.get("v.Med.HIV_I_II__c");
                    console.log(HIV);
                    var Syphilis = component.get("v.Med.Syphilis__c");
                    var user = a.getReturnValue();
                    //component.set("v.userInfo",user);
                    console.log("user details are "+JSON.stringify(user));
                    if((user.Username === "team@megnity.com.uat" || user.Username === "team@megnity.com" ||user.Username === "mohsineyebank@lvpei.org.uat"|| user.Username === "mtc-drushtidaan@lvpei.org.uat" || user.Username === "venkataswamy@lvpei.org.uat" || user.Username === "srinivas.rieb@lvpei.org.uat" || user.Username === "venkataswamy@lvpei.org.uat" || user.Username === "tkeb@lvpei.org.uat" || user.Username === "kbsrinivas@lvpei.org.uat" ) && (HBsAG == "Negative" && HCV == "Negative" && HIV == "Negative" && Syphilis == "Negative")){
                        console.log("I am in if");
                        component.set("v.DisableField",false);  
                        component.set("v.userInfo",user.Username);
                    }
                    
                    else{
                        console.log("I am in else");
                        component.set("v.DisableField",true);
                        
                    }
                    
                });
                
                
                var action5 = component.get("c.getCurrentUser");
                action5.setCallback(this, function(a){
                    var HBsAG = component.get("v.Med.HBsAG__c");
                    console.log(HBsAG);
                    var HCV = component.get("v.Med.HCV__c");
                    console.log(HCV);
                    var HIV = component.get("v.Med.HIV_I_II__c");
                    console.log(HIV);
                    var Syphilis = component.get("v.Med.Syphilis__c");
                    console.log(Syphilis);
                    var user = a.getReturnValue();
                    if (HBsAG == "Negative" && HCV == "Negative" && HIV == "Negative" && Syphilis == "Negative"){
                        console.log("I am in if");
                        component.set("v.outcomevalue",false);
                        
                    }
                    else{
                        console.log("I am in else");
                        component.set("v.outcomevalue",true);
                    }
                    
                });
                $A.enqueueAction(action4)
                $A.enqueueAction(action5)
            }
        });
        $A.enqueueAction(checkUserBranch);
    },
    
    //Getting Details from Referral, Recovery
    getDetails: function(component, event, helper) {
        var params = event.getParam('arguments');
        component.set("v.MedId",params.MedId);
        component.set("v.DonorId",params.DonorId);
        component.set("v.DonorName",params.DonorName);
        component.set("v.DonorAge",params.DonorAge);
        component.set("v.DonorGender",params.DonorGender);
        //  componnet.set("v.Recoveryintent",params.Recoveryintent);
        component.set("v.DeathDateTime",params.DeathDateTime);
        component.set("v.TissueImported",params.TissueImported);
        component.set("v.recoveryId",params.recoveryId);
        component.set("v.eyeType",params.eyeType);
        component.set("v.dislpayNext",params.dislpayNext);
        if(component.get("v.eyeType")!=null){
            component.find("eye").set("v.value",component.get("v.eyeType"));
            component.set("v.enabled","true");
        }
        component.set("v.tisEval.Medical_Review__c",component.get("v.MedId"));
        var recoveryId = component.get("v.recoveryId");
        if(recoveryId!=null){
            component.set("v.tisEval.Donor_ID__c",component.get("v.DonorId"));
            component.set("v.tisEval.Recovery__c",recoveryId);
        }
        var action = component.get("c.getRecovery");
        action.setParams({
            "recoveryId":recoveryId
        });
        action.setCallback(this,function(response){
            if(response.getState()==='SUCCESS'){
                component.set("v.Recovery",response.getReturnValue());
                //   component.set("v.tisEval.Media_Expiration_Date__c",component.get("v.Recovery").Cornea_Preservation_Date_Time__c);
            }
        });
        $A.enqueueAction(action);
        
        
    },
    
    //Code for Expand and Collapse Sections
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
    
    section07 : function(component, event, helper) {
        helper.helperadd(component,event,'Seven');
    },
    
    section08 : function(component, event, helper) {
        helper.helperadd(component,event,'Eight');
    },
    
    section09 : function(component, event, helper) {
        helper.helperadd(component,event,'Nine');
    },
    
    section10 : function(component, event, helper) {
        helper.helperadd(component,event,'Ten');
    },
    
    section11 : function(component, event, helper) {
        helper.helperadd(component,event,'Eleven');
    },
    
    section12 : function(component, event, helper) {
        helper.helperadd(component,event,'Twelve');
    },
    
    section13 : function(component, event, helper) {
        helper.helperadd(component,event,'Thirteen');
    },
    
    section14 : function(component, event, helper) {
        helper.helperadd(component,event,'Fourteen');
    },
    //Code for Hide and Show Procedures under LFH
    onProcedurePick : function(component, event, helper) {
        var procedure =component.find("procedure").get("v.value");        
        if(procedure=='No'){
            
            component.set("v.ProcedureNo",true);
        }
        else{
            component.set("v.ProcedureNo",false);
        }
        
    },
    
    //Code for Hide and Show Specular Evaluation Done
    OnSpecPick : function(component, event, helper) {
        var SpecEval =component.find("SpecEval").get("v.value");
        if(SpecEval=='Yes'){
            component.set("v.display","true");
        }
        else{
            component.set("v.display","false");
        }
    },
    //Code for Hide and Show Slit Lamp Done
    OnSlitPick : function(component, event, helper) {
        var Slitval =component.find("Slitval").get("v.value");
        if(Slitval=='Yes'){
            component.set("v.display1","true");
        }
        else{
            component.set("v.display1","false");
        }
    },
    //Code for Hide and Show Clear and Intact
    OnclearIntPick : function(component, event, helper) {
        var clearInt =component.find("clearInt").get("v.value");        
        if(clearInt=='Yes'){
            
            component.set("v.display10",true);
        }
        else{
            component.set("v.display10",false);
        }
        
    },
    //Code for Hide and Show Debris
    OnDebrisPick : function(component, event, helper) {
        var debris =component.find("debris").get("v.value");        
        if(debris=='Yes'){
            
            component.set("v.DebrisYes",true);
        }
        else{
            component.set("v.DebrisYes",false);
        }
        
    },
    
    //Code for Hide and Show Scleral Rim 2mm or Greater Circumferentially?
    OnSclerlPick : function(component, event, helper) {
        var Sclerl =component.find("Sclerl").get("v.value");
        if(Sclerl=='No'){
            component.set("v.display2","true");  
        }
        else{
            component.set("v.display2","false");
        }
    },
    //Code for Hide and Show Tissue Type
    ontissueTypePick: function(component, event, helper) {
        var tissueType = component.find("tissueType").get("v.value");
        if(tissueType=="Whole Globe" || tissueType=="Cornea" || tissueType=="Sclera" || tissueType=="None"){
            $A.util.removeClass(component.find("TissueProcessedBy"),"slds-hide");
            $A.util.addClass(component.find("TissueProcessedBy"),"slds-show");      
        }
        else{
            $A.util.removeClass(component.find("TissueProcessedBy"),"slds-show");
            $A.util.addClass(component.find("TissueProcessedBy"),"slds-hide");      
        }
        if(tissueType=="Cornea" || tissueType=="Whole Globe"){
            component.find("tissueSubType").set("v.value","Whole");
        }
        else{
            component.find("tissueSubType").set("v.value","");
        }
    },
    //Code for Hide and Show Pre-Cut
    OnPreCutPick : function(component, event, helper) {
        var PreCutVal =component.find("PreCutVal").get("v.value");
        if(PreCutVal=='Yes'){
            component.set("v.display3","true");  
        }
        else{
            component.set("v.display3","false");
        }
    },
    //Code for Hide and Show Tissue Suitability
    OnTisSuitPick : function(component, event, helper) {
        var TisSuit =component.find("TisSuit").get("v.value");
        
        if(TisSuit=='Suitable'){
            component.set("v.display4","true");
            $A.util.removeClass(component.find("slitlampeval"),"slds-show");
            $A.util.addClass(component.find("slitlampeval"),"slds-hide");  
            $A.util.removeClass(component.find("speculareval"),"slds-show");
            $A.util.addClass(component.find("speculareval"),"slds-hide");  
            $A.util.removeClass(component.find("sterilitycompromise"),"slds-show");
            $A.util.addClass(component.find("sterilitycompromise"),"slds-hide");  
            $A.util.removeClass(component.find("IssuesTransportlog"),"slds-show");
            $A.util.addClass(component.find("IssuesTransportlog"),"slds-hide");  
            
        }
        else{
            component.set("v.display4","false");
            $A.util.removeClass(component.find("slitlampeval"),"slds-hide");
            $A.util.addClass(component.find("slitlampeval"),"slds-show");
            $A.util.removeClass(component.find("speculareval"),"slds-hide");
            $A.util.addClass(component.find("speculareval"),"slds-show");
            $A.util.removeClass(component.find("sterilitycompromise"),"slds-hide");
            $A.util.addClass(component.find("sterilitycompromise"),"slds-show");
            $A.util.removeClass(component.find("IssuesTransportlog"),"slds-hide");
            $A.util.addClass(component.find("IssuesTransportlog"),"slds-show");
        }
        if(TisSuit=='NSFT'){
            component.set("v.display7","true");
            //component.set("v.tisEval.Approval_Outcome__c","Discard");
            //component.set("v.tisEval.Tissue_Disposition__c","Discarded");
        }
        else{
            component.set("v.display7","false");
            component.set("v.tisEval.Approval_Outcome__c","");
            component.set("v.tisEval.Tissue_Disposition__c","");
        }
        
        
    },
    //Code for Hide and Show Stroma
    OnStromaPick : function(component, event, helper) {
        var StromaPick =component.find("StromaPick").get("v.value");
        if(StromaPick=='Yes'){
            component.set("v.display8","true");  
        }
        else{
            component.set("v.display8","false");
        }
    },
    //Code for Hide and Show Endothelium : Defects
    OnEndoDefectsPick : function(component, event, helper) {
        var EndoDefects =component.find("EndoDefects").get("v.value");
        if(EndoDefects=='Yes'){
            component.set("v.EndoDefectYes","true");  
        }
        else{
            component.set("v.EndoDefectYes","false");
        }
    },
    
    
    //Code for Hide and Show Tissue Disposition
    OnTisDispPick : function(component, event, helper) {
        var TisDisp =component.find("TisDisp").get("v.value");
        if(TisDisp=='Discarded'){
            component.set("v.display5","true");  
        }
        else{
            component.set("v.display5","false");
        }
    },
    //Code for Hide and Show Category
    OnCategPick : function(component, event, helper) {
        var Categ =component.find("Categ").get("v.value");
        if(Categ=='Other Reasons'){
            component.set("v.display6","true");  
        }
        else{
            component.set("v.display6","false");
        }
        
    },
    //Code for Hide and Show Other Reasons
    OnotherReasonPick : function(component, event, helper) {
        var otherReason =component.find("otherReason").get("v.value");
        if(otherReason=='Sterility Compromise'){
            component.set("v.display9","true");  
        }
        else{
            component.set("v.display9","false");
        }
        
        if(otherReason=='Media Issue'){
            component.set("v.display11","true");  
        }
        else{
            component.set("v.display11","false");
        }
        
        if(otherReason=='Tissue Damage Due to Transportation/Logistics'){
            component.set("v.display12","true");  
        }
        else{
            component.set("v.display12","false");
        }
        
        if(otherReason=='Cold Chain Break'){
            component.set("v.display13","true");  
        }
        else{
            component.set("v.display13","false");
        }
        
        if(otherReason=='Preservation Issue'){
            component.set("v.display14","true");  
        }
        else{
            component.set("v.display14","false");
        }
        
        if(otherReason=='Surgeon Issue'){
            component.set("v.display15","true");  
        }
        else{
            component.set("v.display15","false");
        }
        
        if(otherReason=='Tissue Damage During Tissue Preparation'){
            component.set("v.display16","true");  
        }
        else{
            component.set("v.display16","false");
        }
        
        if(otherReason=='Post Distribution Issues'){
            component.set("v.display17","true");  
        }
        else{
            component.set("v.display17","false");
        }
        
        if(otherReason=='Tissue Expiry'){
            component.set("v.display18","true");  
        }
        else{
            component.set("v.display18","false");
        }
        
    },
    //Code for Hide and Show Sloughing
    sloughingChange : function(component, event, helper) {
        var sloughi =component.find("sloughing").get("v.value");
        if(sloughi=='None'){
            component.set("v.slough","false");
        }
        else{
            component.set("v.slough","true");
        }
    },
    //Code for Hide and Show Opacities 1
    opacities : function(component, event, helper) {
        var opa =component.find("opacity").get("v.value");
        if(opa=='None'){
            component.set("v.opaciti","false");
        }
        else{
            component.set("v.opaciti","true");
        }
    },
    //Code for Hide and Show Opacities 2
    opacities2 : function(component, event, helper) {
        var opa2 =component.find("opacity2").get("v.value");
        if(opa2=='None'){
            component.set("v.opaciti2","false");
        }
        else{
            component.set("v.opaciti2","true");
        }
    },
    
    //Code for Hide and Show Defects
    def : function(component, event, helper) {
        var de =component.find("descr").get("v.value");
        if(de=='None'){
            component.set("v.desc","false");
        }
        else{
            component.set("v.desc","true");
        }
    },
    
    //Code for Calculating Tissue Expiry Based on Different Mediums
    tissueExpiryCalc : function(component, event, helper) {  
        
        var preservationMediaDate = component.get("v.tisEval.Preservation_Date_Time__c");
        var parsedPreservationMediaDate = new Date(preservationMediaDate);
        var PreservMedium = component.find("PreservMedium").get("v.value");
        var expiryDate;
        switch(PreservMedium){
            case 'MK':  
                var newExpiryDate = parsedPreservationMediaDate.setDate(parsedPreservationMediaDate.getDate() + 4);
                expiryDate =  $A.localizationService.formatDate(newExpiryDate, "yyyy-MM-ddTHH:mm:ss.000Z");
                component.set("v.tisEval.Tissue_Expiry_Date__c",expiryDate);
                break;
                
            case 'Cornisol':
            case 'OptisolGS':
            case 'Eusol-c':
            case 'Life4c':
                var newExpiryDate = parsedPreservationMediaDate.setDate(parsedPreservationMediaDate.getDate() + 14);
                expiryDate =  $A.localizationService.formatDate(newExpiryDate, "yyyy-MM-ddTHH:mm:ss.000Z");
                component.set("v.tisEval.Tissue_Expiry_Date__c",expiryDate);
                break;
                
            case '100%EtOH':
            case '95%EtOH':
            case '70%EtOH':
            case 'Glycerin':
                var newExpiryDate = parsedPreservationMediaDate.setDate(parsedPreservationMediaDate.getDate() + 365);
                expiryDate =  $A.localizationService.formatDate(newExpiryDate, "yyyy-MM-ddTHH:mm:ss.000Z");
                component.set("v.tisEval.Tissue_Expiry_Date__c",expiryDate);
                break;
                
            case 'MoistChamber':
                var newExpiryDate = parsedPreservationMediaDate.setDate(parsedPreservationMediaDate.getDate() + 1);
                expiryDate =  $A.localizationService.formatDate(newExpiryDate, "yyyy-MM-ddTHH:mm:ss.000Z");
                component.set("v.tisEval.Tissue_Expiry_Date__c",expiryDate);
                break;
        }
    },
    
    //PDF for Post Cut Evaluation Form
    downloadPostCutPdf : function(component, event, helper){
        var recordId = component.get("v.recordId");
        window.open('/apex/PostCutEvaluationForm?tissueId='+recordId, '_blank');        
    },
    
    //Code for Print Label PDF
    printLabel : function(component, event, helper){
        var recordId = component.get("v.recordId");
        window.open('/apex/TissueEvalPrintLabel?tissueId='+recordId, '_blank');        
    },
    
    //Functionality for Saving Tissue Evaluation
    SaveTissueEval : function(component, event, helper){
        component.set("v.spinner",true);
        component.set("v.buttonDisable",true);
        var PreCutVal =component.find("PreCutVal").get("v.value");
        var newtisEval = component.get("v.tisEval");
        var donorconId = component.get("v.DonorCon").Id;
        var donorconId1 = component.get("v.DonorCon1").Id;
        var donorconId2 = component.get("v.DonorCon2").Id;
        var donorconId3 = component.get("v.DonorCon3").Id;
        var donorconId4 = component.get("v.DonorCon4").Id;
        var donorconId5 = component.get("v.DonorCon5").Id;
        var donorconId6 = component.get("v.DonorCon6").Id;
        var donorconId7 = component.get("v.DonorCon7").Id;
        var donorconId8 = component.get("v.DonorCon8").Id;
        var action  = component.get("c.Savetissue");
        // alert(newtisEval.Date_Time_Processed__c);
        //alert(newtisEval.Outcome_Slit_Lamp_Date_Time__c);
        
        if(PreCutVal=='')
        {
         component.set("v.tisEval.Date_Time_Processed__c","");
            

        }
        if(PreCutVal=='Yes')
        {
         component.set("v.tisEval.Date_Time_Processed__c",component.get("v.datetime"));

        }
        

        
        if(PreCutVal=='No')
        {
            component.set("v.tisEval.Cut_Type__c" ,"");
            component.set("v.tisEval.Cut_Parameters__c" ,"");
            component.set("v.tisEval.Tissue_Processed_for__c" ,"");
            component.set("v.datetime" ,"");
            component.set("v.tisEval.Date_Time_Processed__c","");
            component.set("v.tisEval.Graft_Thickness_microns__c" ,"");
            component.set("v.tisEval.Graft_Diameter_mm__c" ,"");
            component.set("v.tisEval.Comments_Post_Cut__c" ,"");
            component.set("v.tisEval.Endothelial_Cell_Density_mm2__c" ,"");
            component.set("v.tisEval.Post_Cut_Epithelium__c" ,"");
            component.set("v.tisEval.Anterior_Stroma__c" ,"");
            component.set("v.tisEval.Posterior_Stroma__c" ,"");
            component.set("v.tisEval.Descemet_s__c" ,"");
            component.set("v.tisEval.Post_Cut_Endothelium__c" ,"");
            component.set("v.tisEval.Post_Cut_Preservation_Medium__c" ,"");
            component.set("v.tisEval.Post_Cut_Media_lot__c" ," ");
            component.set("v.tisEval.Post_Cut_Media_Expiration_Date_Time__c" ,"");
            component.set("v.tisEval.Slit_Lamp_Date_Time__c" ," ");
            component.set("v.tisEval.Specular_Date_Time__c" ,"");
            component.set("v.tisEval.Additional__c" ,"");
            
            
        }
        action.setParams({
            "TisEval": newtisEval,
            "firstlookup" : donorconId,
            "secondlookup" : donorconId1,
            "thirdlookup" : donorconId2,
            "fourthlookup" : donorconId3,
            "fifthlookup" : donorconId4,
            "sixthlookup" : donorconId5,
            "seventhlookup" : donorconId6,
            "eighthlookup" : donorconId7,
            "ninthlookup" : donorconId8
        });
        
        action.setCallback(this, function(a) {
            var TissueEvalName="";
            var tisEval="";
            var state = a.getState();
            if (state === "SUCCESS") {
                tisEval = a.getReturnValue();
                component.set("v.recordId",tisEval.Id);
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "type": "Success",
                    "message": "Record Saved"
                });
                resultsToast.fire();
                
                
                /*====START=========Create attchment to tissue record creating above*/
                var fileInput;
                console.log(component.get("v.uploadedFiles"));
                console.log(component.get("v.uploadedFiles1"));
                if(component.get("v.uploadedFiles") >0){
                    fileInput = component.find("fileId").get("v.files");
                    console.log("i am here");
                    helper.uploadHelper(component, event, fileInput,component.get("v.imageName"));
                }
                if(component.get("v.uploadedFiles1") >0){
                    fileInput = component.find("fileId1").get("v.files");
                    console.log("i am here");
                    helper.uploadHelper(component, event, fileInput,component.get("v.imageName1"));
                }
                /*====END=========Create attchment to tissue record creating above*/    
                
                //Record ID & SF ID Functionality  (Start)
                var TissueEvalName1 = component.get("c.getTissueEvalName");
                TissueEvalName1.setParams({
                    "tisEvalId":tisEval.Id
                });
                TissueEvalName1.setCallback(this, function(a) {
                    var state = a.getState();
                    var tissue="";
                    if(state === "SUCCESS"){
                        tissue = a.getReturnValue();
                        TissueEvalName = tissue.Name;
                        tisEval.Name=TissueEvalName;
                        component.set("v.tisEval.Tissue_ID__c",TissueEvalName);
                        component.set("v.tissue",tisEval);
                        var tissueDetail = component.get("v.tissue");
                        var getEvent = component.getEvent("GetTissueDetail");
                        getEvent.setParams({
                            "tissue":tissueDetail,
                            "closeModal":"false"
                        });
                        getEvent.fire();
                        //ADDED START
                        var navEvt = $A.get("e.force:navigateToSObject");
                        navEvt.setParams({
                            "recordId": tisEval.Id
                        });
                        navEvt.fire();
                        //ADDED END
                    }
                });
                $A.enqueueAction(TissueEvalName1)
                
                //Record ID & SF ID Functionality  (End)                
                
                
                /*var dislpayNext = component.get("v.dislpayNext");
                    if(dislpayNext=="false"){
                        var homeEvt = $A.get("e.force:navigateToObjectHome");
                        homeEvt.setParams({
                            "scope": "Tissue_Evaluation__c"
                        });
                        homeEvt.fire();
                    }*/
                
            }else if (state === "ERROR") {
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
            component.set("v.buttonDisable",false);    
        });
        $A.enqueueAction(action);
    } ,
    
    // Lookup Tab Index
    focusToNextField : function(component,event, helper){
        var selectedLookupLabel = event.getParam("label");
        console.log("Testing : "+selectedLookupLabel);
        if(selectedLookupLabel == "Tissue Processed By"){
            var f1 = component.find("PreservMedium");
            f1.focus();
        }  
        else if(selectedLookupLabel == "Specular Evaluation Done By"){
            var f2 = component.find("SpecularEvaluationDateTime");
            f2.focus();
        }
            else if(selectedLookupLabel == "Cornea Suitability Determined By"){
                var f3 = component.find("EvaluationsComments");
                f3.focus();
            }
                else if(selectedLookupLabel == "Slit Lamp Eval Performed By"){
                    var f4 = component.find("ApprovalOutcome");
                    f4.focus();
                }
                    else if(selectedLookupLabel == "Final Review and Approval Done By"){
                        var f5 = component.find("DateTimeofFinalReviewApproval");
                        f5.focus();
                    }
                        else if(selectedLookupLabel == "Slit Lamp Technician"){
                            var f6 = component.find("slitlampdatetime");
                            f6.focus();
                        }
                            else if(selectedLookupLabel == "Specular Technician"){
                                var f7 = component.find("speculardatetime");
                                f7.focus();
                            }
                                else if(selectedLookupLabel == "Circulator"){
                                    var f8 = component.find("additional");
                                    f8.focus();
                                }
    },
    sldate : function(component, event, helper) {
        //var tissrecDate = component.find("Trec").get("v.value");
        
        var tisProcessed = new Date(component.find("TissueProcessed").get("v.value"));        
        var slitDate = new Date(component.find("slitlampdatetime").get("v.value"));
        
        if(slitDate.getTime() > tisProcessed.getTime()){
            component.set("v.booleanvalue", "false");            
        }
        else{
            component.set("v.booleanvalue", "true");
            
        }
    },
    stdate : function(component, event, helper) {
        //var tissrecDate = component.find("Trec").get("v.value");
        
        var tisProcessed = new Date(component.find("TissueProcessed").get("v.value"));        
        var sdatetime = new Date(component.find("speculardatetime").get("v.value"));
        
        if(sdatetime.getTime() > tisProcessed.getTime()){
            component.set("v.booleanvalue1", "false");            
        }
        else{
            component.set("v.booleanvalue1", "true");
            
        }
    },
    outcome : function(component, event, helper) {
        //var tissrecDate = component.find("Trec").get("v.value");
        
        var slitDate = new Date(component.find("OutcomeSlit").get("v.value"));        
        var finalapprovaldatetime = new Date(component.find("DateTimeofFinalReviewApproval").get("v.value"));
        
        if(finalapprovaldatetime.getTime() > slitDate.getTime()){
            component.set("v.booleanvalue2", "false");            
        }
        else{
            component.set("v.booleanvalue2", "true");
            
        }
    },
    TissRecDate : function(component, event, helper) {
        //var tissrecDate = component.find("Trec").get("v.value");
        
        var specularDate = new Date(component.find("SpecularEvaluationDateTime").get("v.value"));        
        var tissRecDate = new Date(component.get("v.TissRecoveryDate"));
        
        if(specularDate.getTime() > tissRecDate.getTime()){
            component.set("v.booleanvalue3", "false");            
        }
        else{
            component.set("v.booleanvalue3", "true");
            
        }
    },

    
    
    
    /* buttonAction: function(component,event,helper){
    let button = component.find('disablebuttonid');
    button.set('v.disabled',true);
  },*/
    
    
})