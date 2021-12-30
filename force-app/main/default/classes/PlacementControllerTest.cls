@isTest(seealldata=False)
private class PlacementControllerTest {
    
    static testmethod void getPlacementRecord()
    {
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

        
        account acc = new account(Name='hari',Phone='8008654356',City__c='hyderabad',Street_1__c='vasanthnagar',Street_2__c='roadnumberthree',Zip_Postal_Code__c='500085',Country__c='india',State__c='telengana',RecordTypeId=org );
        insert acc;
        
        contact con =new contact(accountid=acc.id,lastname='sagiraju',City__c='hyderabd',Street_1__c='ramnagar',Street_2__c='plotno436',Zip_Postal_Code__c='530045',Country__c='india',State__c='hyderabad',MobilePhone='9381956789');
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
        
        
        insert tiseval;
        
        Request__c req =new Request__c();
        req.Request_Date_time__c = system.today();
        req.Tissue_Evaluation__c = tiseval.Id;
        req.Requesting_Organization__c = acc.Id;
        req.Requesting_Surgeon__c = con.Id;
        req.Surgery_Location__c = acc.Id;
        req.Eye_Bank_Performing_Pre_Cut__c = acc.Id;
        
        insert req;
        
        Placement__c p = new Placement__c();
        p.Request__c = req.Id;
        p.Shipment_Date__c = system.today();
        p.Select_Tissue__c = tiseval.Id;
        p.Hand_Carried_By_By_Hand__c = con.id;
        p.To__c = acc.id;
        
        insert p;
        
        
        Test.startTest();
        
        Placement__c p1 = [select id, Select_Tissue__c, Hand_Carried_By_By_Hand__c, To__c  from Placement__c limit 1];
        //Account acc1 = [select id, Name from Account where id=: p1.To__c];
        Tissue_Return__c tr = new Tissue_Return__c();
        
        PlacementController.getCurrentUser();
        PlacementController.checkUserBranch();
        PlacementController.getReferral(ref.Id);
        PlacementController.savePDF('p1');
        PlacementController.saveReturn(tr, tr.id);
        PlacementController.getPlacementName(p1.Id);
     //   PlacementController.getBranchAddress(req.Id);
        PlacementController.getTissueEvalName(tiseval.Id);
        PlacementController.getLookups(p1.Id);
        PlacementController.getPlacementDetails(p1.Id);
        PlacementController.getRequestDetails(req.Id);
        PlacementController.getPlacementCount(req.Id);
        //PlacementController.savePlacement(p1, tiseval.id, con.id, req.Id, con.Id, tr, p1.Id);
        PlacementController.getReferral(ref.Id);
        //PlacementController.savePDF();
       // PlacementController.saveReturn(tr, con.Id);
      //  PlacementController.getPlacementName(p1.Id);
        //insert p1;
        
        Test.stopTest();
        
        }
        
        
        
    }
    static testmethod void getPlacementRecord1()
    {
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

        account acc = new account(Name='test7837',RecordTypeId=org);
        insert acc;
        
        contact con =new contact(accountid=acc.id,lastname='sagiraju',City__c='hyderabd',Street_1__c='ramnagar',Street_2__c='plotno436',Zip_Postal_Code__c='530045',Country__c='india',State__c='hyderabad',MobilePhone='9381956789');
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
        
        
        
        insert tiseval;
        
        System.debug(tiseval);
        
        Request__c req =new Request__c();
        req.Request_Date_time__c = system.today();
        req.Tissue_Evaluation__c = tiseval.Id;
        req.Requesting_Organization__c = acc.Id;
        req.Requesting_Surgeon__c = con.Id;
        req.Surgery_Location__c = acc.Id;
        req.Eye_Bank_Performing_Pre_Cut__c = acc.Id;
        
        insert req;
        
        Placement__c p = new Placement__c();
        p.Request__c = req.Id;
        p.Shipment_Date__c = system.today();
        p.Select_Tissue__c = tiseval.Id;
        p.Hand_Carried_By_By_Hand__c = con.id;
        p.To__c = acc.id;
        
        insert p;
        
        
        Test.startTest();
        
        Placement__c p1 = [select id, Hand_Carried_By_By_Hand__c, To__c, Tissue_Disposition__c, Select_Tissue__r.Name  from Placement__c limit 1];
        System.debug(p1.Id);
        
        Account acc1 = [select id, Name from Account where id=: p1.To__c];
        
        
        
        Tissue_Evaluation__c tiseval1 = [select Id,Name,Placement_Status__c,Approval_Outcome__c, Tissue_Disposition__c from Tissue_Evaluation__c limit 1];
        system.debug(tiseval1);
        
        Tissue_Return__c tr = new Tissue_Return__c();
        tr.Placement__c = p1.Id;
        System.debug(tiseval.Name);
        tr.Tissue_Id1__c = p1.Select_Tissue__r.Name ;
        
       // insert tr;
        
       
        
        //Tissue_Return__c tr1 = [select id , Name from Tissue_Return__c limit 1];
        
        
        PlacementController.savePlacement(p1, tiseval.id, con.id, req.Id, acc1.Id, tr, p1.Id);
       
        PlacementController.savePDF('/apex/TissueReturnPrintPDF');
        PlacementController.saveReturn(tr, con.Id);
        
        
        Test.stopTest();
        
        
        
        }
        
    }

}