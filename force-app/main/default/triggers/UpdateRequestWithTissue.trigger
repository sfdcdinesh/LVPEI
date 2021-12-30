trigger UpdateRequestWithTissue on Placement__c (after insert, after update){
    Map<Id,Id> RequestTissueMap = new Map<Id,Id>();
    if(Trigger.isAfter && Trigger.isInsert || Trigger.isUpdate){
        for(Placement__c pcm: trigger.new){
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
}