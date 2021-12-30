({
    referralList : function(component,event,helper) {
		 var action = component.get("c.getReferralList");
        
        action.setCallback(this, function(a)
                           {
                               component.set("v.ReferralList", a.getReturnValue());
                           });
        $A.enqueueAction(action);
	},
	recoverylist : function(component,event,helper) {
		 var action = component.get("c.getRecoveryList");
        
        action.setCallback(this, function(a)
                           {
                               component.set("v.RecoveryList", a.getReturnValue());
                           });
        $A.enqueueAction(action);
	},
    MedicalEvalList : function(component,event,helper) {
		 var action = component.get("c.getMedicalEvalList");
        
        action.setCallback(this, function(a)
                           {
                               component.set("v.MedicalRevList", a.getReturnValue());
                           });
        $A.enqueueAction(action);
	},
    TissuesList : function(component,event,helper) {
		 var action = component.get("c.getTissuesList");
        
        action.setCallback(this, function(a)
                           {
                               component.set("v.TissueList", a.getReturnValue());
                           });
        $A.enqueueAction(action);
	}
})