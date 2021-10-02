@RestResource(urlMapping='/Contracts/*')
global with sharing class ContractManager {
    
    //Create contract
    @HttpPost
    global static Id createContract(Id AccountId, String status, Integer contractTerm) {
        Contract thisContract = new Contract(
           // Name = name,
            AccountId = accountId,
            Status = status,
            ContractTerm = contractTerm
        );
        insert thisContract;
        return thisContract.Id;
    }
    //Update a contract 
    @HttpPatch
    global static void updateContract() {
        RestRequest request = RestContext.request;
        String contractId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Contract thisContract = [SELECT Id FROM Contract WHERE Id = :contractId];
        
        // Deserialize the JSON string into name-value pairs
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        
        // Iterate through each parameter field and value
        for(String fieldName : params.keySet()) {
            // Set the field and value on the Contract sObject
            thisContract.put(fieldName, params.get(fieldName));
        }
        update thisContract;
    }
}