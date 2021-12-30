({

           downloadPostCutPdf : function(component, event, helper) {

         var recordId = component.get("v.recordId");

        window.open('/apex/PostCutEvaluationForm?tissueId='+recordId, '_blank');       

           }

})