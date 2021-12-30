@isTest(seealldata=False)
private class TissueEvaluationTest {
    
    static testmethod void getTissueEvaluationRecord1()
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
        tiseval.Approval_Outcome__c = 'Transplant';
        tiseval.Specular_Evaluation__c = 'Yes';
        tiseval.Pre_Cut__c = 'Yes';
        
        
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
        
        Tissue_Evaluation__c tiseval1 = [select Id, Approval_Outcome__c, Recovery__c from Tissue_Evaluation__c limit 1];
        Recovery__c rec1 = [select id, Cornea_Preservation_Date_Time__c from Recovery__c limit 1];

        //TissueEvaluationSave.doinit(tiseval1.Id);
        //TissueEvaluationSave.getTissue(tiseval1.Id);
        
       // TissueEvaluationSave.Savetissue(tiseval1, con.Id, con.Id, con.Id, con.Id, con.Id, con.Id, con.Id, con.Id, con.Id, tiseval1.Id);
        TissueEvaluationSave.getPreviousTissue(mr.Id);
        TissueEvaluationSave.fetchInitData(tiseval1.id);
        TissueEvaluationSave.getCurrentUser();
        TissueEvaluationSave.checkUserBranch();
        TissueEvaluationSave.fetchTissue(tiseval1.id);
        TissueEvaluationSave.Savetissue(tiseval1,con.id,con.id,con.id,con.id,con.id,con.id,con.id,con.id,con.id);
        TissueEvaluationSave.getLookups(tiseval1.Id);
        TissueEvaluationSave.getTissueEvalName(tiseval1.Id);
        TissueEvaluationSave.getRecovery(rec.Id);
        TissueEvaluationSave.getDonorId(tiseval1.Id);
        TissueEvaluationSave.getTissueCount(mr.Id);
        TissueEvaluationSave.tissueInventory();
        TissueEvaluationSave.getAlltissues();
        TissueEvaluationSave.createChildRecord(TisEval, 'tiseval1');
        TissueEvaluationSave.getAttachments(tiseval1.Id);
        TissueEvaluationSave.saveNewAttachment(attach2.Body, attach2.Name, attach2.ContentType, tiseval1.Id );
        
        
        
        
        
        Test.stopTest();
        }
        
    }
    static testmethod void getTissueEvaluationRecord2()
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
        tiseval.Approval_Outcome__c = 'Transplant';
        tiseval.Specular_Evaluation__c = 'Yes';
        tiseval.Pre_Cut__c = 'Yes';
        tiseval.Tissue_Processed_By__c = null;
       tiseval.Specular_Evaluation_Done_By__c = null;
        tiseval.Cornea_Suitability_Determined_By__c = null;
        tiseval.Slit_Lamp_Eval_Performed_By__c = null;
        tiseval.Final_Review_and_Approval_Done_By__c = null;
         tiseval.Slit_Lamp_Technician__c = null;
           tiseval.Specular_Technician__c =null;
        tiseval.EK_Tech__c = null;
        tiseval.Circulator__c = null;
       
        
        
        insert tiseval;
        System.debug(tiseval);
        
       	Attachment attach=new Attachment();   	
		attach.Name='abcde-specEval';
		Blob bodyBlob=Blob.valueOf('abcde-specEval');
		attach.body=bodyBlob;
		attach.parentId=tiseval.id;
		insert attach;
        
        
        
        Test.startTest();
        
        Tissue_Evaluation__c tiseval1 = [select Id, Approval_Outcome__c, Recovery__c,Tissue_Processed_By__c,Specular_Evaluation_Done_By__c,Cornea_Suitability_Determined_By__c,
                                    Slit_Lamp_Eval_Performed_By__c,Final_Review_and_Approval_Done_By__c,Slit_Lamp_Technician__c,
                                    Specular_Technician__c,EK_Tech__c,Circulator__c from Tissue_Evaluation__c limit 1];
      
        
        

        TissueEvaluationSave.getAttachments(tiseval1.Id);
        
        
        Test.stopTest();

        }
    }
    static testmethod void getTissueEvaluationRecord3()
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
        tiseval.Approval_Outcome__c = 'Transplant';
        tiseval.Specular_Evaluation__c = 'Yes';
        tiseval.Pre_Cut__c = 'Yes';
        
        
        insert tiseval;
        System.debug(tiseval);
        
        Attachment attach1=new Attachment();   	
		attach1.Name='abcde-specEval';
		Blob bodyBlob=Blob.valueOf('abcde-specEval');
		attach1.body=bodyBlob;
		attach1.parentId=tiseval.id;
        attach1.ContentType = 'image/jpg';
		insert attach1;
        
        

        Test.startTest();
        
        Tissue_Evaluation__c tiseval1 = [select Id, Approval_Outcome__c, Recovery__c from Tissue_Evaluation__c limit 1];
         TissueEvaluationSave.fetchInitData(tiseval1.ID);
        TissueEvaluationSave.getAttachments(tiseval1.Id);
        TissueEvaluationSave.saveNewAttachment(attach1.Body, attach1.Name, attach1.ContentType, tiseval1.Id );
         TissueEvaluationSave.getPreviousTissue(mr.Id);
        TissueEvaluationSave.fetchInitData(tiseval1.id);
        TissueEvaluationSave.getCurrentUser();
        TissueEvaluationSave.fetchTissue(tiseval1.id);
        TissueEvaluationSave.Savetissue(tiseval1,con.id,con.id,con.id,con.id,con.id,con.id,con.id,con.id,con.id);
        TissueEvaluationSave.getLookups(tiseval1.Id);
        TissueEvaluationSave.getTissueEvalName(tiseval1.Id);
        TissueEvaluationSave.getRecovery(rec.Id);
        TissueEvaluationSave.getDonorId(tiseval1.Id);
        TissueEvaluationSave.getTissueCount(mr.Id);
        TissueEvaluationSave.tissueInventory();
        TissueEvaluationSave.getAlltissues();
        TissueEvaluationSave.createChildRecord(TisEval, 'tiseval1');
        TissueEvaluationSave.getAttachments(tiseval1.Id);
        TissueEvaluationSave.saveNewAttachment(attach1.Body, attach1.Name, attach1.ContentType, tiseval1.Id );
        TissueEvaluationSave.fetchChildRecord(tiseval1.id);
        
        Test.stopTest();

        }
    }
    

}