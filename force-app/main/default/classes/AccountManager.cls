@RestResource(urlMapping='/Accounts/*')
global with sharing class AccountManager {
    
 //Create account
    @HttpPost
    global static ID createAccount(String name) {
      
            Account thisAccount = new Account(
                Name = name
            );
            insert thisAccount;
            return thisAccount.Id;
        
    }
  
   @HttpGet
    global static Account getAccountById() {
        RestRequest request = RestContext.request;
        
        // grab the contactId from the end of the URL
        String accountId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Account result =  [SELECT Id,Name FROM Account WHERE Id = :accountId];               
        return result;
        
    } 
    //Update account 
    @HttpPatch
    global static Account updateAccount() {
        RestRequest request = RestContext.request;
        String accountId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Account thisAccount = [SELECT Id FROM Account WHERE Id = :accountId];
        
        // Deserialize the JSON string into name-value pairs
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        // Iterate through each parameter field and value
        for(String fieldName : params.keySet()) {
            // Set the field and value on the account sObject
            thisAccount.put(fieldName, params.get(fieldName));
        }
        update thisAccount;
        return thisAccount;
    }
}