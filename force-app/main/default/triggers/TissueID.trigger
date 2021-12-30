trigger TissueID on Tissue_Evaluation__c (before insert,before update) {
    if(Trigger.isBefore){
        for(Tissue_Evaluation__c tissueID: Trigger.New){
            system.debug('record is '+tissueID);
            
            //Tissue Suitability updates
            if(tissueID.Tissue_Suitability__c == 'Suitable'){
                string approvedUsages = '';
                if(tissueID.PK__c == 'Yes'){
                    if(approvedUsages == ''){
                        approvedUsages = 'PK';
                    }
                }
                if(tissueID.ALK__c == 'Yes'){
                    if(approvedUsages == ''){
                        approvedUsages = 'ALK';
                    }else{
                        approvedUsages = approvedUsages+', ALK';
                    }
                }
                if(tissueID.EK__c == 'Yes'){
                    if(approvedUsages == ''){
                        approvedUsages = 'EK';
                    }else{
                        approvedUsages = approvedUsages+', EK';
                    }
                }
                if(tissueID.K_Pro__c == 'Yes'){
                    if(approvedUsages == ''){
                        approvedUsages = 'K-Pro';
                    }else{
                        approvedUsages = approvedUsages+', K-Pro';
                    }
                }
                if(tissueID.KLA__c == 'Yes'){
                    if(approvedUsages == ''){
                        approvedUsages = 'KLA';
                    }else{
                        approvedUsages = approvedUsages+', KLA';
                    }
                }
                if(tissueID.Tectonic_Therapeutic__c == 'Yes'){
                    if(approvedUsages == ''){
                        approvedUsages = 'Tectonic/Therapeutic';
                    }else{
                        approvedUsages = approvedUsages+', Tectonic/Therapeutic';
                    }
                }
                tissueID.Approved_Usages__c = approvedUsages;
            }
            //Tissue suitablity updates done
            
            if(tissueID.Is_Child_Record__c){
               string generatedId = tissueID.Donor_ID__c+' '+tissueID.Eye__c+'-'+'S'+'-'+'Q'+tissueID.Quarter__c;
               tissueID.Name = generatedId;
            }else{
                string GeneratedId = '';
                string DonorId = tissueID.Donor_ID__c;
                string Eye = tissueID.Eye__c;
                string TissueType = tissueID.Tissue_Type__c;
                if(TissueType == 'Cornea'){
                    GeneratedId = DonorId+' '+Eye+'-'+'C';
                    tissueType = 'C';
                }else if(TissueType == 'Whole Globe'){
                    GeneratedId = DonorId+' '+Eye+'-'+'WG';
                }
                tissueID.Name = GeneratedId;    
            }
        }
    }
    
    /*//Jagadeesh Changes Start Here
    if(Trigger.isAfter && Trigger.isInsert){
    
        Map<ID,ID> TissueMedicalMap = new Map<ID,ID>();
        Map<ID,ID> MedicalRecoveryMap = new Map<ID,ID>();
        Map<ID,ID> RecoveryReferralMap = new Map<ID,ID>();
        
        for(Tissue_Evaluation__c tev: trigger.new){
            TissueMedicalMap.put(tev.Id,tev.Medical_Review__c);
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
        
        for(Tissue_Evaluation__c tev: trigger.new){
        
            Consolidated_Report__c obj = new Consolidated_Report__c();
            
            obj.Tissue_Evaluation__c = tev.Id;
                
            if(TissueMedicalMap.containsKey(tev.Id))
                obj.Medical_Review__c = TissueMedicalMap.get(tev.Id);
                
            if(MedicalRecoveryMap.containsKey(TissueMedicalMap.get(tev.Id)))
                obj.Recovery__c = MedicalRecoveryMap.get(TissueMedicalMap.get(tev.Id));
                
            if(RecoveryReferralMap.containsKey(MedicalRecoveryMap.get(TissueMedicalMap.get(tev.Id))))
                obj.Referral__c = RecoveryReferralMap.get(MedicalRecoveryMap.get(TissueMedicalMap.get(tev.Id)));
            
            ConsolidatedLst.add(obj);
        }
        
        if(!ConsolidatedLst.isEmpty()){
            insert ConsolidatedLst;
        }
    }
    
    //Jagadeesh Changes Ends Here*/
}