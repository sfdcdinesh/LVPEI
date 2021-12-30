public with sharing class DownloadReportasPDFController {
    public Branch__c branch{get;set;}
    public Placement__c plac{get;set;}
    public Request__c req{get;set;}
    public Tissue_Evaluation__c tissue{get;set;}
    public Medical_Review__c med{get;set;}
    public Recovery__c rec{get;set;}
    public Referral__c ref{get;set;}
    public Integer SurgeryInterval{get;set;}
    public Long diffDate{get;set;}
    public ID placId;
    public String tisCheck{get;set;}
    public String ARCheck{get;set;}
    public String ACCheck{get;set;} 
    public String RICheck{get;set;} 
    public String RQCheck{get;set;} 
    public String SLCheck{get;set;} 
    public string EpitheliumValues{get;set;}
    public string StromaValues{get;set;}
    public string DescemetValues{get;set;}
    public string EndotheliumValues{get;set;}
    public string AdditionalValues{get;set;}
    public String approvedUsages{get;set;}
    public String medicalReviewOutcome{get;set;}

    public Double offset{get{
        TimeZone tz = UserInfo.getTimeZone();
        //Milliseconds to Day
        return tz.getOffset(DateTime.now()) / (1000 * 3600 * 24.0);
    }}
     
    public DownloadReportasPDFController(){
        placId = ApexPages.currentPage().getParameters().get('placId'); 
        tisCheck = ApexPages.currentPage().getParameters().get('tisCheck'); 
        ARCheck = ApexPages.currentPage().getParameters().get('ARCheck'); 
        ACCheck = ApexPages.currentPage().getParameters().get('ACCheck'); 
        RICheck = ApexPages.currentPage().getParameters().get('RICheck'); 
        RQCheck = ApexPages.currentPage().getParameters().get('RQCheck'); 
        SLCheck = ApexPages.currentPage().getParameters().get('SLCheck'); 
        System.debug('Parameters-->'+placId+' '+ tisCheck);
        plac =  new Placement__c();
        if(placId!=null){
        plac = [Select Id,Branch_Name__c,Name,Hand_Carried_By_By_Hand__r.Name,Ship_Via__c,From__c,To__c,To__r.Name,Comments__c,Airline__c,Origin_City__c,
                Destination_City__c,Flight__c,ETD_Date_Time__c,ETA_Date_Time__c,Select_Tissue__c,Select_Tissue__r.Name,Date_Initial_Info_Received__c,
                Date_1st_Follow_Up_Request_Sent__c,Date_2nd_Follow_Up_Request_Sent__c,Date_Recipient_Info_Completed_on__c,BU_Responsible_for_Follow_Up__c,
                Date_3_6_month_Follow_Up_Form_Sent__c,Date_3_6_Month_Follow_up_Form_Received__c,Request__c from Placement__c where id=:placId limit 1];
        	System.debug('Placement-->'+plac.Select_Tissue__r.Name);
            Map<String,string> plaMap = new Map<String, string>();
            plaMap.put('BranchName', plac.Branch_Name__c);
            Flow.Interview.GetBranchAddress myflow = new Flow.Interview.GetBranchAddress(plaMap);
            myflow.start();
            branch = (Branch__c)myflow.getVariableValue('BranchRecord');
        }
        req = new Request__c();
        if(plac.Request__c!=null){
        req = [Select Id,Name,Request_Status__c,Adverse_Reaction_Report_Date_Time__c,Eye_Involved__c,Previous_Ocular_Surgery__c,Pre_Surgical_Diagnosis__c,Medical_Record__c,
               Age__c,Email__c,Address__c,Gender__c,DOB__c,Phone__c,First_Name__c,Last_Name__c,Tissue_Sub_Type__c,
               Surgery__c,Tissue_Type__c,Intended_Outcome__c,Surgery_Notes__c,Surgery_Location__c,Surgery_Location__r.Name,Mobile_Phone__c,Requesting_Surgeon__c,Requesting_Surgeon__r.Name, 
               Surgery_Date_Time__c,Surgery_Sub_Type_EK__c,Surgery_Type_ALK__c,Request_Date_time__c,Pre_cut_needed__c,Other_Patient_Notes__c,Occupation__c,If_Other__c,Describe_if_Other__c from Request__c where id=:plac.Request__c];
        System.debug('Request-->'+req.Name);
        }
        tissue = new Tissue_Evaluation__c();
        if(plac.Select_Tissue__c!=null){
        /*tissue = [Select Donor_ID__c,Name,Tissue_Type__c,Recovery__r.Referral__r.Age_of_Donor__c,Recovery__r.Referral__r.Gender__c,Recovery__r.Referral__r.Medical_Ocular_History__c,Recovery__r.Referral__r.Date_Time_of_Death__c,
                  Medical_Review__r.Death_to_Cornea_Preservation_Time__c,Recovery__r.Tissue_recovery_date_time__c,Recovery__r.Referral__r.Primary_Cause_of_Death__c,
                  Recovery__r.Date_Time_body_subjected_to_cooling__c,Recovery__r.Date_Time_body_removed_from_cooling__c,Preservation_Medium__c,Media_Lot__c,
                  Recovery__r.Recovery_completed_by__r.Name,Recovery__r.Cornea_preserved_by__r.Name,Medical_Review__c,Medical_Review__r.Total_Cooling_Time__c,
                  Recovery__r.Referral__r.Social_and_Behavioral_History__c,Medical_Review__r.MedicalSurgical_History_Summary__c,Tissue_Expiry_Date__c,
                  Recovery__r.Referral__r.Was_the_donor_on_a_ventilator__c,Recovery__r.Referral__r.Duration_of_time_on_Ventilator_if_Yes__c,Evaluations_Comments__c,
                  Recovery__r.Referral__r.Autopsy_Completed__c,Medical_Review__r.Autopsy__c,Medical_Review__r.Attending_Physician__c,Medical_Review__r.Physical_Assessment__c,
                  Medical_Review__r.Medical_Chart__c,Medical_Review__r.Donor_Family_Information__c,Haze__c,Exposure__c,Exposure_Location__c,Exposure_Percentage__c,Sloughing__c,
                  Debris__c,If_Yes_Describe__c,Clear_and_Compact__c,Edema__c,Edema_Location__c,Arcus__c,Relative_number_of_folds__c,Folds__c,Defects__c,Defects_Describe__c,
                  Relative_Number_of_Stress_Lines__c,Stress_Lines_Location__c,Endothelium_Defects__c,Endothelium_If_Yes_Describe__c,Cell_Dropouts__c,Cell_Dropout_Location__c,
                  Polymegathism__c,Pleomorphism__c,Jaundice__c,Scleral_Rim_Information__c,PK__c,ALK__c,EK__c,K_Pro__c,KLA__c,Tectonic_Therapeutic__c,Clear_Zone__c,Lens__c,
                  Cell_Count_per_mm2__c,Number_of_Fields__c,Pachymetry_microns__c,Slit_Lamp_Date_Time__c,Slit_Lamp_Technician__r.Name,Specular_Evaluation_Date_Time__c,Specular_Date_Time__c,
                  Specular_Technician__r.Name,Medical_Review__r.HBsAG__c,Medical_Review__r.HCV__c,Medical_Review__r.HIV_I_II__c,Medical_Review__r.Syphilis__c,Recovery__r.Cornea_Preservation_Date_Time__c,
                  Date_Time_of_Final_Review_Approval__c,Final_Review_and_Approval_Done_By__r.Name from Tissue_Evaluation__c where id=:plac.Select_Tissue__c limit 1];*/
           
            tissue = [Select Donor_ID__c,Name,Tissue_Type__c,Recovery__r.Referral__r.Age_of_Donor__c,Recovery__r.Referral__r.Gender__c,Recovery__r.Referral__r.Medical_Ocular_Histor__c,Recovery__r.Referral__r.Date_Time_of_Death__c,
                  Medical_Review__r.Death_to_Cornea_Preservation_Time__c,Recovery__r.Tissue_recovery_date_time__c,Recovery__r.Referral__r.Primary_Cause_of_Death__c,Opacities1_Length_Diameter__c,Opacities1_mm_on_Button_From_LimbusDepth__c,Opacities1_Location_at__c,
                  Recovery__r.Date_Time_body_subjected_to_cooling__c,Recovery__r.Date_Time_body_removed_from_cooling__c,Preservation_Medium__c,Media_Lot__c,Opacities2_Length_Diameter__c,Opacities2_mm_on_Button_From_LimbusDept__c,Opacities2_Location_at__c,
                  Recovery__r.Recovery_completed_by__r.Name,Recovery__r.Cornea_preserved_by__r.Name,Medical_Review__c,Medical_Review__r.Total_Cooling_Time__c,Opacities_1__c,Opacities_2__c,Relative_number_of_Striae__c,Striae__c,Striae_Location__c,
                  Recovery__r.Referral__r.Social_and_Behavioral_History__c,Medical_Review__r.MedicalSurgical_History_Summary__c,Tissue_Expiry_Date__c,
                  Recovery__r.Referral__r.Was_the_donor_on_a_ventilator__c,Recovery__r.Referral__r.Duration_of_time_on_Ventilator_if_Yes__c,Evaluations_Comments__c,
                  Recovery__r.Referral__r.Autopsy_Completed__c,Medical_Review__r.Autopsy__c,Medical_Review__r.Attending_Physician__c,Medical_Review__r.Physical_Assessment__c,
                  Medical_Review__r.Medical_Chart__c,Medical_Review__r.Donor_Family_Information__c,Haze__c,Exposure__c,Exposure_Location__c,Exposure_Percentage__c,Sloughing__c,
                  Debris__c,If_Yes_Describe__c,Clear_and_Compact__c,Edema__c,Edema_Location__c,Arcus__c,Relative_number_of_folds__c,Folds__c,Defects__c,Defects_Describe__c,
                  Relative_Number_of_Stress_Lines__c,Stress_Lines_Location__c,Endothelium_Defects__c,Endothelium_If_Yes_Describe__c,Cell_Dropouts__c,Cell_Dropout_Location__c,
                  Polymegathism__c,Pleomorphism__c,Jaundice__c,Scleral_Rim_Information__c,PK__c,ALK__c,EK__c,K_Pro__c,KLA__c,Tectonic_Therapeutic__c,Clear_Zone__c,Lens__c,
                  Cell_Count_per_mm2__c,Number_of_Fields__c,Pachymetry_microns__c,Specular_Evaluation_Done_By__r.Name,Slit_Lamp_Eval_Performed_By__r.Name,Outcome_Slit_Lamp_Date_Time__c,Slit_Lamp_Date_Time__c,Slit_Lamp_Technician__r.Name,Specular_Evaluation_Date_Time__c,Specular_Date_Time__c,
                  Specular_Technician__r.Name,Medical_Review__r.HBsAG__c,Medical_Review__r.HCV__c,Medical_Review__r.HIV_I_II__c,Medical_Review__r.Syphilis__c,Recovery__r.Cornea_Preservation_Date_Time__c,
                  Date_Time_of_Final_Review_Approval__c,Final_Review_and_Approval_Done_By__r.Name from Tissue_Evaluation__c where id=:plac.Select_Tissue__c limit 1];

        System.debug('Tissue-->'+tissue.Name);
        }
        med  = new Medical_Review__c();
        if(tissue.Medical_Review__c!=null){
        med = [Select Id,Name,Recovery__c,Death_to_Cornea_Preservation_Time__c,Tissue_Imported__c,Origin_Eye_Bank__c,Origin_Eye_Bank_Tissue_ID__c from Medical_Review__c where id=:tissue.Medical_Review__c limit 1];
        }
            
        rec = new Recovery__c();
        if(med.Recovery__c!=null){
        rec = [Select Id,Name,Cornea_Preservation_Date_Time__c,Referral__c from Recovery__c where id=:med.Recovery__c limit 1];
        }
        ref = new Referral__c();
        if(rec.Referral__c!=null){
        ref = [Select Id,Name,Age_of_Donor__c,Primary_Cause_of_Death__c,Medical_Record_Number__c,Date_Time_of_Death__c from Referral__c where id=:rec.Referral__c limit 1];
        }
        System.debug('Surgery-->'+req.Surgery_Date_Time__c);
        if(req.Surgery_Date_Time__c!=null){
        decimal Interval = decimal.valueof((req.Surgery_Date_Time__c.getTime() - ref.Date_Time_of_Death__c.getTime())/(60*60));
        SurgeryInterval = integer.valueOf(Interval/1000)/24;
      //  diffDate = req.Surgery_Date_Time__c.daysBetween(ref.Date_Time_of_Death__c) ;
      //diffDate =  (req.Surgery_Date_Time__c - ref.Date_Time_of_Death__c) * 24 * 60 ;
     //  diffDate = ((req.Surgery_Date_Time__c.getTime())/1000/60) - ((ref.Date_Time_of_Death__c.getTime())/1000/60);
        }
        system.debug('Interval--->'+SurgeryInterval);
        
        
        EpitheliumValues = '';
        List<string> EpitheliumList = new list<string>();
        if(tissue.Haze__c!=null && tissue.Haze__c!='' && tissue.Haze__c!= 'none'){
            EpitheliumList.add(tissue.Haze__c+' Haze');
        }
        if((tissue.Exposure__c!='' && tissue.Exposure__c!=null)&&(tissue.Exposure_Location__c!='' && tissue.Exposure_Location__c!=null)){
            EpitheliumList.add(tissue.Exposure__c +' ' +tissue.Exposure_Location__c+' Exposure');
        }
        String sloughingVals = '';
        if((tissue.Exposure_Percentage__c >= 0 && tissue.Exposure_Percentage__c!=null)){
            sloughingVals = tissue.Exposure_Percentage__c+'% ';
        }
        if(tissue.Sloughing__c!='' && tissue.Sloughing__c!=null){
            sloughingVals = sloughingVals+tissue.Sloughing__c+' Sloughing';
        }
        if(sloughingVals != ''){
            EpitheliumList.add(sloughingVals); 
        }
        String ifYes = '';
        if(tissue.Debris__c!='' && tissue.Debris__c!=null){
            ifYes = tissue.Debris__c+' ';
            if(tissue.Debris__c == 'Yes'){
                if(tissue.If_Yes_Describe__c!='' && tissue.If_Yes_Describe__c!=null){
                    ifYes = ifYes+tissue.If_Yes_Describe__c;
                }             
            }
            else{
                
            }
        }
        if(ifYes != ''){
            EpitheliumList.add(ifYes+' Debris');
        }
        if(EpitheliumValues == ''){
            EpitheliumValues = String.join(EpitheliumList, '; ');
        }
        
       /* StromaValues = '';
        List<string> StromaList = new list<string>();
        if(tissue.Clear_and_Compact__c!='' && tissue.Clear_and_Compact__c!=null){
            StromaList.add(tissue.Clear_and_Compact__c);
        }
        if((tissue.Edema__c!='' && tissue.Edema__c!=null)&&(tissue.Edema_Location__c!='' && tissue.Edema_Location__c!=null)){
            StromaList.add(tissue.Edema__c +' ' +tissue.Edema_Location__c+' Edema');
        }
        if(tissue.Arcus__c!='' && tissue.Arcus__c!=null){
            StromaList.add(tissue.Arcus__c+' Arcus');
        }
        if(StromaValues == ''){
            StromaValues = String.join(StromaList, '; ');
        }*/
        StromaValues = '';
        List<string> StromaList = new list<string>();
        if(tissue.Clear_and_Compact__c!=null &&  tissue.Clear_and_Compact__c!='' &&  tissue.Clear_and_Compact__c!='none'){
            StromaList.add(tissue.Clear_and_Compact__c);
        }
        if((tissue.Striae__c!=null && tissue.Striae__c!='' && tissue.Striae__c!='none')&&(tissue.Striae_Location__c!=null && tissue.Striae_Location__c!='' && tissue.Striae_Location__c!='none')){
            StromaList.add(tissue.Striae__c +' ' +tissue.Striae_Location__c+' Striae');
        }
        if(tissue.Relative_number_of_Striae__c!=null && tissue.Relative_number_of_Striae__c !='' && tissue.Relative_number_of_Striae__c!='none'){
            StromaList.add(tissue.Relative_number_of_Striae__c+' Relative Number of Striae');
        }
        if((tissue.Edema__c!=null && tissue.Edema__c!='' && tissue.Edema__c!='none')&&(tissue.Edema_Location__c!=null && tissue.Edema_Location__c!='' && tissue.Edema_Location__c!='none')){
            StromaList.add(tissue.Edema__c +' ' +tissue.Edema_Location__c+' Edema');
        }
        if(tissue.Arcus__c!=null && tissue.Arcus__c!='' &&  tissue.Arcus__c!='none'){
            StromaList.add(tissue.Arcus__c+' Arcus');
        }
        
        
        string Opacities1=tissue.Opacities_1__c==null?'0':'Opacities 1 : '+tissue.Opacities_1__c;
        string Length=tissue.Opacities1_Length_Diameter__c==null?'0':tissue.Opacities1_Length_Diameter__c+' Length/Diameter ';
        string location=tissue.Opacities1_Location_at__c==null?'0':tissue.Opacities1_Location_at__c+' Location ';
        string Depth=tissue.Opacities1_mm_on_Button_From_LimbusDepth__c==null?'0':tissue.Opacities1_mm_on_Button_From_LimbusDepth__c+' on Button/From Limbus Depth';
         string Opacities2=tissue.Opacities_2__c==null?'0':'Opacities 2 : '+tissue.Opacities_2__c;
        string Length2=tissue.Opacities2_Length_Diameter__c==null?'0':tissue.Opacities2_Length_Diameter__c+' Length/Diameter ';
        string location2=tissue.Opacities2_Location_at__c==null?'0':tissue.Opacities2_Location_at__c+' Location ';
        string Depth2=tissue.Opacities2_mm_on_Button_From_LimbusDept__c==null?'0':tissue.Opacities2_mm_on_Button_From_LimbusDept__c+' on Button/From Limbus Depth';
        if(tissue.Opacities_1__c != 'none'){
        StromaList.add(Opacities1 );
        StromaList.add(Length );
        StromaList.add(location);
            StromaList.add(Depth);}
        if(tissue.Opacities_2__c != 'none'){
          StromaList.add(Opacities2 );
        StromaList.add(Length2 );
        StromaList.add(location2);
            StromaList.add(Depth2);}
            if(StromaValues == ''){
            StromaValues = String.join(StromaList, '; ');
        }
        
        
        DescemetValues = '';
        List<string> DescemetList = new list<string>();
        if((tissue.Relative_number_of_folds__c!=null && tissue.Relative_number_of_folds__c!='' && tissue.Relative_number_of_folds__c!='none')&&(tissue.Folds__c!=null && tissue.Folds__c!='' && tissue.Folds__c!='none')){
            DescemetList.add(tissue.Relative_number_of_folds__c +' ' +tissue.Folds__c);
        }
        String DefectsDescribe = '';
        if(tissue.Defects__c!=null && tissue.Defects__c!='' && tissue.Defects__c!='none'){
            DefectsDescribe = tissue.Defects__c+' ';
            if(tissue.Defects__c == 'None'){
                if(tissue.Defects_Describe__c!=null && tissue.Defects_Describe__c!='' && tissue.Defects_Describe__c!='none'){
                    DefectsDescribe = DefectsDescribe+tissue.Defects_Describe__c;
                }             
            }
            else{
                
            }
        }
        if(DefectsDescribe != ''){
            DescemetList.add(DefectsDescribe+' Defects');
        }
        if(DescemetValues == ''){
            DescemetValues = String.join(DescemetList, '; ');
        }
        
        EndotheliumValues = '';
        List<string> EndotheliumList = new list<string>();
        if((tissue.Relative_Number_of_Stress_Lines__c!=null && tissue.Relative_Number_of_Stress_Lines__c!='' && tissue.Relative_Number_of_Stress_Lines__c!='none')&&(tissue.Stress_Lines_Location__c!=null && tissue.Stress_Lines_Location__c!='' && tissue.Stress_Lines_Location__c!='none')){
            EndotheliumList.add(tissue.Relative_Number_of_Stress_Lines__c +' '+tissue.Stress_Lines_Location__c+' Stress Lines');
        }
        String DefectsYesDescribe = '';
        if(tissue.Endothelium_Defects__c!=null && tissue.Endothelium_Defects__c!='' && tissue.Endothelium_Defects__c!='none'){
            DefectsYesDescribe = tissue.Endothelium_Defects__c+' ';
           if(tissue.Endothelium_Defects__c == 'Yes'){
                if(tissue.Endothelium_If_Yes_Describe__c!=null && tissue.Endothelium_If_Yes_Describe__c!='' && tissue.Endothelium_If_Yes_Describe__c!='none'){
                    DefectsYesDescribe = DefectsYesDescribe+tissue.Endothelium_If_Yes_Describe__c;
                }             
            }
            else{
                
            } 
        }
        if(DefectsYesDescribe != ''){
            EndotheliumList.add(DefectsYesDescribe+' Defects');
        }
        if((tissue.Cell_Dropouts__c!=null && tissue.Cell_Dropouts__c!='' && tissue.Cell_Dropouts__c!='none')&&(tissue.Cell_Dropout_Location__c!=null && tissue.Cell_Dropout_Location__c!='' && tissue.Cell_Dropout_Location__c!='none')){
            EndotheliumList.add(tissue.Cell_Dropouts__c +' ' +tissue.Cell_Dropout_Location__c+' Cell Dropout');
        }
        if(tissue.Polymegathism__c!=null && tissue.Polymegathism__c!='' && tissue.Polymegathism__c!='none'){
            EndotheliumList.add(tissue.Polymegathism__c+' Polymegathism');
        }
        if(tissue.Pleomorphism__c!=null && tissue.Pleomorphism__c!='' && tissue.Pleomorphism__c!='none'){
            EndotheliumList.add(tissue.Pleomorphism__c+' Pleomorphism');
        }
        if(EndotheliumValues == ''){
            EndotheliumValues = String.join(EndotheliumList, '; ');
        }
        
        AdditionalValues = '';
        List<string> AdditionalList = new list<string>();
        if(tissue.Jaundice__c!=null && tissue.Jaundice__c!='' && tissue.Jaundice__c!='none'){
            AdditionalList.add(tissue.Jaundice__c+' Jaundice');
        }
        if(tissue.Scleral_Rim_Information__c!=null && tissue.Scleral_Rim_Information__c!='' && tissue.Scleral_Rim_Information__c!='none'){
            AdditionalList.add(tissue.Scleral_Rim_Information__c+' Scleral Rim');
        }
        if(AdditionalValues == ''){
            AdditionalValues = String.join(AdditionalList, '; ');
        }
        
        
      approvedUsages = '';
      medicalReviewOutcome = '';
        if(tissue.PK__c == 'Yes'){
            if(approvedUsages == ''){
                approvedUsages = 'PK';
            }
        }
        if(tissue.ALK__c == 'Yes'){
            if(approvedUsages == ''){
                approvedUsages = 'ALK';
            }
            else{
                approvedUsages = approvedUsages+', ALK';
            }
        }
    if(tissue.EK__c == 'Yes'){
            if(approvedUsages == ''){
                approvedUsages = 'EK';
            }
            else{
                approvedUsages = approvedUsages+', EK';
            }
        }
     if(tissue.K_Pro__c == 'Yes'){
            if(approvedUsages == ''){
                approvedUsages = 'K-Pro';
            }
            else{
                approvedUsages = approvedUsages+', K-Pro';
            }
        }
    if(tissue.KLA__c == 'Yes'){
            if(approvedUsages == ''){
                approvedUsages = 'KLA';
            }
            else{
                approvedUsages = approvedUsages+', KLA';
            }
        }
      if(tissue.Tectonic_Therapeutic__c == 'Yes'){
            if(approvedUsages == ''){
                approvedUsages = 'Tectonic/Therapeutic';
            }
            else{
                approvedUsages = approvedUsages+', Tectonic/Therapeutic';
            }
        } 
      if(tissue.Medical_Review__r.Medical_Chart__c == 'Yes'){
            if(medicalReviewOutcome == ''){
                medicalReviewOutcome = 'Medical Chart';
            }
        }
      if(tissue.Medical_Review__r.Physical_Assessment__c == 'Yes'){
            if(medicalReviewOutcome == ''){
                medicalReviewOutcome = 'Physical Assessment';
            }
        
      else{
                medicalReviewOutcome = medicalReviewOutcome+', Physical Assessment';
         }
      }
      if(tissue.Medical_Review__r.Donor_Family_Information__c == 'Yes'){
            if(medicalReviewOutcome == ''){
                medicalReviewOutcome = 'Donor Family Information';
            }
        
      else{
                medicalReviewOutcome = medicalReviewOutcome+', Donor Family Information';
         }
      }
      if(tissue.Medical_Review__r.Attending_Physician__c == 'Yes'){
            if(medicalReviewOutcome == ''){
                medicalReviewOutcome = 'Attending Physician';
            }
      else{
                medicalReviewOutcome = medicalReviewOutcome+', Attending Physician';
         }
      }
    }
     public Attachment attachment {
         get{
            List<Attachment> objAttachments = new List<Attachment>(); 
         Attachment att = new Attachment();
            try
            {               
                objAttachments = [Select Id, Name, ContentType from Attachment where ParentId = :plac.Select_Tissue__c AND Name LIKE '%-specEval' order by createddate DESC LIMIT 1]; 
                att = objAttachments[0];
            }
            catch(exception ex)
            {           
                objAttachments = null;
            }
            return att;  
           }
        set;}  
}