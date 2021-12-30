trigger UpdateRecInConRepForRecovery on Recovery__c (after insert,after update) {
    List<Consolidated_Report__c> ConsolidatedLst = new List<Consolidated_Report__c>();
    Map<Id,Id> RefferalRecoveryIdMap = new Map<Id,Id>();
    try{
        if(Trigger.isAfter && Trigger.isInsert){
            for(Recovery__c obj: trigger.new){
                RefferalRecoveryIdMap.put(obj.Referral__c,obj.Id); //key is referral id, value is recovery id
            }
            
            if(!RefferalRecoveryIdMap.isEmpty()){
                ConsolidatedLst = [select Id,Referral__c,Recovery__c from Consolidated_Report__c where Referral__c IN :RefferalRecoveryIdMap.keySet()];
                if(!ConsolidatedLst.isEmpty()){
                    for(Consolidated_Report__c obj: ConsolidatedLst){
                        if(RefferalRecoveryIdMap.containsKey(obj.Referral__c)){
                            obj.Recovery__c = RefferalRecoveryIdMap.get(obj.Referral__c);
                        }                        
                    }
                }
            }
            
            if(!ConsolidatedLst.isEmpty()){
                update ConsolidatedLst;
            }
        }
    }catch(Exception ex){
        system.debug('Exception in UpdateRecInConRepForRecovery trigger '+ex.getMessage()+' At line number '+ex.getLineNumber());
    }    
}