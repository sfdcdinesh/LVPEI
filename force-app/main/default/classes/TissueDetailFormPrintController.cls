public class TissueDetailFormPrintController {
    public Tissue_Evaluation__c tissue{get;set;}
    public String approvedUsages{get;set;}
    public String medicalReviewOutcome{get;set;}
    public ID tissueId;
    public string EpitheliumValues{get;set;}
    public string StromaValues{get;set;}
    public string DescemetValues{get;set;}
    public string EndotheliumValues{get;set;}
    public string AdditionalValues{get;set;}
    public Branch__c branch{get;set;}
    public Double offset{get{
        TimeZone tz = UserInfo.getTimeZone();
        //Milliseconds to Day
        return tz.getOffset(DateTime.now()) / (1000 * 3600 * 24.0);
    }}
    
    
    
    
    public TissueDetailFormPrintController() {
        
        String UserName = UserInfo.getUserName();//Returns the context user's login name.
        System.Debug('UserName-' + UserName);
        
        tissueId = ApexPages.currentPage().getParameters().get('tissueId');    
        tissue = new Tissue_Evaluation__c();
        tissue = [Select Donor_ID__c,Name,Tissue_Type__c,Outcome_Slit_Lamp_Date_Time__c,Opacities1_Length_Diameter__c,Opacities1_mm_on_Button_From_LimbusDepth__c,Opacities1_Location_at__c,
                  Opacities2_Length_Diameter__c,Opacities2_mm_on_Button_From_LimbusDept__c,Opacities2_Location_at__c,Recovery__r.Referral__r.Age_of_Donor__c,Recovery__r.Referral__r.Gender__c,Recovery__r.Referral__r.Date_Time_of_Death__c,
                  Medical_Review__r.Death_to_Cornea_Preservation_Time__c,Recovery__r.Tissue_recovery_date_time__c,Recovery__r.Referral__r.Primary_Cause_of_Death__c,
                  Recovery__r.Date_Time_body_subjected_to_cooling__c,Recovery__r.Date_Time_body_removed_from_cooling__c,Preservation_Medium__c,Media_Lot__c,
                  Recovery__r.Recovery_completed_by__r.Name,Recovery__r.Cornea_preserved_by__r.Name,Medical_Review__r.Total_Cooling_Time__c,Slit_Lamp_Technician__r.Name,Specular_Date_Time__c,Specular_Technician__r.Name,
                  Recovery__r.Referral__r.Social_and_Behavioral_History__c,Medical_Review__r.MedicalSurgical_History_Summary__c,Tissue_Expiry_Date__c,
                  Recovery__r.Referral__r.Was_the_donor_on_a_ventilator__c,Recovery__r.Referral__r.Duration_of_time_on_Ventilator_if_Yes__c,Evaluations_Comments__c,
                  Recovery__r.Referral__r.Autopsy_Completed__c,Medical_Review__r.Autopsy__c,Medical_Review__r.Attending_Physician__c,Medical_Review__r.Physical_Assessment__c,
                  Medical_Review__r.Medical_Chart__c,Medical_Review__r.Donor_Family_Information__c,Haze__c,Exposure__c,Exposure_Location__c,Exposure_Percentage__c,Sloughing__c,
                  Debris__c,If_Yes_Describe__c,Clear_and_Compact__c,Edema__c,Edema_Location__c,Arcus__c,Relative_number_of_folds__c,Folds__c,Defects__c,Defects_Describe__c,
                  Relative_Number_of_Stress_Lines__c,Stress_Lines_Location__c,Endothelium_Defects__c,Endothelium_If_Yes_Describe__c,Cell_Dropouts__c,Cell_Dropout_Location__c,
                  Polymegathism__c,Pleomorphism__c,Jaundice__c,Scleral_Rim_Information__c,Scleral_Rim_2mm_or_greater_circumferen__c ,Scleral_rim_is_greater_than_2mm_Describe__c ,PK__c,ALK__c,EK__c,K_Pro__c,KLA__c,Tectonic_Therapeutic__c,Clear_Zone__c,Lens__c,Percent_of_Total_Cornea__c,
                  Cell_Count_per_mm2__c,Number_of_Fields__c,Pachymetry_microns__c,Slit_Lamp_Date_Time__c,Slit_Lamp_Eval_Performed_By__r.Name,Specular_Evaluation_Date_Time__c,
                  Specular_Evaluation_Done_By__r.Name,Medical_Review__r.HBsAG__c,Medical_Review__r.HCV__c,Medical_Review__r.HIV_I_II__c,Medical_Review__r.Syphilis__c,Recovery__r.Cornea_Preservation_Date_Time__c,
                  Date_Time_of_Final_Review_Approval__c,Final_Review_and_Approval_Done_By__r.Name,Opacities_1__c,Opacities_2__c,Relative_number_of_Striae__c,Striae__c,Striae_Location__c, Tissue_Suitability__c,
                  Stroma__c, Epithelium__c, Descemet_s_Membrane__c, Endothelium__c, Slit_Lamp_Evaluation__c, Specular_Evaluation__c,Prior_Refractive_Surgery__c, Scar__c, Stroma_Infractive__c, Foreign_Body__c, Other__c, Descemet_Comments__c,  Medical_Review__r.Death_To_Cornea_Preservation_Time1__c,
                  Endothelium_Comments__c, Epithelium_Comments__c, Stroma_Comments__c, Stress_Lines__c, Clear_and_Intact__c, CreatedBy.FirstName , CreatedBy.LastName,Branch_Name__c from Tissue_Evaluation__c where id=:tissueId limit 1];
        
        Map<String,string> referralMap = new Map<String, string>();
        referralMap.put('BranchName', tissue.Branch_Name__c);
        Flow.Interview.GetBranchAddress myflow = new Flow.Interview.GetBranchAddress(referralMap);
        myflow.start();
    	branch = (Branch__c)myflow.getVariableValue('BranchRecord');
        EpitheliumValues = '';
        List<string> EpitheliumList = new list<string>();
        
        
        if(tissue.Clear_and_Intact__c == 'Yes')
        {
            EpitheliumList.add(tissue.Clear_and_Intact__c+' Clear and Intact');
        }
        if(tissue.Clear_and_Intact__c == 'No')
        {
                if(tissue.Haze__c!=null && tissue.Haze__c!= ''){
                    EpitheliumList.add(tissue.Haze__c+' Haze');
                } 
                
            if(tissue.Exposure__c!=null && tissue.Exposure__c!='') {
                if(tissue.Exposure_Location__c!='' && tissue.Exposure_Location__c!=null && tissue.Exposure_Location__c!='none'){
                    EpitheliumList.add(tissue.Exposure__c +' ' +tissue.Exposure_Location__c+' Exposure Keratitis');
                }
                else
                {
                  EpitheliumList.add(tissue.Exposure__c + 'Exposure Keratitis');  
                }
            }
                
                String ExposurePercentage = '';
                if(tissue.Exposure_Percentage__c!=null && tissue.Exposure_Percentage__c >= 0 && tissue.Exposure_Percentage__c!=null){
                    ExposurePercentage = tissue.Exposure_Percentage__c+ '%' ;
                }
                
                if(ExposurePercentage != '')
                {
                    EpitheliumList.add(ExposurePercentage); 
                }
                
                String sloughingVals = '';
                if(tissue.Percent_of_Total_Cornea__c != null && tissue.Percent_of_Total_Cornea__c >= 0 && tissue.Percent_of_Total_Cornea__c!=null){
                    sloughingVals = tissue.Percent_of_Total_Cornea__c+'% ';
                }
                if(tissue.Sloughing__c!=null && tissue.Sloughing__c!=''){
                    sloughingVals = sloughingVals+tissue.Sloughing__c+' Sloughing';
                }
                if(sloughingVals != ''){
                    EpitheliumList.add(sloughingVals); 
                }
            	if (tissue.Epithelium_Comments__c != '')
                {
                    EpitheliumList.add(tissue.Epithelium_Comments__c);
                }
        }
        
        String ifYes = '';
        if(tissue.Debris__c != null && tissue.Debris__c!=''){
            //ifYes = tissue.Debris__c+' ';
            if(tissue.Debris__c == 'Yes'){
                if(tissue.If_Yes_Describe__c!=null && tissue.If_Yes_Describe__c!='' && tissue.If_Yes_Describe__c!='none'){
                    ifYes = ifYes+tissue.If_Yes_Describe__c;
                }             
            }
            else{
                
            }
        }
        if(ifYes != '' ){
            EpitheliumList.add(ifYes+' Debris  ');
        }
        
        if(EpitheliumValues == ''){
            EpitheliumValues = String.join(EpitheliumList, ';  ');
        }
        
        StromaValues = '';
        List<string> StromaList = new list<string>();
        if(tissue.Clear_and_Compact__c==''){
            StromaList.add('');
        }
        
        if(tissue.Clear_and_Compact__c!=null && tissue.Clear_and_Compact__c!=''){
            StromaList.add(tissue.Clear_and_Compact__c);
        }
        if(tissue.Striae__c!=null && tissue.Striae__c!=''){
           if(tissue.Striae_Location__c!=null && tissue.Striae_Location__c!='' && tissue.Striae_Location__c!='none'){
            StromaList.add(tissue.Striae__c +' ' +tissue.Striae_Location__c+' Striae');
        }
            else{
               StromaList.add(tissue.Striae__c +'Striae'); 
            }
        }
        if(tissue.Relative_number_of_Striae__c!=null && tissue.Relative_number_of_Striae__c!=''){
            StromaList.add(tissue.Relative_number_of_Striae__c+' Relative Number of Striae');
        }
        if(tissue.Edema__c!=null && tissue.Edema__c!=''){
           if(tissue.Edema_Location__c!=null && tissue.Edema_Location__c!='' && tissue.Edema_Location__c!='none'){
            StromaList.add(tissue.Edema__c +' ' +tissue.Edema_Location__c+' Edema');
        }
            else{
               StromaList.add(tissue.Edema__c +'Edema'); 
            }
        }
        if(tissue.Arcus__c!=null && tissue.Arcus__c!=''){
            StromaList.add(tissue.Arcus__c+' Arcus');
        }
        
        String StromaComments = tissue.Stroma_Comments__c == null?null: '  '+tissue.Stroma_Comments__c;
        if(tissue.Stroma_Comments__c != null)
        {
            StromaList.add(';' +StromaComments);
        }
        
        string Opacities1=tissue.Opacities_1__c==null?null:'Opacities 1 : '+tissue.Opacities_1__c;
        string Length=tissue.Opacities1_Length_Diameter__c==null?null:tissue.Opacities1_Length_Diameter__c+' Length ';
        string location=tissue.Opacities1_Location_at__c==null?null:tissue.Opacities1_Location_at__c+' Location ';
        string Depth=tissue.Opacities1_mm_on_Button_From_LimbusDepth__c==null?null:tissue.Opacities1_mm_on_Button_From_LimbusDepth__c+'Depth';
        string Opacities2=tissue.Opacities_2__c==null?null:'Opacities 2 : '+tissue.Opacities_2__c;
        string Length2=tissue.Opacities2_Length_Diameter__c==null?null:tissue.Opacities2_Length_Diameter__c+' Length';
        string location2=tissue.Opacities2_Location_at__c==null?null:tissue.Opacities2_Location_at__c+' Location ';
        string Depth2=tissue.Opacities2_mm_on_Button_From_LimbusDept__c==null?null:tissue.Opacities2_mm_on_Button_From_LimbusDept__c+'Depth';
        if(tissue.Opacities_1__c!='none' && tissue.Opacities_1__c!= null && tissue.Opacities_1__c!=''){
            StromaList.add(Opacities1 );
            StromaList.add(Length );
            StromaList.add(location);
            StromaList.add(Depth);} 
        
        if(tissue.Opacities_2__c!='none'&& tissue.Opacities_2__c!= null && tissue.Opacities_2__c!=''){
            StromaList.add(Opacities2 );
            StromaList.add(Length2 );
            StromaList.add(location2);
            StromaList.add(Depth2); }
        if(tissue.Opacities_1__c == 'None')
        {
            StromaList.add('Opacities 1 : '+tissue.Opacities_1__c );
        }
        
        if(tissue.Opacities_2__c == 'None')
        {
            StromaList.add('Opacities 2 : '+tissue.Opacities_1__c );
        }
        
        
        if(StromaValues != null){
            StromaValues = String.join(StromaList, '; ');
        }
        
        
        DescemetValues = '';
        List<string> DescemetList = new list<string>();
        if(tissue.Folds__c!=null && tissue.Folds__c!=''){
            if(tissue.Relative_number_of_folds__c!=null && tissue.Relative_number_of_folds__c!=''&& tissue.Relative_number_of_folds__c!='none')
            {
            DescemetList.add(tissue.Relative_number_of_folds__c +' ' +tissue.Folds__c + 'Folds');
        }
            else
            {
              DescemetList.add(+tissue.Folds__c + 'Folds');  
            }
        }
        
        String DefectsDescribe = '';
        if(tissue.Defects__c!=null && tissue.Defects__c!=''){
            DefectsDescribe = tissue.Defects__c+' ';
            System.debug(DefectsDescribe);
            if(tissue.Defects__c!= null && tissue.Defects__c!=''){
                if(tissue.Defects_Describe__c!=null && tissue.Defects_Describe__c!=''){
                    DefectsDescribe = DefectsDescribe+tissue.Defects_Describe__c;
                    system.debug('Defects'+DefectsDescribe);
                } 
                
                 
                
            }
            else{
                	
                	
                }             
                
            
        }
        
        
        
        
        
        if(DefectsDescribe != ''){
            DescemetList.add(DefectsDescribe+' ' );
        }
        if(tissue.Descemet_Comments__c != null)
        {
            DescemetList.add(tissue.Descemet_Comments__c);
        }
        if(tissue.Defects_Describe__c == 'None')
        {
            DescemetList.add(tissue.Defects_Describe__c);
        }
        if(DescemetValues == ''){
            DescemetValues = String.join(DescemetList, ' ');
            
        }
        
        EndotheliumValues = '';
        List<string> EndotheliumList = new list<string>();
        String str1 = '';
        str1 = (tissue.Relative_Number_of_Stress_Lines__c!=null && 
                tissue.Relative_Number_of_Stress_Lines__c!='' && 
                tissue.Relative_Number_of_Stress_Lines__c!='none')? (tissue.Relative_Number_of_Stress_Lines__c + ' ') : str1;
        str1 = (tissue.Stress_Lines_Location__c!=null && 
                tissue.Stress_Lines_Location__c!='' && 
                tissue.Stress_Lines_Location__c!='none')? str1 + tissue.Stress_Lines_Location__c + ' ' : str1;
        if(str1 <> '')
            EndotheliumList.add( str1 + 'Stress Lines');
        
        if(tissue.Stress_Lines__c == 'None')
        {
            EndotheliumList.add('Stress Lines : '+tissue.Stress_Lines__c);
        }
        
        system.debug('str1 : ' + str1);
        /*
if(
(tissue.Relative_Number_of_Stress_Lines__c!=null && 
tissue.Relative_Number_of_Stress_Lines__c!='' && 
tissue.Relative_Number_of_Stress_Lines__c!='none') &&

(tissue.Stress_Lines_Location__c!=null && 
tissue.Stress_Lines_Location__c!='' && 
tissue.Stress_Lines_Location__c!='none')){
EndotheliumList.add(tissue.Relative_Number_of_Stress_Lines__c +' ' +tissue.Stress_Lines_Location__c+' Stress Lines');
}
*/    
        String DefectsYesDescribe = '';
        if(tissue.Endothelium_Defects__c!= null && tissue.Endothelium_Defects__c!=''){
           // DefectsYesDescribe = tissue.Endothelium_Defects__c+' ';
            if(tissue.Endothelium_Defects__c == 'Yes'){
                if(tissue.Endothelium_If_Yes_Describe__c!=null && tissue.Endothelium_If_Yes_Describe__c!='' && tissue.Endothelium_If_Yes_Describe__c!='none') {
                    DefectsYesDescribe = DefectsYesDescribe+tissue.Endothelium_If_Yes_Describe__c ;
                    //EndotheliumList.add(tissue.Endothelium_If_Yes_Describe__c+'' +tissue.Endothelium_Comments__c+'Endothelium Defects');
                }             
            }
            else{
                
            } 
        }
        if(DefectsYesDescribe != ''){
            EndotheliumList.add(DefectsYesDescribe+' Defects');
        }
        if(tissue.Endothelium_Comments__c!='')
        {
           EndotheliumList.add(tissue.Endothelium_Comments__c); 
        }
        if(tissue.Cell_Dropouts__c!=null && tissue.Cell_Dropouts__c!='') {
           if(tissue.Cell_Dropout_Location__c!=null && tissue.Cell_Dropout_Location__c!='' && tissue.Cell_Dropout_Location__c!='none'){
            EndotheliumList.add(tissue.Cell_Dropouts__c +' ' +tissue.Cell_Dropout_Location__c+' Cell Dropout');
        }
            else
            {
              EndotheliumList.add(tissue.Cell_Dropouts__c +'Cell Dropout');  
            }
        }
        if(tissue.Polymegathism__c!=null && tissue.Polymegathism__c!=''){
            EndotheliumList.add(tissue.Polymegathism__c+' Polymegathism');
        }
        if(tissue.Pleomorphism__c!= null && tissue.Pleomorphism__c!=''){
            EndotheliumList.add(tissue.Pleomorphism__c+' Pleomorphism');
        }
        if(EndotheliumValues == ''){
            EndotheliumValues = String.join(EndotheliumList, '; ');
        }
        
        AdditionalValues = '';
        List<string> AdditionalList = new list<string>();
        if(tissue.Jaundice__c!=null && tissue.Jaundice__c!=''){
            AdditionalList.add(tissue.Jaundice__c+' Jaundice');
        }
        if(tissue.Scleral_Rim_Information__c!=null && tissue.Scleral_Rim_Information__c!=''){
            AdditionalList.add(tissue.Scleral_Rim_Information__c+' Scleral Rim');
        }
        if(tissue.Scleral_Rim_2mm_or_greater_circumferen__c!='No'&& tissue.Scleral_Rim_2mm_or_greater_circumferen__c!='none'){
            AdditionalList.add(tissue.Scleral_Rim_2mm_or_greater_circumferen__c+' Scleral Rim 2mm');
        }
        if(tissue.Scleral_Rim_2mm_or_greater_circumferen__c!='Yes' && tissue.Scleral_Rim_2mm_or_greater_circumferen__c!='none' )
        {
         AdditionalList.add(tissue.Scleral_rim_is_greater_than_2mm_Describe__c +' ');   
        }
        if(AdditionalValues == ''){
            AdditionalValues = String.join(AdditionalList, '; ');
        }
        
        approvedUsages = '';
        medicalReviewOutcome = '';
        
        
        if(tissue.Tissue_Suitability__c == 'Suitable')
        {
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
        }
       /* if(tissue.Tissue_Suitability__c == 'NSFT')
        {
            if(tissue.Stroma__c == 'Yes'){
                if(approvedUsages == ''){
                    approvedUsages = 'Stroma';
                    if(tissue.Prior_Refractive_Surgery__c == 'Yes'){
                        if(approvedUsages == ''){
							approvedUsages = 'Prior Refractive Surgery';
                        }
                        else{
                             approvedUsages = approvedUsages+', Prior Refractive Surgery';
                        }
                    }
                    if(tissue.Scar__c == 'Yes'){
                        if(approvedUsages == ''){
							approvedUsages = 'Scar';
                        }
                        else{
                             approvedUsages = approvedUsages+', Scar';
                        }
                    }
                    if(tissue.Stroma_Infractive__c == 'Yes'){
                        if(approvedUsages == ''){
							approvedUsages = 'Stroma Infractive';
                        }
                        else{
                             approvedUsages = approvedUsages+', Stroma Infractive';
                        }
                    }
                    if(tissue.Foreign_Body__c == 'Yes'){
                        if(approvedUsages == ''){
							approvedUsages = 'Foreign Body';
                        }
                        else{
                             approvedUsages = approvedUsages+', Foreign Body';
                        }
                    }
                    if(tissue.Other__c == 'Yes'){
                        if(approvedUsages == ''){
							approvedUsages = 'Other';
                        }
                        else{
                             approvedUsages = approvedUsages+', Other';
                        }
                    }
                    
                }
                else {
                    approvedUsages = approvedUsages+', Stroma';
                }
            }
            if(tissue.Epithelium__c == 'Yes'){
                if(approvedUsages == ''){
                    approvedUsages = 'Epithelium';
                }
                else {
                    approvedUsages = approvedUsages+', Epithelium';
                }

            }
            if(tissue.Descemet_s_Membrane__c == 'Yes'){
                if(approvedUsages == ''){
                    approvedUsages = 'Descemets Membrane';
                }
                else {
                    approvedUsages = approvedUsages+', Descemets Membrane';
                }
                
            }
            if(tissue.Endothelium__c	 == 'Yes'){
                if(approvedUsages == ''){
                    approvedUsages = 'Endothelium';
                }
                else {
                    approvedUsages = approvedUsages+', Endothelium';
                }
            }
            if(tissue.Slit_Lamp_Evaluation__c	 == 'Yes'){
                if(approvedUsages == ''){
                    approvedUsages = 'Slit Lamp Evaluation';
                }
                else {
                    approvedUsages = approvedUsages+', Slit Lamp Evaluation';
                }
            }
            if(tissue.Specular_Evaluation__c	 == 'Yes'){
                if(approvedUsages == ''){
                    approvedUsages = 'Specular Evaluation';
                }
                else {
                    approvedUsages = approvedUsages+', Specular Evaluation';
                }
            }
        }*/
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
    
    public Attachment attachment {get {
        List<Attachment> objAttachments = new List<Attachment>(); 
        Attachment att = new Attachment();
        try
        {               
            objAttachments = [Select Id, Name, ContentType from Attachment where ParentId = :tissueId AND Name LIKE '%-specEval' order by createddate DESC LIMIT 1]; 
            att = objAttachments[0];
        }
        catch(exception ex)
        {           
            objAttachments = null;
        }
        return att;  
    } set;}  
    
    
}