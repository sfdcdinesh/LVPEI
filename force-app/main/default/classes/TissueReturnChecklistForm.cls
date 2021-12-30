public class TissueReturnChecklistForm {
    public Branch__c branch{get;set;}
    public Tissue_Return__c tissuertrn{get;set;}
    public String tissueId{get;set;}
    public String surgeon{get;set;}
    public DateTime ETD{get;set;}
    public ID tisrtrnID;
       public Double offset{get{
        TimeZone tz = UserInfo.getTimeZone();
        //Milliseconds to Day
        return tz.getOffset(DateTime.now()) / (1000 * 3600 * 24.0);
    }}
    public TissueReturnChecklistForm(){
        tisrtrnID = ApexPages.currentPage().getParameters().get('tisrtrnid');
        system.debug('tisrtrnID '+tisrtrnID);    
        tissuertrn =  new Tissue_Return__c();
        tissuertrn = [select Id, Name, Branch_Name__c,Sent_to__c, Date_Time_Sent__c, Reason_for_Return__c,
                      Method_of_Transportation__c, Storage_Conditions_During_Absence__c, 
                      Total_Time_Spent_Out_Cooling_Range__c, Tamper_Evident_Seal_Intact__c,
                      Tissue_Have_Been_Refrigerated__c, Vial_or_Viewing_Chamber_Not_Broken__c, 
                      Accompanying_Paperwork_Matches_Donor_No__c, Optisol_Checked_Visually_Color__c, 
                      Date_Time_Returned__c, Completed_By__c,Completed_By__r.Name,Placement__c from Tissue_Return__c where Placement__c =: tisrtrnID limit 1];
        Placement__c plac  = [select Select_Tissue__c,ETD_Date_Time__c,Request__c from Placement__c where id=:tissuertrn.Placement__c];
        Tissue_Evaluation__c tisEval = [select Id,Name from Tissue_Evaluation__c where id=:plac.Select_Tissue__c];
        Request__c req = [select Requesting_Surgeon__r.Name from Request__c where id=:plac.Request__c];
        surgeon = req.Requesting_Surgeon__r.Name;
        system.debug('surgeon' + surgeon);
        ETD = plac.ETD_Date_Time__c;
        System.debug('ETD' + ETD);
        tissueId = tisEval.Name;
        Map<String,string> trMap = new Map<String, string>();
        trMap.put('BranchName', tissuertrn.Branch_Name__c);
        Flow.Interview.GetBranchAddress myflow = new Flow.Interview.GetBranchAddress(trMap);
        myflow.start();
        branch = (Branch__c)myflow.getVariableValue('BranchRecord');
    }

}