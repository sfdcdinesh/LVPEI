public class FinalListController {
  
    @AuraEnabled
    public static List<Referral__c> getReferralList()
    {
        return[Select Id,Name,Donor_Name__c,Referral_Method__c,Referral_Source__c from Referral__c Where (Name !=null AND Referral_Method__c !=null AND Referral_Source__c !=null) order by createdDate DESC limit 10];
    }
      @AuraEnabled
    public static List<Recovery__c> getRecoveryList()
    {
    return[Select Id,Name,Tissue_recovery_date_time__c, Recovery_Intent__c, Recovery_outcome__c from Recovery__c order by createdDate DESC limit 10];
        
    }
 @AuraEnabled
    public static List<Medical_Review__c> getMedicalEvalList()
    {
        return[select Id ,Donor_Name_Id__c,Donor_Name__c,Recovery__c,Recovery__r.Id,Tissue_Imported__c,
               MedicalSurgical_History_Summary__c,Donor_Eligibility__c from  Medical_Review__c Where(Donor_Name_Id__c!=null AND Tissue_Imported__c!=null AND Donor_Eligibility__c!=null) order by createdDate DESC limit 10];
    }
     @AuraEnabled
    public static List<Tissue_Evaluation__c> getTissuesList()
    {
        return[Select Id,Donor_ID__c,Tissue_Sub_Type__c,Tissue_Type__c from Tissue_Evaluation__c];
    } 

    
    
}