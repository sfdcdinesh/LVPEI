trigger Placement on Placement__c (before insert, before update, after insert) {
    
    set<ID> RequestIds = new set<ID>();
    List<Request__c> ReqLst = new List<Request__c>();
    
    if(Trigger.isAfter && Trigger.isInsert){
        
        for(Placement__c pm: trigger.new){
            
            if(pm.Request__c != null){
                RequestIds.add(pm.Request__c);
            }
        }
        if(!RequestIds.isEmpty())
        {
            ReqLst = [select id,Name, Request_Status__c from Request__c where Id IN :RequestIds];
            if(!ReqLst.isEmpty()){
                for(Request__c req: ReqLst){    
                    req.Request_Status__c = 'Fulfilled';
                }
                update ReqLst;
            }
        }
        
    }
    
    
}