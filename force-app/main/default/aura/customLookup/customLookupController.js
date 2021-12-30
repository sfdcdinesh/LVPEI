({  
 	onselectedRecordChange : function (component, event, helper) {
     var oldValue = event.getParam("oldValue");
     var newValue = event.getParam("value");
     console.log("old : " + JSON.stringify(oldValue));
     console.log("new : " + JSON.stringify(newValue));
     console.log(JSON.stringify(event.getSource().get("v.label")));
            
     if(oldValue != null && newValue != null){
     	console.log("came inside if");
     	if(oldValue.Id !== newValue.Id){
             console.log("came inside second if");
             component.set("v.selectedRecord" , event.getParam("value"));
             
             var lookupPill = component.find("lookup-pill");
             $A.util.addClass(lookupPill, "slds-show");
             $A.util.removeClass(lookupPill, "slds-hide");
             
             var forclose = component.find("searchRes");
             $A.util.addClass(forclose, "slds-is-close");
             $A.util.removeClass(forclose, "slds-is-open");
             
             var lookUpTarget = component.find("lookupField");
             $A.util.addClass(lookUpTarget, "slds-hide");
             $A.util.removeClass(lookUpTarget, "slds-show");
         }
     }
},
   onfocus : function(component,event,helper){
       $A.util.addClass(component.find("mySpinner"), "slds-show");
        var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC  
         var getInputkeyWord ='';
         helper.searchHelper(component,event,getInputkeyWord);
    },
    onblur : function(component,event,helper){       
        component.set("v.listOfSearchRecords", null );
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    keyPressController : function(component, event, helper) {
       // get the search Input keyword   
         var getInputkeyWord = component.get("v.SearchKeyWord");
        //debugger;
       // check if getInputKeyWord size id more then 0 then open the lookup result List and 
       // call the helper 
       // else close the lookup result List part.   
        if( getInputkeyWord.length > 0 ){
             var forOpen = component.find("searchRes");
               $A.util.addClass(forOpen, 'slds-is-open');
               $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else{  
             component.set("v.listOfSearchRecords", null ); 
             var forclose = component.find("searchRes");
               $A.util.addClass(forclose, 'slds-is-close');
               $A.util.removeClass(forclose, 'slds-is-open');
          }
	},
    
  // function for clear the Record Selaction 
    clear :function(component,event,heplper){
        var pillTarget = component.find("lookup-pill");
        var lookUpTarget = component.find("lookupField"); 
                
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        
        component.set("v.SearchKeyWord",null);
        component.set("v.listOfSearchRecords", null );
        component.set("v.selectedRecord", null );        
    },
    
  // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
        console.log("i am event handler method...");
       // debugger;
    // get the selected Account record from the COMPONENT event 	 
       var selectedAccountGetFromEvent = event.getParam("recordByEvent");
	   component.set("v.selectedRecord" , selectedAccountGetFromEvent); 
       component.set("v.recordId", event.getParam("recordId"));
       component.set("v.recordName", event.getParam("recordName"));
        var forclose = component.find("lookup-pill");
           $A.util.addClass(forclose, 'slds-show');
           $A.util.removeClass(forclose, 'slds-hide');
  
        var forclose = component.find("searchRes");
           $A.util.addClass(forclose, 'slds-is-close');
           $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupField");
            $A.util.addClass(lookUpTarget, 'slds-hide');
            $A.util.removeClass(lookUpTarget, 'slds-show');  
      console.log("i am event handler method finished...");
	},
    
    createContact: function(component,event,helper){
        component.set("v.callSObject",true); 
    },
    
    handleEMR: function(component,event,helper){
        var createAcountContactEvent = $A.get("e.force:createRecord");
        createAcountContactEvent.setParams({
            "entityApiName": "EMR__c"
       });
        createAcountContactEvent.fire();
    },
    createHospital : function(component,event,helper){
        //component.set("v.callSObject",true); 
        component.set("v.account",true); 
    },
    closeIt : function(component,event,helper){
        var closed = event.getParam("closeit");
        component.set("v.callSObject",closed); 
    },
    closeModel :function(component,event,helper){
       component.set("v.callSObject","false"); 
    },
    closeModelacc :function(component,event,helper){
       component.set("v.account","false"); 
    }
})