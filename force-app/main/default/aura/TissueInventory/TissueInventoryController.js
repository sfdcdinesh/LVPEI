({
	doInit : function(component, event, helper) {
            
		component.set('v.columns', [
            { label: 'Tissue #', fieldName: 'Id',type: 'url', typeAttributes: {label: {fieldName: 'Name'},target: '_blank'},sortable: true},
            { label: 'Tissue Type', fieldName: 'Tissue_Type__c', type: 'text' },
            { label: 'Donor Age', fieldName:'Age__c', type: 'number',sortable: true },
            { label: 'Cell Count', fieldName: 'Cell_Count_per_mm2__c', type: 'number',sortable: true },
            { label: 'Death Date/Time', fieldName: 'Date_Time_of_Death_TissueEvaluation__c', type: 'date',typeAttributes: {  
                                                                            day: 'numeric',  
                                                                            month: 'short',  
                                                                            year: 'numeric',  
                                                                            hour: '2-digit',  
                                                                            minute: '2-digit',  
                                                                            second: '2-digit',  
                                                                            hour12: true}},
            { label: 'Aging(Days)', fieldName: 'Tissue_Aging__c', type: 'number',sortable: true },
            { label: 'Origin', fieldName: 'Organisation__c', type: 'text',sortable: true },
            { label: 'Approved Outcome', fieldName: 'Approval_Outcome__c', type: 'text' },
            { label: 'Tissue Disposition', fieldName: 'Tissue_Disposition__c', type: 'text',sortable: true },
            { label: 'Approved For', fieldName: 'Approved_Usages__c', type: 'text',sortable: true},
            { label: 'PDF', type: 'button', typeAttributes: { label: 'Print',name: 'print',title: 'Print',disabled: false,value: 'view',variant:'brand'} }
        ]);
        
		var action = component.get("c.tissueInventory");
        action.setCallback(this,function(response){
          if(response.getState()==='SUCCESS'){
            var inventoryList = response.getReturnValue();
             if(inventoryList!=null){
                 component.set("v.InventoryList",inventoryList);
                 var inventory = component.get("v.InventoryList");
                 component.set("v.transplantWG",inventory[0]);
                 component.set("v.transplantWC",inventory[1]);
                 component.set("v.transplantS",inventory[2]);
                 component.set("v.researchWG",inventory[3]);
                 component.set("v.researchWC",inventory[4]);
                 component.set("v.researchS",inventory[5]);
                 component.set("v.trainingWG",inventory[6]);
                 component.set("v.trainingWC",inventory[7]);
                 component.set("v.trainingS",inventory[8]);
                 component.set("v.QuarantineWG",inventory[9]);
                 component.set("v.QuarantineWC",inventory[10]);
                 component.set("v.QuarantineS",inventory[11]);
                }                
            }
        });
        $A.enqueueAction(action)
 
        //Getting Data for the Table
        var getAllTissues = component.get("c.getAlltissues");
        getAllTissues.setCallback(this,function(response){
            var approvedUsages = '';
            if(response.getState()=="SUCCESS"){
                console.log("response is "+JSON.stringify(response.getReturnValue()));
                //component.set("v.OriginalTissuesList",response.getReturnValue());
                if(response.getReturnValue().length==0){
                    component.set("v.errorMessage","No Records To Display");
                }
                else{
                    var result = response.getReturnValue();
                    var records = result;
                    records.forEach(function(record){
                        record.Id = '/'+record.Id;
                    });
                    component.set("v.data",records);
            	}
            }
            });
            $A.enqueueAction(getAllTissues)
    },
    
    printTissueDetail: function(component,event,helper){
      var recId = event.getParam('row').Id;
      var rId = recId.substring(1);
      window.open('/apex/TissueDetailFormPrint?tissueId='+rId, '_blank');     
    },
    
    filterOutcome : function(component,event,helper){
        component.set("v.showFilter","true");
    },
    
    selectedOutcome : function(component,event,helper){
        component.set("v.allTissuesList","");
        component.set("v.emptytissueList","");
        
        var filteredTissuesList ="";
        var Outcome = component.find("approvdOutcome").get("v.value");
        var allTissuesList  = component.get("v.OriginalTissuesList");       
        for(var i=0;i<allTissuesList.length;i++){
            if(Outcome!="None"){
            if(allTissuesList[i].Approval_Outcome__c!='undefined' && allTissuesList[i].Approval_Outcome__c==Outcome){
               filteredTissuesList =  component.get("v.emptytissueList");
               filteredTissuesList.push(allTissuesList[i]);
                component.set("v.allTissuesList",filteredTissuesList);  
            }        
           }
            else{
               // component.set("v.allTissuesList",component.get("v.OriginalTissuesList"));
            }
        }
    },
    
    sortTissueID: function(component, event, helper) {
       // set current selected header field on selectedTabsoft attribute.     
       component.set("v.selectedTabsoft", 'tissueId');
       // call the helper function with pass sortField Name   
       
      var currentDir = component.get("v.arrowDirection");
 
      if (currentDir == 'arrowdown') {
         // set the arrowDirection attribute for conditionally rendred arrow sign  
         component.set("v.arrowDirection", 'arrowup');
         // set the isAsc flag to true for sort in Assending order.  
         component.set("v.isAsc", true);
      } else {
         component.set("v.arrowDirection", 'arrowdown');
         component.set("v.isAsc", false);
      }
      helper.onLoad(component, event, 'Name');
    },
    
    handleSort: function(component, event, helper) {
        helper.handleSort(component, event);
    },
    
    onFilterChange: function(component, event, helper){
        component.set("v.isProcessing",true);
        var action = component.get("c.getFilterTissues");
        console.log("tissue type is "+component.get("v.tissueType"));
        console.log("outcome is "+component.get("v.approvedoutcome"));
        console.log("approvedfor is "+component.get("v.approvedFor"));
        action.setParams({
            "tisstype" : component.get("v.tissueType"),
            "approvedoutcome" : component.get("v.approvedoutcome"),
            "approvedfor" : component.get("v.approvedFor")
        });
        action.setCallback(this,function(res){
            var state = res.getState();
            if(state === "SUCCESS"){
                console.log("In Success"+JSON.stringify(res.getReturnValue()));
                var result = res.getReturnValue();
                var records = result;
                records.forEach(function(record){
                    record.Id = '/'+record.Id;
                });
                component.set("v.data",records);
                component.set("v.isProcessing",false);
            }else if(state === "INCOMPLETE"){
                console.log("In Incomplete");
            }else if(state === "ERROR"){
                console.log("In Error");
            }
        });
        $A.enqueueAction(action)
    }
})