({
    createObjectData: function(component, event) {
        // get the bloodList from component and add(push) New Object to List  
        var BloodItemList = component.get("v.bloodList");
        console.log("BloodItemList size is "+BloodItemList.length);
        if(BloodItemList.length === 0){
        	BloodItemList.push({
            	'sobjectType': 'Blood_Product__c',
            	'Blood_Product__c': '',
            	'Date_Time__c': '',
            	'Volume__c': ''
        	});
        	// set the updated list to attribute (bloodList) again    
        	component.set("v.bloodList", BloodItemList);    
        }
        
        
         // get the colloidList from component and add(push) New Object to List  
        var ColloidItemList = component.get("v.colloidList");
        console.log("ColloidItemList size is "+ColloidItemList.length);
        if(ColloidItemList.length === 0){
        	ColloidItemList.push({
                'sobjectType': 'Colloid__c',
                'Blood_Product__c': '',
                'Date_Time__c': '',
                'Volume__c': ''
            });
            // set the updated list to attribute (colloidList) again    
            component.set("v.colloidList", ColloidItemList);    
        }
        
        
        // get the crystalloidList from component and add(push) New Object to List  
        var CrystalloidItemList = component.get("v.crystalloidList");
        console.log("CrystalloidItemList size is "+CrystalloidItemList.length);
        if(CrystalloidItemList.length === 0){
        	CrystalloidItemList.push({
                'sobjectType': 'Crystalloid__c',
                'Blood_Product__c': '',
                'Date_Time__c': '',
                'Volume__c': ''
            });
            // set the updated list to attribute (crystalloidList) again    
            component.set("v.crystalloidList", CrystalloidItemList);            
        }
    },
    createBloodObjectData: function(component, event) {
        // get the bloodList from component and add(push) New Object to List  
        var BloodItemList = component.get("v.bloodList");
        BloodItemList.push({
            'sobjectType': 'Blood_Product__c',
            'Blood_Product__c': '',
            'Date_Time__c': '',
            'Volume__c': ''
        });
        // set the updated list to attribute (bloodList) again    
        component.set("v.bloodList", BloodItemList);
    },
    
    createColloidObjectData : function(component,event){
         var ColloidItemList = component.get("v.colloidList");
        ColloidItemList.push({
            'sobjectType': 'Colloid__c',
            'Blood_Product__c': '',
            'Date_Time__c': '',
            'Volume__c': ''
        });
        // set the updated list to attribute (colloidList) again    
        component.set("v.colloidList", ColloidItemList);
    },
    createCrystalloidObjectData: function(component,event){
        var CrystalloidItemList = component.get("v.crystalloidList");
        CrystalloidItemList.push({
            'sobjectType': 'Crystalloid__c',
            'Blood_Product__c': '',
            'Date_Time__c': '',
            'Volume__c': ''
        });
        // set the updated list to attribute (crystalloidList) again    
        component.set("v.crystalloidList", CrystalloidItemList);        
    }
})