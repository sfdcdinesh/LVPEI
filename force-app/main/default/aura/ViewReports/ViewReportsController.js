({
	doInit : function(component, event, helper) {
		var action = component.get("c.getReferral");
        action.setParams({
            "refID" : 'a0y6F00000Bi6YXQAZ'
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") { 
                component.set("v.ref",a.getReturnValue());
            }
        });
        $A.enqueueAction(action)
	}
})