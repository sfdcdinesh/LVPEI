global class CreateConsolidatedRecsBatch implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC){
        string query = 'select Id from Referral__c where Id = \'a0vN000000438NsIAI\'';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Referral__c> scope){
        set<Id> ReferralIds = new set<Id>();
        
        List<Recovery__c> RecoveryLst = new List<Recovery__c>();
        Map<Id,Id> RefferalRecoveryIdMap = new Map<Id,Id>(); //key is referral id, value is recovery id
        
        List<Medical_Review__c> MedicalLst = new List<Medical_Review__c>();
        Map<Id,Id> RecoveryMedRevIdMap = new Map<Id,Id>(); //key is recovery id, value is medical review id
        
        List<Tissue_Evaluation__c> TissueLst = new List<Tissue_Evaluation__c>();
        Map<Id,Id> MedRevTissuEvaIdMap = new Map<Id,Id>(); //key is tissue id, value is medical review id
        
        List<Request__c> RequestLst = new List<Request__c>();
        Map<Id,Id> TissuEvalReqIdMap = new Map<Id,Id>(); //key is tissue eval id, value is request id
        
        List<Placement__c> PlacementLst = new List<Placement__c>();
        Map<Id,Id> ReqPlacementIdMap = new Map<Id,Id>(); //key is request id, value is placement id
        
        List<Consolidated_Report__c> ConsolidatedLst  = new List<Consolidated_Report__c>();
        
        for(Referral__c obj: scope){
            ReferralIds.add(obj.Id);
        }
        system.debug('referral ids '+ReferralIds);
        if(!ReferralIds.isEmpty()){
            RecoveryLst = [select Id,Referral__c from Recovery__c where Referral__c IN :ReferralIds];
            if(!RecoveryLst.isEmpty()){
                for(Recovery__c obj: RecoveryLst){
                    RefferalRecoveryIdMap.put(obj.Referral__c,obj.Id);
                }
            }
        }
        system.debug('RefferalRecoveryIdMap '+RefferalRecoveryIdMap);
        if(!RefferalRecoveryIdMap.isEmpty()){
            MedicalLst = [select Id,Recovery__c from Medical_Review__c where Recovery__c IN :RefferalRecoveryIdMap.values()];
            if(!MedicalLst.isEmpty()){
                for(Medical_Review__c obj1: MedicalLst){
                    RecoveryMedRevIdMap.put(obj1.Recovery__c,obj1.Id);
                }
            }
        }
        system.debug('RecoveryMedRevIdMap '+RecoveryMedRevIdMap);
        if(!RecoveryMedRevIdMap.isEmpty()){
            TissueLst = [select Id,Medical_Review__c,Is_Child_Record__c,Eye__c from Tissue_Evaluation__c where Medical_Review__c IN :RecoveryMedRevIdMap.values()];
            if(!TissueLst.isEmpty()){
                for(Tissue_Evaluation__c obj2: TissueLst){
                    MedRevTissuEvaIdMap.put(obj2.Id,obj2.Medical_Review__c);
                }
            }
        }
        system.debug('MedRevTissuEvaIdMap '+MedRevTissuEvaIdMap);
        if(!MedRevTissuEvaIdMap.isEmpty()){
            RequestLst = [select Id,Tissue_Evaluation__c from Request__c where Tissue_Evaluation__c IN :MedRevTissuEvaIdMap.keySet()];
            if(!RequestLst.isEmpty()){
                for(Request__c obj3: RequestLst){
                    TissuEvalReqIdMap.put(obj3.Tissue_Evaluation__c,obj3.Id);
                }
            }
        }
        system.debug('TissuEvalReqIdMap '+TissuEvalReqIdMap);
        if(!TissuEvalReqIdMap.isEmpty()){
            PlacementLst = [select Id,Request__c from Placement__c where Request__c IN :TissuEvalReqIdMap.values()];
            if(!PlacementLst.isEmpty()){
                for(Placement__c obj4: PlacementLst){
                    ReqPlacementIdMap.put(obj4.Request__c,obj4.Id);
                }
            }
        }
        system.debug('ReqPlacementIdMap '+ReqPlacementIdMap);
        //Now create consolidated record with above details.
        for(Referral__c obj5: scope){
        	Consolidated_Report__c newobj6 = new Consolidated_Report__c();
            newobj6.Referral__c = obj5.Id;
            if(RefferalRecoveryIdMap.containsKey(obj5.Id)){
            	newobj6.Recovery__c = RefferalRecoveryIdMap.get(obj5.Id);    
            }
            if(newobj6.Recovery__c != null && RecoveryMedRevIdMap.containsKey(newobj6.Recovery__c)){
            	newobj6.Medical_Review__c = RecoveryMedRevIdMap.get(newobj6.Recovery__c);    
            }
            if(newobj6.Medical_Review__c != null){
            	for(Tissue_Evaluation__c obj: TissueLst){
                	if(obj.Is_Child_Record__c){
                    	Consolidated_Report__c newobj2 = new Consolidated_Report__c();
                        newobj2.Referral__c = newobj6.Referral__c;
                        newobj2.Recovery__c = newobj6.Recovery__c;
                        newobj2.Medical_Review__c = newobj6.Medical_Review__c;
                        newobj2.Tissue_Evaluation__c = obj.Id;
                        system.debug('value is there for request '+TissuEvalReqIdMap.containsKey(newobj2.Tissue_Evaluation__c));
                        if(newobj2.Tissue_Evaluation__c != null && TissuEvalReqIdMap.containsKey(newobj2.Tissue_Evaluation__c))
                        	newobj2.Request__c = TissuEvalReqIdMap.get(newobj2.Tissue_Evaluation__c);
                        system.debug('value is there placement '+TissuEvalReqIdMap.containsKey(newobj2.Tissue_Evaluation__c));
                        if(newobj2.Request__c != null && ReqPlacementIdMap.containsKey(newobj2.Request__c))
                        	newobj2.Placement__c = ReqPlacementIdMap.get(newobj2.Request__c);
                        ConsolidatedLst.add(newobj2);
                    }else{
                        if(obj.Eye__c == 'OD'){
                        	Consolidated_Report__c newobj = new Consolidated_Report__c();
                            newobj.Referral__c = newobj6.Referral__c;
                            newobj.Recovery__c = newobj6.Recovery__c;
                            newobj.Medical_Review__c = newobj6.Medical_Review__c;
                            newobj.Tissue_Evaluation__c = obj.Id;
                            if(newobj.Tissue_Evaluation__c != null && TissuEvalReqIdMap.containsKey(newobj.Tissue_Evaluation__c))
                                newobj.Request__c = TissuEvalReqIdMap.get(newobj.Tissue_Evaluation__c);
                            if(newobj.Request__c != null && ReqPlacementIdMap.containsKey(newobj.Request__c))
                                newobj.Placement__c = ReqPlacementIdMap.get(newobj.Request__c);
                            ConsolidatedLst.add(newobj);
                            
                        }else if(obj.Eye__c == 'OS'){
                            Consolidated_Report__c newobj1 = new Consolidated_Report__c();
                            newobj1.Referral__c = newobj6.Referral__c;
                            newobj1.Recovery__c = newobj6.Recovery__c;
                            newobj1.Medical_Review__c = newobj6.Medical_Review__c;
                            newobj1.Tissue_Evaluation__c = obj.Id;
                            if(newobj1.Tissue_Evaluation__c != null && TissuEvalReqIdMap.containsKey(newobj1.Tissue_Evaluation__c))
                                newobj1.Request__c = TissuEvalReqIdMap.get(newobj1.Tissue_Evaluation__c);
                            if(newobj1.Request__c != null && ReqPlacementIdMap.containsKey(newobj1.Request__c))
                                newobj1.Placement__c = ReqPlacementIdMap.get(newobj1.Request__c);
                            ConsolidatedLst.add(newobj1);
                        }
                    }   
                }                
            }
    	}
        if(!ConsolidatedLst.isEmpty())
        	upsert ConsolidatedLst;
    }
    global void finish(Database.BatchableContext BC){}
}