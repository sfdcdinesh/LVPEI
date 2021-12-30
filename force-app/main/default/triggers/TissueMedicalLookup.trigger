trigger TissueMedicalLookup on Medical_Review__c (after insert) {
     Id donorId;
     List<Tissue_Evaluation__c> tissues = new List<Tissue_Evaluation__c>();
    if(Trigger.isAfter){
        for(Medical_Review__c medRev: Trigger.New){   
             donorId = medRev.Recovery__c;
        }
            tissues = [Select id,Recovery__c from Tissue_Evaluation__c where Recovery__c=:donorId];
        if(tissues!=null){
            for(Tissue_Evaluation__c tis:tissues){
                tis.Medical_Review__c = Trigger.New[0].Id;
                update tis;
            }
            }
        }
    
}