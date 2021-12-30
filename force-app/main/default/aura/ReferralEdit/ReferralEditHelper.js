({
    //Hide and Show Functionality for Sections
    helperadd : function(component,event,secId) {
        var acc = component.find(secId);
        for(var cmp in acc) {
            $A.util.toggleClass(acc[cmp], 'slds-show');  
            $A.util.toggleClass(acc[cmp], 'slds-hide');  
        }
    },
    helperHide : function(component,event,sectionId) {
        var acc = component.find(sectionId);
        for(var cmp in acc) {
            $A.util.toggleClass(acc[cmp], "slds-hide");  
            $A.util.toggleClass(acc[cmp], "slds-hide"); 
            $A.util.toggleClass(acc[cmp], "slds-hide");   
        }
    },  
    //Fetching Picklist Values
    fetchPicklistValuess : function(component,objDetails,controllerField,dependentField){
        // call the server side function  
        var action = component.get("c.getDependentMap");
        // pass paramerters [object definition , contrller field name ,dependent field name]
        // to server side function         
        action.setParams({
            'newRef' : objDetails,
            'contrfieldApiName': controllerField,
            'depfieldApiName': dependentField 
        });
        //set callback   
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                //store the return response from server (map<string,List<string>>)  
                var StoreResponse = response.getReturnValue();
                console.log("StoreResponse"+StoreResponse);
                // once set #StoreResponse to depnedentFieldMap attribute 
                component.set("v.depnedentFieldMap",StoreResponse);
                console.log("dependent field map is "+JSON.stringify(StoreResponse))
        	}
        });
        $A.enqueueAction(action);
    },
    
    //Fetching Dependent Values    
    fetchDepValues: function(component, ListOfDependentFields) {
        // create a empty array var for store dependent picklist values for controller field  
        var dependentFields = [];
        dependentFields.push({
        	label: "--None--",
            value: ""
        });
        for (var i = 0; i < ListOfDependentFields.length; i++) {
            dependentFields.push({
                label: ListOfDependentFields[i], value: ListOfDependentFields[i]
            });
        }
        // set the dependentFields variable values to store(dependent picklist field) on lightning:select
        component.set("v.listDependingValues", dependentFields);      
    }
})