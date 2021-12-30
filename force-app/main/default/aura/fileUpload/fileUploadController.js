({
    doSave: function(component, event, helper) {
        if (component.find("fileId").get("v.files").length > 0) {
            helper.uploadHelper(component, event);
        } else {
            alert('Please Select a Valid File');
        }
        
    },
    //To get Newly created TissueId 
    getParentId : function(component, event, helper) {
        var params = event.getParam('arguments');
        if(params!=null && component.find("fileId").get("v.files").length > 0){
        component.set("v.parentId", params.parentId);
        helper.uploadHelper(component, event);
        }
    },
 
    handleFilesChange: function(component, event, helper) { 
        var fileName = 'No File Selected..';
        var firstimg;
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName", fileName);
        console.log("first img "+firstimg);
        if(component.get("v.firstimg")!= undefined){
             firstimg = component.get("v.firstimg");
        }
        console.log("after image "+firstimg);
        var fileInput = component.find("fileId").get("v.files");
        var file = fileInput[0];
        var holdimage = $A.get("e.c:Imagehandler");
        holdimage.setParams({
            "image":file,
            "firstimg":firstimg
        });
        console.log("before event fire");
        console.log("hold image "+JSON.stringify(holdimage.getParams()));
        holdimage.fire();
        console.log("after event fire ");
    }
})