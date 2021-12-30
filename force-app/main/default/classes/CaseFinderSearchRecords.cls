public class CaseFinderSearchRecords {
    
    @AuraEnabled
    public static List<Account> getRefOrgs(String searchString)
    {
        Set<Id> accId =new Set<Id>();
        list<AggregateResult> AggregateResults;
        if(searchString!=null && searchString!='')
        {
            searchString='%'+searchString+'%';
            
            AggregateResults   = [select count(Id),Unit_Organization_Hospital_Name__c from Referral__c group by Unit_Organization_Hospital_Name__r.Name,Unit_Organization_Hospital_Name__c having Unit_Organization_Hospital_Name__r.Name LIKE :searchString and Unit_Organization_Hospital_Name__c !=null ];
            
        }
        else{
            AggregateResults      = [select count(Id),Unit_Organization_Hospital_Name__c from Referral__c group by Unit_Organization_Hospital_Name__c having Unit_Organization_Hospital_Name__c!= null ];
            
        }
        
        for(AggregateResult ag : AggregateResults)
        {
            Id idd =  (Id) ag.get('Unit_Organization_Hospital_Name__c');
            accId.add(idd);
        }
        
        return [select Name from Account where Id in : accId];
        
        
    }
    @AuraEnabled
    public static List<Referral__c> getCase(String first,String last, String donorid,String refid)
    {
        
        List<Referral__c> referral;
        
        System.debug('values........'+first+'     '+last+'     '+donorid+'     '+refid);
        
        
        if( first!=null && last !=null)
            
        {
            last = last + '%';
            first=first+'%';
            
            referral=    [select Id,Name,First_Name__c,Last_Name__c,Death_Notification_Consignment_Date_Time__c,Unit_Organization_Hospital_Name__r.Name,Unit_Organization_Hospital_Name__c,Donor_ID__c,Age_of_Donor__c,Date_Time_of_Death__c from Referral__c where First_Name__c  like : last AND Last_Name__c like : first ];
            
        }
        else if(refid!=null)
        {
            referral= [select Id,Name,First_Name__c,Last_Name__c,Death_Notification_Consignment_Date_Time__c,Unit_Organization_Hospital_Name__r.Name,Unit_Organization_Hospital_Name__c,Donor_ID__c,Age_of_Donor__c,Date_Time_of_Death__c from Referral__c where Name = : refid  ];
            
        }
        else if(donorid!=null)
        {
            referral= [select Id,Name,First_Name__c,Last_Name__c,Death_Notification_Consignment_Date_Time__c,Unit_Organization_Hospital_Name__r.Name,Unit_Organization_Hospital_Name__c,Donor_ID__c,Age_of_Donor__c,Date_Time_of_Death__c from Referral__c where Donor_ID__c  = : donorid  ];
            
        }
        
        
        else  if(first!=null)
        {
            first = first + '%';
            
            referral= [select Id,Name,First_Name__c,Last_Name__c,Death_Notification_Consignment_Date_Time__c,Unit_Organization_Hospital_Name__r.Name,Unit_Organization_Hospital_Name__c,Donor_ID__c,Age_of_Donor__c,Date_Time_of_Death__c from Referral__c where (Last_Name__c  like : first  )];
            
        }
        else if( last !=null)
            
        {
            last = last + '%';
            
            referral=    [select Id,Name,First_Name__c,Last_Name__c,Death_Notification_Consignment_Date_Time__c,Unit_Organization_Hospital_Name__r.Name,Unit_Organization_Hospital_Name__c,Donor_ID__c,Age_of_Donor__c,Date_Time_of_Death__c from Referral__c where First_Name__c  like : last  ];
            
        }
        
        
        return referral;
        
        
    }
    @AuraEnabled
    public static List<Referral__c> getCases(String accId,Date deathstart,Date deathend,Date refstart,Date refend)
    {
        List<Referral__c> refferals=new List<Referral__c>();
        System.debug('cases........'+accId+'     '+deathstart+'     '+deathend+'     '+refstart);
        
        
        
        if(accId!=null && deathstart!=null && deathend!=null && refstart!=null && refend!=null)
            
        {
            Set<Referral__c> reff = new Set<Referral__c>([select Id,Name,First_Name__c,Last_Name__c,Death_Notification_Consignment_Date_Time__c,Unit_Organization_Hospital_Name__c,Unit_Organization_Hospital_Name__r.Name,Donor_ID__c,Age_of_Donor__c,Date_Time_of_Death__c from Referral__c where ( Unit_Organization_Hospital_Name__c= : accId) and (Date_Time_of_Death__c >= : deathstart) and (Date_Time_of_Death__c <= : deathend+1)]);
            Set<Referral__c> ref = new Set<Referral__c>([select Id,Name,First_Name__c,Last_Name__c,Death_Notification_Consignment_Date_Time__c,Unit_Organization_Hospital_Name__c,Unit_Organization_Hospital_Name__r.Name,Donor_ID__c,Age_of_Donor__c,Date_Time_of_Death__c from Referral__c where ( Unit_Organization_Hospital_Name__c= : accId) and (Death_Notification_Consignment_Date_Time__c >= :refstart) and (Death_Notification_Consignment_Date_Time__c <= :refend+1)]);
            
            System.debug('list.....'+reff+'           /n'+ref);
            reff.addAll(ref);
            refferals.addAll(reff);
            
        }
        else if(accId!=null)
        {
            
            
                if(deathstart==null && deathend==null && refstart==null && refend==null)
            {
              Set<Referral__c> reff = new Set<Referral__c>([select Id,Name,First_Name__c,Last_Name__c,Death_Notification_Consignment_Date_Time__c,Unit_Organization_Hospital_Name__c,Unit_Organization_Hospital_Name__r.Name,Donor_ID__c,Age_of_Donor__c,Date_Time_of_Death__c from Referral__c where ( Unit_Organization_Hospital_Name__c= : accId)]);
            refferals.addAll(reff);
              
                
            }
            else if(deathstart!=null && deathend!=null)
            {
                Set<Referral__c> reff = new Set<Referral__c>([select Id,Name,First_Name__c,Last_Name__c,Death_Notification_Consignment_Date_Time__c,Unit_Organization_Hospital_Name__c,Unit_Organization_Hospital_Name__r.Name,Donor_ID__c,Age_of_Donor__c,Date_Time_of_Death__c from Referral__c where ( Unit_Organization_Hospital_Name__c= : accId) and (Date_Time_of_Death__c >= : deathstart) and (Date_Time_of_Death__c <= : deathend+1)]);
                refferals.addAll(reff);
                
            }
            else if(refstart!=null && refend!=null)
            {
                Set<Referral__c> ref = new Set<Referral__c>([select Id,Name,First_Name__c,Last_Name__c,Death_Notification_Consignment_Date_Time__c,Unit_Organization_Hospital_Name__c,Unit_Organization_Hospital_Name__r.Name,Donor_ID__c,Age_of_Donor__c,Date_Time_of_Death__c from Referral__c where ( Unit_Organization_Hospital_Name__c= : accId) and (Death_Notification_Consignment_Date_Time__c >= :refstart) and (Death_Notification_Consignment_Date_Time__c <= :refend+1)]);
                refferals.addAll(ref);
             
            }
            else if(deathstart!=null&&refstart!=null)
            {
                  Set<Referral__c> reff = new Set<Referral__c>([select Id,Name,First_Name__c,Last_Name__c,Death_Notification_Consignment_Date_Time__c,Unit_Organization_Hospital_Name__c,Unit_Organization_Hospital_Name__r.Name,Donor_ID__c,Age_of_Donor__c,Date_Time_of_Death__c from Referral__c where ( Unit_Organization_Hospital_Name__c= : accId) and (Date_Time_of_Death__c >= : deathstart)]);
                Set<Referral__c> ref = new Set<Referral__c>([select Id,Name,First_Name__c,Last_Name__c,Death_Notification_Consignment_Date_Time__c,Unit_Organization_Hospital_Name__c,Unit_Organization_Hospital_Name__r.Name,Donor_ID__c,Age_of_Donor__c,Date_Time_of_Death__c from Referral__c where ( Unit_Organization_Hospital_Name__c= : accId) and (Death_Notification_Consignment_Date_Time__c >= :refstart)]);
                reff.addAll(ref);
                refferals.addAll(reff);
              
               }
        
            else if(deathstart!=null&&refstart==null)
            {
                  Set<Referral__c> reff = new Set<Referral__c>([select Id,Name,First_Name__c,Last_Name__c,Death_Notification_Consignment_Date_Time__c,Unit_Organization_Hospital_Name__c,Unit_Organization_Hospital_Name__r.Name,Donor_ID__c,Age_of_Donor__c,Date_Time_of_Death__c from Referral__c where ( Unit_Organization_Hospital_Name__c= : accId) and (Date_Time_of_Death__c >= : deathstart)]);
                refferals.addAll(reff);
              
               }
            else if(refstart!=null&&deathstart==null)
            {
                Set<Referral__c> ref = new Set<Referral__c>([select Id,Name,First_Name__c,Last_Name__c,Death_Notification_Consignment_Date_Time__c,Unit_Organization_Hospital_Name__c,Unit_Organization_Hospital_Name__r.Name,Donor_ID__c,Age_of_Donor__c,Date_Time_of_Death__c from Referral__c where ( Unit_Organization_Hospital_Name__c= : accId) and (Death_Notification_Consignment_Date_Time__c >= :refstart)]);
                refferals.addAll(ref);
              
               }
          
          
        }
        else if(accId==null)
            
        {
            
            if(deathstart!=null && deathend!=null && refstart!=null && refend!=null)
            {
                Set<Referral__c> reff = new Set<Referral__c>([select Id,Name,First_Name__c,Last_Name__c,Death_Notification_Consignment_Date_Time__c,Unit_Organization_Hospital_Name__c,Unit_Organization_Hospital_Name__r.Name,Donor_ID__c,Age_of_Donor__c,Date_Time_of_Death__c from Referral__c where   (Date_Time_of_Death__c >= : deathstart) and (Date_Time_of_Death__c <= : deathend+1)]);
                Set<Referral__c> ref = new Set<Referral__c>([select Id,Name,First_Name__c,Last_Name__c,Death_Notification_Consignment_Date_Time__c,Unit_Organization_Hospital_Name__c,Unit_Organization_Hospital_Name__r.Name,Donor_ID__c,Age_of_Donor__c,Date_Time_of_Death__c from Referral__c where  (Death_Notification_Consignment_Date_Time__c >= :refstart) and (Death_Notification_Consignment_Date_Time__c <= :refend+1)]);
            reff.addAll(ref);
                refferals.addAll(reff);
                
                
            }
            else if(deathstart!=null && deathend!=null)
            {
                Set<Referral__c> reff = new Set<Referral__c>([select Id,Name,First_Name__c,Last_Name__c,Death_Notification_Consignment_Date_Time__c,Unit_Organization_Hospital_Name__c,Unit_Organization_Hospital_Name__r.Name,Donor_ID__c,Age_of_Donor__c,Date_Time_of_Death__c from Referral__c where  (Date_Time_of_Death__c >= : deathstart) and (Date_Time_of_Death__c <= : deathend+1)]);
                refferals.addAll(reff);
                
            }
            else if(refstart!=null && refend!=null)
            {
                Set<Referral__c> ref = new Set<Referral__c>([select Id,Name,First_Name__c,Last_Name__c,Death_Notification_Consignment_Date_Time__c,Unit_Organization_Hospital_Name__c,Unit_Organization_Hospital_Name__r.Name,Donor_ID__c,Age_of_Donor__c,Date_Time_of_Death__c from Referral__c where (Death_Notification_Consignment_Date_Time__c >= :refstart) and (Death_Notification_Consignment_Date_Time__c <= :refend+1)]);
                refferals.addAll(ref);
             
            }
            else if(deathstart!=null&&refstart!=null)
            {
                  Set<Referral__c> reff = new Set<Referral__c>([select Id,Name,First_Name__c,Last_Name__c,Death_Notification_Consignment_Date_Time__c,Unit_Organization_Hospital_Name__c,Unit_Organization_Hospital_Name__r.Name,Donor_ID__c,Age_of_Donor__c,Date_Time_of_Death__c from Referral__c where  (Date_Time_of_Death__c >= : deathstart)]);
                Set<Referral__c> ref = new Set<Referral__c>([select Id,Name,First_Name__c,Last_Name__c,Death_Notification_Consignment_Date_Time__c,Unit_Organization_Hospital_Name__c,Unit_Organization_Hospital_Name__r.Name,Donor_ID__c,Age_of_Donor__c,Date_Time_of_Death__c from Referral__c where (Death_Notification_Consignment_Date_Time__c >= :refstart)]);
                 reff.addAll(ref);
                refferals.addAll(reff);
              
               }
             else if(deathstart!=null&&refstart==null)
            {
                  Set<Referral__c> reff = new Set<Referral__c>([select Id,Name,First_Name__c,Last_Name__c,Death_Notification_Consignment_Date_Time__c,Unit_Organization_Hospital_Name__c,Unit_Organization_Hospital_Name__r.Name,Donor_ID__c,Age_of_Donor__c,Date_Time_of_Death__c from Referral__c where (Date_Time_of_Death__c >= : deathstart)]);
                refferals.addAll(reff);
              
               }
            else if(refstart!=null&&deathstart==null)
            {
                Set<Referral__c> ref = new Set<Referral__c>([select Id,Name,First_Name__c,Last_Name__c,Death_Notification_Consignment_Date_Time__c,Unit_Organization_Hospital_Name__c,Unit_Organization_Hospital_Name__r.Name,Donor_ID__c,Age_of_Donor__c,Date_Time_of_Death__c from Referral__c where (Death_Notification_Consignment_Date_Time__c >= :refstart)]);
                refferals.addAll(ref);
              
               }
          
            
            
            
        }
        
        
        return refferals;
        
    }
}