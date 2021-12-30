({
	onLoad: function(component, event, sortField) {
      //call apex class method
      var action = component.get('c.fetchContact');
 
      // pass the apex method parameters to action 
      action.setParams({
         'sortField': sortField,
         'isAsc': component.get("v.isAsc")
      });
      action.setCallback(this, function(response) {
         //store state of response
         var state = response.getState();
         if (state === "SUCCESS") {
            //set response value in ListOfContact attribute on component.
            component.set('v.OriginalTissuesList', response.getReturnValue());
         }
      });
      $A.enqueueAction(action);
   },
    
    //Method gets called by onsort action,
    handleSort : function(component,event,helper){
        console.log("I am here 1");
        //Returns the field which has to be sorted
        var sortBy = event.getParam("fieldName");
        //returns the direction of sorting like asc or desc
        var sortDirection = event.getParam("sortDirection");
        //Set the sortBy and SortDirection attributes
        component.set("v.sortBy",sortBy);
        component.set("v.sortDirection",sortDirection);
        // call sortData helper function
        console.log("I am here 2");
        this.sortData(component,sortBy,sortDirection);
        console.log("I am here 3");
    },
    
    sortData : function(component,fieldName,sortDirection){
        console.log("I am here 4");
        var data = component.get("v.data");
        //function to return the value stored in the field
        var key = function(a) { return a[fieldName]; }
        var reverse = sortDirection == 'asc' ? 1: -1;
        
        // to handel number/currency type fields 
        if(fieldName == 'Age__c' || fieldName == 'Cell_Count_per_mm2__c' || fieldName == 'Tissue_Aging__c'){ 
            data.sort(function(a,b){
                var a = key(a) ? key(a) : '';
                var b = key(b) ? key(b) : '';
                return reverse * ((a>b) - (b>a));
            }); 
        }
        else{// to handel text type fields 
            console.log("I am here 5");
            data.sort(function(a,b){ 
                var a = key(a) ? key(a).toLowerCase() : '';//To handle null values , uppercase records during sorting
                var b = key(b) ? key(b).toLowerCase() : '';
                return reverse * ((a>b) - (b>a));
            });
            console.log("I am here 6");
        }
        //set sorted data to accountData attribute
        console.log("I am here 7");
        component.set("v.data",data);
        console.log("I am here 8");
        console.log("data is "+JSON.stringify(component.get("v.data")));
        console.log("I am here 9");
    }

})