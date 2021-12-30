({
    doinit : function(component, event, helper) {
        
        
        var colms=[{label : "Referral Id",fieldName: 'Name', type: 'text'},
                   {label : "Donor Id",fieldName : 'Donor_ID__c',type: 'text'},
                   {label : "Family Name",fieldName : 'Last_Name__c',type: 'text'},
                   {label : "Given Name",fieldName : 'First_Name__c',type: 'text'},
                   {label : "Age",fieldName : 'Age_of_Donor__c',type: 'text'},
                   {label : "Referring Org",fieldName : 'Unit_Organization_Hospital_Name__rName',type: 'text'},
                   {label : "Referral Date",fieldName : 'Death_Notification_Consignment_Date_Time__c',type: 'date'},
                   { label : 'View',type: 'button', typeAttributes: { label: 'View',
                                                      name: 'view',
                                                      title: 'View',
                                                      disabled: false,
                                                      value: 'view',
                                                      variant : 'brand',
                                                      iconName : 'utility:preview',
                                                      iconPosition: 'left' } },
                   
                   { label : 'Edit',type: 'button', typeAttributes: {     
                       label: 'Edit',
                       name: 'edit',
                       title: 'Edit',
                       disabled: false,
                       value: 'edit',
                       variant : 'brand',
                       iconName: 'utility:edit',
                       iconPosition: 'left'
                   } }
                   
                   
                   
                  ];
        
        component.set("v.cols",colms);
    },
    searchCase : function(component, event, helper) {
        
        
        var ref= event.getParam("Refferal");
        if(ref!=null)
        {
  component.set("v.isshow",true);
        
        for (var i = 0; i < ref.length; i++)
        {
            var refff = ref[i];
            // checking if any account related data in row
            if (refff.Unit_Organization_Hospital_Name__c)
            {
                refff.linkName = '/'+refff.Id;
                
                refff.Unit_Organization_Hospital_Name__rName = refff.Unit_Organization_Hospital_Name__r.Name;
            }
            
            
        }
        
        component.set("v.refferals",ref);
        component.set("v.isspin",false);
      
        }
        else{

          component.set("v.isshow",false);
        component.set("v.isspin",false);

        
        }
        
        
        
    },
    handleRowAction: function ( cmp, event, helper ) {
        
        var action = event.getParam( 'action' );
        var row = event.getParam( 'row' );
        var recId = row.Id;

        
        switch ( action.name ) {
            case 'edit':
                var editRecordEvent = $A.get("e.force:navigateToComponent");
                editRecordEvent.setParams({
                    //  "recordId": recId
                    componentDef : "c:ReferralEdit",
                    componentAttributes: {
                        recordId : recId
                    }
                });
                editRecordEvent.fire();
                break;
            case 'view':
                var viewRecordEvent = $A.get("e.force:navigateToURL");
                viewRecordEvent.setParams({
                    "url": "/" + recId
                });
                viewRecordEvent.fire();
                break;
        }
    }
    
})