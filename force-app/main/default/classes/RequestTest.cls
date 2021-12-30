// Test class for Request Component
@isTest(seealldata=False)
public class RequestTest {
        @isTest
        static void requestTestMethod(){
        //Id householdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household Account').getRecordTypeId();
        Id organization = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Organization').getRecordTypeId();
        Id counsellor = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Counselors').getRecordTypeId();
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

       //Inserting Account and Contact      
        Account a = TestFactory.getAccount(organization,'Ramayamma International Eye Bank Organisation', true);   
        Contact c = TestFactory.getContact(counsellor,a.Id,'Hasan',true);
        DateTime NotifDateTime = datetime.newInstance(2018, 12, 21, 12, 30, 0);
            
        Account acc = new Account();
        acc.Name = 'Apollo';
        acc.Hospital__c = true;
       // acc.RecordTypeId = org;
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

            
        
       //Inserting EMR record      
            EMR__c emr = new EMR__c(Name='Test Case');
            insert emr;
            Referral__c ref1 = new Referral__c();
            Request__c req = new Request__c();
            req.Request_Date_time__c = system.now();
            req.Tissue_Evaluation__c = tiseval.Id;
            req.Requesting_Organization__c = acc.Id;
            req.Requesting_Surgeon__c = con.Id;
      	    req.Surgery_Location__c = acc.Id;
            req.Eye_Bank_Performing_Pre_Cut__c = acc.Id;
            Insert req;
            req.Intended_Outcome__c = 'Training';
            update req;
            Test.startTest();
            ReqSave.getCurrentUser();
            string fld = 'Request_Source__c';
            ReqSave.getselectOptions(new Request__c(), fld);
          ReqSave.getRequestName(req.Id);
            ReqSave.getEmrDetails(req.Id);
            ReqSave.checkUserBranch();
            ReqSave.getCurrentUser();
            ReqSave.save(req, c.Id, c.Id, c.Id, c.Id, c.Id, emr, req.Id);
        /*Request__c reque = new Request__c();
        reque.Request_Date_time__c = system.now();
        ReqSave.save(reque,c.Id,c.Id,c.Id,c.Id,c.Id, emr.Id,null);
        ReqSave.getCurrentUser();
        string fld = 'Request_Source__c';
        Recovery__c Rc;
        ReqSave.getselectOptions(new Request__c(), fld); */
        Test.stopTest();  
        }

    }

}