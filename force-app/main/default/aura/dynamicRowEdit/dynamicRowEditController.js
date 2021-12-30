({
 
    // function call on component Load
    doInit: function(component, event, helper) {
        // create a Default RowItem [Contact Instance] on first time Component Load
        // by call this helper function  
        helper.createObjectData(component, event);
    },
 
    // function for sending records to the parent component
    Submit: function(component, event, helper) {  
        var bloodData = component.get("v.bloodList");
        var colloidData = component.get("v.colloidList");
        var crystalloidData = component.get("v.crystalloidList");
        var bloodDataEvt = component.getEvent("bloodData");
        bloodDataEvt.setParams({
            "bloodData":bloodData,
            "colloidData":colloidData,
            "crystalloidData":crystalloidData, 
            "closeTable":"true"
        });
        bloodDataEvt.fire();
    },
    //Aura Method to the record count of each table
    RecordCount : function(component,event,helper){
        var params = event.getParam('arguments');
        if(params.bloodCount!=null){
            component.set("v.bloodCount",params.bloodCount);
            component.set("v.colloidCount",params.colloidCount);
            component.set("v.crystalloidCount",params.crystalloidCount); 
            component.set("v.successMessage",params.successMessage); 
        }
        var successMessage = component.find("successMessage");
        $A.util.removeClass(successMessage,"slds-hide");
        $A.util.addClass(successMessage,"slds-show");
    },
 
    // function for create new object Row in Contact List 
    addNewRow: function(component, event, helper) {
        // call the common "createObjectData" helper method for add new Object Row to List 
        var tableName= event.getParam("tableName") ;
        if(tableName=="bloodTable"){
        helper.createBloodObjectData(component, event);
        }
        if(tableName=="colloidTable"){
        helper.createColloidObjectData(component, event);
        }
        if(tableName=="crystalloidTable"){
        helper.createCrystalloidObjectData(component, event);
        }
        
    },
 
    // function for delete the row 
    removeDeletedRow: function(component, event, helper) {
        var tableName = event.getParam("tableName");
        if(tableName=="bloodTable"){
        // get the selected row Index for delete, from Lightning Event Attribute  
        var index = event.getParam("indexVar");
        // get the all List (bloodList attribute) and remove the Object Element Using splice method    
        var AllRowsList = component.get("v.bloodList");
        AllRowsList.splice(index, 1);
        // set the bloodList after remove selected row element  
        component.set("v.bloodList", AllRowsList);
        }
        if(tableName=="colloidTable"){
        // get the selected row Index for delete, from Lightning Event Attribute  
        var index = event.getParam("indexVar");
        // get the all List (bloodList attribute) and remove the Object Element Using splice method    
        var AllRowsList = component.get("v.colloidList");
        AllRowsList.splice(index, 1);
        // set the bloodList after remove selected row element  
        component.set("v.colloidList", AllRowsList);
        }
        if(tableName=="crystalloidTable"){
        // get the selected row Index for delete, from Lightning Event Attribute  
        var index = event.getParam("indexVar");
        // get the all List (bloodList attribute) and remove the Object Element Using splice method    
        var AllRowsList = component.get("v.crystalloidList");
        AllRowsList.splice(index, 1);
        // set the bloodList after remove selected row element  
        component.set("v.crystalloidList", AllRowsList);
        }
        
    },
})