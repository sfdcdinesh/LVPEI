trigger UpdateRecInConRepForMedicalRev on Medical_Review__c (after insert,after update, before insert) {
    List<Consolidated_Report__c> ConsolidatedLst = new List<Consolidated_Report__c>();
    Map<Id,Id> RecoveryMedRevIdMap = new Map<Id,Id>();
    Set<Id> recoveryIds = new Set<Id>();
    List<Medical_Review__c> medRevList = new List<Medical_Review__c>();
    
    try{
        if(Trigger.isbefore && Trigger.isInsert ){
            for(Medical_Review__c obj: trigger.new){
                recoveryIds.add(obj.Recovery__c); 
            }
            List<Recovery__c> recoveryLst = [Select Id, (Select Id from Medical_Review__r) from Recovery__c Where Id IN: recoveryIds];
            SYSTEM.debug('recoveryLst ' + recoveryLst);
            if(!recoveryLst.isEmpty()){
                for(Recovery__c recovRec: recoveryLst){
                    medRevList.addAll(recovRec.Medical_Review__r);
                    system.debug('size =  '+recovRec.Medical_Review__r.Size());
                    if(medRevList.Size()>=1){
                        trigger.new[0].addError('Medical Review is already exists for this Recovery');
                    }
                }
            }
        }
        if(Trigger.isAfter && Trigger.isInsert){
            for(Medical_Review__c obj: trigger.new){
                RecoveryMedRevIdMap.put(obj.Recovery__c,obj.Id); //key is recovery id, value is medical review id
            }
            
            if(!RecoveryMedRevIdMap.isEmpty()){
                ConsolidatedLst = [select Id,Recovery__c,Medical_Review__c from Consolidated_Report__c where Recovery__c IN :RecoveryMedRevIdMap.keySet()];
                if(!ConsolidatedLst.isEmpty()){
                    for(Consolidated_Report__c obj: ConsolidatedLst){
                        if(RecoveryMedRevIdMap.containsKey(obj.Recovery__c)){
                            obj.Medical_Review__c = RecoveryMedRevIdMap.get(obj.Recovery__c);
                        }                        
                    }
                }
            }
            
            if(!ConsolidatedLst.isEmpty()){
                update ConsolidatedLst;
            }
        }
    }catch(Exception ex){
        system.debug('Exception in UpdateRecInConRepForMedicalRev trigger '+ex.getMessage()+' At line number '+ex.getLineNumber());
    }    
}