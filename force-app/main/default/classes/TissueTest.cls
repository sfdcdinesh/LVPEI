@isTest
public class TissueTest {
   @isTest
    static void tissueTestMethod(){
        Contact con = new Contact();
        con.LastName = 'Test Name';
        insert con;
        Recovery__c rc = new Recovery__c();
        Referral__c don = new Referral__c();
        Tissue_Evaluation__c te = new Tissue_Evaluation__c();
        rc.Donor_ID__c = don.Id;
        te.Tissue_Type__c = 'Sclera';
        te.Tissue_Sub_Type__c = 'Whole';
        TissueEvaluationSave.Savetissue(te, con.Id, con.Id, con.Id, con.Id, con.Id);
       // TissueEvaluationSave.getRecovery(rc.Id);
    }
}