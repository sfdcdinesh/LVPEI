({
    
	doInit : function(component, event, helper) {
          
          helper.referralList(component,event,helper);
          helper.recoverylist(component,event,helper);
          helper.MedicalEvalList(component,event,helper);
          helper.TissuesList(component,event,helper);
		
	},
    
    getReferral: function(component,event,helper){
       var referral = event.getParam("referral");
       var referralName = event.getParam("referralName");
       var referralOutcome = event.getParam("referralOutcome");
       component.set("v.referral",referral);
       component.set("v.referralName",referralName);
        if(referralOutcome=="Approached: Consented"){
            component.set("v.dislpayNext",true);
            var RecoveryCmp = component.find("RecoveryCmp");
            RecoveryCmp.RecoveryMethod(component.get("v.referral"),component.get("v.dislpayNext"),component.get("v.referralName"));
        }
        else{
           component.set("v.dislpayNext",false);
        }
    },
         
    getRecovery: function(component,event,helper){
       var recovery = event.getParam("recovery");
       component.set("v.recovery",recovery);
       var MedRevcmp = component.find("MedRevCmp");
       MedRevcmp.MedicalReviewMethod(component.get("v.recovery"),component.get("v.dislpayNext"));
    },
    gotopath: function(component,event,helper)
    {
        var addfromhide = component.find("home"); 
          $A.util.removeClass(addfromhide, 'vshow');
        $A.util.addClass(addfromhide, 'vhide');
       
          var addfromhide = component.find("firstPath"); 
           $A.util.removeClass(addfromhide, 'vhide');
        $A.util.addClass(addfromhide, 'vshow');
         var addfromhide = component.find("fifthsession"); 
        $A.util.removeClass(addfromhide, 'vhide');
        $A.util.addClass(addfromhide, 'vshow');
      
    },
   /* GetRecoveryID: function(component,event,helper){
        var recoveryId = event.getParam("recoveryId");
        component.set("v.recoveryId",recoveryId);
     },*/
    clinkOnNextdonor: function(component,event,helper)
    {
        
        var addfromhide = component.find("firstPath"); 
        $A.util.removeClass(addfromhide, 'vshow');
        $A.util.addClass(addfromhide, 'vhide');
        var addfromhide = component.find("fifthsession"); 
        $A.util.removeClass(addfromhide, 'vshow');
        $A.util.addClass(addfromhide, 'vhide');
        var addfromhide = component.find("secondPath"); 
        $A.util.removeClass(addfromhide, 'vhide');
        $A.util.addClass(addfromhide, 'vshow');
        var addfromhide = component.find("sessiontwo"); 
        $A.util.removeClass(addfromhide, 'vhide');
        $A.util.addClass(addfromhide, 'vshow');    
    },
    
    clinkOnNextrefer : function(component,event,helper)
    {
        
     var addfromhide = component.find("fiftPath"); 
        $A.util.removeClass(addfromhide, 'vshow');
        $A.util.addClass(addfromhide, 'vhide');
          var addfromhide = component.find("sessionone"); 
        $A.util.removeClass(addfromhide, 'vshow');
        $A.util.addClass(addfromhide, 'vhide');
     var addfromhide = component.find("firstPath"); 
        $A.util.removeClass(addfromhide, 'vhide');
        $A.util.addClass(addfromhide, 'vshow');
        var addfromhide = component.find("fifthsession"); 
        $A.util.removeClass(addfromhide, 'vhide');
        $A.util.addClass(addfromhide, 'vshow');

    },
    clinkOnNext: function(component,event,helper)
    {

      var addfromhide = component.find("fiftPath"); 
        $A.util.removeClass(addfromhide, 'vshow');
        $A.util.addClass(addfromhide, 'vhide');
          var addfromhide = component.find("sessionone"); 
        $A.util.removeClass(addfromhide, 'vshow');
        $A.util.addClass(addfromhide, 'vhide');
     var addfromhide = component.find("secondPath"); 
        $A.util.removeClass(addfromhide, 'vhide');
        $A.util.addClass(addfromhide, 'vshow');
        var addfromhide = component.find("sessiontwo"); 
        $A.util.removeClass(addfromhide, 'vhide');
        $A.util.addClass(addfromhide, 'vshow');
            
    },
    gobacktoRefferal : function(component,event,helper)
    {

      var addfromhide = component.find("secondPath"); 
        $A.util.removeClass(addfromhide, 'vshow');
        $A.util.addClass(addfromhide, 'vhide');
        var addfromhide = component.find("sessiontwo"); 
        $A.util.removeClass(addfromhide, 'vshow');
        $A.util.addClass(addfromhide, 'vhide');
        var addfromhide = component.find("firstPath"); 
        $A.util.removeClass(addfromhide, 'vhide');
        $A.util.addClass(addfromhide, 'vshow');
        var addfromhide = component.find("fifthsession"); 
        $A.util.removeClass(addfromhide, 'vhide');
        $A.util.addClass(addfromhide, 'vshow');
        
    },
    gotoMedical : function(component,event,helper)
    {

      var addfromhide = component.find("secondPath"); 
        $A.util.removeClass(addfromhide, 'vshow');
        $A.util.addClass(addfromhide, 'vhide');
          var addfromhide = component.find("sessiontwo"); 
        $A.util.removeClass(addfromhide, 'vshow');
        $A.util.addClass(addfromhide, 'vhide');
     var addfromhide = component.find("thirdPath"); 
        $A.util.removeClass(addfromhide, 'vhide');
        $A.util.addClass(addfromhide, 'vshow');
        var addfromhide = component.find("sessionthree"); 
        $A.util.removeClass(addfromhide, 'vhide');
        $A.util.addClass(addfromhide, 'vshow');
          
    },
    gobacktoRecovery : function(component,event,helper)
    {

      var addfromhide = component.find("thirdPath"); 
        $A.util.removeClass(addfromhide, 'vshow');
        $A.util.addClass(addfromhide, 'vhide');
     var addfromhide = component.find("sessionthree"); 
        $A.util.removeClass(addfromhide, 'vshow');
        $A.util.addClass(addfromhide, 'vhide');
         var addfromhide = component.find("secondPath"); 
        $A.util.removeClass(addfromhide, 'vhide');
        $A.util.addClass(addfromhide, 'vshow');
        var addfromhide = component.find("sessiontwo"); 
        $A.util.removeClass(addfromhide, 'vhide');
        $A.util.addClass(addfromhide, 'vshow');
        
          
    },
     gotoEMR : function(component,event,helper)
    {

      var addfromhide = component.find("thirdPath"); 
        $A.util.removeClass(addfromhide, 'vshow');
        $A.util.addClass(addfromhide, 'vhide');
          var addfromhide = component.find("sessionthree"); 
        $A.util.removeClass(addfromhide, 'vshow');
        $A.util.addClass(addfromhide, 'vhide');
     var addfromhide = component.find("FourthPath"); 
        $A.util.removeClass(addfromhide, 'vhide');
        $A.util.addClass(addfromhide, 'vshow');
        var addfromhide = component.find("sessionfour"); 
        $A.util.removeClass(addfromhide, 'vhide');
        $A.util.addClass(addfromhide, 'vshow');
        
          
    },
    gobacktoMedical: function(component,event,helper)
    {

      var addfromhide = component.find("FourthPath"); 
        $A.util.removeClass(addfromhide, 'vshow');
        $A.util.addClass(addfromhide, 'vhide');
          var addfromhide = component.find("sessionfour"); 
        $A.util.removeClass(addfromhide, 'vshow');
        $A.util.addClass(addfromhide, 'vhide');
     var addfromhide = component.find("thirdPath"); 
        $A.util.removeClass(addfromhide, 'vhide');
        $A.util.addClass(addfromhide, 'vshow');
        var addfromhide = component.find("sessionthree"); 
        $A.util.removeClass(addfromhide, 'vhide');
        $A.util.addClass(addfromhide, 'vshow');         
    },
   
    editRecord : function (component, event, helper) {
    var referralId = event.currentTarget.dataset.value;
    var editRecordEvent = $A.get("e.force:editRecord");
    editRecordEvent.setParams({
        "recordId": referralId
    });
    editRecordEvent.fire();
},
    editRecoveryRecord : function (component, event, helper) {
    var recoveryId = event.currentTarget.dataset.value;
    var editRecordEvent = $A.get("e.force:editRecord");
    editRecordEvent.setParams({
        "recordId": recoveryId
    });
    editRecordEvent.fire();
    
    },
    editMedicalRecord: function (component, event, helper) {
    var medicalId = event.currentTarget.dataset.value;
    var editRecordEvent = $A.get("e.force:editRecord");
    editRecordEvent.setParams({
        "recordId": medicalId
    });
    editRecordEvent.fire();
    
    },
    editTissueRecord : function (component, event, helper) {
    var tissueId = event.currentTarget.dataset.value;
    var editRecordEvent = $A.get("e.force:editRecord");
    editRecordEvent.setParams({
        "recordId": tissueId
    });
    editRecordEvent.fire();
    
    }
})