@isTest
private class ContactManagerTest {
    //Test to create a new contact 
    @isTest static void testCreateContact() {
        //Call the method to test
        Id thisContactId = ContactManager.createContact('Test', 'Prénom', 'test@testcontact.com', '06060606');
        
        //Verify the test
        System.assert(thisContactId != null);
        Contact thisContact = [SELECT Id, Email, FirstName FROM Contact WHERE Id=:thisContactId];
        System.assert(thisContact != null);
        System.assertEquals('Prénom', thisContact.FirstName);
        System.assertEquals('test@testcontact.com', thisContact.Email);
    }
    // Test get a contact
     @isTest static void testGetContactById() {
        Id contactId = createTestContact();
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri = 'https://ocr3-dev-ed.my.salesforce.com/services/apexrest/Contacts/'+ contactId;
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        Contact thisContact = ContactManager.getContactById();
        // Verify results
        System.assert(thisContact != null);
        System.assertEquals('Prénom ContactTest', thisContact.Name );
    }
    //Test to update contact with info from AXG
    @isTest static void testUpdateContact() {
        //Create a record of contact to test
        Id thisContactId = createTestContact();
        //Instantiate request
        RestRequest request = new RestRequest();
        request.requestURI = 'https://ocr3-dev-ed.my.salesforce.com/services/apexrest/Contacts/'+thisContactId;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"email": "newemail@exemple.com"}');
        RestContext.request = request;
        //Update contact of existing contact
        Contact contactUpdate = ContactManager.updateContact();
        
        //Verify contact was update
        System.assert(contactUpdate != null);
        Contact thisContact = [SELECT Email FROM Contact WHERE Id=:thisContactId];
        System.assert(thisContact != null);
        System.assertEquals('newemail@exemple.com', thisContact.Email);
        
    }
   
    
    //Test to unactive contact after delete from AXG
    @isTest static void testDisableContact() {
        //Create a record of contact to test
        Id thisContactId = createTestContact();
        //Instantiate request
        RestRequest request = new RestRequest();
        request.requestURI = 'https://yourInstance.my.salesforce.com/services/apexrest/Contacts/'+thisContactId;
        request.httpMethod = 'GET';
        RestContext.request = request;
        //Disable contact
        ContactManager.disableContact();
        
        //Verify the contact is disable and NOT delete
        Contact thisContact = [SELECT Active__c FROM Contact WHERE Id=:thisContactId];
        System.assert(thisContact != null);
        System.assertEquals(false, thisContact.Active__c);
    }
    //Helper method
    static Id createTestContact() {
        Contact contact = new Contact(
            LastName = 'ContactTest',
            FirstName = 'Prénom',
            Email = 'emailTest@test.com',
            Phone = '060606060'
        );
        insert contact;
        return contact.Id;
    }    
}

 
   /** @isTest 
    static void testUpsertContact() { //ID upsertContact(String lastName, String firstName, String email, String phone, String id)
        // 1. Insert new record
        
        Id thisContactId = createTestContact();
        Id contact1Id = ContactManager.upsertContact('contactTest1','Prénom1', 'emailTest1@test.com', '060606005111', thisContactId);
        // Verify new record was created
        System.assert(Contact1Id != null);
        Contact contact1 = [SELECT Id ,Name FROM Contact WHERE Id=:contact1Id];
        System.assert(contact1 != null);
        System.assertEquals(contact1.Name, 'Prénom1 contactTest1');
        // 2. Update status of existing record to Working
        Id contact2Id = ContactManager.upsertContact('contactTest1','Prénom1', 'emailTest2@test.com', '060606005222', contact1Id);
        // Verify record was updated
        System.assertEquals(contact1Id, contact2Id);
       
        Contact contact2 = [SELECT Id,Email, Phone FROM Contact WHERE Id=:contact2Id];
        System.assert(contact2 != null);
        System.assertEquals(contact2.Email, 'emailtest2@test.com');
          System.assertEquals(contact2.Phone, '060606005222'); 
          
    } **/