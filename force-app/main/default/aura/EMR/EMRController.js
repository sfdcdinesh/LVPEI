({
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
         OnSpecPick : function(component, event, helper) {
		var SpecEval =component.find("pcn").get("v.value");
        if(SpecEval=='DSAEK'){
            component.set("v.display","true");
        }
        else{
            component.set("v.display","false");
        }
    },
    OnPick : function(component, event, helper) {
		var Spec =component.find("surgy").get("v.value");
        if(Spec=='EK'){
            component.set("v.disp","true");
        }
        else{
            component.set("v.disp","false");
        }
    },
    OnTissueType : function(component, event, helper) {
		var Spec =component.find("tistp").get("v.value");
        if(Spec=='Sclera'){
            component.set("v.display1","true");
        }
        else{
            component.set("v.display1","false");
        }
    },

    
    SaveERMval : function(component, event, helper){
        var newERM = component.get("v.emr");
        alert(newERM.Surgery__c);
        var donarconId = component.get("v.donarcon").Id;
        var donarcon1Id = component.get("v.donarcon1").Id;
        var donarcon2Id = component.get("v.donarcon2").Id;
        var donarcon3Id = component.get("v.donarcon3").Id;
        var action  = component.get("c.save");
        action.setParams({ 
            "EMRval": newERM,"firstlookup":donarconId ,"secondlookup":donarcon1Id,
            "thirdlookup":donarcon2Id,"fourthlookup":donarcon3Id
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                var name = a.getReturnValue();
                alert("success");
            }
        });
        $A.enqueueAction(action)
    }
    
})