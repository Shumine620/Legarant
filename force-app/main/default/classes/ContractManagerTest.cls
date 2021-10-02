@isTest
private class ContractManagerTest {
    //Test to create a new contract 
    @isTest static void testCreateContract() { 
        
        String account = createAccountId();
        
        //Call the method to test
        Id thisContractId = ContractManager.createContract(account, 'Draft', 12);
        
        //Verify the test
        System.assert(thisContractId != null);
        Contract thisContract = [SELECT AccountId, Status FROM Contract WHERE Id=:thisContractId];
        System.assert(thisContract != null);
        System.assertEquals(Account, thisContract.AccountId);
        System.assertEquals('Draft', thisContract.Status);
    }
    
    //Test to update contact with info from AXG
    @isTest static void testUpdateContract() {
        String account = createAccountId();
        
        //Create a record of contact to test
        Id thisContractId = ContractManager.createContract(account, 'Draft', 12);
        
        //Instantiate request
        RestRequest request = new RestRequest();
        request.requestURI = 'https://ocr3-dev-ed.my.salesforce.com/services/apexrest/Contracts/'+thisContractId;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"status": "Activated"}');
        RestContext.request = request;
        
        //Update contract of existing contract
        ContractManager.updateContract();
        
        //Verify contact was update
        
        Contract thisContract = [SELECT Status FROM Contract WHERE Id=:thisContractId];
        System.assert(thisContract != null);
        System.assertEquals('Activated', thisContract.Status);
        
    }
    //Helper method
    public static String createAccountId() {
        Account account = new Account(
            Name = 'AccountTest',
            Phone = '01020302'
        );
        insert account;
        return account.Id;
    }
    public static Id createContractTest(String account) { 
        Contract contract = new Contract(
            AccountId = account,
            Status = 'Draft',
            ContractTerm = 12
            
        );
        insert contract;
        return contract.Id;
    }
}