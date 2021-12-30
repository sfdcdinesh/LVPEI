@isTest(seealldata=false)
private class ReferralTest {
    
  static testmethod void getReferralId1()
    {
        id org = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Organization').getRecordTypeId();
        //id contactrecordtype = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Counselor').getRecordTypeId();
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
        
        Contact con = new Contact(LastName = 'test', AccountId = acc.Id, Organisation_Hospital__c=true);
        insert con;
      
        Referral__c ref = new Referral__c(Death_Notification_Consignment_Date_Time__c = datetime.newInstance(2019, 12, 20, 12, 0, 0), 
                                         Referral_Method__c = 'HCRP', Referral_Source__c = 'HCRP motivated', Age_of_Donor__c = 45,
                                         Date_Time_of_Death__c = datetime.newInstance(2019, 12, 20, 12, 0, 0), 
                                         Date_of_Birth__c =  date.newInstance(1995, 12, 11));
        insert ref;
       
       system.debug(Schema.SObjectType.Account.getRecordTypeInfosByName().get('Organization'));
       Test.startTest();
        
        Referral__c ref1 = [select id from Referral__c limit 1];  
        ReferralCtrl.fetchIntialData(ref1.Id,ref1,'Referral_Method__c','Referral_Source__c');
        ReferralCtrl.getBranch();
        ReferralCtrl.checkUserBranch();
        ReferralCtrl.getDependentMap(ref1 , 'Referral_Method__c' , 'Referral_Source__c' );
        ReferralCtrl.saveReferrall(ref1, con.id, con.id, acc.Id, acc.Id, ref1.Id);
        ReferralCtrl.getReferralName(ref1.Id);
       
         
        
        Test.stopTest();
        }
    }
    
    static testmethod void getReferralId2()
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
        acc.Name = 'Apollo1';
        acc.Hospital__c = true;
        acc.RecordTypeId = org;
        insert acc;
        
        Contact con = new Contact(LastName = 'test1', AccountId = acc.Id, Organisation_Hospital__c=true);
        insert con;
      
        Referral__c ref = new Referral__c(Death_Notification_Consignment_Date_Time__c = datetime.newInstance(2019, 12, 20, 12, 0, 0), 
                                         Referral_Method__c = 'HCRP', Referral_Source__c = 'HCRP motivated', Age_of_Donor__c = 45,
                                         Date_Time_of_Death__c = datetime.newInstance(2019, 12, 20, 12, 0, 0), 
                                         Date_of_Birth__c =  date.newInstance(1995, 12, 11),
                                         Donation_Counselor_Volunteer__c = con.id);
        insert ref;
        
        Test.startTest();
        
        Referral__c ref2 = [select id, Donation_Counselor_Volunteer__c from Referral__c limit 1];
        Contact c1 = [select Id from Contact where id=:ref2.Donation_Counselor_Volunteer__c  ];
       ReferralCtrl.fetchIntialData(ref2.Id,ref2,'Referral_Method__c','Referral_Source__c');
        
        Test.stopTest();
        
        }  
    }
        
    static testmethod void getReferralId3()
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
        acc.Name = 'Apollo3';
        acc.Hospital__c = true;
        acc.RecordTypeId = org;
        insert acc;
        
        Contact con = new Contact(LastName = 'test3', AccountId = acc.Id, Organisation_Hospital__c=true);
        insert con;
      
        Referral__c ref = new Referral__c(Death_Notification_Consignment_Date_Time__c = datetime.newInstance(2019, 12, 20, 12, 0, 0), 
                                         Referral_Method__c = 'HCRP', Referral_Source__c = 'HCRP motivated', Age_of_Donor__c = 45,
                                         Date_Time_of_Death__c = datetime.newInstance(2019, 12, 20, 12, 0, 0), 
                                         Date_of_Birth__c =  date.newInstance(1995, 12, 11),
                                         Seconday_Donation_Counselor_Volunteer__c = con.id);
        insert ref;
        
        Test.startTest();
        
        Referral__c ref3 = [select id, Seconday_Donation_Counselor_Volunteer__c from Referral__c limit 1];
        Contact c1 = [select Id, Name from Contact where id=:ref3.Seconday_Donation_Counselor_Volunteer__c  ];
       ReferralCtrl.fetchIntialData(ref3.Id,ref3,'Referral_Method__c','Referral_Source__c');
        
        Test.stopTest();
        }
    }
    static testmethod void getReferralId4()
    {
        id org = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Organization').getRecordTypeId();
       // id contactrecordtype = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Counselors').getRecordTypeId();
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
        acc.Name = 'Apollo4';
        acc.Hospital__c = true;
        acc.RecordTypeId = org;
        insert acc;
        
        Contact con = new Contact(LastName = 'test4', AccountId = acc.Id, Organisation_Hospital__c=true);
        insert con;
      
        Referral__c ref = new Referral__c(Death_Notification_Consignment_Date_Time__c = datetime.newInstance(2019, 12, 20, 12, 0, 0), 
                                         Referral_Method__c = 'HCRP', Referral_Source__c = 'HCRP motivated', Age_of_Donor__c = 45,
                                         Date_Time_of_Death__c = datetime.newInstance(2019, 12, 20, 12, 0, 0), 
                                         Date_of_Birth__c =  date.newInstance(1995, 12, 11),
                                         Unit_Organization_Hospital_Name__c = acc.id);
        insert ref;
        
        Test.startTest();
        
        Referral__c ref4 = [select id, Unit_Organization_Hospital_Name__c from Referral__c limit 1];
        Account a1 = [select Id, Name from Account where id=:ref.Unit_Organization_Hospital_Name__c ];
        ReferralCtrl.fetchIntialData(ref4.Id,ref4,'Referral_Method__c','Referral_Source__c');
        
        Test.stopTest();
    }
    
    }
}