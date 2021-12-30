public with sharing class MedicalReview {
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
    public static InitWrapper fetchInitData(string MedRevId){
        InitWrapper obj = new InitWrapper();
        try{
            //Set Bllod samples
            obj.bloodsamples = getBloodSamples(MedRevId);
            //set user
            obj.user = getCurrentUser();
            //set lookups
            obj.lookups = getLookups(MedRevId);
            //set recovery id
            obj.MedicalReview = getRecoveryId(MedRevId);
            //set required picklist values
            Map<string,List<string>> result = fetchReqPicklist();
            if(result.containsKey('HBsAG__c'))
            	obj.hbsagopts = result.get('HBsAG__c');
            if(result.containsKey('HCV__c'))
            	obj.hcvopts = result.get('HCV__c');
            if(result.containsKey('HIV_I_II__c'))
            	obj.hivopts = result.get('HIV_I_II__c');
            if(result.containsKey('Syphilis__c'))
            	obj.sypopts = result.get('Syphilis__c');
            if(result.containsKey('Reason_Donor_is_Ineligible__c'))
            	obj.reason = result.get('Reason_Donor_is_Ineligible__c');
        }catch(Exception ex){
            system.debug('Exception '+ex.getMessage()+' At line number '+ex.getLineNumber());
        }
        return obj;
    }
    
    public class InitWrapper{
        @AuraEnabled
        public BloodSmapleWrapper bloodsamples;
        @AuraEnabled
        public User user;
        @AuraEnabled
        public Map<String,sObject> lookups;
        @AuraEnabled
        public Medical_Review__c MedicalReview;
        @AuraEnabled
        public List<string> hbsagopts;
        @AuraEnabled
        public List<string> hcvopts;
        @AuraEnabled
        public List<string> hivopts;
        @AuraEnabled
        public List<string> sypopts;
        @AuraEnabled
        public List<string> reason;
    }
    
    public static Map<string,List<string>> fetchReqPicklist(){
        Map<string,List<string>> mapobj = new Map<string,List<string>>();
        List<string> reqpicklstNames = new List<string>();
        reqpicklstNames.add('HBsAG__c');reqpicklstNames.add('HCV__c');reqpicklstNames.add('HIV_I_II__c');reqpicklstNames.add('Syphilis__c');
        reqpicklstNames.add('Reason_Donor_is_Ineligible__c');
        Medical_Review__c medrevobj = new Medical_Review__c();
        for(string s: reqpicklstNames){
            List<string> options = getselectOptions(medrevobj,s);
        	mapobj.put(s,options);
        }
        return mapobj;
    }
    
    @AuraEnabled
    public static User getCurrentUser() {
        User toReturn = [SELECT Id, FirstName, LastName, Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        return toReturn;
    }
    @AuraEnabled
    public static Map<String,sObject> getLookups(Id medID){
        system.debug('lookup'+ medID);
        Map<String,sObject> lookupList = new Map<String,sObject>();
        Medical_Review__c med = [select Hemodilution_Done_By__c,Serology_Test_Done_By__c,
                                 Serology_Test_Approved_By__c,Medical_Review_Completed_By__c,
                                 Person_Collected_By__c, Death_To_Cornea_Preservation_Time1__c from Medical_Review__c where id=:medID];
        
        if(med.Hemodilution_Done_By__c!=null){
            Contact con1 = [select Id,Name from Contact where id=:med.Hemodilution_Done_By__c];
            lookupList.put('con1',con1);
        }
        else{
            lookupList.put('con1',null);
        }
        if(med.Serology_Test_Done_By__c!=null){
            Contact con2 = [select Id,Name from Contact where id=:med.Serology_Test_Done_By__c];
            lookupList.put('con2',con2);
        }
        else{
            lookupList.put('con2',null);
        }
        if(med.Serology_Test_Approved_By__c!=null){
            Contact con3 = [select Id,Name from Contact where id=:med.Serology_Test_Approved_By__c];
            lookupList.put('con3',con3);
        }
        else{
            lookupList.put('con3',null);
        }
        if(med.Medical_Review_Completed_By__c!=null){
            Contact con4 = [select Id,Name from Contact where id=:med.Medical_Review_Completed_By__c];
            lookupList.put('con4',con4);
        }
        else{
            lookupList.put('con4',null);
        }
        if(med.Person_Collected_By__c!=null){
            Contact con5 = [select Id,Name from Contact where id=:med.Person_Collected_By__c];
            lookupList.put('con5',con5);
        }
        else{
            lookupList.put('con5',null);
        }
        System.debug('-------->' + lookupList);
        return lookupList;
    }
    @AuraEnabled
    public static List < String > getselectOptions(sObject objObject, string fld) {
        system.debug('objObject --->' + objObject);
        system.debug('fld --->' + fld);
        List < String > allOpts = new list < String > ();
        // Get the object type of the SObject.
        // 
        Schema.sObjectType objType = objObject.getSObjectType();
        system.debug('objObject --->' + objType);
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        // Get a map of fields for the SObject
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        // Get the list of picklist values for this field.
        list < Schema.PicklistEntry > values =
            fieldMap.get(fld).getDescribe().getPickListValues();
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        system.debug('allOpts ---->' + allOpts);
        allOpts.sort();
        return allOpts;
    }
    //To get RecoveryId while editing
    @auraEnabled
    public static Medical_Review__c getRecoveryId(String medId){
        system.debug('hey' + medId);
        return [Select Id,Name_of_Donor_MedicalReview__c,Date_Time_of_Death_MedicalReview__c,Age__c,Gender__c,CreatedBy.Name,LastModifiedBy.Name,Sample_Collected__c,Sample_Collected_By__c,Was_donor_infused_or_transfused_prior_t__c,Pulse_Value_PV__c,Blood_Value__c,Sample_Rejected__c,Has_extravascular_blood_loss_occurred_I__c,Hemodilution_has_been_reviewed_and_deter__c,Hemodilution_Done_On__c,Sample_Qualified__c,Date_Time_of_Serology_Review__c,Serology_Test_Done__c,HBsAG__c,HCV__c,HIV_I_II__c,Syphilis__c,Death_To_Cornea_Preservation_Time1__c,Total_Cooling_Time__c,Primary_Cause_of_Death__c,Date_Time_Body_Subjected_to_Cooling__c,Death_to_Cooling_Start_Time__c,Death_to_Current_Time__c,Cornea_Preservation_Date_Time__c,Date_Time_body_recovered_from_cooling__c, Date_Time_of_blood_sample_collection__c, Medical_Chart__c,Donor_Family_Information__c,Autopsy__c,MedicalSurgical_History_Summary__c,Physical_Assessment__c,Attending_Physician__c,Other__c,Medical_Review_Date_time__c,Donor_Eligibility__c,Reason_Donor_is_Ineligible__c,Donor_Name_Id__c,Tissue_Imported__c,Reason_for_Import__c,Origin_Eye_Bank_Tissue_ID__c,Tissue_Receipt_Acceptable__c,Origin_Eye_Bank__c,Recovery__c,Branch_Name__c from Medical_Review__c where id =:medId];
    }
    
    @auraEnabled
    public static Recovery__c getRecoveryDetails(String recoveryId){
        Recovery__c rec;
        System.debug('hi' + recoveryId);
        try{
            if(recoveryId!='null' || recoveryId!='undefined' || recoveryId!=''){
                rec= [Select Id,Name,Referral_ID__c,Donor_Name__c,Referral__r.Weight__c,
                      Referral__r.Age_of_Donor__c,Date_Time_of_blood_sample_collection__c,Referral__r.Date_Time_of_Death__c,
                      Collected_By__r.Name,Collected_By__c,Referral__r.Gender__c,Referral__r.Medical_Ocular_Histor__c,
                      Referral__r.Death_Notification_Consignment_Date_Time__c,Cornea_Preservation_Date_Time__c,
                      Date_Time_body_removed_from_cooling__c,Date_Time_body_subjected_to_cooling__c,
                      Referral__r.Primary_Cause_of_Death__c,Date_Time_of_Death_Recovery__c,Branch_Name__c from Recovery__c where Id=:recoveryId limit 1];
            }
        }
        catch(Exception e){}
        system.debug('wwww'+rec.Collected_By__c);
        return rec;
    } 
    
    @auraEnabled
    public static List<string> getDates(String recoveryId){
        System.debug('DATES--->'+ recoveryId);
        Recovery__c rec;
        if(recoveryId!='null' || recoveryId!='undefined' || recoveryId!=''){
            rec= [Select Referral__r.Death_Notification_Consignment_Date_Time__c,Referral__r.Date_Time_of_Death__c,Cornea_Preservation_Date_Time__c,Date_Time_body_removed_from_cooling__c,Date_Time_body_subjected_to_cooling__c from Recovery__c where Id=:recoveryId limit 1];
        }
        List<string> dates = new List<string>();
        DateTime CurentTime = system.now();
        String TimeZones = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        List<String> lststrsplit = TimeZones.substring(12,TimeZones.length()).split('\\(',2);
        system.debug('xxx-->'+TimeZones.substring(12,TimeZones.length()));
        system.debug('yyy-->'+lststrsplit);
        string strTimeZone = lststrsplit[1].substring(0,lststrsplit[1].length()-1);
        system.debug(CurentTime+'abc#');
        string strCurrentTime = CurentTime.format('YYYY-MM-dd HH:mm:ss', strTimeZone);
        Datetime current_datetime = Datetime.valueof(strCurrentTime);
        // DateTime current_datetime = system.now();
        if(rec.Date_Time_body_removed_from_cooling__c!=null && rec.Date_Time_body_subjected_to_cooling__c!=null && (rec.Date_Time_body_removed_from_cooling__c>rec.Date_Time_body_subjected_to_cooling__c)){
            //decimal totalCoolingTime = decimal.valueof((rec.Date_Time_body_removed_from_cooling__c.getTime() - rec.Date_Time_body_subjected_to_cooling__c.getTime())/(60*60));
            Long deathTime = rec.Date_Time_body_subjected_to_cooling__c.getTime();
            Long corneaTime = rec.Date_Time_body_removed_from_cooling__c.getTime();
            Long timeDiff = corneaTime -deathTime;
			Long hourDiff = timeDiff/3600/1000;
            Long minDiff = timeDiff/60/1000;
            Double hours = Math.floor(hourDiff);
            Double minutes = minDiff - 60 * Math.floor(hourDiff);
            system.debug(hours+'===='+minutes);
            String hoursAndMin = String.valueOf(Integer.valueOf(hours))+'.'+String.valueOf(Integer.valueOf(minutes));           
            
            dates.add(hoursAndMin);
        }
        else{
            dates.add('0.00');   
        }
        
        if(rec.Cornea_Preservation_Date_Time__c!=null && rec.Referral__r.Date_Time_of_Death__c!=null && (rec.Cornea_Preservation_Date_Time__c>rec.Referral__r.Date_Time_of_Death__c)){
            Long deathTime = rec.Referral__r.Date_Time_of_Death__c.getTime();
            Long corneaTime = rec.Cornea_Preservation_Date_Time__c.getTime();
            Long timeDiff = corneaTime -deathTime;
			Long hourDiff = timeDiff/3600/1000;
            Long minDiff = timeDiff/60/1000;
            Double hours = Math.floor(hourDiff);
            Double minutes = minDiff - 60 * Math.floor(hourDiff);
            system.debug(hours+'===='+minutes);
            String hoursAndMin = String.valueOf(Integer.valueOf(hours))+'.'+String.valueOf(Integer.valueOf(minutes));
            system.debug('hoursAndMin'+hoursAndMin);
            system.debug('========'+Decimal.valueOf(hoursAndMin));
            dates.add(hoursAndMin);
            /*decimal deathToCornea = decimal.valueof((rec.Cornea_Preservation_Date_Time__c.getTime() - rec.Referral__r.Date_Time_of_Death__c.getTime())/(60*60));
            decimal deathCornea = (deathToCornea/1000).setscale(2);
            System.debug(deathCornea/1000);
            dates.add(deathCornea);*/
        }
        else{
            dates.add('0.00');   
        }
        
        if(rec.Date_Time_body_removed_from_cooling__c!=null && rec.Referral__r.Date_Time_of_Death__c!=null && (rec.Date_Time_body_subjected_to_cooling__c>rec.Referral__r.Date_Time_of_Death__c)){
            decimal deathCoolingStart = decimal.valueof((rec.Date_Time_body_subjected_to_cooling__c.getTime() - rec.Referral__r.Date_Time_of_Death__c.getTime())/(60*60));
            Long deathTime = rec.Referral__r.Date_Time_of_Death__c.getTime();
            Long corneaTime = rec.Date_Time_body_subjected_to_cooling__c.getTime();
            Long timeDiff = corneaTime -deathTime;
			Long hourDiff = timeDiff/3600/1000;
            Long minDiff = timeDiff/60/1000;
            Double hours = Math.floor(hourDiff);
            Double minutes = minDiff - 60 * Math.floor(hourDiff);
            system.debug(hours+'===='+minutes);
            String hoursAndMin = String.valueOf(Integer.valueOf(hours))+'.'+String.valueOf(Integer.valueOf(minutes));
            system.debug('hoursAndMin'+hoursAndMin);
            system.debug('========'+Decimal.valueOf(hoursAndMin));
            dates.add(hoursAndMin);
        }
        else{
            dates.add('0.00');   
        }
        
        if(rec.Referral__r.Date_Time_of_Death__c != null && (current_datetime > rec.Referral__r.Date_Time_of_Death__c)){
            decimal deathToCurrent = decimal.valueof((current_datetime.getTime() - rec.Referral__r.Date_Time_of_Death__c.getTime())/(60*60));
            Long deathTime = rec.Referral__r.Date_Time_of_Death__c.getTime();
            Long corneaTime = current_datetime.getTime();
            Long timeDiff = corneaTime -deathTime;
			Long hourDiff = timeDiff/3600/1000;
            Long minDiff = timeDiff/60/1000;
            Double hours = Math.floor(hourDiff);
            Double minutes = minDiff - 60 * Math.floor(hourDiff);
            system.debug(hours+'===='+minutes);
            String hoursAndMin = String.valueOf(Integer.valueOf(hours))+'.'+String.valueOf(Integer.valueOf(minutes));
            system.debug('hoursAndMin'+hoursAndMin);
            system.debug('========'+Decimal.valueOf(hoursAndMin));
            dates.add(hoursAndMin);
        }
        else{
            dates.add('0.00');   
        }
        System.debug('Calculated Dates'+ dates);
        return dates;
    }
    @AuraEnabled
    public static Integer getMedicalCount(Id parentId){
        system.debug('ParentId' + parentId);
        Integer medicalCount = 0;
        List<AggregateResult> results = [Select count(Id) from Medical_Review__c where Recovery__c=:parentId];
        if(results!=null){
            system.debug('medicalCount'+ results);
            medicalCount =  (Integer)results[0].get('expr0');
        }
        return medicalCount;
    }
    
    //Record ID Ends
    
    @auraEnabled
    public static Medical_Review__c getMedicalReviewName(Id MedRevId){
        system.debug(MedRevId);
        return [select Name from Medical_Review__c where Id=:MedRevId];
    }
    //Record ID Ends
    @AuraEnabled
    public static Medical_Review__c saveDetails(Medical_Review__c MedicalReview, Id firstlookup,Id secondlookup,Id thirdlookup,Id fourthlookup,Id fifthlookup,List<Blood_Product__c> bloodProduct,List<Colloid__c> colloid,List<Crystalloid__c> crystalloid,Id medicalReviewID){
        
        if(firstlookup != null || firstlookup != ''){
            MedicalReview.Hemodilution_Done_By__c=firstlookup;
        }
        if(secondlookup != null || secondlookup != ''){
            MedicalReview.Serology_Test_Done_By__c=secondlookup;
        }
        if(thirdlookup != null || thirdlookup != ''){
            MedicalReview.Serology_Test_Approved_By__c=thirdlookup; 
        }
        if(fourthlookup != null || fourthlookup != ''){
            MedicalReview.Medical_Review_Completed_By__c=fourthlookup;
        }
        if(fifthlookup != null || fifthlookup != ''){
            MedicalReview.Person_Collected_By__c=fifthlookup;
        }
        if(medicalReviewID != null){
            
            system.debug('hellooo' + medicalReviewID);
            MedicalReview.Id = medicalReviewID;
            update MedicalReview;
        }
        else{
            //insert MedicalReview;
            upsert MedicalReview;
            system.debug('************'+MedicalReview);
        }
        
        if(bloodProduct != null){
            for(Blood_Product__c bloodPro:bloodProduct){
                if(string.isBlank(bloodPro.Medical_Review__c))
                	bloodPro.Medical_Review__c = MedicalReview.Id;
            }
            upsert bloodProduct;
        }
        
        if(colloid != null){
            for(Colloid__c colobj:colloid){
                if(string.isBlank(colobj.Medical_Review__c))
                	colobj.Medical_Review__c = MedicalReview.Id;
            }
            upsert colloid;
        }
        
        if(crystalloid != null){
            for(Crystalloid__c cryobj:crystalloid){
                if(string.isBlank(cryobj.Medical_Review__c))
                	cryobj.Medical_Review__c = MedicalReview.Id;
            }
            upsert crystalloid;
        }
        return MedicalReview;
    } 
    
    
    @auraEnabled
    public static BloodSmapleWrapper getBloodSamples(string MedRevId){
        BloodSmapleWrapper obj = new BloodSmapleWrapper();
        try{
        	if(string.isNotBlank(MedRevId)){
                List<Blood_Product__c> bptemplst = [select Id,Blood_Product__c,Date_Time__c,Volume__c,Medical_Review__c from Blood_Product__c where Medical_Review__c = :MedRevId];
                if(!bptemplst.isEmpty())
                    obj.bplst = bptemplst;
                List<Colloid__c> ctemplst = [select Id,Colloid__c,Date_Time__c,Volume__c,Medical_Review__c from Colloid__c where Medical_Review__c = :MedRevId];
                if(!ctemplst.isEmpty())
                    obj.clst = ctemplst;
                List<Crystalloid__c> crytemplst = [select Id,Crystalloid__c,Date_Time__c,Volume__c,Medical_Review__c from Crystalloid__c where Medical_Review__c = :MedRevId];
                if(!crytemplst.isEmpty())
                    obj.crylst = crytemplst;
            }   
        }catch(Exception ex){
            system.debug('Exception '+ex.getMessage()+' at line number '+ex.getLineNumber());
        }
        return obj;
    }
    
    public class BloodSmapleWrapper{
        @auraEnabled
        public List<Crystalloid__c> crylst;
        @auraEnabled
        public List<Colloid__c> clst;
        @auraEnabled
        public List<Blood_Product__c> bplst;
    }
}