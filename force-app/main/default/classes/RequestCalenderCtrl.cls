/* ****************************************************************
*Author: Jagadeesh
*Created Date: 21/09/2020
*Last Modified by: Sangram
*Last Modified Date:24-09-2020
*Description: This class will have methods for Request Calender Data and Count for the default current month as well for the requested dates
**************************************************************** */
public class RequestCalenderCtrl {
    //This is the only method we will call from component to get required data
    @AuraEnabled
    public static ReqWrapper fetchInitialData(DateTime fromDate,DateTime toDate,string filter){
        //Logic to get full day
        DateTime newDateTime=fromDate.addHours(00);
        DateTime newDateTime1=newDateTime.addMinutes(00);
        DateTime totalfirstDate=newDateTime1.addSeconds(00);
        DateTime newDateTime2=toDate.addHours(23);
        DateTime newDateTime3=newDateTime2.addMinutes(59);
        DateTime totalEndDate=newDateTime3.addSeconds(59);
        
        ReqWrapper obj = new ReqWrapper();
        obj.statusCount = fetchRequestDataCount(totalfirstDate,totalEndDate); //fetch  count
        obj.reqData = fetchRequestData(totalfirstDate,totalEndDate,filter); //fetch data
        return obj;
    }
    
    //Get request data count details based on fromDate and toDate
    public static List<statusCount> fetchRequestDataCount(DateTime fromDate, DateTime toDate){
        List<statusCount> statusCount = new List<statusCount>();
        Map<string,string> countMap = new Map<string,string>();
        Map<string,String> options = new Map<string,string>();
        List<AggregateResult> results;
        
        Schema.DescribeFieldResult fieldResult = Request__c.Request_Status__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList){
            if(p.getLabel() != 'Not Fulfilled'){
                options.put(p.getLabel(),p.getValue()); 
            }
        }
        if(fromDate != null && toDate != null){
            results = [Select Request_Status__c value,count(Id) recordscount from Request__c WHERE Surgery_Date_Time__c >= :fromDate AND Surgery_Date_Time__c <= :toDate AND Request_Status__c != 'Not Fulfilled' Group By Request_Status__c];          
        }else{
            results = [Select Request_Status__c value,count(Id) recordscount from Request__c WHERE Surgery_Date_Time__c =  THIS_MONTH AND Request_Status__c != 'Not Fulfilled' Group By Request_Status__c];  
            
        }
        if(results != null){
            for(AggregateResult agr: results){
                countMap.put(String.valueOf(agr.get('Value')),String.valueOf(agr.get('recordscount'))); 
            }
        }
        for(string str: options.keySet()){
            if(countMap.containsKey(options.get(str))){
                statusCount obj = new statusCount(); //object initialize
                obj.status = str;
                obj.count = countMap.get(options.get(str));
                statusCount.add(obj);
                
            }
        }
        System.debug('statusCount'+statusCount);
        return statusCount;
          
    }
    
    //Get request data details based on from date and to date
    private static Map<String, List<Request__c>> fetchRequestData(DateTime fromDate, DateTime toDate,string filter){
        Map<String,List<Request__c>> data= new Map<String,List<Request__c>>();
        Date formatFromDate;
        Date formatToDate;
        if(fromDate != null){
            formatFromDate = Date.valueOf(fromDate.format('yyyy-MM-dd HH:mm:ss', 'IST'));    
        }
        if(toDate != null){
            formatToDate = Date.valueOf(toDate.format('yyyy-MM-dd HH:mm:ss', 'IST'));
        }
        List<Request__c> RecLst;
        if(filter == 'ALL' && fromDate == null && toDate == null){
            RecLst = [SELECT id, Name, Age__c, Surgery__c, Requesting_Surgeon__c, Request_Status__c, 
                      Medical_Record__c, Requesting_Surgeon__r.Name, Tissue_ID__c, TissueID__c, createdDate,
                      Surgery_Date_Time__c FROM Request__c WHERE Surgery_Date_Time__c = THIS_MONTH AND Request_Status__c != 'Not Fulfilled' Order By Surgery_Date_Time__c]; 
        }else if(filter == 'ALL' && formatFromDate != null && formatFromDate != null){
            RecLst = [SELECT id, Name, Age__c, Surgery__c, Requesting_Surgeon__c, Request_Status__c, 
                      Medical_Record__c, Requesting_Surgeon__r.Name, Tissue_ID__c, TissueID__c, createdDate,
                      Surgery_Date_Time__c FROM Request__c WHERE DAY_ONLY(Surgery_Date_Time__c) >= :formatFromDate AND 
                      DAY_ONLY(Surgery_Date_Time__c) <= :formatToDate AND Request_Status__c != 'Not Fulfilled' Order By Surgery_Date_Time__c]; 
        }else{
            RecLst = [SELECT id, Name, Age__c,Surgery__c, Requesting_Surgeon__c, Request_Status__c,
                      Medical_Record__c,Requesting_Surgeon__r.Name,Tissue_ID__c,TissueID__c, createdDate, 
                      Surgery_Date_Time__c FROM Request__c WHERE DAY_ONLY(Surgery_Date_Time__c) >= :formatFromDate AND 
                      DAY_ONLY(Surgery_Date_Time__c) <= :formatToDate AND Request_Status__c =: filter AND Request_Status__c != 'Not Fulfilled'
                      Order By Surgery_Date_Time__c];
        }
        if(RecLst != null && RecLst.size()>0){
            for(Request__c req: RecLst){
                if(data.containsKey(req.Surgery_Date_Time__c.format('dd/MM/yyyy'))) {
                    List<Request__c> exist=  data.get(req.Surgery_Date_Time__c.format('dd/MM/yyyy'));
                    exist.add(req);
                    data.put(req.Surgery_Date_Time__c.format('dd/MM/yyyy'), exist);
                }else{
                    data.put(req.Surgery_Date_Time__c.format('dd/MM/yyyy'), new List<Request__c> {req});
                } 
            }
        }
        return data;
    }
    
    //This class holds request calender componet details 
    public class ReqWrapper{
        @AuraEnabled
        public List<statusCount> statusCount;
        @AuraEnabled
        public Map<String,List<Request__c>> reqData;
    }
    
    //This class holds Status and corresponding count 
    public class statusCount{
        @AuraEnabled
        public string status;
        @AuraEnabled
        public string count;
    }
}