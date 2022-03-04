public with sharing class AccountLightningCtrl {
	
    @AuraEnabled
    public static Account getAccountFromId(String accId){
		List<Account> lstAccount = [SELECT Id,Name FROM Account WHERE Id = :accId];
        if(!lstAccount.isEmpty()){
            return lstAccount[0];
        } else {
            return new Account();
        }
    }
    
    @AuraEnabled
    public static void saveData(Account acc){
		upsert acc; // Nếu account chưa Id -> insert / Nếu account có Id -> update
    }
    
    @AuraEnabled
    public static void deleteAccount(String accId){
        // Dùng Database.delete để delete record theo Id
        Database.delete(accId);
        // Dùng delete object để delete record theo object
        // Tham khảo thêm:
        // https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_methods_system_database.htm
    }
    
    @AuraEnabled
    public static List<Account> searchAccount(String searchCondition){
        List<Account> accounts = new List<Account>();
        if(String.isNotBlank(searchCondition)){
            String likeCondition = '%'+searchCondition+'%';
            accounts = [SELECT Id,Name,Owner.Name 
                        FROM Account 
                        WHERE Name LIKE :likeCondition];
        } else {
            accounts = [SELECT Id,Name,Owner.Name FROM Account];
        }
        System.debug('==searchCondition==' + searchCondition);
        System.debug('==accounts==' + accounts);
        return accounts;
    }
    
}