({
	doInit : function(component, event, helper) {
        alert(component.get("v.donor"))
		/*var action = component.get("c.getReferral");
        action.setParams({
            "refID" : 'a0y6F00000Bi7OTQAZ'
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") { 
                component.set("v.donor",a.getReturnValue());
                component.set("v.referral",a.getReturnValue());
            }
        });
        $A.enqueueAction(action)*/
	}
})