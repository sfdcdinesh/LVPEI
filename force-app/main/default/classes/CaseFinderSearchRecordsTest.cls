@isTest
public class CaseFinderSearchRecordsTest {
    
    @testSetup
    static void setData()
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
            
            Referral__c ref = new Referral__c(First_Name__c='Raj',Last_Name__c='krish',   Death_Notification_Consignment_Date_Time__c = datetime.newInstance(2019, 12, 20, 12, 0, 0), 
                                              Referral_Method__c = 'HCRP', Referral_Source__c = 'HCRP motivated', Age_of_Donor__c = 45,
                                              Date_Time_of_Death__c = datetime.newInstance(2019, 12, 20, 12, 0, 0), 
                                              Date_of_Birth__c =  date.newInstance(1995, 12, 11),Unit_Organization_Hospital_Name__c=acc.Id);
            insert ref;
            
            Referral__c r=[select Name,Id from Referral__c where id =: ref.Id];
            System.debug('ref name.......'+r.Name);
            
            
            Test.startTest();
            List<Account>  accounts= CaseFinderSearchRecords.getRefOrgs('Apollo');  
            List<Referral__c>  reffs= CaseFinderSearchRecords.getCase(ref.Last_Name__c,ref.First_Name__c,ref.Name,ref.Donor_ID__c);  
            
            List<Referral__c>  re= CaseFinderSearchRecords.getCases(acc.Id,ref.Date_Time_of_Death__c.date() ,ref.Date_Time_of_Death__c.date(),ref.Date_Time_of_Death__c.date(),ref.Date_Time_of_Death__c.date());  
            
            Test.stopTest();
            
            System.assertEquals(1, accounts.size());
            System.assertEquals(1, reffs.size());
            System.assertEquals(1, re.size());
            
        }
    }
    @isTest
    static void getCase()
    {
        
        Referral__c ref =    [select Name,Id,Date_Time_of_Death__c,Unit_Organization_Hospital_Name__c,Death_Notification_Consignment_Date_Time__c,Donor_ID__c from Referral__c limit 1];
        System.debug('11111111111122222222......'+ref);
        
        Test.startTest();
        List<Referral__c>  reffs= CaseFinderSearchRecords.getCase(null,null,ref.Donor_ID__c,ref.Name);          
        List<Referral__c>  re= CaseFinderSearchRecords.getCases(null,ref.Date_Time_of_Death__c.date() ,null,ref.Death_Notification_Consignment_Date_Time__c.date(),null);         
        Test.stopTest();
        
        System.assertEquals(1, reffs.size());
        System.assertEquals(1, re.size());
        
    }
    
    @isTest
    static void getCase1()
    {
        
        Referral__c ref =    [select Name,Id,First_Name__c,Last_Name__c,Date_Time_of_Death__c,Unit_Organization_Hospital_Name__c,Donor_ID__c from Referral__c limit 1];
        
        Test.startTest();
        List<Referral__c>  reffs= CaseFinderSearchRecords.getCase(ref.First_Name__c,null,ref.Name,ref.Donor_ID__c);  
        List<Referral__c>  refffs= CaseFinderSearchRecords.getCase(null,null,null,ref.Donor_ID__c);  
        List<Referral__c>  reffffs= CaseFinderSearchRecords.getCase(null,ref.Last_Name__c,null,null);  
        
        List<Referral__c>  re= CaseFinderSearchRecords.getCases(ref.Unit_Organization_Hospital_Name__c,null ,ref.Date_Time_of_Death__c.date(),ref.Date_Time_of_Death__c.date(),ref.Date_Time_of_Death__c.date());  
        
        Test.stopTest();
        
        
    }
    @isTest
    static void getCase2()
    {
        
        Referral__c ref =    [select Name,First_Name__c,Last_Name__c , Id,Date_Time_of_Death__c,Unit_Organization_Hospital_Name__c,Donor_ID__c from Referral__c limit 1];
        System.debug('11111111111122222222......'+ref);
        
        Test.startTest();
        List<Referral__c>  refffs= CaseFinderSearchRecords.getCase(null,null,null,ref.Name);  
        List<Referral__c>  refff= CaseFinderSearchRecords.getCase(ref.First_Name__c,null,null,null);  
        List<Referral__c>  ree= CaseFinderSearchRecords.getCase(null,ref.Last_Name__c,null,null);  
        
        List<Referral__c>  re= CaseFinderSearchRecords.getCases(ref.Unit_Organization_Hospital_Name__c,ref.Date_Time_of_Death__c.date() ,ref.Date_Time_of_Death__c.date(),ref.Date_Time_of_Death__c.date(),ref.Date_Time_of_Death__c.date());  
        
        Test.stopTest();
        
        
    }
    
    @isTest
    static void getCases3()
    {
        
        Referral__c ref =    [select Name,First_Name__c,Id,Date_Time_of_Death__c,Unit_Organization_Hospital_Name__c,Donor_ID__c from Referral__c limit 1];
        System.debug('222222222232222333......'+ref);
        Test.startTest();
        List<Referral__c>  reffs= CaseFinderSearchRecords.getCase(null,ref.First_Name__c,null,ref.Donor_ID__c);  
        
        List<Referral__c>  re= CaseFinderSearchRecords.getCases(ref.Unit_Organization_Hospital_Name__c,null ,ref.Date_Time_of_Death__c.date(),ref.Date_Time_of_Death__c.date(),ref.Date_Time_of_Death__c.date());  
        
        Test.stopTest();
        
        
    }
    @isTest
    static void getCases4()
    {
        
        Referral__c ref =    [select Name,Id,First_Name__c,Date_Time_of_Death__c,Unit_Organization_Hospital_Name__c,Donor_ID__c from Referral__c limit 1];
        Test.startTest();
        List<Referral__c>  reffs= CaseFinderSearchRecords.getCase(null,ref.First_Name__c,null,ref.Donor_ID__c);  
        
        List<Referral__c>  re= CaseFinderSearchRecords.getCases(ref.Unit_Organization_Hospital_Name__c,null ,null,null,null);  
               list<Account> accs=   CaseFinderSearchRecords.getRefOrgs(null);        
        Test.stopTest();
        System.assertEquals(1, reffs.size());
        System.assertEquals(false,accs.isEmpty());

        
    }
    @isTest
    static void getCases5()
    {
        
        Referral__c ref =    [select Name,Id,First_Name__c,Date_Time_of_Death__c,Unit_Organization_Hospital_Name__c,Donor_ID__c from Referral__c limit 1];
        Test.startTest();
        List<Referral__c>  re= CaseFinderSearchRecords.getCases(ref.Unit_Organization_Hospital_Name__c,ref.Date_Time_of_Death__c.date() ,ref.Date_Time_of_Death__c.date(),null,null);  
        Test.stopTest();
        System.assertEquals(1, re.size());

        
    }
    @isTest
    static void getCases6()
    {
        
        Referral__c ref =    [select Name,Id,First_Name__c,Date_Time_of_Death__c,Unit_Organization_Hospital_Name__c,Donor_ID__c from Referral__c limit 1];
        Test.startTest();
        List<Referral__c>  re= CaseFinderSearchRecords.getCases(ref.Unit_Organization_Hospital_Name__c,ref.Date_Time_of_Death__c.date() ,null,ref.Date_Time_of_Death__c.date(),null);  
        Test.stopTest();
        System.assertEquals(1, re.size());

        
    }
    @isTest
    static void getCases7()
    {
        
        Referral__c ref =    [select Name,Id,First_Name__c,Date_Time_of_Death__c,Unit_Organization_Hospital_Name__c,Donor_ID__c from Referral__c limit 1];
        Test.startTest();
        List<Referral__c>  re= CaseFinderSearchRecords.getCases(ref.Unit_Organization_Hospital_Name__c,ref.Date_Time_of_Death__c.date() ,null,null,null);  
        Test.stopTest();
        System.assertEquals(1, re.size());

        
    }
    @isTest
    static void getCases8()
    {
        
        Referral__c ref =    [select Name,Id,First_Name__c,Date_Time_of_Death__c,Unit_Organization_Hospital_Name__c,Donor_ID__c from Referral__c limit 1];
        Test.startTest();
        List<Referral__c>  re= CaseFinderSearchRecords.getCases(ref.Unit_Organization_Hospital_Name__c,null ,null,ref.Date_Time_of_Death__c.date(),null);  
        Test.stopTest();
        System.assertEquals(1, re.size());

        
    }
    @isTest
    static void getCases9()
    {
        
        Referral__c ref =    [select Name,Id,First_Name__c,Date_Time_of_Death__c,Unit_Organization_Hospital_Name__c,Donor_ID__c from Referral__c limit 1];
        Test.startTest();
        List<Referral__c>  re= CaseFinderSearchRecords.getCases(null,ref.Date_Time_of_Death__c.date() ,ref.Date_Time_of_Death__c.date(),ref.Date_Time_of_Death__c.date(),ref.Date_Time_of_Death__c.date());  
        Test.stopTest();
        System.assertEquals(1, re.size());

        
    }
      @isTest
    static void getCases10()
    {
        
        Referral__c ref =    [select Name,Id,First_Name__c,Date_Time_of_Death__c,Unit_Organization_Hospital_Name__c,Donor_ID__c from Referral__c limit 1];
        Test.startTest();
        List<Referral__c>  re= CaseFinderSearchRecords.getCases(null,ref.Date_Time_of_Death__c.date() ,ref.Date_Time_of_Death__c.date(),null,null);  
        Test.stopTest();
        System.assertEquals(1, re.size());

        
    }
      @isTest
    static void getCases11()
    {
        
        Referral__c ref =    [select Name,Id,First_Name__c,Date_Time_of_Death__c,Unit_Organization_Hospital_Name__c,Donor_ID__c from Referral__c limit 1];
        Test.startTest();
        List<Referral__c>  re= CaseFinderSearchRecords.getCases(null,null ,null,ref.Date_Time_of_Death__c.date(),ref.Date_Time_of_Death__c.date());  
        Test.stopTest();
        System.assertEquals(1, re.size());

        
    }
      @isTest
    static void getCases12()
    {
        
        Referral__c ref =    [select Name,Id,First_Name__c,Date_Time_of_Death__c,Unit_Organization_Hospital_Name__c,Donor_ID__c from Referral__c limit 1];
        Test.startTest();
        List<Referral__c>  re= CaseFinderSearchRecords.getCases(null,ref.Date_Time_of_Death__c.date() ,null,ref.Date_Time_of_Death__c.date(),null);  
        Test.stopTest();
        System.assertEquals(1, re.size());

        
    }
      @isTest
    static void getCases13()
    {
        
        Referral__c ref =    [select Name,Id,First_Name__c,Date_Time_of_Death__c,Unit_Organization_Hospital_Name__c,Donor_ID__c from Referral__c limit 1];
        Test.startTest();
        List<Referral__c>  re= CaseFinderSearchRecords.getCases(null,ref.Date_Time_of_Death__c.date() ,null,null,null);  
        Test.stopTest();
        System.assertEquals(1, re.size());

        
    }
  
  
   @isTest
    static void getCases14()
    {
        
        Referral__c ref =    [select Name,Id,First_Name__c,Date_Time_of_Death__c,Unit_Organization_Hospital_Name__c,Donor_ID__c from Referral__c limit 1];
        Test.startTest();
        List<Referral__c>  re= CaseFinderSearchRecords.getCases(null,null ,null,ref.Date_Time_of_Death__c.date(),null);  
        Test.stopTest();
        System.assertEquals(1, re.size());

        
    }
   
  
    
}