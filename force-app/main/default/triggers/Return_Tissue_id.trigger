trigger Return_Tissue_id on Tissue_Return__c (before insert, before update, after insert) {
    Map<string,string> PlacementIdTissueIdMap = new Map<string,string>();
    Map<string,string> PlacementNameTissueIdMap = new Map<string,string>();
    Map<Id,Placement__c> PlacementMap;
    set<ID> PlacementIds = new set<ID>();
    List<Placement__c> PlacementLst = new List<Placement__c>();
    set<ID> TissueIds = new set<ID>();
    set<ID> RequestIds = new set<ID>();
    
    List<Tissue_Evaluation__c> TissueEvalLst = new List<Tissue_Evaluation__c>();
    List<Request__c> reqList = new List<Request__c>();
    
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        //Check User Branch
        Map<String, Referral__c> params = new Map<String, Referral__c>();
        Flow.Interview.Check_User_In_Branch_Team userflow = new Flow.Interview.Check_User_In_Branch_Team(params);
        userflow.start();
        // Obtain the results
        Boolean result = Boolean.valueOf(userflow.getVariableValue('ReturnValue'));
        System.debug('Flow returned ' + result);
        if(result){
            for(Tissue_Return__c ts : trigger.new){
                system.debug('ts data==> '+ts);
                if(string.isNotBlank(ts.Tissue_Id1__c) && string.isNotBlank(ts.Placement__c)){
                    PlacementIdTissueIdMap.put(ts.Placement__c,ts.Tissue_Id1__c);
                }
            }
            
            if(!PlacementIdTissueIdMap.keyset().isEmpty()){
                PlacementMap = new Map<Id,Placement__c>([Select id,Name,Tissue_Disposition__c,Select_Tissue__r.Name From Placement__c where id IN :PlacementIdTissueIdMap.keySet()]);
            }
            
            for(Tissue_Return__c ts : trigger.new){
                system.debug('Current tissue record '+ts);
                if(string.isNotBlank(ts.Tissue_Id1__c) && string.isNotBlank(ts.Placement__c) && PlacementMap.containsKey(ts.Placement__c)){
                    if(ts.Tissue_Id1__c != PlacementMap.get(ts.Placement__c).Select_Tissue__r.Name){
                        ts.addError('Please provide correct Tissue id along with placement data.');
                    }
                }
            }
        }else{
            for(Tissue_Return__c ts: trigger.new){
                ts.addError('Current Loggedin User not Related Any Branch, Hence Can not Proceed Further');
            }
        }
        
        
    }
    
    if(Trigger.isAfter && Trigger.isInsert){
        for(Tissue_Return__c tr: trigger.new){
            if(tr.Placement__c != null){
                PlacementIds.add(tr.Placement__c);    
            }
        }
        if(!PlacementIds.isEmpty()){
            PlacementLst = [select id,Name,Tissue_Disposition__c,Request__c,Placement_Status__c,Select_Tissue__c from Placement__c where Id IN :PlacementIds];
            if(!PlacementLst.isEmpty()){
                for(Placement__c pm: PlacementLst){
                    TissueIds.add(pm.Select_Tissue__c);     
                    RequestIds.add(pm.Request__c);     
                    
                    pm.Tissue_Disposition__c = 'Returned';
                    pm.Placement_Status__c = 'Returned';
                }
                update PlacementLst;
            }
            if(!TissueIds.isEmpty())
            {
                TissueEvalLst = [select id,Name,Approval_Outcome__c,Last_Approval_Outcome__c from Tissue_Evaluation__c where Id IN :TissueIds];
                if(!TissueEvalLst.isEmpty())
                {
                    for(Tissue_Evaluation__c te: TissueEvalLst)
                    {
                        te.Approval_Outcome__c = te.Last_Approval_Outcome__c;
                        te.Tissue_Disposition__c = 'Returned';
                    }
                    update TissueEvalLst;
                }
            }
            if(!RequestIds.isEmpty())
            {
                reqList = [select id,Name, Request_Status__c from Request__c where Id IN :RequestIds];
                if(!reqList.isEmpty()){
                    for(Request__c req: reqList){    
                        req.Request_Status__c = 'Returned';
                    }
                    update reqList;
                }
            }        
        }
    }
}