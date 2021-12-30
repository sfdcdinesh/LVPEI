({
	searchHelper : function(component,event,getInputkeyWord) {
	  // call the apex class method 
     var action = component.get("c.fetchLookUpValues");
        var crole=component.get("v.contactRole");
  //debugger;
      // set param to method  
      //alert('Gm'+component.get("v.TissueType"));
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'ObjectName' : component.get("v.objectAPIName"),
            'contactRole' : component.get("v.contactRole"),
            'tissueType' : component.get("v.TissueType")
          });
      // set a callBack    
        action.setCallback(this, function(response) {
          $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
              // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                    component.set("v.displayContact","false");
                } else {
                    component.set("v.Message", '');
                    component.set("v.displayContact","true");
                }
                // set searchResult list with return value from server.
                component.set("v.listOfSearchRecords", storeResponse);
                //alert('listOfSearchRecords:::'+component.get("v.listOfSearchRecords"))
            }
 
        });
      // enqueue the Action  
        $A.enqueueAction(action);
    
	},
})