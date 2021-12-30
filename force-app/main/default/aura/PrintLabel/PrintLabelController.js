({

           printLabel : function(component, event, helper){

        var recordId = component.get("v.recordId");

        window.open('/apex/TissueEvalPrintLabel?tissueId='+recordId, '_blank');       

    }

})