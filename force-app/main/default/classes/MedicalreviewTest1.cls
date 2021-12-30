@isTest(seealldata=False)
private class MedicalreviewTest1 {

    static testmethod void medicalReviewTestMethod1(){
	
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
        mr.MedicalSurgical_History_Summary__c = ref.Medical_Ocular_History__c;
        
        insert mr;
    
        Blood_Product__c blood = new Blood_Product__c();
        List<Blood_Product__c> bloodlist = new List<Blood_Product__c>();
        blood.Volume__c = '10';
        bloodlist.add(blood);
            
        Colloid__c colloid = new Colloid__c();
        List<Colloid__c> colloidlist = new List<Colloid__c>();
        colloid.Colloid__c = 'colloid';
        colloidlist.add(colloid);
            
        Crystalloid__c crystalloid = new Crystalloid__c();
        List<Crystalloid__c> crystalloidlist = new List<Crystalloid__c>();
        crystalloid.Crystalloid__c = 'crystalloid';
        crystalloidlist.add(crystalloid);
            
        Test.startTest();
        Medical_Review__c medRev = [select Id from Medical_Review__c limit 1];
        MedicalReview.fetchInitData(medRev.Id);
        MedicalReview.fetchReqPicklist();
        MedicalReview.getCurrentUser();
        MedicalReview.checkUserBranch();
        MedicalReview.getLookups(medRev.Id);
        MedicalReview.getselectOptions(medRev, 'HBsAG__c');
        MedicalReview.getRecoveryId(medRev.Id);
        MedicalReview.getRecoveryDetails(rec.Id);
        MedicalReview.getDates(rec.Id);
        MedicalReview.getMedicalCount(rec.Id);
        MedicalReview.getMedicalReviewName(medRev.Id);
        MedicalReview.saveDetails(medRev, con.Id, con.Id, con.Id, con.Id, con.Id,bloodlist,colloidlist,crystalloidlist, medRev.Id); 
        //MedicalReview.saveDetails(medRev, c.Id, c.Id, c.Id, c.Id, c.Id,bloodlist,colloidlist,crystalloidlist,medRev1.Id);
        MedicalReview.getBloodSamples(medRev.Id);
        
        
        Test.stopTest();
        }
    }
    static testmethod void medicalReviewTestMethod2(){
	
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
        rec.Date_Time_body_removed_from_cooling__c = system.today();
        rec.Date_Time_body_subjected_to_cooling__c = datetime.newInstance(2020, 01, 01, 12, 0, 0);
        rec.Cornea_Preservation_Date_Time__c = system.today();
        insert rec;
		
        Medical_Review__c mr = new Medical_Review__c();
        mr.Referral__c = ref.Id;
        mr.Recovery__c = rec.Id;
        mr.MedicalSurgical_History_Summary__c = ref.Medical_Ocular_History__c;
        mr.Hemodilution_Done_By__c = con.Id;
        mr.Serology_Test_Done_By__c = con.Id;
        mr.Serology_Test_Approved_By__c = con.Id;
        mr.Medical_Review_Completed_By__c = con.Id;
        mr.Person_Collected_By__c = con.Id;
        
        insert mr;
    
        Blood_Product__c blood = new Blood_Product__c();
        List<Blood_Product__c> bloodlist = new List<Blood_Product__c>();
        blood.Volume__c = '10';
        bloodlist.add(blood);
            
        Colloid__c colloid = new Colloid__c();
        List<Colloid__c> colloidlist = new List<Colloid__c>();
        colloid.Colloid__c = 'colloid';
        colloidlist.add(colloid);
            
        Crystalloid__c crystalloid = new Crystalloid__c();
        List<Crystalloid__c> crystalloidlist = new List<Crystalloid__c>();
        crystalloid.Crystalloid__c = 'crystalloid';
        crystalloidlist.add(crystalloid);
            
        Test.startTest();
        
        
        Medical_Review__c medRev = [select Id, Hemodilution_Done_By__c, Serology_Test_Done_By__c, Serology_Test_Approved_By__c,
                                    Medical_Review_Completed_By__c, Person_Collected_By__c from Medical_Review__c limit 1];
        contact con1 = [select id, Name from Contact where id =: medRev.Hemodilution_Done_By__c];
        Recovery__c rec1 = [select Date_Time_body_removed_from_cooling__c, Date_Time_body_subjected_to_cooling__c, Cornea_Preservation_Date_Time__c,
                           Referral__r.Date_Time_of_Death__c from Recovery__c limit 1];
        
        MedicalReview.getLookups(medRev.Id);
        MedicalReview.getDates(rec1.Id);
        
        
        
        Test.stopTest(); 
        }
    }
}