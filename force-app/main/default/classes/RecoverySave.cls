public with sharing class RecoverySave {
    
    public static List<Consult__c> listOfConsults = new List<Consult__c>();
    //Execute Flow for Checking UserId present in BranchTeam
    @AuraEnabled
    public static Boolean checkUserBranch(){
        Map<String, Referral__c> params = new Map<String, Referral__c>();
        Flow.Interview.Check_User_In_Branch_Team userflow = new Flow.Interview.Check_User_In_Branch_Team(params);
        userflow.start();
        // Obtain the results
        Boolean result = Boolean.valueOf(userflow.getVariableValue('ReturnValue'));
        System.debug('Flow returned ' + result);
        return result;
    }
    @AuraEnabled
    //Getting Current User
    public static User getCurrentUser() {
        User toReturn = [SELECT Id, FirstName, LastName,Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        return toReturn;
    }
    @AuraEnabled
    //Getting Referral Information
    public static Recovery__c getRefId(String RecId){
        system.debug('hey' + RecId);
        return [Select Referral__c,Condition_of_superior_LId__c,OS_Condition_of_superior_LId__c,Condition_of_inferior_Lid__c,
                OS_Condition_of_inferior_Lid__c, Condition_of_conjuctiva__c, OS_Condition_of_conjunctiva__c, Codition_of_epithelium__c,
                OS_Condition_of_Epithelium__c, Condition_of_corneal_stroma__c, OS_Condition_of_corneal_stroma__c, Condition_of_intraocular__c,
                OS_Condition_of_Intraocular__c, Iris_color__c, OS_Iris_color__c from Recovery__c where id=:RecId];
    }
    @AuraEnabled
    //Getting Referral ID
    public static Referral__c getReferralId(String donorId) {
        system.debug('hey' + donorId);
        return [select Name,Death_Notification_Consignment_Date_Time__c, Age_of_Donor__c,Gender__c,First_Name__c,Last_Name__c,Date_Time_of_Death__c,recoverycount__c,Branch_Name__c,Referral_Outcome__c from Referral__c where id=:donorId limit 1];
    }
    @AuraEnabled
    public static Referral__c getDetails(String refId){
        return [select Name from Referral__c where id=:refId limit 1];
        
    }
    @AuraEnabled
    //Getting and Storing Lookup Values
    public static Map<String,sObject> getLookups(Id recID){
        system.debug('Gm' + recID);
        Map<String,sObject> lookupList = new Map<String,sObject>();
        Recovery__c rec = [select Physical_Inspection_By__c,Recovery_completed_by__c,Assisted_by__c,Condition_of_superior_LId__c,
                           Sclera_Preserved_By__c,Technician_performing_physicalAssessmen__c,Collected_By__c,Performed_by__c,
                           OS_Performed_by__c from Recovery__c where id=:recID];
        
        //lookupList.put('rec',rec);
        if(rec.Physical_Inspection_By__c!=null){
            Contact con1 = [select Id,Name from Contact where id=:rec.Physical_Inspection_By__c];
            lookupList.put('con1',con1);
        }
        else{
            lookupList.put('con1',null);
        } 
        if(rec.Recovery_completed_by__c!=null){
            Contact con2 = [select Id,Name from Contact where id=:rec.Recovery_completed_by__c];
            lookupList.put('con2',con2);
        }
        else{
            lookupList.put('con2',null);
        } 
        if(rec.Assisted_by__c!=null){
            Contact con3 = [select Id,Name from Contact where id=:rec.Assisted_by__c];
            lookupList.put('con3',con3);
        }
        else{
            lookupList.put('con3',null);
        } 
        if(rec.Sclera_Preserved_By__c!=null){
            Contact con4 = [select Id,Name from Contact where id=:rec.Sclera_Preserved_By__c];
            lookupList.put('con4',con4);
        }
        else{
            lookupList.put('con4',null);
        } 
        if(rec.Technician_performing_physicalAssessmen__c!=null){
            Contact con5 = [select Id,Name from Contact where id=:rec.Technician_performing_physicalAssessmen__c];
            lookupList.put('con5',con5);
        }
        else{
            lookupList.put('con5',null);
        } 
        if(rec.Collected_By__c!=null){
            Contact con6 = [select Id,Name from Contact where id=:rec.Collected_By__c];
            lookupList.put('con6',con6);
        }
        else{
            lookupList.put('con6',null);
        } 
        if(rec.Performed_by__c!=null){
            Contact con7 = [select Id,Name from Contact where id=:rec.Performed_by__c];
            lookupList.put('con7',con7);
        }
        else{
            lookupList.put('con7',null);
        } 
        if(rec.OS_Performed_by__c!=null){
            Contact con8 = [select Id,Name from Contact where id=:rec.OS_Performed_by__c];
            lookupList.put('con8',con8);
        }
        else{
            lookupList.put('con8',null);
        } 
        return lookupList;
    }
    @AuraEnabled
    //Saving Recovery Record
    public static Recovery__c save(Recovery__c recovery, List<Consult__c> conList,Id firstlookup,Id secondlookup,Id thirdlookup,Id fourthlookup,Id fifthlookup,Id sixthlookup,Id seventhlookup, Id ninelookup, Id tenlookup, Id recoveryID){
        try{
        	system.debug('recovery'+recovery);
            //system.debug('rec Superior'+recovery.Condition_of_superior_LId__c);
            //String superior = recovery.Condition_of_superior_LId__c;
            //recovery.Condition_of_superior_LId__c = superior.replace(',', ';');
            recovery.Physical_Inspection_By__c=firstlookup;
            recovery.Recovery_completed_by__c=secondlookup;
            recovery.Assisted_by__c=thirdlookup;
            recovery.Recovery_completed_by__c=fourthlookup;
            recovery.Sclera_Preserved_By__c=fifthlookup;
            recovery.Technician_performing_physicalAssessmen__c=sixthlookup;
            recovery.Collected_By__c=seventhlookup;
            recovery.Performed_by__c=ninelookup;
            recovery.OS_Performed_by__c=tenlookup;
          
            recovery.Cornea_Preservation_Date_Time__c=recovery.Tissue_recovery_date_time__c;
            recovery.Cornea_preserved_by__c=recovery.Recovery_completed_by__c;
            if(recoveryID != null){
                recovery.Id = recoveryID;
                update recovery;
            }
            else{
                insert recovery;
            }
            for(Consult__c c : conList){
                c.Recovery__c = recovery.Id;
            }
            update conList;
            if(string.isNotBlank(recovery.Id)){
                recovery = [select Name from Recovery__c where Id = :recovery.Id];
                
                 //sangram logic to update Tissue_Evaluation__c Recovery_Intent__c 
                List<Tissue_Evaluation__c> tissueList = new List<Tissue_Evaluation__c>();
                for(Tissue_Evaluation__c tissue : [SELECT Id, Name, Recovery_Intent__c, Recovery__c,Recovery__r.Recovery_Intent__c 
                                                   FROM Tissue_Evaluation__c where Recovery__c =: recovery.Id]){
                                                       tissue.Recovery_Intent__c  =  tissue.Recovery__r.Recovery_Intent__c;
                                                       tissueList.add(tissue);
                                                   }
                update tissueList;
            }
            
        }catch(Exception ex){
            system.debug('Exception '+ex.getMessage()+'At line number '+ex.getLineNumber());
        }
        return recovery;
    }
    
    //Record ID Starts
    @AuraEnabled
    public static Recovery__c getRecoveryName(Id recId){
        system.debug(recId);
        return [select Name from Recovery__c where Id=:recId];
    }
    
    
    @AuraEnabled
    //Saving Consult
    public static Consult__c saveConsults(Consult__c consult){
        insert consult;
        
        listOfConsults.add(consult);
        System.debug('listOfConsults'+listOfConsults[0]);
        return consult;
    }
    
    @AuraEnabled
    //Getting List of Consults
    public static List<Consult__c> getConsults(){
        return listOfConsults;
    }
    
    @AuraEnabled
    //Getting List of Consults
    public static List<Consult__c> fetchConsults(string RecoveryId){
        return [select Id,Name,Date_Time__c,Topic_Subject_matter__c,Discussion__c from Consult__c where Recovery__c = :RecoveryId];
    }
    
    @AuraEnabled
    //Getting Donor Count
    public static Integer getDonorCount(Id parentId){
        system.debug('ParentId' + parentId);
        Integer donorCount = 0;
        List<AggregateResult> results = [Select count(Id) from Recovery__c where Referral__c=:parentId];
        if(results!=null){
            system.debug('donorCount'+ results);
            donorCount =  (Integer)results[0].get('expr0');
        }
        return donorCount;
    }
    
    @AuraEnabled
    //Getting Picklist Values
    public static List<String> getSelectOptions(sObject obj, string fld) {
        List<String> allOpts = new List<String>();        
        Schema.sObjectType objType = obj.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        Map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        List<Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();
        for(Schema.PicklistEntry a : values){
            allOpts.add(a.getValue());
        }
        allOpts.sort();
        return allOpts;
    }
    
}