public class ReferralController {
    
    //Init Method while loading component
    @AuraEnabled
    public static InitWrapper fetchIntialData(string refId,Sobject sobj,string contfiled,string depentfield){
        InitWrapper obj = new InitWrapper();
        try{
        	if(string.isNotBlank(refId)){
            	obj.CurrentUser 		= 	getCurrentUser();
                obj.lookups				= 	getLookups(refId);
                obj.referral 			= 	getRefId(refId);
                obj.referralmethVals 	= 	fetchReferralVals();
                obj.referralsourVals 	= 	fetchReferralSourVals();
                obj.DependentPicklst 	= 	getDependentMap(sobj,contfiled,depentfield);
        	}    
        }catch(Exception ex){
            system.debug('Exception in fetchInitialData method '+ex.getMessage()+' At line number '+ex.getLineNumber());
        }
        system.debug('initial data before return '+obj);
        return obj;
    }
    
    public class InitWrapper{
        @AuraEnabled
        public User CurrentUser;
        @AuraEnabled
        public Map<String, sobject> lookups;
        @AuraEnabled
        public Referral__c referral;
        @AuraEnabled
        public List<string> referralmethVals;
        @AuraEnabled
        public List<string> referralsourVals;
        @AuraEnabled
        public Map<String, List<String>> DependentPicklst;
    }
    
    //Get Branch Based on Current User Id
    @AuraEnabled
    public static Branch__c getBranch(){
        Branch__c branch = new Branch__c();
        Branch_Team__c BT = [select Id,Branch__c from Branch_Team__c where User__c = :UserInfo.getUserId() LIMIT 1];
        system.debug('BT is '+BT);
        if(BT != null){
            branch = [select Id,Name from Branch__c where Id =: BT.Branch__c LIMIT 1];
        }
        system.debug('branch '+branch);
        return branch;
    }
    
    //Getting Current User
    @AuraEnabled
    public static User getCurrentUser() {
        User toReturn = [SELECT Id, FirstName, LastName, Name FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        return toReturn;
    }
    
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
    
    //Getting Lookup Values
    @AuraEnabled
    public static Map<String, sobject> getLookups(String refID){
     Map<String, sobject> lookupList = new Map<String, sobject>();
     Referral__c ref = [select Donation_Counselor_Volunteer__c,Seconday_Donation_Counselor_Volunteer__c,
                       Unit_Organization_Hospital_Name__c,Medico_Legal_Facility__c from Referral__c where id=:refID];
       
   
        if(ref.Donation_Counselor_Volunteer__c!=null){
        Contact con1 = [select Id, Name from Contact where id=:ref.Donation_Counselor_Volunteer__c];
        lookupList.put('con1',con1);
        }
        else{
            lookupList.put('con1',null);
        }
        if(ref.Seconday_Donation_Counselor_Volunteer__c!=null){
        Contact con2 = [select Id, Name from Contact where id=:ref.Seconday_Donation_Counselor_Volunteer__c];
        lookupList.put('con2',con2);
        }
        else{
            lookupList.put('con2',null);
        }
        if(ref.Unit_Organization_Hospital_Name__c!=null){
        Account con3 = [select Id, Name from Account where id=:ref.Unit_Organization_Hospital_Name__c];
        lookupList.put('con3',con3);
        }
        else{
            lookupList.put('con3',null);
        }
        if(ref.Medico_Legal_Facility__c!=null){
        Account con4 = [select Id, Name from Account where id=:ref.Medico_Legal_Facility__c];
        lookupList.put('con4',con4);
        }
        else{
            lookupList.put('con4',null);
        }
        System.debug('lookupList::::'+lookupList);
        return lookupList;
    }																	

   
    //Getting Referral ID
    @AuraEnabled
    public static Referral__c getRefId(String RefId){
        system.debug('hey>>>' + RefId);
        Referral__c  LstReferals = [SELECT Name,First_Name__c,Last_Name__c,
                Seconday_Donation_Counselor_Volunteer__r.Name,Date_Time_of_Death__c,
                Age_of_Donor__c,Gender__c,
                                    Date_of_Birth__c,
                                    Religion__c,
                                    If_Other_Specify_the_Religion__c,
                                    Height__c,
                                    Height_Unit__c,
                                    Weight__c,
                                    Weight_Unit__c,
                                    Is_Height_Estimated_or_Reported__c,
                                    Is_weight_Estimated_or_Reported__c,
                                    Date_of_Admission__c,
                                    Medical_Record_Number__c,
                                    Primary_Cause_of_Death__c,
                                    If_Other_Provide_Cause__c,
                                    Circumstances_Leading_to_Death__c,
                                    Attending_physician__c,
                                    Referral_Method__c,
                                    Referral_Outcome__c,
                                    Referral_Source__c,
                                    Branch_Name__c,
                                    CreatedBy.Name,
                                    LastModifiedBy.Name,
                                    Death_Notification_Consignment_Date_Time__c,
                                    Phone_Number_Of_Caller__c,
                                    Caller_First_Name__c,
                                    Caller_Last_Name__c,
                                    Relationship_of_caller_to_donor__c,
                                    If_Other_Mention_the_Relationship__c,
                                    Special_Instructions__c,
                                    Unit_Type__c,
                                    unit_type_other__c,
                                    Recovery_Direction__c,
                                    Recovery_Address__c,
                                    Location_of_Donor__c,
                                    Other_Location_of_Donor__c,
                                    Medical_Ocular_Histor__c,
                                    Social_and_Behavioral_History__c,
                                    Was_the_donor_on_a_ventilator__c,
                                    Duration_of_time_on_Ventilator_if_Yes__c,
                                    Isolation__c,
                                    If_Yes_Please_Specify_the_Isolation__c,
                                    IV_Fluid_given_in_last_hour__c,
                                    How_many_IV_Fluids_given_in_Last_Hour__c,
                                    IV_Fluid_Date_Time__c,
                                    Sign_symptoms_of_systemic_infection__c,
                                    If_Yes_Mention_the_Sign_symptoms__c,
                                    Blood_given_in_the_last_48_hours__c,
                                    How_much_Blood_given_in_last_48_hours__c,
                                    Blood_given_Date_Time__c,
                                    Initially_Suitable__c,
                                    Transferred_from_other_facility__c,
                                    Facility_Name__c,
                                    To_Where__c,
                                    Suitability_Explanation__c,
                                    Medico_Legal_Information_Case__c,
                                    Police_Medico_Legal_Case_Autopsy_Number__c,
                                    Permission_for_Donation__c,
                                    Released_By__c,
                                    Phone_Number_for_Who_Released_Donor__c,
                                    Autopsy_Completed__c,
                                    If_Yes_Who_Completed_the_Autopsy__c,
                                    Medico_Legal_Hosp_Restriction_SpecialReq__c,
                                    Comments__c,
                                    
                                    Screened_Not_Suitable__c,
                                    If_Other_Specify_the_Reason1__c,
                                    Suitable_Not_Approached__c,
                                    If_Other_Mention_the_Reason__c,
                                    Not_Screened__c,
                                    If_Other_Mention_Not_Screened__c,
                                    Approached_Not_Consented__c,
                                    If_Other_Specify_about_it__c
                FROM  Referral__c where id=:RefId LIMIT 1];
        system.debug('LstReferals>>>>>>'+LstReferals);
        return LstReferals;
    }
    
    //Get Referal method values
    private static List<string> fetchReferralVals(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Referral__c.Referral_Method__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.add(p.getLabel());
        }
        return options;
    }
    
    //Get Referral source values
    private static List<string> fetchReferralSourVals(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Referral__c.Referral_Source__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.add(p.getLabel());
        }
        return options;
    }
    
    @AuraEnabled 
    //Getting Dependent Picklists
    public static Map<String, List<String>> getDependentMap(sObject newRef,string contrfieldApiName,string depfieldApiName) {
        
        String controllingField = contrfieldApiName.toLowerCase();
        String dependentField = depfieldApiName.toLowerCase();
        Map<String,List<String>> objResults = new Map<String,List<String>>();
       
        Schema.sObjectType objType = newRef.getSObjectType();
        if (objType==null){
            return objResults;
        }
        
        Map<String, Schema.SObjectField> objFieldMap = objType.getDescribe().fields.getMap();
        
        if (!objFieldMap.containsKey(controllingField) || !objFieldMap.containsKey(dependentField)){
            return objResults;     
        }
        
        Schema.SObjectField theField = objFieldMap.get(dependentField);
        Schema.SObjectField ctrlField = objFieldMap.get(controllingField);
        
        List<Schema.PicklistEntry> contrEntries = ctrlField.getDescribe().getPicklistValues();
        List<PicklistEntryWrapper> depEntries = wrapPicklistEntries(theField.getDescribe().getPicklistValues());
        List<String> controllingValues = new List<String>();
        
        for (Schema.PicklistEntry ple : contrEntries) {
            String label = ple.getLabel();
            objResults.put(label, new List<String>());
            controllingValues.add(label);
        }
        for (PicklistEntryWrapper plew : depEntries) {
            String label = plew.label;
            String validForBits = base64ToBits(plew.validFor);
            for (Integer i = 0; i < validForBits.length(); i++) {
                String bit = validForBits.mid(i, 1);
                if (bit == '1') {
                    objResults.get(controllingValues.get(i)).add(label);
                }
            }
        }
        return objResults;
    }
    //Method for Converting Decimal Value to Binary
    public static String decimalToBinary(Integer val) {
        String bits = '';
        while (val > 0) {
            Integer remainder = Math.mod(val, 2);
            val = Integer.valueOf(Math.floor(val / 2));
            bits = String.valueOf(remainder) + bits;
        }
        return bits;
    }
    
    public static String base64ToBits(String validFor) {
        if (String.isEmpty(validFor)) return '';
        
        String validForBits = '';
        
        for (Integer i = 0; i < validFor.length(); i++) {
            String thisChar = validFor.mid(i, 1);
            Integer val = base64Chars.indexOf(thisChar);
            String bits = decimalToBinary(val).leftPad(6, '0');
            validForBits += bits;
        }
        
        return validForBits;
    }
    
    private static final String base64Chars = '' +
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
        'abcdefghijklmnopqrstuvwxyz' +
        '0123456789+/';
    
    
    private static List<PicklistEntryWrapper> wrapPicklistEntries(List<Schema.PicklistEntry> PLEs) {
        return (List<PicklistEntryWrapper>)
            JSON.deserialize(JSON.serialize(PLEs), List<PicklistEntryWrapper>.class);
    }
    
    public class PicklistEntryWrapper{
        public String active {get;set;}
        public String defaultValue {get;set;}
        public String label {get;set;}
        public String value {get;set;}
        public String validFor {get;set;}
        public PicklistEntryWrapper(){            
        }    
}
    
    @AuraEnabled
    //Saving Referral Record
    public static Referral__c saveReferrall(Referral__c referral,
                                            Id ContactId,
                                            Id secondlookup,
                                            Id thirdlookup,
                                            Id fourthlookup,
                                            Id referralID){
    system.debug(thirdlookup);
        if(ContactId != null || ContactId != '' || ContactId !='undefined'){
            referral.Donation_Counselor_Volunteer__c=ContactId;
        }
         if(secondlookup != null || secondlookup != '' || secondlookup != 'undefined'){
            referral.Seconday_Donation_Counselor_Volunteer__c=secondlookup;
         }
        if(thirdlookup != null || thirdlookup != '' || thirdlookup != 'undefined'){
            referral.Unit_Organization_Hospital_Name__c=thirdlookup;
        }
         if(fourthlookup != null || fourthlookup != '' || fourthlookup != 'undefined'){
            referral.Medico_Legal_Facility__c=fourthlookup;
         }
        if(referralID != null){
            referral.Id = referralID;
            update referral;            
        }
        else{
            //insert referral;
            insert referral;  
        }
        return [select Name from Referral__c where Id = :referral.Id];
    }
    
    //Record ID Starts
    @AuraEnabled
    public static Referral__c getReferralName(Id refId){
        system.debug(refId);
        return [select Name from Referral__c where Id=:refId];
    }
     //Record ID Ends
     
 /*public PageReference savePDF(String urlstr){
        System.PageReference pageRef = new System.PageReference(urlstr);
        
        //ensure pdf downloads and is assigned with defined name
        pageRef.getHeaders().put('content-disposition', 
                                 'attachment; filename=TestPDF.pdf');
        
        return pageRef;
    } */
 
    @InvocableMethod
    public static void updateMedicalHistorySummary(List<Id> refId){
        try{
        system.debug('refID-->'+ refId);
        Referral__c ref =[Select Id,Medical_Ocular_Histor__c from Referral__c where Id=:refId limit 1];
        Medical_Review__c med = [Select Id,Recovery__r.Referral__c,MedicalSurgical_History_Summary__c from Medical_Review__c where Recovery__r.Referral__c=:refId limit 1];
        system.debug('MEdical-->'+ med.Id);
            if(ref.Medical_Ocular_Histor__c!=null && med.Id!=null){  
            system.debug('xxxx-->'+ ref.Medical_Ocular_Histor__c);
            med.MedicalSurgical_History_Summary__c = ref.Medical_Ocular_Histor__c;
            update med;
            }
        } 
        catch(Exception e){}
    }
}