public with sharing class TissueReturnPrintController {
    public Tissue_Return__c tissuereturn{get;set;}
    public ID tissuereturnID;
       public Double offset{get{
        TimeZone tz = UserInfo.getTimeZone();
        //Milliseconds to Day
        return tz.getOffset(DateTime.now()) / (1000 * 3600 * 24.0);
    }}
    public TissueReturnPrintController(ApexPages.StandardController sc){
        tissuereturnID = sc.getId();
        System.debug('Id-->'+ tissuereturnID);
        tissuereturn =  new Tissue_Return__c();
        tissuereturn = [select Id, Name, Date_Time_Sent__c, Date_Time_Returned__c, Reason_for_Return__c, Sent_to__c,
                        Method_of_Transportation__c, Storage_Conditions_During_Absence__c, 
                        Tamper_Evident_Seal_Intact__c, Tissue_Have_Been_Refrigerated__c, 
                        Vial_or_Viewing_Chamber_Not_Broken__c, Accompanying_Paperwork_Matches_Donor_No__c,
                        Optisol_Checked_Visually_Color__c, Completed_By__r.Name,Tissue_Id1__c  from Tissue_Return__c where id =: tissuereturnID limit 1];
    
    } 
  
}