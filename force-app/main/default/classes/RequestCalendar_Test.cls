@isTest
public class RequestCalendar_Test {
    @isTest
    Static void requestSummaryTest(){
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

        Request__c reqt = new Request__c();
        reqt.Request_Status__c = 'Fulfilled';
        reqt.Request_Date_time__c = Datetime.now();
        reqt.Surgery_Date_Time__c = DateTime.newInstance(2020, 9, 01, 10, 8, 16);
        reqt.Tissue_Evaluation__c = tiseval.Id;
        reqt.Requesting_Organization__c = acc.Id;
        reqt.Requesting_Surgeon__c = con.Id;
        reqt.Surgery_Location__c = acc.Id;
        reqt.Eye_Bank_Performing_Pre_Cut__c = acc.Id;
       
        insert reqt;
       Datetime yesterday = Datetime.now().addDays(-1);
       Test.setCreatedDate(reqt.Id, yesterday);  
        datetime fromDate = DateTime.newInstance(2020, 9, 01, 10, 8, 16);
        datetime toDate = DateTime.newInstance(2020, 9, 02, 10, 8, 16);
        string filter;
        Test.startTest(); 
        RequestCalenderCtrl.fetchInitialData(fromDate, toDate, filter);
        RequestCalenderCtrl.fetchRequestDataCount(fromDate, toDate);
          Test.stopTest();
        }
    }
     @isTest
    Static void requestSummaryTest1(){
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

        Request__c reqt = new Request__c();
        reqt.Request_Status__c = 'Not Fulfilled';
        reqt.Name = 'sai';
        reqt.Surgery__c ='ALK';
        reqt.Request_Date_time__c = Datetime.now();
        reqt.Surgery_Date_Time__c = DateTime.newInstance(2020, 9, 01, 10, 8, 16);
        reqt.Tissue_Evaluation__c = tiseval.Id;
        reqt.Requesting_Organization__c = acc.Id;
        reqt.Requesting_Surgeon__c = con.Id;
        reqt.Surgery_Location__c = acc.Id;
        reqt.Eye_Bank_Performing_Pre_Cut__c = acc.Id;
       
        insert reqt;
        Test.startTest();
        Request__c RecLst = [SELECT id, Name, Age__c, Surgery__c, Requesting_Surgeon__c, Request_Status__c, 
                      Medical_Record__c, Requesting_Surgeon__r.Name, Tissue_ID__c, TissueID__c, createdDate,
                      Surgery_Date_Time__c FROM Request__c];
       datetime fromDate = null;
        datetime toDate = null;
        string filter='ALL';             
        RequestCalenderCtrl.fetchRequestDataCount(fromDate, toDate);
         Test.stopTest();
        }
    }
    @isTest
    Static void requestSummaryTest2(){
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

        Request__c reqt = new Request__c();
        reqt.Request_Status__c = 'Not Fulfilled';
        reqt.Name = 'sai';
        reqt.Surgery__c ='ALK';
        reqt.Request_Date_time__c = Datetime.now();
        reqt.Surgery_Date_Time__c = DateTime.newInstance(2020, 9, 01, 10, 8, 16);
        reqt.Tissue_Evaluation__c = tiseval.Id;
        reqt.Requesting_Organization__c = acc.Id;
        reqt.Requesting_Surgeon__c = con.Id;
        reqt.Surgery_Location__c = acc.Id;
        reqt.Eye_Bank_Performing_Pre_Cut__c = acc.Id;
       
        insert reqt;
        Test.startTest();
     Request__c RecLst = [SELECT id, Name, Age__c, Surgery__c, Requesting_Surgeon__c, Request_Status__c, 
                      Medical_Record__c, Requesting_Surgeon__r.Name, Tissue_ID__c, TissueID__c, createdDate,
                      Surgery_Date_Time__c FROM Request__c];
       datetime fromDate = DateTime.newInstance(2020, 9, 01, 10, 8, 16);
        datetime toDate = DateTime.newInstance(2020, 9, 02, 10, 8, 16);
        string filter='ALL';
        RequestCalenderCtrl.fetchInitialData(fromDate, toDate, filter);          
        RequestCalenderCtrl.fetchRequestDataCount(fromDate, toDate);
         Test.stopTest();
        }

    }

   
    
    
   }