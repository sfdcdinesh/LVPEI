//replaced insert with upsert
public with sharing class TissueEvaluationSave {
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
    public static InitWrapper fetchInitData(string placID){
        InitWrapper obj = new InitWrapper();
        try{
            obj.user = getCurrentUser();
        }
        catch(Exception ex){
            system.debug('Exception '+ex.getMessage()+' At line number '+ex.getLineNumber());
        }
        return obj;
    }
    
    public class InitWrapper{
        @AuraEnabled
        public User user;
    }
    
    public static List<Tissue_Evaluation__c> tissue = new List<Tissue_Evaluation__c>();
    
    
    @AuraEnabled 
    public static User getCurrentUser() {
        User toReturn = [SELECT Id, FirstName, LastName, Name, Username FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        return toReturn;
    }
    
    @AuraEnabled
    public static Tissue_Evaluation__c fetchTissue(string RecId){
        return [select Id,Donor_ID__c,Medical_Review__c,Recovery__c,Circulator__c,Cornea_Suitability_Determined_By__c,EK_Tech__c,Final_Review_and_Approval_Done_By__c,Slit_Lamp_Eval_Performed_By__c,Slit_Lamp_Technician__c,Specular_Evaluation_Done_By__c,Specular_Technician__c,Tissue_Processed_By__c,Name,Eye__c,Tissue_Type__c, Quarter__c, Tissue_Sub_Type__c, Was_cornea_processed_under_a_LFH__c, Preservation_Medium__c, Media_Lot__c, Media_Expiration_Date__c,
                Tissue_Expiry_Date__c,Recovery_Intent__c, Specular_Evaluation_Done__c, Specular_Evaluation_Date_Time__c, Cell_Count_per_mm2__c, Number_of_Fields__c,
                Pachymetry_microns__c,Slit_Lamp_Done__c,Clear_and_Intact__c,Haze__c, Debris__c, If_Yes_Describe__c, Epithelium_Comments__c,
                Exposure__c, Exposure_Location__c, Exposure_Percentage__c, Sloughing__c, Percent_of_Total_Cornea__c, Clear_and_Compact__c, Edema__c,
                Edema_Location__c, Striae__c, Striae_Location__c, Relative_number_of_Striae__c, Opacities_1__c, Opacities1_Length_Diameter__c, 
                Opacities1_Location_at__c, Opacities1_mm_on_Button_From_LimbusDepth__c, Arcus__c, Clear_Zone__c, Infiltrate__c, Stroma_Comments__c,
                Opacities_2__c, Opacities2_Length_Diameter__c, Opacities2_Location_at__c, Opacities2_mm_on_Button_From_LimbusDept__c, Folds__c, 
                Relative_number_of_folds__c, Defects__c, Defects_Describe__c, Stress_Lines__c, Relative_Number_of_Stress_Lines__c, Stress_Lines_Location__c,
                Cell_Dropouts__c, Cell_Dropout_Location__c, Polymegathism__c, Pleomorphism__c, Endothelium_Defects__c, Endothelium_If_Yes_Describe__c,
                Endothelium_Comments__c, Jaundice__c, Lens__c, Scleral_Rim_Information__c, Scleral_Rim_2mm_or_greater_circumferen__c,
                Scleral_rim_is_greater_than_2mm_Describe__c, Pre_Cut__c, Cut_Type__c, Cut_Parameters__c, Tissue_Processed_for__c, Date_Time_Processed__c,
                Graft_Thickness_microns__c, Graft_Diameter_mm__c, Comments_Post_Cut__c, Endothelial_Cell_Density_mm2__c, Post_Cut_Epithelium__c, 
                Anterior_Stroma__c,Posterior_Stroma__c, Descemet_s__c, Post_Cut_Endothelium__c, Post_Cut_Preservation_Medium__c, Post_Cut_Media_lot__c,
                Post_Cut_Media_Expiration_Date_Time__c, Slit_Lamp_Date_Time__c, Specular_Date_Time__c, Additional__c, Tissue_Suitability__c, PK__c,
                EK__c, KLA__c, Tectonic_Therapeutic__c, ALK__c, K_Pro__c, Stroma__c, Epithelium__c, Prior_Refractive_Surgery__c, Stroma_Infractive__c, 
                Other__c, Scar__c, Foreign_Body__c, If_Other__c, Descemet_s_Membrane__c, Endothelium__c, Slit_Lamp_Evaluation__c, Specular_Evaluation__c,
                Evaluations_Comments__c, Tissue_Returned__c, Sterility_Compromise__c, Issues_in_Transportation_Logistics__c, Outcome_Slit_Lamp_Date_Time__c,
                Approval_Outcome__c, Tissue_Disposition__c, Category__c, Other_Reasons__c, Category_Comments__c, Comments_for_Media_Issue__c,
                Comments_for_Tissue_Damage_Transport_Log__c, Comments_for_Cold_Chain_Break__c, Comments_for_Preservation_Issue__c, Comments_for_Surgeon_Issue__c,
                Comments_for_Damage_During_Preparation__c, Comments_for_Post_Distribution_Issues__c, Comments_for_Tissue_Expiry__c, Sub_Category__c, 
                Date_Time_of_Final_Review_Approval__c,Name_of_Donor_TissueEvalauation__c,Date_Time_of_Death_TissueEvaluation__c,Age__c,Gender__c,Is_Child_Record__c,Descemet_Comments__c from Tissue_Evaluation__c where Id = :RecId];
    }
    
    @AuraEnabled    
    public static Tissue_Evaluation__c Savetissue(Tissue_Evaluation__c TisEval, Id firstlookup,Id secondlookup, Id thirdlookup, Id fourthlookup, Id fifthlookup, Id sixthlookup, Id seventhlookup, Id eighthlookup, Id ninthlookup){
        system.debug('TisEvaluation'+TisEval);
        List<Tissue_Evaluation__c> upsertLst = new List<Tissue_Evaluation__c>();
        TisEval.Specular_Evaluation_Done_By__c = firstlookup;
        TisEval.Cornea_Suitability_Determined_By__c = secondlookup;
        TisEval.Slit_Lamp_Eval_Performed_By__c = thirdlookup;
        TisEval.Final_Review_and_Approval_Done_By__c = fourthlookup;
        TisEval.Tissue_Processed_By__c = fifthlookup;
        TisEval.Slit_Lamp_Technician__c = sixthlookup;
        TisEval.Specular_Technician__c = seventhlookup;
        TisEval.EK_Tech__c = eighthlookup;
        TisEval.Circulator__c = ninthlookup;  
        TisEval.Cornea_Suitability_Determined_By__c = TisEval.Slit_Lamp_Eval_Performed_By__c;
        TisEval.Last_Approval_Outcome__c=TisEval.Approval_Outcome__c;
        //TisEval.Date_Time_Processed__c = r.Tissue_recovery_date_time__c;
       // TisEval.Outcome_Slit_Lamp_Date_Time__c = r.Tissue_recovery_date_time__c;
        Recovery__c rec = [Select Cornea_Preservation_Date_Time__c from Recovery__c where id=:TisEval.Recovery__c];
        System.debug('CorneaDate-->'+ rec.Cornea_Preservation_Date_Time__c);
        DateTime current_datetime = datetime.now();
        if(rec.Cornea_Preservation_Date_Time__c!=null){
            decimal age = decimal.valueof((current_datetime.getTime()-rec.Cornea_Preservation_Date_Time__c.getTime())/(60*60));
            Integer aging = integer.valueOf(age/1000)/24;
            TisEval.Aging__c = aging;
            system.debug('Aging-->' +TisEval.Aging__c );
        }
        upsert TisEval;
        return TisEval;        
    }
    
    @AuraEnabled
    public static string createChildRecord(Tissue_Evaluation__c parentRec, string newTissueId){
        string result = 'Failure';
        List<Attachment> ChildAtt = new List<Attachment>();
        if(parentRec != null && string.isNotBlank(newTissueId)){
            system.debug('parent record '+parentRec);
            Tissue_Evaluation__c parentRec1 = fetchTissue(parentRec.Id);
            system.debug('parent record '+parentRec1);
            Tissue_Evaluation__c childRec = parentRec1.clone();
            childRec.Is_Child_Record__c = true;
            childRec.Quarter__c = parentRec.Quarter__c;
            childRec.Name = newTissueId;
            system.debug('child record '+childRec);
            insert childRec;
            system.debug('child record '+childRec);
            List<Attachment> attachments = getAttachments(parentRec.Id);
            if(!attachments.isEmpty()){
                for(Attachment att: attachments){
                    Attachment obj = new Attachment();
                    obj = att.clone();
                    obj.ParentId = childRec.Id;
                    ChildAtt.add(obj);
                }
                if(!ChildAtt.isEmpty()){
                    insert ChildAtt;
                }
            }
            result = 'Success';
        }
        return result;
    }
    
    @AuraEnabled
    public static String getPreviousTissue(Id parentId){
        Tissue_Evaluation__c tis =  [select Eye__c from Tissue_Evaluation__c where Medical_Review__c=:parentId];
        return tis.Eye__c;
    }
    
    @AuraEnabled
    public static Attachment saveNewAttachment(Blob base64Data ,String fileName, String fileType, Id parentId){
        Attachment att = new Attachment();
        try{                        
            att.Body = base64Data;
            att.ParentId = parentId;
            att.Name = fileName;
            att.ContentType = fileType;            
            upsert att;  
                           
             
        /*  ContentVersion cv = new ContentVersion();
            cv.ContentLocation = 'S';
            cv.PathOnClient = fileName;
            cv.Origin = 'H';            
            cv.Title = fileName;            
            cv.VersionData = EncodingUtil.base64Decode(base64Data);            
            insert cv;
            ContentVersion cversion = [select ContentDocumentId from ContentVersion where Id =: cv.Id];
            ContentDocumentLink cl = new ContentDocumentLink(LinkedEntityId = parentId, ContentDocumentId = cversion.ContentDocumentId, ShareType = 'V');
            insert cl;
          */  
        }
        catch(Exception e){}
        return att;
        
    }
    
   /* @AuraEnabled
    public static List<Attachment> getAttachment(Id tissueId){
        List<Attachment> getAtt = [Select id, ParentId, Body from Attachment where ParentId =: tissueId];
        System.debug(getAtt[0]);
        System.debug(getAtt[1]);
        if(getAtt != null)
            return getAtt;
        else
            return null;
    }*/
    
    
    //Lookup Starts
     @AuraEnabled
    public static Map<String,sObject> getLookups(Id tisID){
        system.debug('Gm' + tisID);
        Map<String,sObject> lookupList = new Map<String,sObject>();
        Tissue_Evaluation__c tis = [select Tissue_Processed_By__c,Specular_Evaluation_Done_By__c,Cornea_Suitability_Determined_By__c,
                                    Slit_Lamp_Eval_Performed_By__c,Final_Review_and_Approval_Done_By__c,Slit_Lamp_Technician__c,
                                    Specular_Technician__c,EK_Tech__c,Circulator__c from Tissue_Evaluation__c where id=:tisID];
        
        
        if(tis.Tissue_Processed_By__c!=null){
        Contact con1 = [select Id,Name from Contact where id=:tis.Tissue_Processed_By__c];
        lookupList.put('con1',con1);
        }
        else{
            lookupList.put('con1',null);
        } 
        if(tis.Specular_Evaluation_Done_By__c!=null){
        Contact con2 = [select Id,Name from Contact where id=:tis.Specular_Evaluation_Done_By__c];
        lookupList.put('con2',con2);
        }
        else{
            lookupList.put('con2',null);
        } 
        if(tis.Cornea_Suitability_Determined_By__c!=null){
        Contact con3 = [select Id,Name from Contact where id=:tis.Cornea_Suitability_Determined_By__c];
        lookupList.put('con3',con3);
        }
        else{
            lookupList.put('con3',null);
        } 
        if(tis.Slit_Lamp_Eval_Performed_By__c!=null){
        Contact con4 = [select Id,Name from Contact where id=:tis.Slit_Lamp_Eval_Performed_By__c];
        lookupList.put('con4',con4);
        }
        else{
            lookupList.put('con4',null);
        } 
        if(tis.Final_Review_and_Approval_Done_By__c!=null){
        Contact con5 = [select Id,Name from Contact where id=:tis.Final_Review_and_Approval_Done_By__c];
        lookupList.put('con5',con5);
        }
        else{
            lookupList.put('con5',null);
        } 
          if(tis.Slit_Lamp_Technician__c!=null){
        Contact con6 = [select Id,Name from Contact where id=:tis.Slit_Lamp_Technician__c];
        lookupList.put('con6',con6);
        }
        else{
            lookupList.put('con6',null);
        } 
        if(tis.Specular_Technician__c!=null){
        Contact con7 = [select Id,Name from Contact where id=:tis.Specular_Technician__c];
        lookupList.put('con7',con7);
        }
        else{
            lookupList.put('con7',null);
        } 
        if(tis.EK_Tech__c!=null){
        Contact con8 = [select Id,Name from Contact where id=:tis.EK_Tech__c];
        lookupList.put('con8',con8);
        }
        else{
            lookupList.put('con8',null);
        } 
        if(tis.Circulator__c!=null){
        Contact con9 = [select Id,Name from Contact where id=:tis.Circulator__c];
        lookupList.put('con9',con9);
        }
        else{
            lookupList.put('con9',null);
        } 
        System.debug('------>' + lookupList);
        return lookupList;
    }
    //Lookup Ends
    
    
    //Record ID Starts
    @AuraEnabled
    public static Tissue_Evaluation__c getTissueEvalName(Id tisEvalId){
        system.debug(tisEvalId);
        return [select Name from Tissue_Evaluation__c where Id=:tisEvalId];
    }
    //Record ID Ends
    
    @AuraEnabled
    public static Recovery__c getRecovery(string recoveryId){
        Recovery__c rec= [select Cornea_Preservation_Date_Time__c,Recovery_Intent__c,Tissue_recovery_date_time__c from Recovery__c where Id=:recoveryId];
        return rec;
        
    }
    
    @AuraEnabled
    public static sObject getDonorId(string recid){
        system.debug('DonorId-->'+recid);
       
        string parent = recid.substring(0,3);
        system.debug(parent);
        if(parent=='a0w'){
             List<Tissue_Evaluation__c> teList=[select Name,Approval_Outcome__c,Tissue_Disposition__c,Medical_Review__r.Donor_Name_Id__c,Recovery__r.Recovery_Intent__c,Medical_Review__c,Recovery__r.Referral__r.Date_Time_of_Death__c,Recovery__r.Cornea_Preservation_Date_Time__c,Recovery__r.Donor_Name__c,Recovery__r.Referral__r.Age_of_Donor__c,Recovery__r.Referral__r.Gender__c,Branch_Name__c
                    from Tissue_Evaluation__c where id=:recid];
            System.debug('teListteList'+teList[0].Medical_Review__r.Donor_Name_Id__c);
            return [select Name,Medical_Review__r.Donor_Name_Id__c,Recovery__r.Recovery_Intent__c,Medical_Review__c,Medical_Review__r.HBsAG__c,Medical_Review__r.HCV__c,Medical_Review__r.HIV_I_II__c,Medical_Review__r.Syphilis__c,Recovery__r.Referral__r.Date_Time_of_Death__c,Recovery__r.Donor_Name__c,Recovery__r.Referral__r.Age_of_Donor__c,Recovery__r.Referral__r.Gender__c,Recovery__r.Cornea_Preservation_Date_Time__c, Recovery__r.Tissue_recovery_date_time__c,Branch_Name__c
                    from Tissue_Evaluation__c where id=:recid];
        }
        else{
            return [select Donor_Name_Id__c,Death_Date_Time__c,Recovery__r.Recovery_Intent__c,HBsAG__c,HCV__c,HIV_I_II__c,Syphilis__c,Recovery__c,Recovery__r.Donor_Name__c,Recovery__r.Referral__r.Age_of_Donor__c,Recovery__r.Referral__r.Gender__c,Recovery__r.Cornea_Preservation_Date_Time__c, Recovery__r.Tissue_recovery_date_time__c,Branch_Name__c 
                    from Medical_Review__c where id=:recid];       
        }
    }
    
    @AuraEnabled
    public static Integer getTissueCount(Id parentId){
        system.debug('ParentId' + parentId);
        Integer tissueCount = 0;
        List<AggregateResult> results = [Select count(Id) from Tissue_Evaluation__c where Medical_Review__c=:parentId];
        if(results!=null){
            system.debug('tissueCount'+ results);
            tissueCount =  (Integer)results[0].get('expr0');
        }
        return tissueCount;
    }
    
    @AuraEnabled
    public static List<Integer> tissueInventory(){
        List<Integer> tissueInventory = new List<Integer>();
        Integer transplantWG = 0;
        Integer transplantWC = 0;
        Integer transplantS = 0;
        Integer researchWG = 0;
        Integer researchWC = 0;
        Integer researchS = 0;
        Integer trainingWG = 0;
        Integer trainingWC = 0;
        Integer trainingS = 0;
        Integer QuarantineWG = 0;
        Integer QuarantineWC = 0;
        Integer QuarantineS = 0;
        
        
        //Transplant
        List<AggregateResult> results1 = [Select count(Id) from Tissue_Evaluation__c where Approval_Outcome__c='Transplant' And Tissue_Type__c='Whole Globe'];
        if(results1!=null){
            transplantWG =  (Integer)results1[0].get('expr0'); 
            tissueInventory.add(transplantWG);
        }
        List<AggregateResult> results2 = [Select count(Id) from Tissue_Evaluation__c where Approval_Outcome__c='Transplant' And Tissue_Type__c='Cornea'];
        if(results2!=null){
            transplantWC =  (Integer)results2[0].get('expr0'); 
            tissueInventory.add(transplantWC);
        }
        List<AggregateResult> results3 = [Select count(Id) from Tissue_Evaluation__c where Approval_Outcome__c='Transplant' And Tissue_Type__c='Sclera'];
        if(results3!=null){
            transplantS =  (Integer)results3[0].get('expr0'); 
            tissueInventory.add(transplantS);
        }
        
        // Research
        List<AggregateResult> results4 = [Select count(Id) from Tissue_Evaluation__c where Approval_Outcome__c='Placed:Research' And Tissue_Type__c='Whole Globe'];
        if(results4!=null){
            researchWG =  (Integer)results4[0].get('expr0'); 
            tissueInventory.add(researchWG);
        }
        List<AggregateResult> results5 = [Select count(Id) from Tissue_Evaluation__c where Approval_Outcome__c='Research' And Tissue_Type__c='Cornea'];
        if(results5!=null){
            researchWC =  (Integer)results5[0].get('expr0'); 
            tissueInventory.add(researchWC);
        }
        List<AggregateResult> results6 = [Select count(Id) from Tissue_Evaluation__c where Approval_Outcome__c='Research' And Tissue_Type__c='Sclera'];
        if(results6!=null){
            researchS =  (Integer)results6[0].get('expr0'); 
            tissueInventory.add(researchS);
        }
        
        //Training
        List<AggregateResult> results7 = [Select count(Id) from Tissue_Evaluation__c where Approval_Outcome__c='Training' And Tissue_Type__c='Whole Globe'];
        if(results7!=null){
            trainingWG =  (Integer)results7[0].get('expr0'); 
            tissueInventory.add(trainingWG);
        }
        List<AggregateResult> results8 = [Select count(Id) from Tissue_Evaluation__c where Approval_Outcome__c='Training' And Tissue_Type__c='Cornea'];
        if(results8!=null){
            trainingWC =  (Integer)results8[0].get('expr0'); 
            tissueInventory.add(trainingWC);
        }
        List<AggregateResult> results9 = [Select count(Id) from Tissue_Evaluation__c where Approval_Outcome__c='Training' And Tissue_Type__c='Sclera'];
        if(results9!=null){
            trainingS =  (Integer)results9[0].get('expr0'); 
            tissueInventory.add(trainingS);
        }
        // quarantine
        List<AggregateResult> results10 = [Select count(Id) from Tissue_Evaluation__c where Approval_Outcome__c='Quarantine' And Tissue_Type__c='Whole Globe'];
        if(results10!=null){
            transplantWG =  (Integer)results10[0].get('expr0'); 
            tissueInventory.add(transplantWG);
        }
        List<AggregateResult> results11 = [Select count(Id) from Tissue_Evaluation__c where Approval_Outcome__c='Quarantine' And Tissue_Type__c='Cornea'];
        if(results11!=null){
            transplantWC =  (Integer)results11[0].get('expr0'); 
            tissueInventory.add(transplantWC);
        }
        List<AggregateResult> results12 = [Select count(Id) from Tissue_Evaluation__c where Approval_Outcome__c='Quarantine' And Tissue_Type__c='Sclera'];
        if(results12!=null){
            transplantS =  (Integer)results12[0].get('expr0'); 
            tissueInventory.add(transplantS);
        }
        System.debug('FinalInventory' + tissueInventory);
        return tissueInventory;
    }
    
    @AuraEnabled
    public static List<Tissue_Evaluation__c> getAlltissues(){
        List<Tissue_Evaluation__c> allTissues = new List<Tissue_Evaluation__c>();
        allTissues = [Select Id,Name,Tissue_Type__c,Recovery__r.Referral__r.Age_of_Donor__c,Cell_Count_per_mm2__c,Recovery__r.Referral__r.Date_Time_of_Death__c,
                      Recovery__r.Cornea_Preservation_Date_Time__c,Recovery__r.Referral__r.Unit_Organization_Hospital_Name__r.Name,Approval_Outcome__c,PK__c,ALK__c,EK__c,K_Pro__c,KLA__c,Tectonic_Therapeutic__c from Tissue_Evaluation__c where Approval_Outcome__c!='Discard'];
        
        
        DateTime current_datetime = datetime.now();
        for(integer i =0;i<allTissues.size();i++){
            if(allTissues[i].Recovery__r.Cornea_Preservation_Date_Time__c!=null){
            decimal age = decimal.valueof((current_datetime.getTime()-allTissues[i].Recovery__r.Cornea_Preservation_Date_Time__c.getTime())/(60*60));
            Integer aging = integer.valueOf(age/1000)/24;
            allTissues[i].Aging__c = aging;
            }
        }
        
        System.debug('AllTissues'+ allTissues);
        return allTissues;
    }
    
    @AuraEnabled
    public static List<Attachment> getAttachments(Id tisId){
		System.debug('AttachmentTissueId-->'+ tisId);
        List<Attachment> Attachments = new List<Attachment>();
        List<Attachment> specEval = null;
        List<Attachment> postCut = null;
        try{
            specEval = [select Id,Name,Body from Attachment where parentId = :tisId AND Name LIKE '%-specEval' ORDER BY createddate DESC LIMIT 1];
            if(!specEval.isEmpty())
            	Attachments.add(specEval[0]);
            
            postCut = [select Id,Name,Body from Attachment where parentId = :tisId AND Name LIKE '%-postCut' ORDER BY createddate DESC LIMIT 1];
            if(!postCut.isEmpty())
            	Attachments.add(postCut[0]);
            
            system.debug('Attachment list is '+Attachments);
		}catch(Exception e){
           system.debug('Exception '+e.getMessage()+' At line number '+e.getLineNumber());
       	} 
       	return Attachments;
	}
    
    @AuraEnabled
    public static Id saveChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId) {
        // check if fileId id ''(Always blank in first chunk), then call the saveTheFile method,
        //  which is save the check data and return the attachemnt Id after insert, 
        //  next time (in else) we are call the appentTOFile() method
        //   for update the attachment with reamins chunks   
        if (fileId == '') {
            fileId = saveTheFile(parentId, fileName, base64Data, contentType);
        } else {
            appendToFile(fileId, base64Data);
        }
 
        return Id.valueOf(fileId);
    }
 
    public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
 
        Attachment oAttachment = new Attachment();
        oAttachment.parentId = parentId;
 
        oAttachment.Body = EncodingUtil.base64Decode(base64Data);
        oAttachment.Name = fileName;
        oAttachment.ContentType = contentType;
 
        insert oAttachment;
 
        return oAttachment.Id;
    }
 
    private static void appendToFile(Id fileId, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
 
        Attachment a = [
            SELECT Id, Body
            FROM Attachment
            WHERE Id =: fileId
        ];
 
        String existingBody = EncodingUtil.base64Encode(a.Body);
 
        a.Body = EncodingUtil.base64Decode(existingBody + base64Data);
 
        update a;
    }
    
    @AuraEnabled
    public static String fetchChildRecord(string TissueId){
        String Result = 'No';
        if(string.isNotBlank(TissueId)){
			List<Tissue_Evaluation__c> childRecs = [select Id,Name,Is_Child_Record__c from Tissue_Evaluation__c where Name = :TissueId AND Is_Child_Record__c = true LIMIT 1];
            if(!childRecs.isEmpty()){
                Result = 'Yes';
            }
        }
        return Result;
    }
}