({
    keyup : function(component, event, helper) {
        if(component.get("v.results").length>0)
            component.set("v.openDropDown", true);
        
    },
    doinit : function(component, event, helper) {
        var list_ar=[];
        
        const searchString = component.get("v.inputValue");
        //Ensure that not many function execution happens if user keeps typing
        
        helper.searchRecords(component, searchString,false);
        
        
        var action=     component.get("c.getRefOrgs");
        action.setCallback(this,function(responce){
            
            if(responce.getState()==='SUCCESS')
            {
                
                var reforgs=  responce.getReturnValue();
                
                list_ar.push({label : '---',value : ''});
                
                
                for(var i=0;i<reforgs.length;i++)
                {
                    var ob={};
                    ob.label=reforgs[i].Name;
                    ob.value=reforgs[i].Id;
                    list_ar.push(ob);
                    
                    
                }
                component.set("v.reff_org",list_ar);
                
                
                
            }
            
        });
        $A.enqueueAction(action);
        
    },
    
    onorgchange : function(component, event, helper)
    {
        
        var selectedOptionValue = event.getParam("value");
        
        component.set("v.selected_org",event.getSource().get("v.value"))
        
    },
    search : function(component, event, helper) 
    {
        
        
        var selectedorg=component.get("v.selectedOption")
        var firstName=component.get('v.first_name')
        var lastName=component.get("v.last_name")
        var donorId=component.get("v.donor_id")
        var refId=component.get("v.refferal_id")
        var ref_start_date=component.get("v.reff_start_date")
        var ref_end_date=component.get("v.reff_end_date")
        var deth_start_date=component.get("v.death_start_date")
        var deth_end_date=component.get("v.death_end_date")
        
        if(($A.util.isEmpty(selectedorg) || selectedorg==='---') && $A.util.isEmpty(firstName) && $A.util.isEmpty(lastName)&& $A.util.isEmpty(donorId) && $A.util.isEmpty(refId) && $A.util.isEmpty(ref_start_date)
           && $A.util.isEmpty(ref_end_date)&& $A.util.isEmpty(deth_start_date) && $A.util.isEmpty(deth_end_date))
        {
            alert('Please Enter Something !');
            return;
        }
        
        component.set("v.isspin",true);
        
        if(firstName !=null || lastName!=null ||donorId!=null || refId!=null)
        {
            var action=     component.get("c.getCase");
            action.setParams({
                "first": firstName,
                "last": lastName,
                "donorid": donorId,
                "refid": refId,
                
                
            });
            action.setCallback(this,function(responce){
                
                
                if(responce.getState()==='SUCCESS')
                {
                    
                    
                    var refferal=  responce.getReturnValue();
                    
                    if(!$A.util.isEmpty(refferal)&& refferal.length>0 )
                    {
                        
                        var event=  component.getEvent("CaseSearch");
                        event.setParams({"Refferal" :refferal });
                        event.fire();
                        
                        
                    }
                    else{
                        var event=  component.getEvent("CaseSearch");
                        event.setParams({"Refferal" :null });
                        
                        event.fire();
                        
                        component.set("v.isspin",false);
                        
                        alert('No Records Found !');
                        /*   var toastEvent = $A.get("e.force:showToast");
       toastEvent.setParams({
        "title": "Case Records!",
        "message": "No Records Found.",
        "variant" : "error"  
    });
    toastEvent.fire();
    */
                    
                }
                
            }
            
        });
                    $A.enqueueAction(action);
                    
                }
        else if((selectedorg!=null && selectedorg!='---') ||ref_start_date!=null||
                ref_end_date!=null||deth_start_date!=null||deth_end_date!=null){
            
            var action=     component.get("c.getCases");
            action.setParams({
                "accId": selectedorg,
                "deathstart" :deth_start_date,
                "deathend" :deth_end_date,
                "refstart" :ref_start_date,
                "refend" :ref_end_date
                
            });
            action.setCallback(this,function(responce){
                
                
                if(responce.getState()==='SUCCESS')
                {
                    
                    
                    var refferal=  responce.getReturnValue();
                    
                    
                    
                    if(!$A.util.isEmpty(refferal)&& refferal.length>0 )
                    {
                        
                        
                        var event=  component.getEvent("CaseSearch");
                        event.setParams({"Refferal" :refferal });
                        event.fire();
                        
                        
                    }
                    else{
                        var event=  component.getEvent("CaseSearch");
                        event.setParams({"Refferal" :null });
                        
                        event.fire();
                        
                        component.set("v.isspin",false);
                        
                        alert('No Records Found !');
                        
                        /*   var toastEvent = $A.get("e.force:showToast");
       toastEvent.setParams({
        "title": "Case Records!",
        "message": "No Records Found.",
        "variant" : "error"  
    });
    toastEvent.fire();
    */
                    
                }
                
                
            }
            
        });
            $A.enqueueAction(action);
            
        }
    },
    reset : function(component, event, helper) {
        
        component.set("v.openDropDown", false);
        component.set("v.selectedOption", null);
        component.set("v.inputValue",null);
        component.set("v.first_name",null);
        component.set("v.last_name",null);
        component.set("v.donor_id",null);
        component.set("v.refferal_id",null);
        component.set("v.reff_start_date",null);
        component.set("v.reff_end_date",null);
        component.set("v.death_start_date",null);
        component.set("v.death_end_date",null);
        
        var event=  component.getEvent("CaseSearch");
        event.setParams({"Refferal" :null });
        event.fire();
        
        
    },
    
    searchHandler : function (component, event, helper) {
        const searchString = component.get("v.inputValue");
        //Ensure that not many function execution happens if user keeps typing
        helper.searchRecords(component, searchString,true);
        
    },
    
    optionClickHandler : function (component, event, helper) {
        const selectedId = event.target.closest('li').dataset.id;
        const selectedValue = event.target.closest('li').dataset.value;
        component.set("v.inputValue", selectedValue);
        component.set("v.openDropDown", false);
        component.set("v.selectedOption", selectedId);
    },
    
    clearOption : function (component, event, helper) {
        component.set("v.results", []);
        component.set("v.openDropDown", false);
        component.set("v.inputValue", "");
        component.set("v.selectedOption", "");
    },
    
    
    
    
})