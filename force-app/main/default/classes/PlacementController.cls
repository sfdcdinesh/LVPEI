public class PlacementController {   
    //Execute Flow for Checking UserId present in BranchTeam
    @AuraEnabled
    public static Boolean checkUserBranch(){
        Map<String, Referral__c> params = new Map<String, Referral__c>();
        Flow.Interview.Check_User_In_Branch_Team userflow = new Flow.Interview.Check_User_In_Branch_Team(params);
        userflow.start();
        // Obtain the results
        Boolean result = Boolean.valueOf(userflow.getVariableValue('ReturnValue'));
        System.debug('Flow returned ' + result);
        return result;
    }
    @AuraEnabled
    //Getting Current User
    public static map<String,object>  getCurrentUser() {
        map<String,object> result = New map<String,object>();
        
        User toReturn = [SELECT Id, FirstName, LastName FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        result.put('user',toReturn);
        Branch_Team__c objBranchTeam = [SELECT Branch__c,Branch__r.Address__c,User__c 
                                        FROM Branch_Team__c WHERE User__c=:UserInfo.getUserId() LIMIT 1];
        result.put('branchAddress',objBranchTeam.Branch__r.Address__c);
		return result;
    }
  /*  @AuraEnabled
    //Getting Current User
    public static Tissue_Evaluation__c getDisposition(string tissueid){
        return [select id,Name,Tissue_Disposition__c from Tissue_Evaluation__c where id=: tissueid limit 1];
    }*/
    
    //To populate lookups in the EDIT component
    @AuraEnabled
    public static Map<String,sObject> getLookups(Id placID){
        Map<String,sObject> lookupList = new Map<String,sObject>();
        Placement__c plac = [select Select_Tissue__c,Hand_Carried_By_By_Hand__c,To__c from Placement__c where id=:placID];   
        System.debug(plac.Select_Tissue__c);
        if(plac.Select_Tissue__c!=null){
            Tissue_Evaluation__c con1 = [select Id,Name,Tissue_Suitability__c from Tissue_Evaluation__c where id=:plac.Select_Tissue__c];
            lookupList.put('con1',con1);
        }
        else{
            lookupList.put('con1',null);
        }
        System.debug(plac.Hand_Carried_By_By_Hand__c);
        if(plac.Hand_Carried_By_By_Hand__c!=null){
            Contact con2 = [select Id,Name from Contact where id=:plac.Hand_Carried_By_By_Hand__c];
            lookupList.put('con2',con2);
        }
        else{
            lookupList.put('con2',null);
        }
        System.debug(plac.To__c);
        if(plac.To__c!=null){
            Account con3 = [select Id,Name,Phone,City__c,Street_1__c,Street_2__c,Zip_Postal_Code__c,Country__c,State__c from Account where id=:plac.To__c];
            lookupList.put('con3',con3);
        }
        else{
            lookupList.put('con3',null);
        }
        system.debug('------->'+ lookupList);
        return lookupList;
    }
    @AuraEnabled
    //Getting Placement Details
    public static Placement__c getPlacementDetails(Id placID){
        system.debug('111'+ placID);
        return [Select Select_Tissue__r.Name,ETD_Date_Time__c,Requesting_Surgeon__c from Placement__c where id=:placID];
    }
    
    @AuraEnabled
    //Getting Request Details
    public static Request__c getRequestDetails(Id reqId){
        return [select Id, Name,Request_Type__c,Requesting_Surgeon__r.Name,Requesting_Surgeon__c,Branch_Name__c from Request__c where id=:reqId];
    }
    
    
    
    @AuraEnabled
    //getting tissue evaluation details
    public static Tissue_Evaluation__c getTissueEvalName(Id tisEvalId){
        system.debug(tisEvalId);
        return [select Name,Tissue_Suitability__c from Tissue_Evaluation__c where Id=:tisEvalId];
    }
    @AuraEnabled
    //Getting Placement Count
    public static Integer getPlacementCount(Id parentId){
        system.debug('ParentId' + parentId);
        Integer placCount = 0;
        List<AggregateResult> results = [Select count(Id) from Placement__c where Request__c=:parentId];
        if(results!=null){
            system.debug('placCount'+ results);
            placCount =  (Integer)results[0].get('expr0');
        }
        return placCount;
    }
    @AuraEnabled
    //Save Placement
    public static Placement__c savePlacement(Placement__c p, ID tissue, ID contact, ID request, ID tocontact, Tissue_Return__c tissueReturn, Id placeID){        
        
        //p.Shipment_Date__c = date.today();
        if(tissue != null || tissue != ''){
            p.Select_Tissue__c = tissue;   
        }
        if(contact != null || contact != ''){
            p.Hand_Carried_By_By_Hand__c = contact;
        }
        if(tocontact != null || tocontact != ''){
            p.To__c = tocontact;
        }    
        if(placeID!=null){
            p.Id=placeID;
            update p;        
        }
        else{
            insert p; 
        }
        
        //Update TissueEvaluation Field 'Placement Status'
        Tissue_Evaluation__c tis = new Tissue_Evaluation__c();
        if(tissue != null){
            tis = [Select Id,Name,Placement_Status__c,Approval_Outcome__c,Tissue_Suitability__c from Tissue_Evaluation__c where id=:tissue limit 1];   
            tis.Approval_Outcome__c='Placed';
             tis.Tissue_Disposition__c=p.Tissue_Disposition__c;
            update tis;
        }        
        System.debug('Selected Tissue-->'+tis.Name);
       /* if(tis.Id != null){
            if(p.Placement_Status__c=='Shipped'){
                tis.Placement_Status__c = 'Shipped';
            }
            else if(p.Placement_Status__c=='Returned'){
                tis.Placement_Status__c = 'Returned';   
            }
            update tis;    
            System.debug('PlacementStatus-->'+ tis.Placement_Status__c);
        }    */    
        
        //TissueReturn Details
      /*  system.debug('tissueReturn==>'+tissueReturn);
        if(tissueReturn!=null ){
            tissueReturn.Placement__c = p.Id;
            upsert tissueReturn;  
        }      */          
        return p;
    }
    @AuraEnabled
    //Getting Referral 
    public static Referral__c getReferral(Id refID){
       Referral__c ref = [select Id, Name, First_Name__c, Last_Name__c, Gender__c, Age_of_Donor__c,Religion__c, Height_Unit__c, Height__c,
                           Is_Height_Estimated_or_Reported__c, Weight_Unit__c, Weight__c, Is_weight_Estimated_or_Reported__c, Date_of_Admission__c, 
                           Medical_Record_Number__c, Primary_Cause_of_Death__c, Circumstances_Leading_to_Death__c, Attending_physician__c,
                           Date_Time_of_Death__c, Medical_Ocular_Histor__c, Was_the_donor_on_a_ventilator__c, Social_and_Behavioral_History__c,
                           Duration_of_time_on_Ventilator_if_Yes__c, Initially_Suitable__c, Isolation__c, Suitability_Explanation__c, 
                           IV_Fluid_given_in_last_hour__c, Blood_given_in_the_last_48_hours__c, Sign_symptoms_of_systemic_infection__c, 
                           Transferred_from_other_facility__c, Facility_Name__c from Referral__c where id =: refID limit 1]; 
        return ref;
    } 
    //Method for Save PDF
    public static PageReference savePDF(String urlstr){
        System.PageReference pageRef = new System.PageReference(urlstr);
        
        //ensure pdf downloads and is assigned with defined name
        pageRef.getHeaders().put('content-disposition', 
                                 'attachment; filename=TestPDF.pdf');
        
        return pageRef;
    } 
    
    @AuraEnabled
    //Save Tissue Return
    public static Tissue_Return__c saveReturn(Tissue_Return__c tissueReturn, ID CompletedBylookup){
        tissueReturn.Completed_By__c = CompletedBylookup;
        insert tissueReturn;
        return tissueReturn;
    } 
    
    @AuraEnabled
    public static Placement__c getPlacementName(Id placId){
        system.debug('placementId-->'+placId);
        return [select Name from Placement__c where Id=:placId];
    }
    
}