({
    doInit : function(component, event, helper) {
        var con = component.get("v.Con");
        component.set("v.Con.HCRP_Counselor__c",false);
        component.set("v.Con.Volunteer__c",false);
        component.set("v.Con.Hospital_Staff__c",false);
        component.set("v.Con.HCRP_Manager__c",false);
        component.set("v.Con.Recovery_Technician__c",false);
        component.set("v.Con.Eye_Bank_Staff__c",false);
        component.set("v.Con.Eye_Bank_Manager__c",false);
        component.set("v.Con.QA_Manager__c",false);
        component.set("v.Con.Serology_Technician__c",false);
        component.set("v.Con.Specular_Technician__c",false);
        component.set("v.Con.Slit_Lamp_Technician__c",false);
        component.set("v.Con.EK_Technician__c",false);
        component.set("v.Con.EK_Circulator__c",false);
        component.set("v.Con.Transplant_Surgeon__c",false);
        component.set("v.Con.Distribution_Assistant__c",false);
        component.set("v.Con.Organisation_Hospital__c",false);
        component.set("v.Con.Transplant_Hospital__c",false);
        component.set("v.Con.HCRP_Hospital__c",false);
        component.set("v.Con.Microbiologist__c",false);
        
        var action = component.get("c.getApiNames");
        action.setCallback(this,function(response){
            if(response.getState()==='SUCCESS'){
                component.set("v.ApiList",response.getReturnValue());
            }
        });
        $A.enqueueAction(action)
    },
    handleSuccess : function(component, event, helper) {
        var payload = event.getParams().response;
        var getevt = component.getEvent("test");
        getevt.setParams({
            "closeit":"false"
        });
        getevt.fire();
    },
    chkRole : function(component, event, helper) {
        var a = event.getSource();
        var auraid = a.getLocalId();
        var cmpLabel = component.find(auraid).get("v.label");
        var isChecked =component.find(auraid).get("v.checked");
        var ApiList = component.get("v.ApiList");
        var APiName = ApiList[cmpLabel];
        component.set("v.Con."+APiName,isChecked);
    },
    CancelCreate:  function(component, event, helper) {
        var getevt = component.getEvent("test");
        getevt.setParams({
            "closeit":"false"
        });
        getevt.fire();
    },
    
     validateFields : function(component,event,helper){
        var zipcodeVal = component.find("zipcode").get("v.value");
        if(zipcodeVal != null){
            if(isNaN(zipcodeVal)){
                component.set("v.eMsg","Please enter a valid format.");
                component.find("savebtn").set("v.disabled",true);
            }else if(zipcodeVal.length > 10){
                component.set("v.eMsg","Zipcode is too long.");
                component.find("savebtn").set("v.disabled",true);
            }else{
                component.set("v.eMsg","");
                component.find("savebtn").set("v.disabled",false);
            } 
        }
    },
    
    checkContact : function(component,event,helper){
      /*var Fname = component.find("Fname").get("v.value");
      var Lname = component.find("Lname").get("v.value");
      var Email = component.find("Email").get("v.value");
      var conrole = component.get("v.contactRole");
      var Name = "";
        if((Lname!=null || Lname!='undefined' || Lname!="") && (Fname==null || Fname=='undefined' || Fname=="")){
            Name = Lname;
        }
        else{
          Name = Fname + " " + Lname      
        }
      var action = component.get("c.ContactDuplicate");
      action.setParams({
            "Name1":Name,
            "Email":Email,
          	"role":conrole
        });
        action.setCallback(this,function(response){
            if(response.getState()==='SUCCESS' && response.getReturnValue()==1){
                var resultsToast = $A.get("e.force:showToast");
                 resultsToast.setParams({
                "type": "Warning",
                "message": 'Contact Already Exists With The Name'+ ' ' +Name
            });
            resultsToast.fire(); 
            component.set("v.isContinue",true);
            }
            else{
                component.set("v.isContinue",false);
            }
              
        });
        $A.enqueueAction(action)*/ 
	},
    continueToSaveContact : function(component,event,helper){
        
        helper.saveContact(component,event,helper);
    }
    
})