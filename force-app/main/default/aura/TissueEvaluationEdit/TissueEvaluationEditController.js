({
    //Functionality for Upload Image 
    handleuploadedImage : function(component,event,helper){
        console.log("in handleuploadedImage")
        const getImage = event.getParam("image");
        var firstimg = event.getParam("firstimg"); 
        if(firstimg==true){
        console.log("in if");
        component.set("v.imageholding", getImage);
        var img = component.find("imagePreview").getElement();
        img.src = URL.createObjectURL(component.get("v.imageholding"));
        }
        else{
            console.log("in else");
       // button.set('v.disabled',false);
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
            firstImage = true;
            if (event.getSource().get("v.files").length > 0) {
                fileName = event.getSource().get("v.files")[0]['name'];
            }
            component.set("v.fileNamespecEval", fileName);
            fileInput = component.find("fileId").get("v.files");
        	file = fileInput[0];
        }else if(eventname === "postCut"){
            component.set("v.imageName",eventname);
            firstImage = false;
            if (event.getSource().get("v.files").length > 0) {
                fileName = event.getSource().get("v.files")[0]['name'];
            }
            component.set("v.fileNamepostCut", fileName);
            fileInput = component.find("fileId1").get("v.files");
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
                var action = component.get("c.fetchTissue");
                action.setParams({
                    "RecId" : component.get("v.recordId")
                });
                action.setCallback(this,function(res){
                    if(res.getState() === "SUCCESS"){
                        console.log("response state is SUCCESS"+JSON.stringify(res.getReturnValue()));
                        if(res.getReturnValue() !== null){
                            component.set("v.tisEval",res.getReturnValue());
                            component.set("v.DataLoad",true);
                            
                                            var today = new Date();
                  var date_time_processed = component.get("v.tisEval.Date_Time_Processed__c");
                      console.log("date..."+date_time_processed);
                if(date_time_processed=="" || date_time_processed==null || date_time_processed=='')
                {
                           component.set("v.datetime", today.toISOString());
                      console.log("date...1111"+date_time_processed);

 
                }
                else{
                      console.log("date...222"+date_time_processed);
                                            component.set("v.datetime", date_time_processed);
   
                }

                        }
                    }else if(res.getState() === "INCOMPLETE"){
                        console.log("response state is INCOMPLETE");
                    }else if(res.getState() === "ERROR"){
                        console.log("response state is ERROR");
                    }
                });
                $A.enqueueAction(action)
                
                //component.set("v.dislpayNext","false");
                console.log("tissue evalution record details "+JSON.stringify(component.get("v.tisEval")));
                //component.set("v.tisEval.Cut_Type__c" ,"EK");
                //component.set("v.tisEval.Tissue_Processed_for__c" ,"DSAEK");
               
                //To pre-populate the lookups
                var action0 = component.get("c.getLookups");
                action0.setParams({
                    "tisID":component.get("v.recordId")  
                });      
                action0.setCallback(this,function(response){
                    if(response.getState()==="SUCCESS"){
                        component.set("v.lookupList",response.getReturnValue());
                        var lookupList = component.get("v.lookupList");
                        
                        if(lookupList['con1']!=null){
                            component.set("v.DonorCon4",lookupList['con1']); 
                        }
                        else{
                            component.set("v.DonorCon4",{});   
                        }
                        if(lookupList['con2']!=null){
                            component.set("v.DonorCon",lookupList['con2']); 
                        }
                        else{
                            component.set("v.DonorCon",{});   
                        }
                        if(lookupList['con3']!=null){
                            component.set("v.DonorCon1",lookupList['con3']);
                        }
                        else{
                            component.set("v.DonorCon1",{});   
                        }
                        if(lookupList['con4']!=null){
                            component.set("v.DonorCon2",lookupList['con4']);
                        }
                        else{
                            component.set("v.DonorCon2",{});   
                        }
                        if(lookupList['con5']!=null){
                            component.set("v.DonorCon3",lookupList['con5']);
                            // Ruma
                            let name= component.get("v.DonorCon3")["Name"];                    
                            component.set("v.lkupValue", name);
                            // / Ruma
                        }
                        else{
                            component.set("v.DonorCon3",{});   
                        }
                        if(lookupList['con6']!=null){
                            component.set("v.DonorCon5",lookupList['con6']);
                        }
                        else{
                            component.set("v.DonorCon5",{});   
                        }
                        if(lookupList['con7']!=null){
                            component.set("v.DonorCon6",lookupList['con7']);
                        }
                        else{
                            component.set("v.DonorCon6",{});   
                        }
                        if(lookupList['con8']!=null){
                            component.set("v.DonorCon7",lookupList['con8']);
                        }
                        else{
                            component.set("v.DonorCon7",{});   
                        }
                        if(lookupList['con9']!=null){
                            component.set("v.DonorCon8",lookupList['con9']);
                        }
                        else{
                            component.set("v.DonorCon8",{});   
                        }               
                    }
                });
                
                
                $A.enqueueAction(action0)
                        
                //Editing the Saved Record
                 
                var currentRecord = component.get("v.recordId");
                var parentTissue = currentRecord.substring(0,3);
                if(parentTissue!=null){
                  
                    var action1 = component.get("c.getDonorId");
                    action1.setParams({
                        "recid":component.get("v.recordId")
                    });
                    action1.setCallback(this,function(response){
                        if(response.getState()==='SUCCESS'){
                           // button.set('v.disabled',false);
                            component.set("v.tissue",response.getReturnValue());
                            component.set("v.tisEval.Branch_Name__c",response.getReturnValue().Branch_Name__c);
                            component.set("v.tisEval.Medical_Review__c",component.get("v.tissue.Medical_Review__c"));    
                            var donorNameId = component.get("v.tissue.Medical_Review__r.Donor_Name_Id__c");
                            component.set("v.tisEval.Donor_ID__c",donorNameId);
                            component.set("v.DonorId",donorNameId);
                            component.set("v.tisEval.Recovery__c",component.get("v.tissue.Recovery__c"));    
                            component.set("v.DonorName",component.get("v.tissue.Recovery__r.Donor_Name__c"));
                           // component.set("v.recoveryintent",component.get("v.tissue.Recovery__r.Recovery_Intent__c"));
                            component.set("v.DonorAge",component.get("v.tissue.Recovery__r.Referral__r.Age_of_Donor__c"));
                            component.set("v.DonorGender",component.get("v.tissue.Recovery__r.Referral__r.Gender__c"));
                            component.set("v.DeathDateTime",component.get("v.tissue.Recovery__r.Referral__r.Date_Time_of_Death__c")); 
                            component.set("v.PreservationDateTime",component.get("v.tissue.Recovery__r.Cornea_Preservation_Date_Time__c"));
                            //component.set("v.TissRecoveryDate",component.get("v.tissue.Recovery__r.Tissue_recovery_date_time__c"));
                            //component.set("v.tisEval.Date_Time_Processed__c",component.get("v.TissRecoveryDate"));
                            //component.set("v.tisEval.Outcome_Slit_Lamp_Date_Time__c",component.get("v.TissRecoveryDate"));
                        }
                    });
                    $A.enqueueAction(action1)
                }
                
                else{
                //To get the Medical Review ID From Related List 
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
                var parent = recid.substring(0,3);
                if(recid!=null){
                    //From Medical Review
                    component.set("v.tisEval.Medical_Review__c",recid);
                    var action2 = component.get("c.getDonorId");
                    action2.setParams({
                        "recid":recid
                    });
                    action2.setCallback(this,function(response){
                        var state=response.getState();
                        alert(Neighbour)
                        if(state==='SUCCESS'){
                           alert(response.getReturnValue())
                            component.set("v.Med",response.getReturnValue()[0]);
                            component.set("v.tisEval.Donor_ID__c",component.get("v.Med").Donor_Name_Id__c);
                            component.set("v.tisEval.Recovery__c",component.get("v.Med").Recovery__c);    
                            component.set("v.DonorName",component.get("v.Med").Recovery__r.Donor_Name__c);
                          // component.set("v.recoveryintent",component.get("v.Med.Recovery__r.Recovery_Intent__c"));
                          component.set("v.tisEval.Recovery_Intent__c",component.get("v.Med").Recovery__r.Recovery_Intent__c);
                            component.set("v.DonorAge",component.get("v.Med").Recovery__r.Referral__r.Age_of_Donor__c);
                            component.set("v.DonorGender",component.get("v.Med").Recovery__r.Referral__r.Gender__c);
                            component.set("v.DeathDateTime",component.get("v.Med").Death_Date_Time__c);
                            component.set("v.PreservationDateTime",component.get("v.Med").Recovery__r.Cornea_Preservation_Date_Time__c);
                            //component.set("v.TissRecoveryDate",component.get("v.Med.Recovery__r.Tissue_recovery_date_time__c"));
                            //component.set("v.tisEval.Date_Time_Processed__c",component.get("v.TissRecoveryDate"));
                            //component.set("v.tisEval.Outcome_Slit_Lamp_Date_Time__c",component.get("v.TissRecoveryDate"));
                        }
                    });
                    $A.enqueueAction(action2)  
                } 
                }
                var action3 = component.get("c.getAttachments");
                action3.setParams({
                    "tisId":component.get("v.recordId")  
                })
                action3.setCallback(this,function(response){
                    console.log("Response is "+response.getState());
                    if(response.getState()==="SUCCESS"){
                        var result = response.getReturnValue();
                        for(var i = 0; i < result.length; i++){
                            console.log("Response is "+result[i]);
                            if(result[i] != null && result[i].Name.includes("specEval")){
                                component.set("v.imgurl", "/servlet/servlet.FileDownload?file="+result[i].Id);
                                console.log("spec Eval "+component.get("v.imgurl"));
                                continue;
                            }
                            if(result[i] != null && result[i].Name.includes("postCut")){
                                component.set("v.imgurl1", "/servlet/servlet.FileDownload?file="+result[i].Id);
                                console.log("post Cut "+component.get("v.imgurl1"));
                                continue;
                            }    
                        }
                    }
                    });
                    $A.enqueueAction(action3)
                //code for serology & user restriction --teja/sai
                   var action4 = component.get("c.getCurrentUser"); 
                    action4.setCallback(this, function(a){
                    var HBsAG = component.get("v.tissue.Medical_Review__r.HBsAG__c");
                    console.log('hey'+HBsAG);
                    var HCV = component.get("v.tissue.Medical_Review__r.HCV__c");
                        console.log(HCV);
                    var HIV = component.get("v.tissue.Medical_Review__r.HIV_I_II__c");
                    var Syphilis = component.get("v.tissue.Medical_Review__r.Syphilis__c");
                   
                           var user = a.getReturnValue();
                           
                        
                        
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
                    $A.enqueueAction(action4)
            	}
        });
        $A.enqueueAction(checkUserBranch);
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
    
    onProcedurePick : function(component, event, helper) {
        var procedure =component.find("procedure").get("v.value");
        console.log("i am onProcedurePick procedure value is "+procedure);
        if(procedure === 'No' || procedure === 'Cornea Processed under LFH' || procedure === 'Cornea Shifted to Another Media' || procedure === 'Other Open Container Procedures'){
            component.set("v.tissuetype",false);
        }else{
            component.set("v.tissuetype",true);
        }
    },
    
    OnSpecPick : function(component, event, helper) {
        var SpecEval =component.find("SpecEval").get("v.value");
        if(SpecEval=='Yes'){
            component.set("v.display","true");
        }
        else{
            component.set("v.display","false");
        }
    }, 
    
    OnSlitPick : function(component, event, helper) {
        var Slitval =component.find("Slitval").get("v.value");
        if(Slitval=='Yes'){
            component.set("v.display1","true");
        }
        else{
            component.set("v.display1","false");
        }
    }, 
    
    OnclearIntPick : function(component, event, helper) {
        var clearInt =component.find("clearInt").get("v.value");        
        if(clearInt=='Yes'){
            
            component.set("v.display10",true);
        }
        else{
            component.set("v.display10",false);
        }
        
    }, 
    
    OnDebrisPick : function(component, event, helper) {
        var debris =component.find("debris").get("v.value");        
        if(debris=='Yes'){
            
            component.set("v.DebrisYes",true);
        }
        else{
            component.set("v.DebrisYes",false);
        }
        
    }, 
    
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
        }else if(tissueType === "Sclera" && component.get("v.tisEval").Is_Child_Record__c === false){
            helper.opendModal(component, event, helper);
        }else{
            component.find("tissueSubType").set("v.value",""); 
        }
    },
    
    validateTissueId: function(component, event, helper){
        component.set("v.showSpinner",true);
        //Check Child Records
        var isChildAvailable = "";
        var result = function(res){
            component.set("v.showSpinner",false);
                console.log("in callback method");
                isChildAvailable = res;
                console.log("in callback method after");
                console.log("before if"+isChildAvailable);
                if(isChildAvailable === "Yes"){
                    component.set("v.tissueIdValidate",true);
                    console.log("in if");
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "type" : "error",
                         "message": "Record Already available with this Tissue Id please select diffrent quater to proceed further."
                    });
                    toastEvent.fire();
                    console.log("after taost");
                }else if(isChildAvailable === "No"){
                    console.log("in if");
                    component.set("v.tissueIdValidate",false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "type" : "info",
                         "message": "No Record Available with this new tissue id..."
                    });
                    toastEvent.fire();
                    console.log("after taost");
                }
            }
        console.log("i am in check child record method");
        var tissue = component.get("v.tisEval");
    	var DonorId = component.get("v.DonorId");
        console.log("i am after donorid");
        var Eye = component.find("eye").get("v.value");
        console.log("i am eye "+Eye);
        var TissueType = component.find("tissueType").get("v.value");
        console.log("i am after tissuetype "+TissueType);
        if(TissueType === "Sclera"){
        	var Quater = component.find("Quarter").get("v.value");
        	console.log("i am after quater "+Quater);
    	}
        var TissueId = tissue.Name;
        if(TissueType !== "" && TissueType !== undefined && TissueType !== null && Quater !== "" && Quater !== undefined && Quater !== null){
            var newTissueId = DonorId+" "+Eye+"-"+"S"+"-"+"Q"+Quater;
            component.set("v.newTissueId",newTissueId);
            helper.checkChildRecords(component, event, helper, newTissueId, result);
        }else{
            
        }
    },
    
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
           // component.set("v.tisEval.Approval_Outcome__c","Discard");
            //component.set("v.tisEval.Tissue_Disposition__c","Discarded");
        }
        else{
            component.set("v.display7","false");
            component.set("v.tisEval.Approval_Outcome__c","");
            component.set("v.tisEval.Tissue_Disposition__c","");
        }
        
    },
    
   OnStromaPick : function(component, event, helper) {
        var StromaPick =component.find("StromaPick").get("v.value");
        if(StromaPick=='Yes'){
            component.set("v.display8","true");  
        }
        else{
            component.set("v.display8","false");
        }
    }, 
    
    OnEndoDefectsPick : function(component, event, helper) {
        var EndoDefects =component.find("EndoDefects").get("v.value");
        if(EndoDefects=='Yes'){
            component.set("v.EndoDefectYes","true");  
        }
        else{
            component.set("v.EndoDefectYes","false");
        }
    }, 
    
    OnTisDispPick : function(component, event, helper) {
        var TisDisp =component.find("TisDisp").get("v.value");
        if(TisDisp=='Discarded'){
            component.set("v.display5","true");  
        }
        else{
            component.set("v.display5","false");
        }
    }, 
    
    OnCategPick : function(component, event, helper) {
        var Categ =component.find("Categ").get("v.value");
        if(Categ=='Other Reasons'){
            component.set("v.display6","true");  
        }
        else{
            component.set("v.display6","false");
        }
    }, 
    
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
    sloughingChange : function(component, event, helper) {
        var sloughi =component.find("sloughing").get("v.value");
        if(sloughi=='None'){
            component.set("v.slough","false");
        }
        else{
            component.set("v.slough","true");
        }
    }, 
    opacities : function(component, event, helper) {
        var opa =component.find("opacity").get("v.value");
        if(opa=='None'){
            component.set("v.opaciti","false");
        }
        else{
            component.set("v.opaciti","true");
        }
    }, 
    opacities2 : function(component, event, helper) {
        var opa2 =component.find("opacity2").get("v.value");
        if(opa2=='None'){
            component.set("v.opaciti2","false");
        }
        else{
            component.set("v.opaciti2","true");
        }
    }, 
   
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
        var preservationMediaDate = component.get("v.PreservationDateTime");
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
    
    //PDF for Tissue Detail Form
    downloadpdf : function(component, event, helper){
        var recordId = component.get("v.recordId");
        window.open('/apex/TissueDetailFormPrint?tissueId='+recordId, '_blank');        
    },
    //Functionality for Saving Tissue Evaluation
    SaveTissueEval : function(component, event, helper){
         var button = component.find('disablebuttonid');
        var PreCutVal =component.find("PreCutVal").get("v.value");
        
               var date_time_processed = component.get("v.tisEval.Date_Time_Processed__c");

        if(PreCutVal== ''&& PreCutVal== "" && (date_time_processed=="" || date_time_processed==''))
          {
              
                 component.set("v.tisEval.Date_Time_Processed__c" ,"");
   
          }
           if(PreCutVal== 'Yes')
          {
                 component.set("v.tisEval.Date_Time_Processed__c" ,component.get("v.datetime"));
 
          }
        
        if(PreCutVal== 'No')
        {
            if(date_time_processed=="" || date_time_processed==null || date_time_processed=='')
            {
                                component.set("v.tisEval.Date_Time_Processed__c" ,"");
 
            }
           component.set("v.tisEval.Cut_Type__c" ,"");
            component.set("v.tisEval.Cut_Parameters__c" ,"");
           component.set("v.tisEval.Tissue_Processed_for__c" ,"");
            component.set("v.TissRecoveryDate" ,"");
            component.set("v.tisEval.Graft_Thickness_microns__c" ,"");
            component.set("v.tisEval.Graft_Diameter_mm__c" ,"");
            component.set("v.tisEval.Comments_Post_Cut__c" ,"");
            component.set("v.tisEval.Endothelial_Cell_Density_mm2__c" ,"");
            component.set("v.tisEval.Post_Cut_Epithelium__c" ,"");
            component.set("v.tisEval.Anterior_Stroma__c" ,"");
            component.set("v.tisEval.Posterior_Stroma__c" ,"");
            component.set("v.tisEval.Descemet_s__c" ,"");
            component.set("v.tisEval.Post_Cut_Endothelium__c" ,"");
             component.set("v.DonorCon5","");
            component.set("v.DonorCon6","");
             component.set("v.DonorCon7","");
            component.set("v.DonorCon8","");
            component.set("v.tisEval.Post_Cut_Preservation_Medium__c" ,"");
            component.set("v.tisEval.Post_Cut_Media_lot__c" ,"");
            component.set("v.tisEval.Post_Cut_Media_Expiration_Date_Time__c" ,"");
            component.set("v.tisEval.Slit_Lamp_Date_Time__c" ,"");
            component.set("v.tisEval.Specular_Date_Time__c" ,"");
            component.set("v.tisEval.Additional__c" ,""); 
            component.set("v.tisEval.Anterior_Stroma__c","");
            component.set("v.imgurl1"," ");
          
           component.set("v.fileNamepostCut","");
           /* component.set("v.fileNamespecEval","");
            component.set("v.fileNamepostCut",""); */
            

            
                 }  
         //button.set('v.disabled',true);
        if(component.get("v.tisEval").Tissue_Type__c === "Sclera" && component.get("v.tisEval").Is_Child_Record__c === false){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
            	"title": "Error!",
                "type" : "error",
                "message": "Tissue Type should not be Sclera."
            });
            toastEvent.fire();
        }else{
        	var newtisEval = component.get("v.tisEval");
               if(component.get("v.DonorCon") !== null)
                    var donorconId = component.get("v.DonorCon").Id;
                if(component.get("v.DonorCon1") !== null)
                    var donorconId1 = component.get("v.DonorCon1").Id;
                if(component.get("v.DonorCon2") !== null)
                    var donorconId2 = component.get("v.DonorCon2").Id;
                if(component.get("v.DonorCon3") !== null)
                    var donorconId3 = component.get("v.DonorCon3").Id;
                if(component.get("v.DonorCon4") !== null)
                    var donorconId4 = component.get("v.DonorCon4").Id;
                if(component.get("v.DonorCon5") !== null)
                    var donorconId5 = component.get("v.DonorCon5").Id;
                if(component.get("v.DonorCon6") !== null)
                    var donorconId6 = component.get("v.DonorCon6").Id;
                if(component.get("v.DonorCon7") !== null)
                    var donorconId7 = component.get("v.DonorCon7").Id;
                if(component.get("v.DonorCon8") !== null)
                    var donorconId8 = component.get("v.DonorCon8").Id;
                var action  = component.get("c.Savetissue");
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
            component.set("v.spinner",true);
                action.setCallback(this, function(a) {
                    var TissueEvalName="";
                    var state = a.getState();
                    if (state === "SUCCESS") {
                        console.log("state is SUCCESS");
                       button.set('v.disabled',false);
                        var tisEval = a.getReturnValue();
                        var resultsToast = $A.get("e.force:showToast");
                        resultsToast.setParams({
                            "type": "Success",
                            "message": "Record Updated"
                        });
                        resultsToast.fire();
                        var navEvt = $A.get("e.force:navigateToSObject");
                        navEvt.setParams({
                            "recordId": tisEval.Id
                        });
                        navEvt.fire();
                        /*Record ID & SF ID Functionality  (Start)
                       var TissueEvalName1 = component.get("c.getTissueEvalName");
                       TissueEvalName1.setParams({
                           "tisEvalId":tisEval.Id 
                          
                       });
                       TissueEvalName1.setCallback(this, function(a) {
                           var state = a.getState();
                           if(state === "SUCCESS"){
                               var tissue = a.getReturnValue();
                                TissueEvalName = tissue.Name;
                                tisEval.Name=TissueEvalName;
                        component.set("v.tissue",tisEval);
                        var tissueDetail = component.get("v.tissue");
                        var getEvent = component.getEvent("GetTissueDetail")++;
                        getEvent.setParams({
                            "tissue":tissueDetail,
                            "closeModal":"false"
                        });
                        getEvent.fire();
                           }
                       });
                        $A.enqueueAction(TissueEvalName1)
                        Record ID & SF ID Functionality  (End)  */        
                        
                    }else if(state === "INCOMPLETE"){
                        console.log("state is INCOMPLETE");
                    }else if(state === "ERROR"){
                        console.log("state is ERROR");
                    }
                });
                $A.enqueueAction(action); 
        }
    },   
    
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
        
        var slitDate = new Date(component.find("OutcomeSlit").get("v.value"));        
        var finalapprovaldatetime = new Date(component.find("DateTimeofFinalReviewApproval").get("v.value"));
        //alert(slitDate)
        //alert(finalapprovaldatetime)
        
        if(finalapprovaldatetime.getTime() > slitDate.getTime()){
            component.set("v.booleanvalue2", "false");            
        }
        
        else{
            //alert('hello')
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
   
    closeModal: function(component, event, helper){
        helper.closeModal(component, event, helper);
    },
    
    createChildRec: function(component, event, helper){
        if(component.get("v.tissueIdValidate") === false){
        	helper.CreatRec(component, event, helper);    
        }else{
            var toastEvent = $A.get("e.force:showToast");
            	toastEvent.setParams({
                	"title": "Error!",
                    "type" : "error",
                    "message": "Record Already available with this Tissue Id please select diffrent quater to proceed further."
                });
            toastEvent.fire();
        }
        
    },
    
    onChangeQuater: function(component, event, helper){
        var quater = component.find("quater").get("v.value");
        console.log("quater is "+quater);
        component.set("v.tisEval.Quarter__c",quater);
    }
})