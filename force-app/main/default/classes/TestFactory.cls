@isTest
public class TestFactory {

  public static Account getAccount(Id recordType,String name, Boolean doInsert){
    Account a = new Account(Name = name,RecordTypeId= recordType);
    if(doInsert){
      insert a;
    }
    return a;
  }
  public static Contact getContact(Id recordType,Id accountId, String lname, Boolean doInsert){
    Contact c = new Contact(RecordTypeId= recordType,LastName=lname,AccountId = accountId);
    if(doInsert){
      insert c;
    }
    return c;
  }
  public static Referral__c getReferral(DateTime notifDate,String refSource,String refMethod, Date dob, DateTime deathtime){
        Referral__c ref = new Referral__c(Death_Notification_Consignment_Date_Time__c=notifDate, 
                                         Referral_Method__c=refMethod,Referral_Source__c=refSource,Date_of_Birth__c=dob, Date_Time_of_Death__c=deathtime);
        insert ref;
        return ref;
    }
  
  public static Recovery__c getRecovery(Id ReferralId,DateTime tissueRecoveryDate,DateTime coolStart,DateTime coolEnd){
        Recovery__c rec = new Recovery__c(Referral__c=ReferralId,Tissue_recovery_date_time__c=tissueRecoveryDate,Cornea_Preservation_Date_Time__c=tissueRecoveryDate,Date_Time_body_subjected_to_cooling__c=coolStart,Date_Time_body_removed_from_cooling__c=coolEnd);
        insert rec;
        return rec;
    }
  public static Medical_Review__c getMedicalReview(Id recoveryId){
        Medical_Review__c medRev = new Medical_Review__c(Recovery__c=recoveryId);
        insert medRev;
        return medRev;
    }
  
}