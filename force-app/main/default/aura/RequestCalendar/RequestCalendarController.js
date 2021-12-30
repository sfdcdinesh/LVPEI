({
    doInit : function(component, event, helper) {
        //default current month first date to last date data
        component.set("v.spinner",true);
        var date = new Date();
        var firstDay = new Date(date.getFullYear(), date.getMonth(), 1);        
        var lastDay = new Date(date.getFullYear(), date.getMonth() + 1, 0);    
        
        helper.fetchData(component, event, firstDay, lastDay, helper,"ALL");
    },
    
    //selected date data displaying
    selectDate: function(component, event, helper){
        var fromDate= new Date(component.find("fromDate").get("v.value"));
        var toDate= new Date(component.find("toDate").get("v.value"));
        component.set("v.selecteddate",true);
        component.set("v.spinner",true);
        helper.fetchData(component, event, fromDate, toDate, helper,"ALL");
    },
    
    //based on status filters records will be displaying
    onControllerFieldChange: function (component, event, helper){
        component.set("v.spinner",true);
        var dateSelectBox= event.getSource().get("v.name");		
        var dateValue= event.getSource().get("v.value");	
        var dataObj= component.get("v.allRecords");    
        var sampleArr= [];
        
        dataObj.forEach( dateRecords => { 
            if(dateRecords.key== dateSelectBox){  
            	if(dateValue== '--None--'){
            		sampleArr= [...dateRecords.value];
        		}else{
        			dateRecords.value.forEach( rec => {
            			if(rec.Request_Status__c== dateValue) {
            				sampleArr.push(rec);
        				}
    				});         
				}            
 			}
 		});
        var allData= component.get("v.surgenRecords");	
        // all records displayed
        allData.forEach( dateRecords=> {
        	if(dateRecords.key== dateSelectBox)  {
            	dateRecords.value= [...sampleArr];
        	} 
        });
        component.set("v.surgenRecords", allData);
        window.setTimeout(
            $A.getCallback(function() {
                component.set("v.spinner",false);
            }), 1500
        );
	},
        
    //Tooltip for TissueId and MRNumber
    handleMouseHover : function(component, event, helper) {
        var srcElement = event.srcElement.id;       //mouse pointed record Id         
        var dataValue= event.target.dataset.value;	// Date the record belongs
        component.set("v.recordId",srcElement);
        helper.ToolTipLayout(component, event, helper, dataValue, srcElement);
    },
        
    handleMouseOut : function(component, event, helper) {
    	component.set("v.hoverRow",-1);
        component.set("v.togglehover",false);
    },
            
    requestedData: function (component, event, helper){
        component.set("v.spinner",true);
        var selectedstatus = component.get("v.selecteddate");
        var getValues = event.getSource().get("v.name");
        if(selectedstatus == false){
            var date = new Date();
            var firstDay = new Date(date.getFullYear(), date.getMonth(), 1);        
            var lastDay = new Date(date.getFullYear(), date.getMonth() + 1, 0); 
            helper.fetchData(component, event, firstDay, lastDay, helper,getValues);
        }else if(selectedstatus == true){
            var fromDate= new Date(component.find("fromDate").get("v.value"));
            var toDate= new Date(component.find("toDate").get("v.value"));
            helper.fetchData(component, event, fromDate, toDate, helper,getValues);
        }
    }
})