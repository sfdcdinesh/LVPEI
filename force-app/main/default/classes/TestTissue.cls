@isTest
public class TestTissue {
@isTest
    static void TissueTestMethod(){
    //Id householdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household Account').getRecordTypeId();
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
    Test.startTest();
        
        Tissue_Evaluation__c te= new Tissue_Evaluation__c();
        te.Tissue_Type__c = 'Sclera';
        te.Tissue_Sub_Type__c = 'Whole';
       	Medical_Review__c mr = new Medical_Review__c();
        TissueEvaluationSave.Savetissue(te, c.Id, c.Id, c.Id, c.Id, c.Id, te.Id);
        TissueEvaluationSave.getLookups(te.Id);
        TissueEvaluationSave.getAlltissues();
        TissueEvaluationSave.tissueInventory();
        Attachment at = new Attachment();
        TissueEvaluationSave.saveNewAttachment(at.Body, at.Name, at.ContentType, at.ParentId);
        TissueEvaluationSave.getPreviousTissue(mr.Id);
        TissueEvaluationSave.getTissueCount(mr.Id);
        TissueEvaluationSave.getDonorId(te.Id);
        TissueEvaluationSave.getRecovery(rec.Id);
        TissueEvaluationSave.getTissueEvalName(te.Id);
       /* Referral__c donor = new Referral__c();
        donor.Death_Notification_Consignment_Date_Time__c = datetime.newInstance(2018, 12, 20, 12, 30, 0);
        donor.Referral_Method__c = 'Voluntary';
        donor.Referral_Source__c = 'Voluntary-Family Initiated';
    Recovery__c recovery = new Recovery__c();
      String  recId=recovery.Id;
        Medical_Review__c mer = new Medical_Review__c();
        String donId = mer.Id;
      Tissue_Evaluation__c te = new Tissue_Evaluation__c();
        te.Tissue_Type__c = 'Sclera';
        te.Tissue_Sub_Type__c = 'Whole';
        TissueEvaluationSave.Savetissue(te, c.Id, c.Id, c.Id, c.Id, c.Id);*/
        
        
    Test.stopTest();        
    }
}