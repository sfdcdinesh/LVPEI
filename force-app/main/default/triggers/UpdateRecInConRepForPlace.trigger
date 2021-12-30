trigger UpdateRecInConRepForPlace on Placement__c (after insert,after update) {
    List<Consolidated_Report__c> ConsolidatedLst = new List<Consolidated_Report__c>();
    Map<Id,Placement__c> ReqPlacementIdMap = new Map<Id,Placement__c>();
    try{
        if(Trigger.isAfter && Trigger.isInsert || Trigger.isAfter && Trigger.isUpdate){
            for(Placement__c obj: trigger.new){
                ReqPlacementIdMap.put(obj.Select_Tissue__c,obj); //key is tissue id, value is placement
            }
            system.debug('map is '+ReqPlacementIdMap);
               if(!ReqPlacementIdMap.isEmpty()){
                ConsolidatedLst = [select Id,Tissue_Evaluation__c,Request__c,Placement__c from Consolidated_Report__c where Tissue_Evaluation__c IN :ReqPlacementIdMap.keySet() LIMIT 1];
                if(!ConsolidatedLst.isEmpty()){
                    for(Consolidated_Report__c obj: ConsolidatedLst){
                        if(ReqPlacementIdMap.containsKey(obj.Tissue_Evaluation__c)){
                            obj.Request__c = ReqPlacementIdMap.get(obj.Tissue_Evaluation__c).Request__c;
                            obj.Placement__c = ReqPlacementIdMap.get(obj.Tissue_Evaluation__c).Id;
                        }                       
                    }
                }
            }
            
            if(!ConsolidatedLst.isEmpty()){
                update ConsolidatedLst;
            }
    }
    }catch(Exception ex){
        system.debug('Exception in UpdateRecInConRepForReq trigger '+ex.getMessage()+' At line number '+ex.getLineNumber());
    }    
}