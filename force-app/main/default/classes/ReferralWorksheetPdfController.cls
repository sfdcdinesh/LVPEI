public with sharing class ReferralWorksheetPdfController {
    public Branch__c branch{get;set;}
    public Referral__c referral{get;set;}
    public Boolean refRend{get;set;}
    public ID referralID;
       public Double offset{get{
        TimeZone tz = UserInfo.getTimeZone();
        //Milliseconds to Day
        return tz.getOffset(DateTime.now()) / (1000 * 3600 * 24.0);
    }}
    public ReferralWorksheetPdfController(){
        referralID = ApexPages.currentPage().getParameters().get('referralid');    
        referral =  new Referral__c();
        
        referral = [select Id, Name, OwnerId, First_Name__c, Last_Name__c, DonorID__c, Donor_ID__c, Date_of_Birth__c, Age_of_Donor__c, Gender__c, 
                 Religion__c,  Medical_Record_Number__c,Date_of_Admission__c, Height__c,Weight__c,Donation_Counselor_Volunteer__r.Name,
                 Primary_Cause_of_Death__c, If_Other_Provide_Cause__c, Circumstances_Leading_to_Death__c, Height_Unit__c, Weight_Unit__c,
                 Attending_physician__c, Date_Time_of_Death__c, Was_the_donor_on_a_ventilator__c, How_much_Blood_given_in_last_48_hours__c,Blood_given_Date_Time__c,
                 Duration_of_time_on_Ventilator_if_Yes__c, Isolation__c, Sign_symptoms_of_systemic_infection__c,Facility_Name__c,To_Where__c,
                 How_many_IV_Fluids_given_in_Last_Hour__c, Blood_given_in_the_last_48_hours__c,If_Yes_Please_Specify_the_Isolation__c,If_Yes_Mention_the_Sign_symptoms__c, 
                 Transferred_from_other_facility__c, Medical_Ocular_Histor__c, Social_and_Behavioral_History__c,IV_Fluid_Date_Time__c,
                 Death_Notification_Consignment_Date_Time__c,Recovery_Address__c,Recovery_Direction__c,IV_Fluid_given_in_last_hour__c,
                 Referral_Method__c,Donation_Counselor_Volunteer__c,Unit_Type__c,Unit_Organization_Hospital_Name__c, Comments__c,
                 Special_Instructions__c,Caller_First_Name__c,Caller_Last_Name__c,Location_of_Donor__c,Unit_Organization_Hospital_Name__r.Name,Phone_Number_Of_Caller__c,Relationship_of_caller_to_donor__c, CreatedBy.Name,Branch_Name__c from Referral__c where id =: referralID limit 1];
    	Map<String,string> referralMap = new Map<String, string>();
        referralMap.put('BranchName', referral.Branch_Name__c);
        Flow.Interview.GetBranchAddress myflow = new Flow.Interview.GetBranchAddress(referralMap);
        myflow.start();
    	branch = (Branch__c)myflow.getVariableValue('BranchRecord');
    } 
  
}