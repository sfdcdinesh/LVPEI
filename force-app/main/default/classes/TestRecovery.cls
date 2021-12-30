@isTest(seealldata=false)
public class TestRecovery {
@isTest
    static void RecoveryTestMethod(){
   // Id householdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household Account').getRecordTypeId();
    
   
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
    Account a = TestFactory.getAccount(organization,'Ramayamma International Eye Bank Organisation', true);   
    Contact c = TestFactory.getContact(counsellor,a.Id,'Hasan',true);
    DateTime NotifDateTime = datetime.newInstance(2018, 12, 21, 12, 30, 0);
    
    Date dob = Date.newInstance(1985, 12, 21);
    DateTime deathTime = datetime.newInstance(2018, 12, 19, 12, 30, 0);
    Referral__c ref = TestFactory.getReferral(NotifDateTime, 'Voluntary', 'Volunteer Motivated',dob,deathTime);
    DateTime tissueRecoveryDate = datetime.newInstance(2018, 12, 20, 12, 30, 0);
    DateTime coolStart = datetime.newInstance(2018, 12, 20, 2, 30, 0);
    DateTime coolEnd = datetime.newInstance(2018, 12, 20, 4, 30, 0);
    Test.startTest();
    Recovery__c recovery = new Recovery__c();
        
        recovery.Referral__c=ref.Id;
        recovery.Tissue_recovery_date_time__c = System.now();
        RecoverySave.getCurrentUser();
        RecoverySave.getReferralId(ref.Id);
        RecoverySave.getDetails(ref.Id);
        RecoverySave.checkUserBranch();
        RecoverySave.getDonorCount(ref.id);
       // RecoverySave.getRefId(ref.Id);
        RecoverySave.getselectOptions(new Recovery__c(), 'Recovery_Intent__c'); 
        Consult__c consult = new Consult__c();
        List<Consult__c> consultlist = new List<Consult__c>();
        consult.Name = 'Test Consult';
        Consult__c consult1= RecoverySave.saveConsults(consult);
        consultlist = RecoverySave.getConsults();
        Recovery__c rec =RecoverySave.save(recovery, consultlist, c.Id, c.Id, c.Id, c.Id, c.Id, c.Id, c.Id, c.Id, c.Id,null);
        System.debug('RecId1'+ rec.Id);
        RecoverySave.save(recovery, consultlist, c.Id, c.Id, c.Id, c.Id, c.Id, c.Id, c.Id, c.Id, c.Id,rec.Id);
        //Recovery__c rec2 = RecoverySave.save(recovery, consultlist, null,null,null,null,null,null,null,null,null,null);

        System.debug('RecId2'+ rec.Id);
        Recovery__c r =RecoverySave.getRecoveryName(rec.Id);
        RecoverySave.getRefId(recovery.Id);
        RecoverySave.getLookups(rec.Id);
        RecoverySave.fetchConsults(rec.Id);
        
        //RecoverySave.getLookups(rec2.Id);
        
    Test.stopTest();        
    }
    }
}