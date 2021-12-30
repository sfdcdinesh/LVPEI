({
    
    MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB 
    CHUNK_SIZE: 750000,      //Chunk Max size 750Kb 
    
    //Code for Hide and Show Sections
	helperadd : function(component,event,secId) {
	  var acc = component.find(secId);
        	for(var cmp in acc) {
        	$A.util.toggleClass(acc[cmp], 'slds-show');  
        	$A.util.toggleClass(acc[cmp], 'slds-hide');  
       }
	},
    
    uploadHelper: function(component, event) {
        console.log("in uploadhelper method");
        // start/show the loading spinner   
       // component.set("v.showLoadingSpinner", true);
        // get the selected files using aura:id [return array of files]
        var fileInput;
        var eventname = event.getSource().get("v.name");
        if(eventname === "specEvalSave"){
            fileInput = component.find("fileId").get("v.files");
        }else if(eventname === "postCutSave"){
            fileInput = component.find("fileId1").get("v.files");
        }

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
            self.uploadProcess(component, file, fileContents);
        });
 
        objFileReader.readAsDataURL(file);
    },
 
    uploadProcess: function(component, file, fileContents) {
        console.log("in uploadprocess method");
        // set a default size or startpostiton as 0 
        var startPosition = 0;
        // calculate the end size or endPostion using Math.min() function which is return the min. value   
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
 
        // start with the initial chunk, and set the attachId(last parameter)is null in begin
        this.uploadInChunk(component, file, fileContents, startPosition, endPosition, '');
    },
 
 
    uploadInChunk: function(component, file, fileContents, startPosition, endPosition, attachId) {
        console.log("in uploadinchucnk method");
        // call the apex method 'saveChunk'
        var imageName = component.get("v.imageName");
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
                    alert('Your File is Saved Successfully');
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
        $A.enqueueAction(action)
    },
    
    checkChildRecords: function(component, event, helper, newTissueId, callbackRes){
        console.log("i am in check child record method");
            console.log("newly generated tissue id "+newTissueId);
            var action = component.get("c.fetchChildRecord");
            action.setParams({
                "TissueId" : newTissueId
            });
            action.setCallback(this, function(res){
                var state = res.getState();
                if(state === "SUCCESS"){
                    console.log("state is SUCCESS"+res.getReturnValue());
                    callbackRes(res.getReturnValue());
                }else if(state === "INCOMPLETE"){
                    component.set("v.showSpinner",false);
                    console.log("state is INCOMPLETE");
                }else if(state === "ERROR"){
                    component.set("v.showSpinner",false);
                    console.log("state is ERROR");
                }
            });
            $A.enqueueAction(action) 
    },
    
    CreatRec: function(component, event, helper){
        component.set("v.showSpinner",true);
        console.log("i am in child record creation method");
            var action1 = component.get("c.createChildRecord");
            action1.setParams({
                "parentRec" : component.get("v.tisEval"),
                "newTissueId" : component.get("v.newTissueId")
            });
            action1.setCallback(this, function(res){
                var state = res.getState();
                console.log("state is SUCCESS "+res.getReturnValue());
                if(state === "SUCCESS"){
                    component.set("v.showSpinner",false);
                    console.log("result is "+res.getReturnValue());
                    this.closeModal(component, event, helper);
                    if(res.getReturnValue() === "Success"){
                    	var resultsToast = $A.get("e.force:showToast");
                        resultsToast.setParams({
                            "type": "Success",
                            "message": "Record created"
                        });
                        resultsToast.fire();    
                    }else{
                        var resultsToast = $A.get("e.force:showToast");
                        resultsToast.setParams({
                            "type": "error",
                            "message": "Failure"
                        });
                        resultsToast.fire();
                    }
                    this.closeModal(component, event, helper);
                }else if(state === "INCOMPLETE"){
                    component.set("v.showSpinner",false);
                    console.log("state is INCOMPLETE");
                }else if(state === "ERROR"){
                    component.set("v.showSpinner",false);
                    console.log("state is ERROR");
                }
            });
            $A.enqueueAction(action1)
    },
    
    opendModal: function(component, event, helper){
        var targetCmp = component.find("Modalbox");
        var targetCmpBack = component.find("Modalbackdrop");
        $A.util.addClass(targetCmp, "slds-fade-in-open");
        $A.util.addClass(targetCmpBack, "slds-backdrop--open");
    },
    
    closeModal: function(component, event, helper){
        var targetCmp = component.find("Modalbox");
        var targetCmpBack = component.find("Modalbackdrop");
        $A.util.removeClass(targetCmp, "slds-fade-in-open");
        $A.util.removeClass(targetCmpBack, "slds-backdrop--open");
    }
})