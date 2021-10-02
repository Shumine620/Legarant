@RestResource(urlMapping='/Contacts/*')
global with sharing class ContactManager {
    
    //Create contact 
    @HttpPost
    global static Id createContact(String lastName, String firstName, String email, String phone) {
        List<Contact> contacts = [SELECT Id FROM Contact WHERE Email=:email];
        if (contacts.size() != 0) {
            return contacts[0].Id;
        } else {
            Contact thisContact = new Contact();
            thisContact.LastName = lastName;
            thisContact.FirstName = firstName;
            thisContact.Email = email;
            thisContact.Phone = phone;
            
            insert thisContact;
            return thisContact.Id;
        }
    }
    
    @HttpGet
    global static Contact getContactById() {
        RestRequest request = RestContext.request;
        
        // grab the contactId from the end of the URL
        String contactId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Contact result =  [SELECT Id,Name,Email FROM Contact WHERE Id = :contactId];               
        return result;
        
    } 
    //Update contact from AXG
    @HttpPatch
    global static Contact updateContact() {
        RestRequest request = RestContext.request;
        String contactId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Contact thisContact = [SELECT Id FROM Contact WHERE Id = :contactId];
        // Deserialize the JSON string into name-value pairs
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        // Iterate through each parameter field and value
        for(String fieldName : params.keySet()) {
            // Set the field and value on the Contact sObject
            thisContact.put(fieldName, params.get(fieldName));
            
        }
        update thisContact;
        return thisContact;
    }
    
/**    @HttpPut
    global static ID upsertContact(String lastName, String firstName, String email, String phone, String id) {
        Contact thisContact = new Contact(
            Id = id,
            LastName = lastName,
            FirstName = firstName,
            Email = email,
            Phone = phone);
        // Match contact by Id, if present.
        // Otherwise, create new contact.
        upsert thisContact;
        // Return the contact ID.
        return thisContact.Id;
    }**/
    
    //Unactive contact in Salesforce
    @HttpDelete
    global static void disableContact() {
        RestRequest request = RestContext.request;
        String contactId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Contact thisContact = [SELECT Id, Active__c FROM Contact WHERE Id = :contactId];
        thisContact.Active__c = false;
        update thisContact;
    }
}