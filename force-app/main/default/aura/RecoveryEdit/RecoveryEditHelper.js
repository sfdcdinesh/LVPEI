({
    //Sections Hide and Show
	helperadd : function(component,event,secId) {
	  var acc = component.find(secId);
        	for(var cmp in acc) {
        	$A.util.toggleClass(acc[cmp], 'slds-show');  
        	$A.util.toggleClass(acc[cmp], 'slds-hide');  
       }
	},
    //Auto Populate Field Values in Edit 
   autoPopulate : function(component,event,ParentId) {
       //alert("Hello")
        var action = component.get("c.getReferralId");
            action.setParams({
                "donorId":ParentId
            });
                action.setCallback(this,function(response){
                component.set("v.Ref",response.getReturnValue());
                var state=response.getState();
                if(state==='SUCCESS'){
                   //alert(component.get("v.Ref").Name)
                    component.set("v.ReferralID",component.get("v.Ref").Name);
                    var firstName = component.get("v.Ref").First_Name__c;
                    var lastName = component.get("v.Ref").Last_Name__c;
                    if(firstName=="undefined"|| firstName==" " || firstName==null ){
                        firstName = " ";
                    }
                    if(lastName=="undefined"|| lastName==" " || lastName==null ){
                        lastName = " ";
                    }
                    var DonorName= firstName + ' ' + lastName;
                    //component.set("v.rec.Name_of_Donor_Recovery__c",DonorName);
                    component.set("v.donorGender",component.get("v.Ref").Gender__c);
                    component.set("v.donorAge",component.get("v.Ref").Age_of_Donor__c);
                    component.set("v.deathTime",component.get("v.Ref").Date_Time_of_Death__c);
                    component.set("v.deathNotificationTime",component.get("v.Ref").Death_Notification_Consignment_Date_Time__c);
        
            }
            });
               $A.enqueueAction(action)
   },
   
   //Getting Picklist Values
   fetchPickListVal: function(component, fieldName, attributeName){
        var action = component.get("c.getSelectOptions");
        action.setParams({
            "obj": component.get("v.rec"),
            "fld": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response){
            if (response.getState() == "SUCCESS"){
                var allValues = response.getReturnValue();
                for (var i = 0; i < allValues.length; i++){
                    if(allValues[i] === "Unremarkable"){
                        opts.unshift({
                        	label: allValues[i],
                        	value: allValues[i]
                    	});
                    }else if(allValues[i] === "Phakic"){
                    	opts.unshift({
                        	label: allValues[i],
                        	value: allValues[i]
                    	});    
                    }else{
                    	opts.push({
                        	label: allValues[i],
                        	value: allValues[i]
                    	});    
                    }
                    
                }
                component.set("v."+attributeName, opts);
            }
            else{
            	console.log("There was an error getting successful response - " + attributeName);
            }
        });
        $A.enqueueAction(action);
    },
    
    prepareSelection : function(component, attributeName, obj) {
    	if(obj != null && obj != ""){
	    	var selectedValues = obj.split(";");
	    	var opts = [];
	    	for(var i = 0; i < selectedValues.length; i++){
                opts.push(selectedValues[i]);
	    	}
	    	component.set("v."+attributeName, opts);
	    }
    }  
})