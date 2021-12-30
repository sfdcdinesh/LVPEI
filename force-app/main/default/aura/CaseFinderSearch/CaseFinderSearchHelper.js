({   
    searchRecords : function(component, searchString,show) {
        var action = component.get("c.getRefOrgs");
        action.setParams({
            "searchString" : searchString
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                const serverResult = response.getReturnValue();
                const results = [];
                serverResult.forEach(element => {
                    const result = {};
                                     result.id=element.Id;
                                     result.value=element.Name;
                                     
                                     results.push(result);
            });
            component.set("v.results", results);
            if(serverResult.length>0){
                if(show)
                {
                    component.set("v.openDropDown", true);
                    
                }
            }
            else{
                if(!show)
                {
                    component.set("v.openDropDown", false);
                    
                }
                
            }
            
        } else{
                           var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams({
                "title": "ERROR",
                "type": "error",
                "message": "Something went wrong!! Check server logs!!"
            });
            toastEvent.fire();
        }
    }
});
$A.enqueueAction(action);
}})