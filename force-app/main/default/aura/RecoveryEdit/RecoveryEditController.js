({  
    //Function Call on Component Loading
    doInit : function(component,event,helper){
        //alert(component.get("v.rec.Condition_of_superior_LId__c"))
        //component.set("v.dislpayNext","false");
        //To get the Current User
        console.log("doinit start");
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
            	var action0 = component.get("c.fetchConsults");
                action0.setParams({
                    RecoveryId : component.get("v.recordId")
                });
                action0.setCallback(this,function(res){
                    if(res.getState()==="SUCCESS"){                    
                        console.log("consultent details "+JSON.stringify(res.getReturnValue()));
                        component.set("v.consultList",res.getReturnValue());  
                        
                    }else if(res.getState()==="ERROR"){
                        console.log("Error in fetch consults "+res.getError());   
                    }
                });
                $A.enqueueAction(action0);
        
                var action1 = component.get("c.getCurrentUser"); 
                action1.setCallback(this, function(a) {
                    component.set("v.currentUser", a.getReturnValue()); 
                });
                $A.enqueueAction(action1);
                
                //To pre-populate the lookups
                var action2 = component.get("c.getLookups");
                action2.setParams({
                    "recID":component.get("v.recordId")  
                });      
                action2.setCallback(this,function(response){
                    if(response.getState()==="SUCCESS"){
                        component.set("v.lookupList",response.getReturnValue());
                        var lookupList = component.get("v.lookupList");
                        if(lookupList['con1']!=null){
                            component.set("v.donorcon",lookupList['con1']); 
                        }
                        else{
                            component.set("v.donorcon",{});   
                        }
                        if(lookupList['con2']!=null){
                            component.set("v.donorcon1",lookupList['con2']); 
                        }
                        else{
                            component.set("v.donorcon1",{});   
                        }
                        if(lookupList['con3']!=null){
                            component.set("v.donorcon2",lookupList['con3']);
                        }
                        else{
                            component.set("v.donorcon2",{});   
                        }
                        if(lookupList['con4']!=null){
                            component.set("v.donorcon4",lookupList['con4']);
                        }
                        else{
                            component.set("v.donorcon4",{});   
                        }
                        if(lookupList['con5']!=null){
                            component.set("v.donorcon5",lookupList['con5']);
                        }
                        else{
                            component.set("v.donorcon5",{});   
                        }
                        if(lookupList['con6']!=null){
                            component.set("v.donorcon6",lookupList['con6']);
                        }
                        else{
                            component.set("v.donorcon6",{});   
                        }
                        if(lookupList['con7']!=null){
                            component.set("v.donorcon9",lookupList['con7']);
                        }
                        else{
                            component.set("v.donorcon9",{});   
                        }
                        if(lookupList['con8']!=null){
                            component.set("v.donorcon10",lookupList['con8']);
                        }
                        else{
                            component.set("v.donorcon10",{});   
                        }
                    }
                });
                $A.enqueueAction(action2)
                
                //To prepoluate Referral Info and Headers
                if(component.get("v.recordId")!=null && component.get("v.recordId")!=""){
                    var recId="";
                    var action = component.get("c.getRefId");
                    action.setParams({
                        "RecId":component.get("v.recordId")
                    });
                    action.setCallback(this,function(response){
                        if(response.getState()==='SUCCESS'){
                            var med = response.getReturnValue();
                            //alert(med.Condition_of_superior_LId__c);
                           // alert(med.OS_Condition_of_superior_LId__c);
                            //component.set("v.rec.Condition_of_superior_LId__c", med.Condition_of_superior_LId__c);
                            helper.prepareSelection(component, 'options1selected', med.Condition_of_superior_LId__c);
                            helper.prepareSelection(component, 'options2selected', med.OS_Condition_of_superior_LId__c);
                            helper.prepareSelection(component, 'options3selected', med.Condition_of_inferior_Lid__c);
                            helper.prepareSelection(component, 'options4selected', med.OS_Condition_of_inferior_Lid__c);
                            helper.prepareSelection(component, 'options5selected', med.Condition_of_conjuctiva__c);
                            helper.prepareSelection(component, 'options6selected', med.OS_Condition_of_conjunctiva__c);
                            helper.prepareSelection(component, 'options7selected', med.Codition_of_epithelium__c);
                            helper.prepareSelection(component, 'options8selected', med.OS_Condition_of_Epithelium__c);
                            helper.prepareSelection(component, 'options9selected', med.Condition_of_corneal_stroma__c);
                            helper.prepareSelection(component, 'options10selected', med.OS_Condition_of_corneal_stroma__c);
                            helper.prepareSelection(component, 'options11selected', med.Condition_of_intraocular__c);
                            helper.prepareSelection(component, 'options12selected', med.OS_Condition_of_Intraocular__c);
                            helper.prepareSelection(component, 'options13selected', med.Iris_color__c);
                            helper.prepareSelection(component, 'options14selected', med.OS_Iris_color__c);
                            recId = med.Referral__c;
                            helper.autoPopulate(component,event,recId);   
                        }
                    });
                    $A.enqueueAction(action);  
                }
                else{
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
                    if(recid!=null || recid!='undefined' || recid!=""){ 
                        helper.autoPopulate(component,event,recId);     
                    }              
                }
                
                helper.fetchPickListVal(component, 'Condition_of_superior_LId__c', 'options1');
                helper.fetchPickListVal(component, 'OS_Condition_of_superior_LId__c', 'options2');
                helper.fetchPickListVal(component, 'Condition_of_inferior_Lid__c', 'options3');
                helper.fetchPickListVal(component, 'OS_Condition_of_inferior_Lid__c', 'options4');
                helper.fetchPickListVal(component, 'Condition_of_conjuctiva__c', 'options5');
                helper.fetchPickListVal(component, 'OS_Condition_of_conjunctiva__c', 'options6');
                helper.fetchPickListVal(component, 'Codition_of_epithelium__c', 'options7');
                helper.fetchPickListVal(component, 'OS_Condition_of_Epithelium__c', 'options8');
                helper.fetchPickListVal(component, 'Condition_of_corneal_stroma__c', 'options9');
                helper.fetchPickListVal(component, 'OS_Condition_of_corneal_stroma__c', 'options10');
                helper.fetchPickListVal(component, 'Condition_of_intraocular__c', 'options11');
                helper.fetchPickListVal(component, 'OS_Condition_of_Intraocular__c', 'options12');
                helper.fetchPickListVal(component, 'Iris_color__c', 'options13');
                helper.fetchPickListVal(component, 'OS_Iris_color__c', 'options14');   
                console.log("doinit done"); 
            }
        });
        $A.enqueueAction(checkUserBranch);
    },
    
    //Code for Collapse and Expand Sections
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
    //Logic for Saving Recovery Record
    saveRecovery : function(component, event, helper){
        console.log("I am in saveRecovery method");
        //var button = component.find('disablebuttonid');
        //button.set('v.disabled',true);
        if(component.get("v.booleanvalue")){
           // button.set('v.disabled',false);
            var resultsToast = $A.get("e.force:showToast");z
            
            resultsToast.setParams({
                "type": "error",
                "message": "Enter proper date values"
            });
            resultsToast.fire();
        }
        else{
            console.log("I am in saveRecovery method else block");
            var newrec = component.get("v.rec");
            /* newrec.Physical_Inspection_By__c=component.get("v.donorcon").Id;
        newrec.Recovery_completed_by__c=component.get("v.donorcon1").Id;
        newrec.Assisted_by__c=component.get("v.donorcon2").Id;
        newrec.Recovery_completed_by__c=component.get("v.donorcon3").Id;
        newrec.Sclera_Preserved_By__c=component.get("v.donorcon4").Id;
        newrec.Technician_performing_physicalAssessmen__c=component.get("v.donorcon5").Id;
        newrec.Collected_By__c=component.get("v.donorcon6").Id; */
            var consults = component.get("v.consultList");
            console.log("consult list is "+consults);
            if(component.get("v.donorcon") !== null)
            	var donorconId = component.get("v.donorcon").Id;
            if(component.get("v.donorcon1") !== null)
            	var donorconId1 = component.get("v.donorcon1").Id;
            if(component.get("v.donorcon2") !== null)
            	var donorconId2 = component.get("v.donorcon2").Id;
            if(component.get("v.donorcon3") !== null)
            	var donorconId3 = component.get("v.donorcon3").Id;
            if(component.get("v.donorcon4") !== null)
            	var donorconId4 = component.get("v.donorcon4").Id;
            if(component.get("v.donorcon5") !== null)
            	var donorconId5 = component.get("v.donorcon5").Id;
            if(component.get("v.donorcon6") !== null)
            	var donorconId6 = component.get("v.donorcon6").Id;
            if(component.get("v.donorcon9") !== null)
            	var donorconId9 = component.get("v.donorcon9").Id;
            if(component.get("v.donorcon10") !== null)
            	var donorconId10 = component.get("v.donorcon10").Id;
            
            console.log("I am in saveRecovery method else block before action");
            //alert(newrec.Recovery_Intent__c);
            var action  = component.get("c.save");
            console.log("after action");
            action.setParams({ 
                "recovery": newrec, "conList": consults,"firstlookup":donorconId,"secondlookup":donorconId1,
                "thirdlookup":donorconId2,"fourthlookup":donorconId1,"fifthlookup":donorconId4,
                "sixthlookup":donorconId5,"seventhlookup":donorconId6,"ninelookup":donorconId9,"tenlookup":donorconId10,
                "recoveryID":component.get("v.recordId")
            });
            console.log("after action parameters");
            action.setCallback(this, function(a) {
                var state = a.getState();
                if (state === "SUCCESS") {
                    var recovery = a.getReturnValue();
                    console.log("I am in saveRecovery method else block after action result is "+JSON.stringify(recovery));
                    component.set("v.rec.Donor_Id__c",recovery.Name);
                    console.log("before toast ");
                    //Event to show toast message "Record Saved"
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "type": "Success",
                        "message": "Record Updated"
                    });
                    resultsToast.fire();  
                    console.log("after toast ");
                    //Apex Call to get the Record Name.
                    /*var recoveryName = component.get("c.getRecoveryName");
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
                    $A.enqueueAction(recoveryName)*/
                    
                    
                    //Firing Event to pass saved record to Final component.
                    var getEvent = component.getEvent("GetRecoveryID");
                    getEvent.setParams({
                        "recovery":recovery
                    });
                    getEvent.fire();
                    console.log("before navigate to home page ");
                    //Event to navigate to Object Home.
                    //var dislpayNext = component.get("v.dislpayNext");
                    //if(dislpayNext=="false"){          
                    var homeEvt = $A.get("e.force:navigateToObjectHome");
                    homeEvt.setParams({
                    	"scope": "Recovery__c"
                    });
                    homeEvt.fire();
                    //}  
                }else if(state === "INCOMPLETE"){
                	console.log("no response from error ");    
                }else if (state === "ERROR") {
                   // button.set('v.disabled',false);
                    var errors = response.getError();
                    if (!errors) {
                        errors = [{"message" : "Unknown Error Occured"}];
                    }
                    console.log(errors);
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "type": "error",
                        "message": errors
                    });
                    resultsToast.fire();
                }
            });
            $A.enqueueAction(action)
        }
    },
    //Recovery Outcome Hide and Show
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
    /* tlc : function(component, event, helper) {
        var SpecEval1 =component.find("tlc").get("v.value");`
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
    },*/
    //Surgery Evidence1 Hide Show
    onEvidence1Change : function(component, event, helper) {
        var Surgery1 =component.find("Surgery1").get("v.value");        
        if(Surgery1=='No'){
            
            component.set("v.evidence1",true);
        }
        else{
            component.set("v.evidence1",false);
        }
        
    },
    //Surgery Evidence2 Hide Show
    onEvidence2Change : function(component, event, helper) {
        var Surgery2 =component.find("Surgery2").get("v.value");        
        if(Surgery2=='No'){
            
            component.set("v.evidence2",true);
        }
        else{
            component.set("v.evidence2",false);
        }
        
    },
    //Open Modal 
    openModel: function(component, event, helper) {
        
        component.set("v.isOpen", true);
    },
    //Close Modal
    closeModel: function(component, event, helper) {
        
        component.set("v.isOpen", false);
    },
    // View Consult
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
    //Save Modal
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
    // Death Notification Date Time Validation
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
    // Cooling Start and End Date Time Validation
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
    //Update Record
    recordUpdated : function(component, event, helper) {
        helper.recordUpdated(component, event, helper);
    },
    
    handleChange: function (component, event) {
        var selectedOptionsList = event.getParam("value");     
        var targetName = event.getSource().get("v.name");
        var selectedOptionsString = selectedOptionsList.toString();  
        
        if(selectedOptionsString != null && selectedOptionsString != ""){
	    	var selectedValues = selectedOptionsString.split(",");
	    	var selection = "";
	    	var opts = [];
	    	for(var i = 0; i < selectedValues.length; i++){
	    		opts.push(selectedValues[i]);
	    		if(i != selectedValues.length-1){
	    			selection+=selectedValues[i] + ";";
	    		}
	    		else{
	    			selection+=selectedValues[i];
	    		}
	    	}          
       
	        if(targetName == 'Condition_of_superior_LId__c'){ 
	            component.set("v.options1selected", opts);
	            component.set("v.rec.Condition_of_superior_LId__c", selection);
	        }
	        else if(targetName == 'OS_Condition_of_superior_LId__c'){
	        	component.set("v.options2selected", opts);
	        	component.set("v.rec.OS_Condition_of_superior_LId__c", selection);
	        }
	        else if(targetName == 'Condition_of_inferior_Lid__c'){
	        	component.set("v.options3selected", opts);
	        	component.set("v.rec.Condition_of_inferior_Lid__c", selection);
	        }
	        else if(targetName == 'OS_Condition_of_inferior_Lid__c'){
	        	component.set("v.options4selected", opts);
	        	component.set("v.rec.OS_Condition_of_inferior_Lid__c", selection);
	        }
	        else if(targetName == 'Condition_of_conjuctiva__c'){      	
	        	component.set("v.options5selected", opts);
	        	component.set("v.rec.Condition_of_conjuctiva__c", selection);
	        }
	        else if(targetName == 'OS_Condition_of_conjunctiva__c'){
	        	component.set("v.options6selected", opts);
	        	component.set("v.rec.OS_Condition_of_conjunctiva__c", selection);
	        }
	        else if(targetName == 'Codition_of_epithelium__c'){
	        	component.set("v.options7selected", opts);
	        	component.set("v.rec.Codition_of_epithelium__c", selection);
	        }
	        else if(targetName == 'OS_Condition_of_Epithelium__c'){
	        	component.set("v.options8selected", opts);
	        	component.set("v.rec.OS_Condition_of_Epithelium__c", selection);
	        }
	        else if(targetName == 'Condition_of_corneal_stroma__c'){
	        	component.set("v.options9selected", opts);
	        	component.set("v.rec.Condition_of_corneal_stroma__c", selection);
	        }
	        else if(targetName == 'OS_Condition_of_corneal_stroma__c'){
	        	component.set("v.options10selected", opts);
	        	component.set("v.rec.OS_Condition_of_corneal_stroma__c", selection);
	        }
	        else if(targetName == 'Condition_of_intraocular__c'){
	        	component.set("v.options11selected", opts);
	        	component.set("v.rec.Condition_of_intraocular__c", selection);
	        }
	        else if(targetName == 'OS_Condition_of_Intraocular__c'){
	        	component.set("v.options12selected", opts);
	        	component.set("v.rec.OS_Condition_of_Intraocular__c", selection);
	        }
	        else if(targetName == 'Iris_color__c'){
	        	component.set("v.options13selected", opts);
	        	component.set("v.rec.Iris_color__c", selection);
	        }
	        else if(targetName == 'OS_Iris_color__c'){
	        	component.set("v.options14selected", opts);
	        	component.set("v.rec.OS_Iris_color__c", selection);
	        }
        }
    },
    
    //When Lookup Fiels is Selected Focus Tab Index to Next Field
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
        /*else if(selectedLookupLabel == "Cloudhub1"){
            //alert("hiwelcome")
            var f7 = component.find("per");
            f7.focus();
        }*/
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
        //var dDate = new Date(component.get("v.deathNotificationTime"));
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
       // var dDate = new Date(component.get("v.deathNotificationTime"));
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
       // var dDate = new Date(component.get("v.deathNotificationTime"));
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
       // var dDate = new Date(component.get("v.deathNotificationTime"));
        if(tDate.getTime() < deathTime.getTime()){
            component.set("v.booleanvalue6", "false");            
        }
        else{
            component.set("v.booleanvalue6", "true");
           
        }
    },
    onChangeCult : function(component, event, helper) {
        //var tissrecDate = component.find("Trec").get("v.value"); 
          
        var deathTime = new Date(component.find("dt1").get("v.value"));        
        var tDate = new Date(component.find("cult1").get("v.value"));
       // var dDate = new Date(component.get("v.deathNotificationTime"));
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
       //var dDate = new Date(component.get("v.deathNotificationTime"));
        if(tDate.getTime() < deathTime.getTime()){
            component.set("v.booleanvalue8", "false");            
        }
        else{
            component.set("v.booleanvalue8", "true");           
        }
    },
})