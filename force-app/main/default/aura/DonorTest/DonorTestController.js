({
	refreshcomponent: function(component,event,helper) {
        component.set("v.body","");
        component.set("v.LoadComponent",true);
        $A.createComponent("c:Referral",
        {
            "RecordId" :component.get("v.RecordId")
        },           
        function(newCmp){
            var body = component.get("v.body");
            body.push(newCmp); 
            component.set("v.body", body);
        }
        );
    }
})