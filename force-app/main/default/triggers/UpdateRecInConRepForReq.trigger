trigger UpdateRecInConRepForReq on Request__c (after insert,after update) {
    List<Consolidated_Report__c> ConsolidatedLst = new List<Consolidated_Report__c>();
    Map<Id,Id> TissuEvalReqIdMap = new Map<Id,Id>();
    try{
        if(Trigger.isAfter && Trigger.isInsert){
            for(Request__c obj: trigger.new){
                if(obj.Tissue_Evaluation__c != null){
                    TissuEvalReqIdMap.put(obj.Tissue_Evaluation__c,obj.Id); //key is tissue eval id, value is request id
                }
            }
            
            if(!TissuEvalReqIdMap.isEmpty()){
                ConsolidatedLst = [select Id,Tissue_Evaluation__c,Request__c from Consolidated_Report__c where Tissue_Evaluation__c IN :TissuEvalReqIdMap.keySet()];
                if(!ConsolidatedLst.isEmpty()){
                    for(Consolidated_Report__c obj: ConsolidatedLst){
                        if(TissuEvalReqIdMap.containsKey(obj.Tissue_Evaluation__c)){
                            obj.Request__c = TissuEvalReqIdMap.get(obj.Tissue_Evaluation__c);
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