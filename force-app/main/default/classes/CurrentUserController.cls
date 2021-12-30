public class CurrentUserController {
 
    @AuraEnabled
    public static User getCurrentUser() {
    	User toReturn = [SELECT Id, FirstName, LastName FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
        return toReturn;
    }
}