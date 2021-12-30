public class CustomAccountController {
	@AuraEnabled
    public static Account fetchAccount(ID AccId){
        return [select Id,Name from Account where Id = :AccId LIMIT 1];
    }
}