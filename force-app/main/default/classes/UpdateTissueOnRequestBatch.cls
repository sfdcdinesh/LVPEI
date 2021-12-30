global class UpdateTissueOnRequestBatch implements Database.Batchable<sObject>{
	global Database.QueryLocator start(Database.BatchableContext BC){
        string query = 'select Id,Request__c,Select_Tissue__c from Placement__c';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Placement__c> scope){
        Map<Id,Id> RequestTissueMap = new Map<Id,Id>();
        for(Placement__c pcm: scope){
            if(string.isNotBlank(pcm.Select_Tissue__c)){
                RequestTissueMap.put(pcm.Request__c,pcm.Select_Tissue__c);
            }
        }
        
        if(!RequestTissueMap.isEmpty()){
            List<Request__c> ReqLst = [Select Id,Tissue_Evaluation__c from Request__c where Id IN :RequestTissueMap.keySet()];
            for(Request__c obj : ReqLst){
                if(RequestTissueMap.containsKey(obj.Id)){   
                    obj.Tissue_Evaluation__c = RequestTissueMap.get(obj.Id);
                }
            }
            
            if(!ReqLst.isEmpty()){
                update ReqLst;
            }
        }
    }
    global void finish(Database.BatchableContext BC){}
}