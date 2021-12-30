public with sharing class PostCutEvaluationFormPrint {
    public Tissue_Evaluation__c tissue{get;set;}
    public Branch__c branch {get;set;}
    public ID tissueID;
       public Double offset{get{
        TimeZone tz = UserInfo.getTimeZone();
        //Milliseconds to Day
        return tz.getOffset(DateTime.now()) / (1000 * 3600 * 24.0);
    }}
    public PostCutEvaluationFormPrint(){
        tissueID = ApexPages.currentPage().getParameters().get('tissueid');    
        tissue =  new Tissue_Evaluation__c();
        tissue = [select Id, Name, Tissue_Type__c, Tissue_Processed_for__c, Graft_Thickness_microns__c, Date_Time_Processed__c, 
                  Graft_Diameter_mm__c, Comments_Post_Cut__c, Endothelial_Cell_Density_mm2__c, Post_Cut_Epithelium__c, Anterior_Stroma__c, 
                  Posterior_Stroma__c,Pre_Cut__c,Descemet_s__c, Folds__c, Post_Cut_Endothelium__c, Stress_Lines__c, Cell_Dropouts__c, Additional__c, 
                  Slit_Lamp_Date_Time__c, Slit_Lamp_Technician__c, Slit_Lamp_Technician__r.Name,Specular_Date_Time__c, Specular_Technician__c, 
                  Specular_Technician__r.Name, EK_Tech__c, EK_Tech__r.Name, Circulator__c, Circulator__r.Name,Post_Cut_Preservation_Medium__c, 
                  Post_Cut_Media_lot__c, Post_Cut_Media_Expiration_Date_Time__c,Branch_Name__c from Tissue_Evaluation__c where id =: tissueID limit 1];
    	Map<String, string> referralMap = new Map<String, string>();
        referralMap.put('BranchName', tissue.Branch_Name__c);
        Flow.Interview.GetBranchAddress myflow = new Flow.Interview.GetBranchAddress(referralMap);
        myflow.start();
        branch = (Branch__c)myflow.getVariableValue('BranchRecord');
    } 
    public Attachment attachment {get {
        List<Attachment> objAttachments = new List<Attachment>();  
        Attachment att = new Attachment();
        try
        {               
            objAttachments = [Select Id, Name, ContentType from Attachment where ParentId = :tissueId AND Name LIKE '%-postCut' order by createddate DESC LIMIT 1];   
           att = objAttachments[0];
        }
        catch(exception ex)
        {           
            objAttachments = null;
        }
        return att;  
    } set;}  
    
    
}