public class InventoryController {  
    
    @AuraEnabled
    public static List<Integer> tissueInventory(){
        List<Integer> tissueInventory = new List<Integer>();
        Integer transplantWG = 0;
        Integer transplantWC = 0;
        Integer transplantS = 0;
        Integer researchWG = 0;
        Integer researchWC = 0;
        Integer researchS = 0;
        Integer trainingWG = 0;
        Integer trainingWC = 0;
        Integer trainingS = 0;
        Integer QuarantineWG = 0;
        Integer QuarantineWC = 0;
        Integer QuarantineS = 0;
        
        //Transplant
        List<AggregateResult> results1 = [Select count(Id) from Tissue_Evaluation__c where Approval_Outcome__c='Transplant' And Tissue_Type__c='Whole Globe' And Placement_Status__c!='Shipped'];
        if(results1!=null){
            transplantWG =  (Integer)results1[0].get('expr0'); 
            tissueInventory.add(transplantWG);
        }
        List<AggregateResult> results2 = [Select count(Id) from Tissue_Evaluation__c where Approval_Outcome__c='Transplant' And Tissue_Type__c='Cornea' And Placement_Status__c!='Shipped'];
        if(results2!=null){
            transplantWC =  (Integer)results2[0].get('expr0'); 
            tissueInventory.add(transplantWC);
        }
        List<AggregateResult> results3 = [Select count(Id) from Tissue_Evaluation__c where Approval_Outcome__c='Transplant' And Tissue_Type__c='Sclera' And Placement_Status__c!='Shipped'];
        if(results3!=null){
            transplantS =  (Integer)results3[0].get('expr0'); 
            tissueInventory.add(transplantS);
        }
        
        // Research
        List<AggregateResult> results4 = [Select count(Id) from Tissue_Evaluation__c where Approval_Outcome__c='Shipped:Research' And Tissue_Type__c='Whole Globe' And Placement_Status__c!='Shipped'];
        if(results4!=null){
            researchWG =  (Integer)results4[0].get('expr0'); 
            tissueInventory.add(researchWG);
        }
        List<AggregateResult> results5 = [Select count(Id) from Tissue_Evaluation__c where Approval_Outcome__c='Research' And Tissue_Type__c='Cornea' And Placement_Status__c!='Shipped'];
        if(results5!=null){
            researchWC =  (Integer)results5[0].get('expr0'); 
            tissueInventory.add(researchWC);
        }
        List<AggregateResult> results6 = [Select count(Id) from Tissue_Evaluation__c where Approval_Outcome__c='Research' And Tissue_Type__c='Sclera' And Placement_Status__c!='Shipped'];
        if(results6!=null){
            researchS =  (Integer)results6[0].get('expr0'); 
            tissueInventory.add(researchS);
        }
        
        //Training
        List<AggregateResult> results7 = [Select count(Id) from Tissue_Evaluation__c where Approval_Outcome__c='Training' And Tissue_Type__c='Whole Globe' And Placement_Status__c!='Shipped'];
        if(results7!=null){
            trainingWG =  (Integer)results7[0].get('expr0'); 
            tissueInventory.add(trainingWG);
        }
        List<AggregateResult> results8 = [Select count(Id) from Tissue_Evaluation__c where Approval_Outcome__c='Training' And Tissue_Type__c='Cornea' And Placement_Status__c!='Shipped'];
        if(results8!=null){
            trainingWC =  (Integer)results8[0].get('expr0'); 
            tissueInventory.add(trainingWC);
        }
        List<AggregateResult> results9 = [Select count(Id) from Tissue_Evaluation__c where Approval_Outcome__c='Training' And Tissue_Type__c='Sclera' And Placement_Status__c!='Shipped'];
        if(results9!=null){
            trainingS =  (Integer)results9[0].get('expr0'); 
            tissueInventory.add(trainingS);
        }
        //Quarantine
       List<AggregateResult> results10 = [Select count(Id) from Tissue_Evaluation__c where Approval_Outcome__c='Quarantine' And Tissue_Type__c='Whole Globe'];
        if(results10!=null){
            QuarantineWG =  (Integer)results10[0].get('expr0'); 
            tissueInventory.add(QuarantineWG);
        }
        List<AggregateResult> results11 = [Select count(Id) from Tissue_Evaluation__c where Approval_Outcome__c='Quarantine' And Tissue_Type__c='Cornea'];
        if(results11!=null){
            QuarantineWC =  (Integer)results11[0].get('expr0'); 
            tissueInventory.add(QuarantineWC);
        }
        List<AggregateResult> results12 = [Select count(Id) from Tissue_Evaluation__c where Approval_Outcome__c='Quarantine' And Tissue_Type__c='Sclera'];
        if(results12!=null){
            QuarantineS =  (Integer)results12[0].get('expr0'); 
            tissueInventory.add(QuarantineS);
        }

        System.debug('FinalInventory' + tissueInventory);
        return tissueInventory;
    }
    
    @AuraEnabled
    public static List<Tissue_Evaluation__c> getFilterTissues(string tisstype, string approvedoutcome, string approvedfor){
        system.debug('tissue type '+tisstype);
        system.debug('outcome '+approvedoutcome);
        List<Tissue_Evaluation__c> allTissues = new List<Tissue_Evaluation__c>();
        set<string> ApprovalOutComeNotIn = new set<string>();
        ApprovalOutComeNotIn.add('Discard');ApprovalOutComeNotIn.add('Shipped');ApprovalOutComeNotIn.add('Placed');ApprovalOutComeNotIn.add('');
        if(string.isNotBlank(tisstype) || string.isNotBlank(approvedoutcome) || string.isNotBlank(approvedfor)){
        	string query = 'Select Id,Name,Tissue_Type__c,Approved_Usages__c,Age__c,Cell_Count_per_mm2__c,Date_Time_of_Death_TissueEvaluation__c,Recovery__r.Cornea_Preservation_Date_Time__c,Organisation__c,Approval_Outcome__c,PK__c,ALK__c,EK__c,K_Pro__c,KLA__c,Tectonic_Therapeutic__c,Aging__c,Placement_Status__c,Request_Status__c, Tissue_Aging__c,Tissue_Disposition__c from Tissue_Evaluation__c where Approval_Outcome__c NOT IN :ApprovalOutComeNotIn';
            system.debug('query is '+query);
            if(string.isNotBlank(tisstype) && tisstype != 'None')
            	query += ' AND Tissue_Type__c =:tisstype';
            system.debug('query is '+query);
            if(string.isNotBlank(approvedoutcome) && approvedoutcome != 'None' && approvedoutcome != '' )
            	query += ' AND Approval_Outcome__c =:approvedoutcome';
            if(string.isNotBlank(approvedfor) && approvedfor != 'None' ){
            	string val = '%'+approvedfor+'%';
                query += ' AND Approved_Usages__c LIKE :val';
            }
            system.debug('query is '+query);
            query += ' Order by CreatedDate Desc';
            system.debug('query is '+query);
            allTissues = Database.query(query);
        }
        System.debug('AllTissues'+ allTissues);
        return allTissues;
    }
    
    @AuraEnabled
    public static List<Tissue_Evaluation__c> getAlltissues(){
        List<Tissue_Evaluation__c> allTissues = new List<Tissue_Evaluation__c>();
        allTissues = [Select Id,Name,Approved_Usages__c,Tissue_Type__c,Age__c,Cell_Count_per_mm2__c,Date_Time_of_Death_TissueEvaluation__c,
                      Recovery__r.Cornea_Preservation_Date_Time__c,Recovery__r.Referral__r.Unit_Organization_Hospital_Name__r.Name,Approval_Outcome__c,PK__c,ALK__c,EK__c,K_Pro__c,KLA__c,Tectonic_Therapeutic__c,Aging__c,Placement_Status__c,
                      Request_Status__c, Tissue_Aging__c,Organisation__c,Tissue_Disposition__c from Tissue_Evaluation__c where Approval_Outcome__c not in ('Discard','','Shipped','Placed', 'None') Order by CreatedDate Desc];    
        
        /*DateTime current_datetime = datetime.now();
        for(integer i =0;i<allTissues.size();i++){
            if(allTissues[i].Recovery__r.Cornea_Preservation_Date_Time__c!=null){
            decimal age = decimal.valueof((current_datetime.getTime()-allTissues[i].Recovery__r.Cornea_Preservation_Date_Time__c.getTime())/(60*60));
            Integer aging = integer.valueOf(age/1000)/24;
            allTissues[i].Aging__c = aging;
            }
        }*/
        
        System.debug('AllTissues'+ allTissues);
        return allTissues;
    }
    
    @AuraEnabled
    public static list < Tissue_Evaluation__c > fetchContact(String sortField, boolean isAsc) {
      String sSoql = 'SELECT Id, ' + sortField + ' ';
      sSoql += 'From Tissue_Evaluation__c';
      system.debug('sortField-->' + sortField);
 
      if (sortField != '') {
         sSoql += ' order by ' + sortField;
 
    // if isAsc is equal tp ture then set 'asc' order otherwise set 'desc' order.
         if (isAsc) {
            sSoql += ' asc';
         } else {
            sSoql += ' desc';
         }
      }
   // set record limit to query 
     // sSoql += ' LIMIT 20';
 
      System.debug('@Developer -->sSoql:' + sSoql);
      list <Tissue_Evaluation__c> lstResult;
      try {
         system.debug('The query is' + sSoql);
         lstResult = Database.query(sSoql);
         List < Tissue_Evaluation__c > returnConList = new List < Tissue_Evaluation__c > ();
 
         for (Tissue_Evaluation__c c: lstResult) {
            returnConList.add(c);
          }
         system.debug('The list is' + returnConList);
         return returnConList;
      } 
      catch (Exception ex) {
         // for handle Exception
         return null;
      }
   }
}