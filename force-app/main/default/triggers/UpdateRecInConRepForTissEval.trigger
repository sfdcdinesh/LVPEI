trigger UpdateRecInConRepForTissEval on Tissue_Evaluation__c (after insert,after update) {
    List<Consolidated_Report__c> ConsolidatedLst = new List<Consolidated_Report__c>();
    List<Consolidated_Report__c> ConsolidatedLstToUpdate = new List<Consolidated_Report__c>();
    Map<Id,Id> MedRevTissuEvaIdMap = new Map<Id,Id>();
    try{
        if(Trigger.isAfter && Trigger.isInsert){
            for(Tissue_Evaluation__c obj: trigger.new){
                MedRevTissuEvaIdMap.put(obj.Medical_Review__c,obj.Id); //key is medical review id, value is tissue eval id
            }
            
            if(!MedRevTissuEvaIdMap.isEmpty()){
                ConsolidatedLst = [select Id,Referral__c,Recovery__c,Medical_Review__c,Tissue_Evaluation__c from Consolidated_Report__c where Medical_Review__c IN :MedRevTissuEvaIdMap.keySet()];
                if(!ConsolidatedLst.isEmpty()){
                    for(Consolidated_Report__c obj: ConsolidatedLst){
                        if(MedRevTissuEvaIdMap.containsKey(obj.Medical_Review__c) && !trigger.newmap.get(MedRevTissuEvaIdMap.get(obj.Medical_Review__c)).Is_Child_Record__c){
                            if(obj.Tissue_Evaluation__c != null){
                                Consolidated_Report__c newobj = new Consolidated_Report__c();
                                newobj.Referral__c = obj.Referral__c;
                                newobj.Recovery__c = obj.Recovery__c;
                                newobj.Medical_Review__c = obj.Medical_Review__c;
                                newobj.Tissue_Evaluation__c = MedRevTissuEvaIdMap.get(obj.Medical_Review__c);
                                ConsolidatedLstToUpdate.add(newobj);
                            }else{
                                obj.Tissue_Evaluation__c = MedRevTissuEvaIdMap.get(obj.Medical_Review__c);
                                ConsolidatedLstToUpdate.add(obj);
                            }
                        }else{
                            if(MedRevTissuEvaIdMap.containsKey(obj.Medical_Review__c) && trigger.newmap.get(MedRevTissuEvaIdMap.get(obj.Medical_Review__c)).Is_Child_Record__c){
                                Consolidated_Report__c newobj2 = new Consolidated_Report__c();
                                newobj2.Referral__c = obj.Referral__c;
                                newobj2.Recovery__c = obj.Recovery__c;
                                newobj2.Medical_Review__c = obj.Medical_Review__c;
                                newobj2.Tissue_Evaluation__c = MedRevTissuEvaIdMap.get(obj.Medical_Review__c);
                                ConsolidatedLstToUpdate.add(newobj2);
                                Break;
                            }    
                        }                        
                    }
                }
            }
            
            if(!ConsolidatedLstToUpdate.isEmpty()){
                upsert ConsolidatedLstToUpdate;
            }
        }
    }catch(Exception ex){
        system.debug('Exception in UpdateRecInConRepForTissEval trigger '+ex.getMessage()+' At line number '+ex.getLineNumber());
    }    
}