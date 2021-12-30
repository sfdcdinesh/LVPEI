trigger CreateRecInConsolidatedReport on Referral__c (after insert){
    List<Consolidated_Report__c> ConsolidatedLst = new List<Consolidated_Report__c>();
   
    try{
        if(Trigger.isAfter && Trigger.isInsert){
            for(Referral__c obj: trigger.new){
                Consolidated_Report__c obj1 = new Consolidated_Report__c();
                obj1.Referral__c = obj.Id;
                ConsolidatedLst.add(obj1);
            }
            if(!ConsolidatedLst.isEmpty()){
                insert ConsolidatedLst;
            }
        }
    }catch(Exception ex){
        system.debug('Exception in CreateRecInConsolidatedReport trigger '+ex.getMessage()+' At line number '+ex.getLineNumber());
    }    
}