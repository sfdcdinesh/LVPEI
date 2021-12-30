trigger CreateConsolidatedRecord on Placement__c (after insert){

   Map<ID,ID> PlacementRequestMap = new Map<ID,ID>();
    Map<ID,ID> RequestTissueMap = new Map<ID,ID>();
    Map<ID,ID> TissueMedicalMap = new Map<ID,ID>();
    Map<ID,ID> MedicalRecoveryMap = new Map<ID,ID>();
    Map<ID,ID> RecoveryReferralMap = new Map<ID,ID>();
    Map<ID,Consolidated_Report__c> ExistingConsolidatedMap = new Map<ID,Consolidated_Report__c>();
    
  
    
    if(Trigger.isAfter && Trigger.isInsert){

        for(Placement__c pcm: trigger.new){
            if(string.isNotBlank(pcm.Request__c)){
                PlacementRequestMap.put(pcm.Id,pcm.Request__c);      
            }
            if(string.isNotBlank(pcm.Select_Tissue__c)){
                RequestTissueMap.put(pcm.Request__c,pcm.Select_Tissue__c);
            }
        }
        
        if(!RequestTissueMap.isEmpty()){
            List<Consolidated_Report__c> TempLst = [Select Id,Request__c,Placement__c,Referral__c,Recovery__c,Medical_Review__c,Tissue_Evaluation__c from Consolidated_Report__c where Tissue_Evaluation__c IN :RequestTissueMap.values()];
            if(!TempLst.isEmpty()){
                for(Consolidated_Report__c cr: TempLst){
                    ExistingConsolidatedMap.put(cr.Tissue_Evaluation__c,cr);
                }
            }
            List<Tissue_Evaluation__c> TissueEvalLst = [Select Id,Medical_Review__c from Tissue_Evaluation__c where Id IN :RequestTissueMap.values()];
            if(!TissueEvalLst.isEmpty()){
                for(Tissue_Evaluation__c tev: TissueEvalLst){
                    TissueMedicalMap.put(tev.Id,tev.Medical_Review__c);
                }
            }
        }
        
        if(!TissueMedicalMap.isEmpty()){
            List<Medical_Review__c> MedicalRevLst = [select Id,Recovery__c from Medical_Review__c where Id IN :TissueMedicalMap.values()];
            if(!MedicalRevLst.isEmpty()){
                for(Medical_Review__c mrv: MedicalRevLst){
                    MedicalRecoveryMap.put(mrv.Id,mrv.Recovery__c);
                }
            }
        }
        
        if(!MedicalRecoveryMap.isEmpty()){
            List<Recovery__c> RecoveryLst = [select Id,Referral__c from Recovery__c where Id IN :MedicalRecoveryMap.values()];
            if(!RecoveryLst.isEmpty()){
                for(Recovery__c rcv:RecoveryLst){
                    RecoveryReferralMap.put(rcv.Id,rcv.Referral__c);
                }
            }
        }
        
        List<Consolidated_Report__c> ConsolidatedLst = new List<Consolidated_Report__c>();
        
        for(Placement__c plm: trigger.new){
        
            Consolidated_Report__c obj = new Consolidated_Report__c();
            
            if(RequestTissueMap.containsKey(PlacementRequestMap.get(plm.Id))){
                if(ExistingConsolidatedMap.containsKey(RequestTissueMap.get(PlacementRequestMap.get(plm.Id)))){
                
                    obj.Id = ExistingConsolidatedMap.get(RequestTissueMap.get(PlacementRequestMap.get(plm.Id))).Id;
                    
                    obj.Placement__c = plm.Id;
                    
                    if(PlacementRequestMap.containsKey(plm.Id))
                        obj.Request__c = PlacementRequestMap.get(plm.Id);
            
                }else{
                    obj.Placement__c = plm.Id;
                    
                    if(PlacementRequestMap.containsKey(plm.Id))
                        obj.Request__c = PlacementRequestMap.get(plm.Id);
                        
                    obj.Tissue_Evaluation__c = RequestTissueMap.get(PlacementRequestMap.get(plm.Id));
                    
                    if(TissueMedicalMap.containsKey(RequestTissueMap.get(PlacementRequestMap.get(plm.Id))))
                        obj.Medical_Review__c = TissueMedicalMap.get(RequestTissueMap.get(PlacementRequestMap.get(plm.Id)));
                        
                    if(MedicalRecoveryMap.containsKey(TissueMedicalMap.get(RequestTissueMap.get(PlacementRequestMap.get(plm.Id)))))
                        obj.Recovery__c = MedicalRecoveryMap.get(TissueMedicalMap.get(RequestTissueMap.get(PlacementRequestMap.get(plm.Id))));
                        
                    if(RecoveryReferralMap.containsKey(MedicalRecoveryMap.get(TissueMedicalMap.get(RequestTissueMap.get(PlacementRequestMap.get(plm.Id))))))
                        obj.Referral__c = RecoveryReferralMap.get(MedicalRecoveryMap.get(TissueMedicalMap.get(RequestTissueMap.get(PlacementRequestMap.get(plm.Id)))));
                }
            }    
            ConsolidatedLst.add(obj);
        }
        
        if(!ConsolidatedLst.isEmpty()){
            upsert ConsolidatedLst;
        }
    }
}