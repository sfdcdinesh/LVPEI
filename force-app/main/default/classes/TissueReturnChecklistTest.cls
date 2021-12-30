@isTest
private class TissueReturnChecklistTest {
    static testmethod void getDownloadReportasPDF(){
        id org = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Organization').getRecordTypeId();
        
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
        
        system.debug('newly inserted user details '+u);
        system.debug('current loggedin user '+UserInfo.getUserId());

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
            account acc = new account(Name='hari',Phone='8008654356',City__c='hyderabad',Street_1__c='vasanthnagar',Street_2__c='roadnumberthree',Zip_Postal_Code__c='500085',Country__c='india',State__c='telengana',RecordTypeId=org);
            insert acc;
            
            contact con =new contact(accountid=acc.id,lastname='sagiraju',City__c='hyderabad',Street_1__c='ramnagar',Street_2__c='plotno436',Zip_Postal_Code__c='530045',Country__c='india',State__c='hyderabad',MobilePhone='9381956789');
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
            mr.Attending_Physician__c ='yes';
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
            tiseval.EK__c = 'Yes';
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
            
            Request__c req =new Request__c();
            req.Request_Date_time__c = system.today();
            req.Tissue_Evaluation__c = tiseval.Id;
            req.Requesting_Organization__c = acc.Id;
            req.Requesting_Surgeon__c = con.Id;
            req.Surgery_Location__c = acc.Id;
            req.Eye_Bank_Performing_Pre_Cut__c = acc.Id;
            req.Request_Status__c = 'Fulfilled';
            insert req;
            
            Placement__c p = new Placement__c();
            p.Request__c = req.Id;
            p.Shipment_Date__c = system.today();
            p.Select_Tissue__c = tiseval.Id;
            p.Hand_Carried_By_By_Hand__c = con.id;
            p.To__c = acc.id;
            p.From__c = 'Text';
            p.Date_3_6_Month_Follow_up_Form_Received__c =date.newInstance(2019, 05, 03);
            p.Date_3_6_month_Follow_Up_Form_Sent__c = date.newInstance(2019,05,04);
            insert p;
            system.debug('placement '+p);
            
            Placement__c p1 = [select id, Select_Tissue__c, Hand_Carried_By_By_Hand__c,To__c,From__c,Date_3_6_Month_Follow_up_Form_Received__c,Date_3_6_month_Follow_Up_Form_Sent__c from Placement__c where Id =:p.Id limit 1];  
            system.debug('placement '+p1);
            
            Tissue_Return__c tr = new Tissue_Return__c();
            tr.Name = 'yes';
            tr.Sent_to__c ='good';
            tr.Placement__c = p1.id;
            tr.Branch_Name__c = 'Drushtidaan Eye Bank';
            tr.Date_Time_Sent__c = datetime.newInstance(2019, 12, 20, 12, 0, 0);
            system.debug('tissue return '+tr);
            insert tr;
            system.debug('tissue return '+tr);
            
            Tissue_Return__c tr1= [select Id, Name, Branch_Name__c,Sent_to__c, Date_Time_Sent__c,Placement__c from Tissue_Return__c limit 1];
            
            Request__c req2 = [Select Id,Name,Request_Status__c,Request_Date_time__c,Tissue_Evaluation__c,Requesting_Organization__c,Requesting_Surgeon__c,Surgery_Location__c,Eye_Bank_Performing_Pre_Cut__c from Request__c limit 1 ];
            Tissue_Evaluation__c tiseval2 = [select Id,Eye__c,Tissue_Type__c,If_Yes_Describe__c,Exposure_Location__c,Tissue_Sub_Type__c,Approval_Outcome__c,Approved_Usages__c,Haze__c,Debris__c,Exposure__c,Exposure_Percentage__c,Sloughing__c,Clear_and_Compact__c,Striae__c,Relative_number_of_Striae__c,Edema__c,Relative_number_of_folds__c,Folds__c,Arcus__c,Endothelium_Defects__c,Endothelium_If_Yes_Describe__c,Preservation_Medium__c,Date_Time_of_Final_Review_Approval__c From Tissue_Evaluation__c limit 1];
            ApexPages.currentPage().getParameters().put('tisrtrnID', p.id);
            
            Test.startTest();
            TissueReturnChecklistForm trc = new TissueReturnChecklistForm();
            Test.stopTest();
        }
    }
}