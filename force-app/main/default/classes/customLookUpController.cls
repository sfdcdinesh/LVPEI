public class customLookUpController {
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName, String contactRole,String tissueType ) {
        system.debug('ObjectName-->' + ObjectName);
        system.debug('TissueType-->' + tissueType);
        String searchKey ='%'+ searchKeyWord + '%';
        String placementStatus = 'Shipped';
       	List < sObject > returnList = new List < sObject > ();
       	Request__c reqWhere = new Request__c();
       // list<Request__c> reqWhere  = new list<Request__c>();
       // 	reqWhere = [select id,  Surgery__c from Request__c];
       	Tissue_Evaluation__c tisWhere = new Tissue_Evaluation__c();
       //  List<Tissue_Evaluation__c> tisWhere = new List<Tissue_Evaluation__c>();
        //	tisWhere = [select id,  PK__c, ALK__c, EK__c, K_Pro__c, KLA__c, Tectonic_Therapeutic__c from Tissue_Evaluation__c];

        String sQuery = '';
        String K = 'K Srinivas';
        String G = 'G Srinivas';
        String V = 'CH Venkata Swamy';
        String KG = 'K Gangadhar';
        string N = 'Niladri Bihari Das';
        string A = 'Abhinit Jain';

        
        list<String> plStrWhere  = new list<String>{'Placed', 'Returned', 'Discard', 'Quarantine'};
        
        if(ObjectName == 'Account' && contactRole=='unitOrganisation')
        {
            sQuery =  'select id,Name,Phone,City__c,Street_1__c,Street_2__c,Zip_Postal_Code__c,Country__c,State__c  from ' +ObjectName +' ' +'Where (Hospital__c=TRUE OR HCRP_Hospital__c=TRUE OR Organisation__c=TRUE OR Transplant_Hospital__c=TRUE) AND  Name Like :searchKey order by createdDate DESC limit 5 '; 
       system.debug('I am Account'+ sQuery);
        }
       else if(ObjectName == 'Account' && contactRole=='unitOrganisation1'){
           sQuery =  'select id,Name,Phone,City__c,Street_1__c,Street_2__c,Zip_Postal_Code__c,Country__c,State__c  from ' +ObjectName +' ' +'Where (Hospital__c=TRUE) AND Name Like :searchKey order by createdDate DESC limit 5 ';
           // sQuery =  'select id,Name,Phone,City__c,Street_1__c,Street_2__c,Zip_Postal_Code__c,Country__c,State__c  from ' +ObjectName +' ' +'Where Name Like :searchKey order by createdDate DESC limit 5 ';
       system.debug('I am Account'+ sQuery);
        }
        else if(ObjectName == 'Contact' && contactRole=='hrcpcounselor'){
            sQuery =  'select id, Name,Phone,MobilePhone,HomePhone,npe01__WorkPhone__c,City__c,Street_1__c,Street_2__c,Zip_Postal_Code__c,Country__c,State__c,HCRP_Counselor__c, Hospital_Staff__c, Volunteer__c, HCRP_Manager__c, Eye_Bank_Staff__c from ' +ObjectName + ' where (HCRP_Counselor__c=TRUE OR Hospital_Staff__c=TRUE OR Volunteer__c=TRUE OR HCRP_Manager__c=TRUE OR Eye_Bank_Staff__c=TRUE) AND Name Like :searchKey order by createdDate DESC limit 5 ';
        }
        
        else if(ObjectName == 'Contact' && contactRole=='unitOrganisation'){
            sQuery =  'select id, Name,MobilePhone,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,Phone,HCRP_Counselor__c from ' +ObjectName + ' where HCRP_Counselor__c=TRUE AND Name Like :searchKey order by createdDate DESC limit 5 ';
        }
        else if(ObjectName == 'Contact' && contactRole=='hcrpHospital'){
            sQuery =  'select id, Name,MobilePhone,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,Phone, HCRP_Hospital__c, Eye_Bank_Staff__c from ' +ObjectName + ' where (HCRP_Hospital__c=TRUE OR Eye_Bank_Staff__c=TRUE) AND Name Like :searchKey order by createdDate DESC limit 5 ';
        }
        
        else if(ObjectName == 'Contact' && contactRole=='recoverytech'){
            sQuery =  'select id, Name,MobilePhone,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,Phone, Recovery_Technician__c, Eye_Bank_Staff__c from ' +ObjectName + ' where (Recovery_Technician__c=TRUE OR Eye_Bank_Staff__c=TRUE) AND Name Like :searchKey order by createdDate DESC limit 5 ';
        }
        else if(ObjectName == 'Contact' && contactRole=='specularTech'){
            sQuery =  'select id, Name,MobilePhone,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,Phone,  Specular_Technician__c, Eye_Bank_Staff__c from ' +ObjectName + ' where (Specular_Technician__c=TRUE OR Eye_Bank_Staff__c=TRUE) AND Name Like :searchKey order by createdDate DESC limit 5 ';
        }
         else if(ObjectName == 'Contact' && contactRole=='ekTech'){
            sQuery =  'select id, Name,MobilePhone,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,Phone,  EK_Technician__c from ' +ObjectName + ' where (EK_Technician__c=TRUE) AND Name Like :searchKey order by createdDate DESC limit 5 ';
        }
         else if(ObjectName == 'Contact' && contactRole=='ekCirculator'){
            sQuery =  'select id, Name,MobilePhone,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,Phone,  EK_Circulator__c from ' +ObjectName + ' where (EK_Circulator__c=TRUE) AND Name Like :searchKey order by createdDate DESC limit 5 ';
        }
        else if(ObjectName == 'Contact' && contactRole=='slitLampTech'){
            sQuery =  'select id, Name,MobilePhone,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,Phone,  Slit_Lamp_Technician__c, Eye_Bank_Staff__c from ' +ObjectName + ' where (Slit_Lamp_Technician__c=TRUE OR Eye_Bank_Staff__c=TRUE) AND Name Like :searchKey order by createdDate DESC limit 5 ';
        }
        else if(ObjectName == 'Contact' && contactRole=='serologytech'){
            sQuery =  'select id, Name,MobilePhone,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,Phone,  Serology_Technician__c, Eye_Bank_Staff__c from ' +ObjectName + ' where (Serology_Technician__c=TRUE OR Eye_Bank_Staff__c=TRUE) AND Name Like :searchKey order by createdDate DESC limit 5 ';
        }
        else if(ObjectName == 'Contact' && contactRole=='microbiologist'){
            sQuery =  'select id, Name,MobilePhone,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,Phone,  Microbiologist__c, Eye_Bank_Staff__c from ' +ObjectName + ' where (Microbiologist__c=TRUE OR Eye_Bank_Staff__c=TRUE) AND Name Like :searchKey order by createdDate DESC limit 5 ';
        }
        else if(ObjectName == 'Contact' && contactRole=='EyebankAndQA'){
            sQuery =  'select id, Name,MobilePhone,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,Phone,  Eye_Bank_Manager__c, QA_Manager__c, Slit_Lamp_Technician__c, Eye_Bank_Staff__c from ' +ObjectName + ' where (Eye_Bank_Manager__c=TRUE OR QA_Manager__c=TRUE OR Slit_Lamp_Technician__c=TRUE OR Eye_Bank_Staff__c=TRUE) AND Name Like :searchKey order by createdDate DESC limit 5 ';
        }
        else if(ObjectName == 'Contact' && contactRole=='EyebankAndQA1'){
            sQuery =  'select id, Name,MobilePhone,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,Phone,  Eye_Bank_Manager__c, QA_Manager__c from ' +ObjectName + ' where (Eye_Bank_Manager__c=TRUE OR QA_Manager__c=TRUE) AND Name Like :searchKey order by createdDate DESC limit 5 ';
        }
        else if(ObjectName == 'Contact' && contactRole=='FinalReview'){
            sQuery =  'select id, Name,MobilePhone,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,Phone,  Eye_Bank_Manager__c, QA_Manager__c from ' +ObjectName + ' where  Name Like : K Limit 1'   ;
        }
        else if(ObjectName == 'Contact' && contactRole=='FinalReview2'){
            sQuery =  'select id, Name,MobilePhone,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,Phone,  Eye_Bank_Manager__c, QA_Manager__c from ' +ObjectName + ' where  Name Like : G Limit 1'   ;
        }
        else if(ObjectName == 'Contact' && contactRole=='FinalReview3'){
            sQuery =  'select id, Name,MobilePhone,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,Phone,  Eye_Bank_Manager__c, QA_Manager__c from ' +ObjectName + ' where  Name Like : V Limit 1'   ;
        }
        else if(ObjectName == 'Contact' && contactRole=='FinalReview4'){
            sQuery =  'select id, Name,MobilePhone,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,Phone,  Eye_Bank_Manager__c, QA_Manager__c from ' +ObjectName + ' where  Name Like : KG Limit 1'   ;
        }        else if(ObjectName == 'Contact' && contactRole=='FinalReview5'){
            sQuery =  'select id, Name,MobilePhone,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,Phone,  Eye_Bank_Manager__c, QA_Manager__c from ' +ObjectName + ' where  Name Like : KG Limit 0'   ;
        }
         else if(ObjectName == 'Contact' && contactRole=='FinalReview6'){
            sQuery =  'select id, Name,MobilePhone,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,Phone,  Eye_Bank_Manager__c, QA_Manager__c from ' +ObjectName + ' where  Name Like : N Limit 1'   ;
        } 
          else if(ObjectName == 'Contact' && contactRole=='FinalReview7'){
            sQuery =  'select id, Name,MobilePhone,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,Phone,  Eye_Bank_Manager__c, QA_Manager__c from ' +ObjectName + ' where  Name Like : A Limit 1'   ;
        }         
        else if(ObjectName == 'Contact' && contactRole=='handBy'){
            sQuery =  'select id, Name,MobilePhone,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,Phone, Distribution_Assistant__c from ' +ObjectName + ' where Distribution_Assistant__c=TRUE AND Name Like :searchKey order by createdDate DESC limit 5 ';
        }
        else if(ObjectName == 'Contact' && contactRole=='to'){
            sQuery =  'select id, Name,Phone,MobilePhone,HomePhone,npe01__WorkPhone__c,City__c,Street_1__c,Street_2__c,Zip_Postal_Code__c,Country__c,State__c, Organisation_Hospital__c, Transplant_Hospital__c from ' +ObjectName + ' where (Organisation_Hospital__c=TRUE OR Transplant_Hospital__c=TRUE) AND Name Like :searchKey order by createdDate DESC limit 5 ';
        }
        else if(ObjectName == 'Contact' && contactRole=='reqorg'){
            sQuery =  'select id, Name,MobilePhone,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,Phone, Organisation_Hospital__c, Transplant_Hospital__c from ' +ObjectName + ' where (Organisation_Hospital__c=TRUE OR Transplant_Hospital__c=TRUE) AND Name Like :searchKey order by createdDate DESC limit 5 ';
        }
        else if(ObjectName == 'Contact' && contactRole=='transsurgeon'){
            sQuery =  'select id, Name,Phone,MobilePhone,HomePhone,npe01__WorkPhone__c,City__c,Street_1__c,Street_2__c,Zip_Postal_Code__c,Country__c,State__c, Transplant_Surgeon__c from ' +ObjectName + ' where Transplant_Surgeon__c=TRUE AND Name Like :searchKey order by createdDate DESC limit 5 ';
        }
        else if(ObjectName == 'Contact' && contactRole=='transHosp'){
            sQuery =  'select id, Name,MobilePhone,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,Phone, Transplant_Hospital__c from ' +ObjectName + ' where Transplant_Hospital__c=TRUE AND Name Like :searchKey order by createdDate DESC limit 5 ';
        }
        else if(ObjectName == 'Contact' && contactRole=='eyebankPrecut'){
            sQuery =  'select id, Name,MobilePhone,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,Phone, Organisation_Hospital__c from ' +ObjectName + ' where Organisation_Hospital__c=TRUE AND Name Like :searchKey order by createdDate DESC limit 5 ';
        }
        else if(ObjectName == 'Contact' && contactRole=='completedBy'){
            sQuery =  'select id, Name,MobilePhone,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,Phone, Recovery_Technician__c,Specular_Technician__c,Slit_Lamp_Technician__c,EK_Technician__c,EK_Circulator__c,Eye_Bank_Staff__c,Eye_Bank_Manager__c,QA_Manager__c,Distribution_Assistant__c from ' +ObjectName + ' where (Recovery_Technician__c=TRUE OR Specular_Technician__c=TRUE OR Slit_Lamp_Technician__c=TRUE OR EK_Technician__c=TRUE OR EK_Circulator__c=TRUE OR Eye_Bank_Staff__c=TRUE OR Eye_Bank_Manager__c=TRUE OR QA_Manager__c=TRUE OR Distribution_Assistant__c=TRUE) AND Name Like :searchKey  order by createdDate DESC limit 5 ';
        }
        else if(ObjectName == 'Contact' && contactRole=='specularTech1'){
            sQuery =  'select id, Name,MobilePhone,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,Phone, Specular_Technician__c from ' +ObjectName + ' where (Specular_Technician__c=TRUE) AND Name Like :searchKey  order by createdDate DESC limit 5 ';
        }
        else if(ObjectName == 'Contact' && contactRole=='specularTechTiss'){
            sQuery =  'select id, Name,MobilePhone,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,Phone, Recovery_Technician__c, Eye_Bank_Staff__c from ' +ObjectName + ' where (Recovery_Technician__c=TRUE OR Eye_Bank_Staff__c=TRUE) AND Name Like :searchKey  order by createdDate DESC limit 5 ';
        }
        else if(ObjectName == 'Contact' && contactRole=='slitLampTech1'){
            sQuery =  'select id, Name,MobilePhone,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,Phone, Slit_Lamp_Technician__c from ' +ObjectName + ' where (Slit_Lamp_Technician__c=TRUE) AND Name Like :searchKey  order by createdDate DESC limit 5 ';
        }
        else if(ObjectName == 'EMR__c'){
            sQuery =  'select id, Name,First_Name__c,Last_Name__c,DOB__c,Age__c,Gender__c,Address__c,Phone__c,Email__c,Urgency__c,Eye_Involved__c,Blindness__c,Patient_Payment_Type__c,Pre_Surgical_Diagnosis__c,Previous_Ocular_Surgery__c,Other_Patient_Notes__c,Adverse_Reaction_Reported__c,Adverse_Reaction_Report_Date_Time__c,Type_Of_Adverse_Reaction__c,Adverse_Reaction_Case__c from ' +ObjectName + ' where Name LIKE: searchKey order by createdDate DESC limit 5';
        }
        else if(ObjectName == 'Tissue_Evaluation__c'){
            
            sQuery =  'select id, Name, Tissue_Suitability__c,EK__c, PK__c, ALK__c, K_Pro__c, KLA__c,Tectonic_Therapeutic__c from Tissue_Evaluation__c where Approval_Outcome__c =:tissueType AND Name Like :searchKey limit 10';         //Approval_Outcome__c =: tissueType AND Placement_Status__c!=:placementStatus AND
        }  
        
        else{
            sQuery =  'select id,Name from ' +ObjectName + ' where Name LIKE: searchKey order by createdDate DESC limit 5';
        }
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5   
        
        //sQuery = String.isNotBlank(recId)?sQuery+' AND Id=:recId':sQuery;
        List < sObject > lstOfRecords = Database.query(sQuery);
        system.debug('Tissue Type'+tissueType);
        //system.debug(lstOfRecords.size()+'======'+lstOfRecords[0]);
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        system.debug('list'+ returnList);
        return returnList;
    }
}