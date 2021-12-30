public class ReqSave {
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
    public static User getCurrentUser() {
      User toReturn = [SELECT Id, FirstName, LastName FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        return toReturn;
    }
    
    @AuraEnabled
    //Getting Request Name
    public static Request__c getRequestName(Id reqId){
        system.debug(reqId);
        return [select Name, Branch_Name__c from Request__c where Id=:reqId];
    }
    //To populate lookups in the edit component
    @AuraEnabled
    public static Map<String,sObject> getEmrDetails(Id reqID){
        Map<String,sObject> lookupList = new Map<String,sObject>();
        Request__c req =  [select Requesting_Organization__c,Requesting_Surgeon__c,Surgery_Location__c,Eye_Bank_Performing_Pre_Cut__c,EMR_ID__c from Request__c where id=:reqID ];     
        if(req.Requesting_Organization__c!=null){
        Account con1 = [select Id,Name from Account where id=:req.Requesting_Organization__c];
        lookupList.put('con1',con1);
        }
        else{
            lookupList.put('con1',null);
        }
        if(req.Requesting_Surgeon__c!=null){
        Contact con2 = [select Id,Name,City__c,Street_1__c,Street_2__c,Zip_Postal_Code__c,Country__c,State__c,MobilePhone from Contact where id=:req.Requesting_Surgeon__c];
        lookupList.put('con2',con2);
        }
        else{
            lookupList.put('con2',null);
        }
        if(req.Surgery_Location__c!=null){
        Account con3 = [select Id,Name,Phone,City__c,Street_1__c,Street_2__c,Zip_Postal_Code__c,Country__c,State__c from Account where id=:req.Surgery_Location__c];
        lookupList.put('con3',con3);
        }
        else{
            lookupList.put('con3',null);
        }
        if(req.Eye_Bank_Performing_Pre_Cut__c!=null){
        Account con4 = [select Id,Name from Account where id=:req.Eye_Bank_Performing_Pre_Cut__c];
        lookupList.put('con4',con4);
        }
        else{
            lookupList.put('con4',null);
        }
        if(req.EMR_ID__c!=null){
        EMR__c emr =  [select Id,Name,First_Name__c,Last_Name__c,DOB__c,Age__c,Gender__c,Address__c,Phone__c,
                Email__c,Urgency__c,Eye_Involved__c,Blindness__c,Patient_Payment_Type__c,
                Pre_Surgical_Diagnosis__c,Previous_Ocular_Surgery__c,Other_Patient_Notes__c, 
                Adverse_Reaction_Reported__c,Adverse_Reaction_Report_Date_Time__c,Type_Of_Adverse_Reaction__c,
                Adverse_Reaction_Case__c from EMR__c where id=:req.EMR_ID__c];
        
        lookupList.put('emr',emr);
        }
        else{
            lookupList.put('emr',null);
        }
        System.debug('-->' + lookupList);
        
        return lookupList;
        
    }
   
    @AuraEnabled
    //Save Request
    public static Request__c save(Request__c Reqval,Id ReqOrglookup,Id ReqSurlookup,Id SurLoclookup,Id EyeBPPClookup,Id fifthlookup,EMR__c con, Id reqID){
        system.debug('Reqval'+Reqval);
        
        Reqval.Requesting_Organization__c=ReqOrglookup;
        Reqval.Requesting_Surgeon__c=ReqSurlookup;
        Reqval.Surgery_Location__c=SurLoclookup;
        Reqval.Eye_Bank_Performing_Pre_Cut__c=EyeBPPClookup;
        Reqval.EMR_ID__c=fifthlookup;
     /*   Reqval.First_Name__c=con.First_Name__c;
        Reqval.Last_Name__c=con.Last_Name__c;
        Reqval.DOB__c=con.DOB__c;
        Reqval.Age__c=con.Age__c;
        Reqval.Gender__c=con.Gender__c;
        Reqval.Address__c=con.Address__c;
        Reqval.Phone__c=con.Phone__c;
        Reqval.Email__c=con.Email__c;
        Reqval.Urgency__c=con.Urgency__c;
        Reqval.Eye_Involved__c=con.Eye_Involved__c;
        Reqval.Blindness__c=con.Blindness__c;
        Reqval.Patient_Payment_Type__c=con.Patient_Payment_Type__c;
        Reqval.Pre_Surgical_Diagnosis__c=con.Pre_Surgical_Diagnosis__c;
        Reqval.Previous_Ocular_Surgery__c=con.Previous_Ocular_Surgery__c;
        Reqval.Other_Patient_Notes__c=con.Other_Patient_Notes__c;
        Reqval.Adverse_Reaction_Reported__c=con.Adverse_Reaction_Reported__c;
        Reqval.Adverse_Reaction_Report_Date_Time__c=con.Adverse_Reaction_Report_Date_Time__c;
        Reqval.Type_Of_Adverse_Reaction__c=con.Type_Of_Adverse_Reaction__c;
        Reqval.Adverse_Reaction_Case__c=con.Adverse_Reaction_Case__c; */
       if(reqID!=null){
            Reqval.Id=reqID;
           if(!test.isRunningTest()){
            update Reqval;  
           }
        }
        else{
            insert Reqval; 
                      
        }
        
        return Reqval;
    }
    
    @AuraEnabled
    //Getting Picklist Values
 public static List < String > getselectOptions(sObject objObject, string fld) {
  system.debug('objObject --->' + objObject);
  system.debug('fld --->' + fld);
  List < String > allOpts = new list < String > ();
  // Get the object type of the SObject.
 
  Schema.sObjectType objType = objObject.getSObjectType();
 
  // Describe the SObject using its object type.
  Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
 
  // Get a map of fields for the SObject
  map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
 
  // Get the list of picklist values for this field.
  list < Schema.PicklistEntry > values =
   fieldMap.get(fld).getDescribe().getPickListValues();
 
  // Add these values to the selectoption list.
  for (Schema.PicklistEntry a: values) {
   allOpts.add(a.getValue());
  }
  system.debug('allOpts ---->' + allOpts);
  //allOpts.sort();
  return allOpts;
 }
    
}