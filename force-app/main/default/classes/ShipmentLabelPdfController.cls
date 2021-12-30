public with sharing class ShipmentLabelPdfController {
   public Placement__c plac{get;set;}
    public Request__c req{get;set;}
    public Tissue_Evaluation__c tissue{get;set;}
    public Medical_Review__c med{get;set;}
    public Recovery__c rec{get;set;}
    public Referral__c ref{get;set;}
    public ID placId;
    public Integer SurgeryInterval{get;set;}
    public Long diffDate{get;set;}

    public Double offset{get{
        TimeZone tz = UserInfo.getTimeZone();
        //Milliseconds to Day
        return tz.getOffset(DateTime.now()) / (1000 * 3600 * 24.0);
    }}
     
    public ShipmentLabelPdfController(){
        placId = ApexPages.currentPage().getParameters().get('placid');    
        plac =  new Placement__c();
        plac = [Select Id,Name,Hand_Carried_By_By_Hand__r.Name,Ship_Via__c,From__c,To__c,To__r.Name,Comments__c,Airline__c,Origin_City__c,
                Destination_City__c,Flight__c,ETD_Date_Time__c,ETA_Date_Time__c,Select_Tissue__c,Select_Tissue__r.Name,Date_Initial_Info_Received__c,
                Date_1st_Follow_Up_Request_Sent__c,Date_2nd_Follow_Up_Request_Sent__c,Date_Recipient_Info_Completed_on__c,BU_Responsible_for_Follow_Up__c,
                Date_3_6_month_Follow_Up_Form_Sent__c,Date_3_6_Month_Follow_up_Form_Received__c,Request__c from Placement__c where id='a0t6F00000SMjwjQAD' limit 1];
        
        req = new Request__c();
        req = [Select Id,Name,Request_Status__c,Adverse_Reaction_Report_Date_Time__c,Eye_Involved__c,Previous_Ocular_Surgery__c,Pre_Surgical_Diagnosis__c,Medical_Record__c,
               Age__c,Email__c,Address__c,Gender__c,DOB__c,Phone__c,First_Name__c,Last_Name__c,
               Surgery__c,Tissue_Type__c,Intended_Outcome__c,Surgery_Notes__c,Surgery_Location__c,Surgery_Location__r.Name,Mobile_Phone__c,Requesting_Surgeon__c,Requesting_Surgeon__r.Name, 
               Surgery_Date_Time__c,Surgery_Sub_Type_EK__c,Request_Date_time__c,Pre_cut_needed__c,Other_Patient_Notes__c,Occupation__c,If_Other__c, Describe_if_Other__c from Request__c where id=:plac.Request__c];
        
        tissue = new Tissue_Evaluation__c();
        tissue = [Select Id,Name,Preservation_Medium__c,Media_Lot__c,Medical_Review__c from Tissue_Evaluation__c where id=:plac.Select_Tissue__c limit 1];
        
        med  = new Medical_Review__c();
        med = [Select Id,Name,Recovery__c,Death_to_Cornea_Preservation_Time__c,Tissue_Imported__c,Origin_Eye_Bank__c,Origin_Eye_Bank_Tissue_ID__c from Medical_Review__c where id=:tissue.Medical_Review__c limit 1];
        
        rec = new Recovery__c();
        rec = [Select Id,Name,Cornea_Preservation_Date_Time__c,Referral__c from Recovery__c where id=:med.Recovery__c limit 1];
        
        ref = new Referral__c();
        ref = [Select Id,Name,Age_of_Donor__c,Primary_Cause_of_Death__c,Medical_Record_Number__c,Date_Time_of_Death__c from Referral__c where id=:rec.Referral__c limit 1];
        
        decimal Interval = decimal.valueof((req.Surgery_Date_Time__c.getTime() - ref.Date_Time_of_Death__c.getTime())/(60*60));
        SurgeryInterval = integer.valueOf(Interval/1000);
        diffDate = SurgeryInterval/24;
        system.debug('Interval--->'+SurgeryInterval);
    }  

}