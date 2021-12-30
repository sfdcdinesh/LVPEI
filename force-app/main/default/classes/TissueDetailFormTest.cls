@isTest(seealldata=False)
Private class TissueDetailFormTest {
    
    static testmethod void getTissueDetails()
    {
        id org = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Organization').getRecordTypeId();
        //id contactrecordtype = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Counselors').getRecordTypeId();
        
       Profile profile = [Select Id From Profile where Name = 'System Administrator' limit 1];
       user u = new user();
       u.firstName = 'test1';
       u.lastName = 'test2';
       u.email = 'test@test.com';
       u.Username ='kiransai94310@gmail.com.hello';
       u.Alias ='rev';
       u.ProfileId = profile.id;
       u.LanguageLocaleKey= 'en_US';   
       u.TimeZoneSidKey ='Asia/Kolkata';
       u.EmailEncodingKey = 'ISO-8859-1';
       u.LocaleSidKey ='en_US';
        insert u;
         Branch__c branch = new Branch__c();
        branch.Name ='Drushtidaan Eye Bank';
        branch.Branch_Code__c = 'DDEB';
        branch.Request_Sequence_Number__c = 1;
        branch.Placement_Sequence_Number__c = 1;
        branch.Tissue_Return_Sequence_Number__c = 1;
        branch.Referral_Sequence_Number__c = 1;
        branch.Recovery_Sequence_Number__c = 1;
        insert branch;
        
        Branch_Team__c bt = new Branch_Team__c();
        bt.Name ='Team Megnity';
        bt.User__c = u.id;
        bt.Branch__c = branch.id;
        insert bt;
        
        
        Branch__c tempobj = [select Id,Name from Branch__c where Id = :branch.Id];
        system.debug('brnahc details '+tempobj);
        
        System.runAs(u) {

        Account acc = new Account();
        acc.Name = 'Apollo';
        acc.Hospital__c = true;
        acc.RecordTypeId = org;
        insert acc;
        
        Contact con = new Contact(LastName = 'test1', AccountId = acc.Id, Organisation_Hospital__c=true);
		insert con;
      
        Referral__c ref = new Referral__c(Death_Notification_Consignment_Date_Time__c = datetime.newInstance(2019, 12, 20, 12, 0, 0), 
                                         Referral_Method__c = 'HCRP', Referral_Source__c = 'HCRP motivated', Age_of_Donor__c = 45,
                                         Date_Time_of_Death__c = datetime.newInstance(2019, 12, 20, 12, 0, 0), 
                                         Date_of_Birth__c =  date.newInstance(1995, 12, 11));
        insert ref;
        
       	Recovery__c rec = new Recovery__c();
        rec.Tissue_recovery_date_time__c = datetime.newInstance(2019, 12, 20, 12, 0, 0);
        rec.Recovery_completed_by__c = con.Id;
        rec.Referral__c = ref.Id ;
        rec.Cornea_Preservation_Date_Time__c = system.today();
        insert rec;
		
        Medical_Review__c mr = new Medical_Review__c();
        mr.Referral__c = ref.Id;
        mr.Recovery__c = rec.Id;

        insert mr;
        
        Tissue_Evaluation__c tiseval = new Tissue_Evaluation__c();
        tiseval.Recovery__c = rec.Id;
        tiseval.Medical_Review__c = mr.Id;
        tiseval.Eye__c = 'OS';
        tiseval.Tissue_Type__c = 'Cornea';
        tiseval.Tissue_Sub_Type__c = 'Whole';
        tiseval.Approval_Outcome__c = 'Placed';
        tiseval.Specular_Evaluation__c = 'Yes';
        tiseval.Pre_Cut__c = 'Yes';
        tiseval.Tissue_Suitability__c = 'Suitable';
        tiseval.PK__c = 'Yes';
        tiseval.Edema__c ='Mild';
        tiseval.Edema_Location__c = 'Central';
        tiseval.Relative_number_of_folds__c ='Mild';
        tiseval.Folds__c ='Few';
     //   tiseval.EK__c = 'Yes';
        tiseval.ALK__c = 'Yes';
        tiseval.K_Pro__c='yes';
        tiseval.KLA__c = 'yes';
        tiseval.Tectonic_Therapeutic__c = 'yes';
        tiseval.Tissue_Disposition__c ='Discarded';
        tiseval.Approval_Outcome__c ='Discard';
        tiseval.Haze__c ='Mild';
        tiseval.Debris__c ='Yes';
        tiseval.Exposure__c ='Moderate';
        tiseval.Exposure_Location__c = 'Central';
        tiseval.Exposure_Percentage__c = 23;
        tiseval.Sloughing__c='Central';
        tiseval.Debris__c = 'yes';
        tiseval.Clear_and_Compact__c = 'Clear Only';
        tiseval.Striae__c ='yes';
        tiseval.Striae_Location__c ='Central';
        tiseval.If_Yes_Describe__c ='This is for testing';
            tiseval.Relative_number_of_Striae__c = 'Few';
            tiseval.Edema__c ='Mild';
            tiseval.Arcus__c ='Mild';
            tiseval.Endothelium_Defects__c = 'yes';
            tiseval.Endothelium_If_Yes_Describe__c = 'hello';
         tiseval.Preservation_Medium__c='Mk';
        tiseval.Date_Time_of_Final_Review_Approval__c = datetime.newInstance(2019, 05, 1);
        tiseval.Approved_Usages__c =' ';
        tiseval.Approved_Usages__c ='Ek';
       
        
        
        
        insert tiseval;
        
        Attachment attach2=new Attachment();   	
		attach2.Name='abcde-specEval';
		Blob bodyBlob=Blob.valueOf('abcde-specEval');
		attach2.body=bodyBlob;
		attach2.parentId=tiseval.id;
        attach2.ContentType = 'image/jpg';
		insert attach2;
        
        System.debug(tiseval);
        
        
        
        Test.startTest();
        
         Tissue_Evaluation__c tiseval1 = [select Id,Eye__c,Tissue_Type__c,If_Yes_Describe__c,Exposure_Location__c,Tissue_Sub_Type__c,Approval_Outcome__c,Approved_Usages__c,Haze__c,Debris__c,Exposure__c,Exposure_Percentage__c,Sloughing__c,Clear_and_Compact__c,Striae__c,Relative_number_of_Striae__c,Edema__c,Relative_number_of_folds__c,Folds__c,Arcus__c,Endothelium_Defects__c,Endothelium_If_Yes_Describe__c,Preservation_Medium__c,Date_Time_of_Final_Review_Approval__c From Tissue_Evaluation__c limit 1];
        
        Recovery__c rec1 = [select id, Cornea_Preservation_Date_Time__c from Recovery__c limit 1];

         ApexPages.currentPage().getParameters().put('tissueId', tiseval1.id);
        
        TissueDetailFormPrintController td = new TissueDetailFormPrintController();
        
        if(td.offset != null) {}
        if(td.attachment != null){}
        }
    }
    
    static testmethod void getTissueDetails1()
    {
        id org = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Organization').getRecordTypeId();
        //id contactrecordtype = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Counselors').getRecordTypeId();
      Profile profile = [Select Id From Profile where Name = 'System Administrator' limit 1];
       user u = new user();
       u.firstName = 'test1';
       u.lastName = 'test2';
       u.email = 'test@test.com';
       u.Username ='kiransai94310@gmail.com.hello';
       u.Alias ='rev';
       u.ProfileId = profile.id;
       u.LanguageLocaleKey= 'en_US';   
       u.TimeZoneSidKey ='Asia/Kolkata';
       u.EmailEncodingKey = 'ISO-8859-1';
       u.LocaleSidKey ='en_US';
        insert u;
         Branch__c branch = new Branch__c();
        branch.Name ='Drushtidaan Eye Bank';
        branch.Branch_Code__c = 'DDEB';
        branch.Request_Sequence_Number__c = 1;
        branch.Placement_Sequence_Number__c = 1;
        branch.Tissue_Return_Sequence_Number__c = 1;
        branch.Referral_Sequence_Number__c = 1;
        branch.Recovery_Sequence_Number__c = 1;
        insert branch;
        
        Branch_Team__c bt = new Branch_Team__c();
        bt.Name ='Team Megnity';
        bt.User__c = u.id;
        bt.Branch__c = branch.id;
        insert bt;
        
        
        Branch__c tempobj = [select Id,Name from Branch__c where Id = :branch.Id];
        system.debug('brnahc details '+tempobj);
        
        System.runAs(u) {

        Account acc = new Account();
        acc.Name = 'Apollo';
        acc.Hospital__c = true;
        acc.RecordTypeId = org;
        insert acc;
        
        Contact con = new Contact(LastName = 'test1', AccountId = acc.Id, Organisation_Hospital__c=true);
		insert con;
      
        Referral__c ref = new Referral__c(Death_Notification_Consignment_Date_Time__c = datetime.newInstance(2019, 12, 20, 12, 0, 0), 
                                         Referral_Method__c = 'HCRP', Referral_Source__c = 'HCRP motivated', Age_of_Donor__c = 45,
                                         Date_Time_of_Death__c = datetime.newInstance(2019, 12, 20, 12, 0, 0), 
                                         Date_of_Birth__c =  date.newInstance(1995, 12, 11));
        insert ref;
        
       	Recovery__c rec = new Recovery__c();
        rec.Tissue_recovery_date_time__c = datetime.newInstance(2019, 12, 20, 12, 0, 0);
        rec.Recovery_completed_by__c = con.Id;
        rec.Referral__c = ref.Id ;
        rec.Cornea_Preservation_Date_Time__c = system.today();
        insert rec;
		
        Medical_Review__c mr = new Medical_Review__c();
        mr.Referral__c = ref.Id;
        mr.Recovery__c = rec.Id;

        insert mr;
        
        Tissue_Evaluation__c tiseval = new Tissue_Evaluation__c();
        tiseval.Recovery__c = rec.Id;
        tiseval.Medical_Review__c = mr.Id;
        tiseval.Eye__c = 'OS';
        tiseval.Tissue_Type__c = 'Cornea';
        tiseval.Tissue_Sub_Type__c = 'Whole';
        tiseval.Approval_Outcome__c = 'Placed';
        tiseval.Specular_Evaluation__c = 'Yes';
        tiseval.Pre_Cut__c = 'Yes';
        tiseval.Tissue_Suitability__c = 'Suitable';
        tiseval.PK__c = 'Yes';
        tiseval.Edema__c ='Mild';
        tiseval.Edema_Location__c = 'Central';
        tiseval.Relative_number_of_folds__c ='Mild';
        tiseval.Folds__c ='Few';
       // tiseval.EK__c = 'Yes';
        tiseval.ALK__c = 'Yes';
        tiseval.K_Pro__c='yes';
        tiseval.KLA__c = 'yes';
        tiseval.Tectonic_Therapeutic__c = 'yes';
        tiseval.Tissue_Disposition__c ='Discarded';
        tiseval.Approval_Outcome__c ='Discard';
        tiseval.Haze__c ='Mild';
        tiseval.Debris__c ='Yes';
        tiseval.Exposure__c ='Moderate';
        tiseval.Exposure_Location__c = 'Central';
        tiseval.Exposure_Percentage__c = 23;
        tiseval.Sloughing__c='Central';
        tiseval.Debris__c = 'yes';
        tiseval.Clear_and_Compact__c = 'Clear Only';
        tiseval.Clear_and_Intact__c = 'No';
        tiseval.Opacities_1__c = 'Other';
        tiseval.Opacities1_Length_Diameter__c = '10';
        tiseval.Opacities1_Location_at__c = 'Central';
        tiseval.Opacities1_mm_on_Button_From_LimbusDepth__c = '12';
        tiseval.Opacities_2__c = 'Other';
        tiseval.Opacities2_Length_Diameter__c = '10';
        tiseval.Opacities2_Location_at__c = 'test';
        tiseval.Opacities2_mm_on_Button_From_LimbusDept__c = '10';
        tiseval.Percent_of_Total_Cornea__c = 10;
        tiseval.Striae__c ='yes';
        tiseval.Striae_Location__c ='Central';
        tiseval.If_Yes_Describe__c ='This is for testing';
        tiseval.Defects__c = 'Descemets Tears';
        tiseval.Defects_Describe__c = 'Test';
        tiseval.Relative_Number_of_Stress_Lines__c = 'Few';
        tiseval.Stress_Lines__c = 'Yes';
        tiseval.Stress_Lines_Location__c = 'Central';
            tiseval.Relative_number_of_Striae__c = 'Few';
            tiseval.Edema__c ='Mild';
            tiseval.Arcus__c ='Mild';
            tiseval.Endothelium_Defects__c = 'yes';
            tiseval.Endothelium_If_Yes_Describe__c = 'hello';
         tiseval.Preservation_Medium__c='Mk';
        tiseval.Date_Time_of_Final_Review_Approval__c = datetime.newInstance(2019, 05, 1);
        tiseval.Approved_Usages__c =' ';
        tiseval.Approved_Usages__c ='Ek';
       
        
        
        
        insert tiseval;
        
        Attachment attach2=new Attachment();   	
		attach2.Name='abcde-specEval';
		Blob bodyBlob=Blob.valueOf('abcde-specEval');
		attach2.body=bodyBlob;
		attach2.parentId=tiseval.id;
        attach2.ContentType = 'image/jpg';
		insert attach2;
        
        System.debug(tiseval);
        
        
        
        Test.startTest();
        
         Tissue_Evaluation__c tiseval1 = [select Id,Eye__c,Tissue_Type__c,If_Yes_Describe__c,Exposure_Location__c,Tissue_Sub_Type__c,Approval_Outcome__c,Approved_Usages__c,Haze__c,Debris__c,Exposure__c,Exposure_Percentage__c,Sloughing__c,Clear_and_Compact__c,Striae__c,Relative_number_of_Striae__c,Edema__c,Relative_number_of_folds__c,Folds__c,Arcus__c,Endothelium_Defects__c,Endothelium_If_Yes_Describe__c,Preservation_Medium__c,Date_Time_of_Final_Review_Approval__c From Tissue_Evaluation__c limit 1];
        
        Recovery__c rec1 = [select id, Cornea_Preservation_Date_Time__c from Recovery__c limit 1];

         ApexPages.currentPage().getParameters().put('tissueId', tiseval1.id);
        
        TissueDetailFormPrintController td = new TissueDetailFormPrintController();
       td.AdditionalValues ='';
        td.EndotheliumValues ='';
        td.EpitheliumValues ='';
        td.approvedUsages ='';
        
        if(td.offset != null) {}
        if(td.attachment != null){}
    }
    }

}