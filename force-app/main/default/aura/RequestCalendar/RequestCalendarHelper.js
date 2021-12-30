({
    //Fetch Initial data
    fetchData: function(component, event, firstDay, lastDay, helper , filter){
        //variable declaration
        var datecount = ((lastDay-firstDay)/8.64e7)+1;
        console.log('Date Count in helper'+firstDay);
        component.set("v.pageSize", datecount);
        component.set("v.returnedcount","Returned - 0");
        component.set("v.fulfilledcount","Placed/Fulfilled - 0");
        component.set("v.cancelledcount","Cancelled - 0");
        component.set("v.inProgresscount","New/InProgress - 0");
        var columns= [];   // To store dates as a list
        var istDatecolmns= []; 	//To store date with ddmmyyyy format
        var methodName = "c.fetchInitialData";
        var params = {
            "fromDate" : firstDay,
            "toDate" : lastDay,
            "filter" : filter
        };
        var result = function(res){
            var statusCount = res.statusCount;
            for(var i=0; i<statusCount.length;i++){
                if(statusCount[i].status == "Returned"){
                    component.set("v.returnedcount", "Returned - "+statusCount[i].count);
                }
                if(statusCount[i].status == "Placed/Fulfilled"){
                    component.set("v.fulfilledcount", "Placed/Fulfilled - "+statusCount[i].count);
                }
                if(statusCount[i].status == "Cancelled"){
                    component.set("v.cancelledcount", "Cancelled - "+statusCount[i].count);
                }
                if(statusCount[i].status == "New/InProgress"){
                    component.set("v.inProgresscount", "New/InProgress - "+statusCount[i].count);
                }
            }
            component.set('v.statusCount',res.statusCount);
            component.set('v.dataMap',res.reqData);
            component.set("v.spinner",false);
            if(lastDay){
                while(firstDay <= lastDay) {  
                    columns.push((new Date(firstDay).toLocaleDateString('en-GB')));
                    istDatecolmns.push((new Date(firstDay)).toLocaleDateString('en-GB'));   
                    firstDay.setDate(firstDay.getDate()+1);
                }
                component.set("v.columnsData", columns);
                if(columns.length) {
                    component.set("v.show", true);
                    var pageSize = component.get("v.pageSize");
                    var PagList = [];
                    var pageListDates= [];
                    var selectActions = [];
                    for ( var i=0; i< pageSize; i++ ){
                        if ( component.get("v.columnsData").length> i ){
                            PagList.push(columns[i]);
                        }
                        pageListDates.push(istDatecolmns[i]);  
                    }
                    var result = res.reqData;                 
                    var arrayMapKeys = [];
                    var  dfRecords=[];           
                    for(var checkdt of PagList ){                            
                        if(result[checkdt]){
                            arrayMapKeys.push({key: checkdt, value: result[checkdt]});
                            dfRecords.push({key: checkdt, value: result[checkdt]});
                        }else{
                            arrayMapKeys.push({key: checkdt, value: []});
                            dfRecords.push({key: checkdt, value: []});  
                        }
                    } 
                    let statusList= [];
                    arrayMapKeys.forEach(arr=> {
                        let opts= new Set();
                        let ops= [];
                        arr.value.forEach(a => {
                            if(a.Request_Status__c) {
                                console.log('Request status in helper\t'+a.Request_Status__c);
                                opts.add(a.Request_Status__c);
                                console.log("opts",opts);
                        	}
                    	}); 
                    	opts.forEach( opt => {
                        	console.log('opt in helper'+opt);
                        	if(opt=="New/In Progress"){
                        		ops.push({value: opt, name: opt,label:"New/InProgress"});
                			}else if(opt=="Fulfilled"){
                    			ops.push({value: opt, name: opt,label:"Placed/Fulfilled"});
                			}else{
                    			ops.push({value: opt, name: opt,label:opt});
                			}
                
            			});
            			statusList.push({key: arr.key, value: [...ops]});
            			console.log("statusList in helper",statusList);
        			});
                    component.set("v.selectedValue",statusList);
                    component.set('v.PaginationList', PagList);
                    component.set("v.PaginationListCol", pageListDates);  
                    component.set("v.surgenRecords", [...arrayMapKeys]);                        
                    component.set("v.allRecords", dfRecords);
    			}else{
    				component.set("v.show", false);
				}
			}
		}
 		//Call apex 
 		this.callApex(component, event, helper, methodName, params, result);
	},
        
    //This method for call the apex method.
    callApex: function (component, event, helper, methodName, params, callbackRes) {
        var action = component.get(methodName);
        action.setParams(params);
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {   
                console.log("state is SUCCESS");
                callbackRes(response.getReturnValue());
            }else if(state === "INCOMPLETE"){
                console.log("state is INCOMPLETE");
                component.set("v.spinner",false);
            }else if(state === "ERROR"){
                console.log("state is ERROR"+response.getErrors());
                component.set("v.spinner",false);
            }
        });
        $A.enqueueAction(action);
    },
    
    //Tooltip for TissueId and MRNumber Functionality
    ToolTipLayout : function(component, event, helper, dataValue, srcElement) {
        var totalRecords= component.get("v.surgenRecords");
        totalRecords.forEach( tipRecord => {
            if(tipRecord.key== dataValue){
            	tipRecord.value.forEach( val => {
            		if(val.Id== srcElement) {
            			let mouseHoverData= {};
                        mouseHoverData.TissueId = val.TissueID__c;
                        mouseHoverData.MRNum = val.Medical_Record__c !=  null ? val.Medical_Record__c : '';
                        mouseHoverData.mhData= dataValue;
                        component.set("v.mouseHoverData", mouseHoverData);
    				}
				});
			}
		});
		component.set("v.hoverRow", parseInt(event.target.dataset.index));
		component.set("v.togglehover",true);
	}
})