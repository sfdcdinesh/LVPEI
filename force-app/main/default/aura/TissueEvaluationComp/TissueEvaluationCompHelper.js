({
    MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB 
    CHUNK_SIZE: 750000,      //Chunk Max size 750Kb
    
    uploadHelper: function(component, event, fileInput, imageName) {
        console.log("in uploadhelper method");
        console.log("in uploadhelper method"+JSON.stringify(fileInput));
        // start/show the loading spinner   
       // component.set("v.showLoadingSpinner", true);
        // get the selected files using aura:id [return array of files]
       
        // get the first file using array index[0]  
        var file = fileInput[0];
        var self = this;
        // check the selected file size, if select file size greter then MAX_FILE_SIZE,
        // then show a alert msg to user,hide the loading spinner and return from function  
        if (file.size > self.MAX_FILE_SIZE) {
            component.set("v.spinner", false);
            component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size);
            return;
        }
 
        // create a FileReader object 
        var objFileReader = new FileReader();
        // set onload function of FileReader object   
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
 
            fileContents = fileContents.substring(dataStart);
            // call the uploadProcess method 
            self.uploadProcess(component, file, fileContents, imageName);
        });
 
        objFileReader.readAsDataURL(file);
    },
 
    uploadProcess: function(component, file, fileContents, imageName) {
        console.log("in uploadprocess method");
        // set a default size or startpostiton as 0 
        var startPosition = 0;
        // calculate the end size or endPostion using Math.min() function which is return the min. value   
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
 
        // start with the initial chunk, and set the attachId(last parameter)is null in begin
        this.uploadInChunk(component, file, fileContents, startPosition, endPosition, '', imageName);
    },
 
 
    uploadInChunk: function(component, file, fileContents, startPosition, endPosition, attachId, imageName) {
        console.log("in uploadinchucnk method");
        // call the apex method 'saveChunk'
        //var imageName = component.get("v.imageName");
        console.log("image name "+imageName);
        var getchunk = fileContents.substring(startPosition, endPosition);
        var action = component.get("c.saveChunk");
        action.setParams({
            parentId: component.get("v.recordId"),
            fileName: file.name+ "-" + imageName,
            base64Data: encodeURIComponent(getchunk),
            contentType: file.type,
            fileId: attachId
        });
 		console.log("after set params");
        // set call back 
        action.setCallback(this, function(response) {
            // store the response / Attachment Id   
            attachId = response.getReturnValue();
            var state = response.getState();
            console.log("state is "+state);
            if (state === "SUCCESS") {
                console.log("response is SUCCESS");
                // update the start position with end postion
                startPosition = endPosition;
                endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
                // check if the start postion is still less then end postion 
                // then call again 'uploadInChunk' method , 
                // else, diaply alert msg and hide the loading spinner
                if (startPosition < endPosition) {
                    this.uploadInChunk(component, file, fileContents, startPosition, endPosition, attachId);
                } else if(component.get("v.fromNew")==false){
                    //alert('Your File is Saved Successfully');
                }
                else{
                }
                
                // handel the response errors        
            } else if (state === "INCOMPLETE") {
                alert("From server: " + response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        // enqueue the action
        $A.enqueueAction(action);
    },
    
    //Code for Hide and Show Sections
	helperadd : function(component,event,secId) {
	  var acc = component.find(secId);
        	for(var cmp in acc) {
        	$A.util.toggleClass(acc[cmp], 'slds-show');  
        	$A.util.toggleClass(acc[cmp], 'slds-hide');  
       }
	},
    
    //Functionality for Tissue Evaluation Records Count
    checkforTissueRecordCount : function(component,event,recid) {
        var action = component.get("c.getTissueCount");
        action.setParams({
            "parentId":recid
        });
        action.setCallback(this,function(response){
            if(response.getState()==='SUCCESS'){    
              var recordCount = response.getReturnValue();
                if(recordCount==1){
                    var action = component.get("c.getPreviousTissue");
                    action.setParams({
                        "parentId":recid
                    });
                    action.setCallback(this,function(response){
                        if(response.getState()==='SUCCESS'){
                            var previousTissueEye = response.getReturnValue();
                            if(previousTissueEye=='OD'){
                                component.find("eye").set("v.value",'OS');
                                component.set("v.enabled","true");
                            }
                            else if(previousTissueEye=='OS'){
                                component.find("eye").set("v.value",'OD');
                                component.set("v.enabled","true");
                            }
                           else{
                               component.find("eye").set("v.value",'None');     
                           }
                        }
                    })
                    $A.enqueueAction(action)
                }
               else if(recordCount==2){
                 var resultsToast = $A.get("e.force:showToast");
                 resultsToast.setParams({
                "type": "warning",
                "message": "Cannot Create More Than 2 Records For the Same Donor."
            });
            resultsToast.fire();  
                    
              var homeEvt = $A.get("e.force:navigateToObjectHome");
                 homeEvt.setParams({
                 "scope": "Tissue_Evaluation__c"
        });
        homeEvt.fire();
                }
            }
        })
        $A.enqueueAction(action)
    }
})