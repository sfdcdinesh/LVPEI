@isTest
public class MedicalReviewTest {
@isTest
    static void medicalReviewTestMethod(){
    Id organization = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Organization').getRecordTypeId();
    Id counsellor = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Counselors').getRecordTypeId();
    Account a = TestFactory.getAccount(organization,'Ramayamma International Eye Bank Organisation', true);   
    Contact c = TestFactory.getContact(counsellor,a.Id,'Hasan',true);
    DateTime NotifDateTime = datetime.newInstance(2018, 12, 21, 12, 30, 0);
    Date dob = Date.newInstance(1985, 12, 21);
    DateTime deathTime = datetime.newInstance(2018, 12, 19, 12, 30, 0);
    Referral__c ref = TestFactory.getReferral(NotifDateTime, 'Voluntary', 'Volunteer Motivated',dob,deathTime);
    DateTime tissueRecoveryDate = datetime.newInstance(2018, 12, 20, 12, 30, 0);
    DateTime coolStart = datetime.newInstance(2018, 12, 20, 2, 30, 0);
    DateTime coolEnd = datetime.newInstance(2018, 12, 20, 4, 30, 0);
    Recovery__c rec = TestFactory.getRecovery(ref.Id, tissueRecoveryDate,coolStart,coolEnd);
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
    Medical_Review__c medRev = new Medical_Review__c();
    MedicalReview.getCurrentUser();
    MedicalReview.getselectOptions(medRev, 'HBsAG__c');
    MedicalReview.getRecoveryDetails(rec.Id);
    MedicalReview.Dates(rec.Id);
    Medical_Review__c medRev1 = MedicalReview.saveDetails(medRev, c.Id, c.Id, c.Id, c.Id, c.Id,bloodlist,colloidlist,crystalloidlist,null); 
    //MedicalReview.saveDetails(medRev, c.Id, c.Id, c.Id, c.Id, c.Id,bloodlist,colloidlist,crystalloidlist,medRev1.Id);
    MedicalReview.getMedicalReviewName(medRev1.Id);
    MedicalReview.getRecoveryId(medRev1.Id);
    MedicalReview.getLookups(medRev1.Id);
    Test.stopTest();        
    }
}