@isTest
private class PropertyAddressIntegrationTest {

    @isTest
    static void testIntegration() {
        // Test data setup
        Geoapify_Integration__c geoapify = new Geoapify_Integration__c(URL__c = 'https://example.com/{Address}?key={Key}', API_Key__c = 'testAPIKey');
        insert geoapify;
        
        // Create a property record without specifying the Id field
        pba__Property__c property = new pba__Property__c(Name = '123 Test St, Test City', Comparable_Properties__c = ', 456 Example Ave, Example City, 123 Example Ave, Example City, 2345 Example Ave, Example City');
        
        // Create mock response
        Test.setMock(HttpCalloutMock.class, new PropertyAddressMockHttpResponse());
        
        // Call the trigger
        Test.startTest();
        insert property;
        Test.stopTest();
        
        // Verify if address fields are updated
        property = [SELECT Property_Name_Number__c, pba__Street_pb__c, pba__City_pb__c FROM pba__Property__c WHERE Name = '123 Test St, Test City'];
        System.assertEquals('123', property.Property_Name_Number__c);
        System.assertEquals('Test St', property.pba__Street_pb__c);
        System.assertEquals('Test City', property.pba__City_pb__c);
    }
}
