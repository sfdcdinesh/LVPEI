public class customContactController {

@AuraEnabled
    public static Map<String,String> getApiNames(){
        Map<String,String> fieldApis = new Map<String,String>(); 
        String objName = 'Contact';
        Map<String, Schema.SObjectType> gdMap = Schema.getGlobalDescribe();
        Schema.Describesobjectresult dsr = gdMap.get(objName).getDescribe();
        Map<String, Schema.SObjectField> fldObjMap = dsr.fields.getMap();   
        List<Schema.SObjectField> fldObjMapValues = fldObjMap.values();
        for(Schema.SObjectField s : fldObjMapValues)
        {
            String theName = s.getDescribe().getName();
            String theLabel = s.getDescribe().getLabel();
            System.debug('APIName-->'+theName);
            System.debug('Label-->'+theLabel);
            fieldApis.put(theLabel,theName);
        }
        return fieldApis;     
    }
@AuraEnabled
    public static Integer ContactDuplicate(String Name1, String Email,string role){
        System.debug('Name-->'+Name1);
        Integer result = 0;
        List<Contact> con = new List<Contact>();
        con = [Select Id,Name,npe01__HomeEmail__c from Contact where Name=:Name1];
        System.debug('Contact-->'+con.size());
            if(con.size()>0){
                result = result+1;
            }
        else{
            result = 0;
        } 
        return result;
    }
    
@AuraEnabled
    public static Contact saveContact(Contact con){
       // con.AccountId = dcon;
        insert con;
        return [select Id,Name from Contact where Id = :con.Id LIMIT 1];
    }
}