public with sharing class PropertyAddressHelper {

    @future(callout=true)
    public static void httpCallout(String address, String propertyId) {
        Geoapify_Integration__c geoapify = Geoapify_Integration__c.getOrgDefaults();
    
        //String transformedAddress = PropertyAddressTriggerHandler.addressTransformer(address);

        String geoapifyEndpoint = geoapify.URL__c.replace('{Address}', address);
        String endpoint = geoapifyEndpoint.replace('{Key}', geoapify.API_Key__c);
        String filteredEndpoint;

        if(!String.IsBlank(geoapify.Country_Filter__c)) {
            filteredEndpoint = endpoint.replace('{CountryCode}', geoapify.Country_Filter__c);
        }else{
            filteredEndpoint = endpoint.replace('{CountryCode}', 'none');
        }
            
        
        System.debug('GeoapifyEndpoint: ' + geoapifyEndpoint);
        System.debug('Endpoint: ' + endpoint);
        System.debug('Filtered Endpoint: ' + filteredEndpoint);

        Http h = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(filteredEndpoint);
        request.setMethod('GET');
        request.setHeader('content-type', 'application/json');
        
        // Send the HTTP request
        HttpResponse response = h.send(request);
        System.debug('Response: ' + response);
    
        // Check the status code of the response
        if (response.getStatusCode() == 200) {
            // If the response is successful, parse the JSON
            String jsonResponse = response.getBody();
            System.debug('Json Response: ' + jsonResponse);
            
            // Parse the JSON response and get relevant values
            Map<String, String> parsedValues = parseJsonResponse(jsonResponse);
            
            // Update the fields of the property record
            updatePropertyFields(parsedValues, propertyId);
            
        } else {
            // Handle non-200 status code, if needed
            System.debug('HTTP Callout failed with status code: ' + response.getStatusCode());
        }
    }
       

    // Helper method to parse JSON response and return relevant values
    public static Map<String, String> parseJsonResponse(String jsonResponse) {
        Map<String, String> parsedValues = new Map<String, String>();
        
        // Deserialize the JSON response
        Map<String, Object> parsedResponse = (Map<String, Object>) JSON.deserializeUntyped(jsonResponse);
        
        // Access the query section
        Map<String, Object> query = (Map<String, Object>) parsedResponse.get('query');
        if (query != null) {
            // Access the parsed section of the query
            Map<String, Object> parsed = (Map<String, Object>) query.get('parsed');
            if (parsed != null) {
                if (parsed.containsKey('housenumber')) {
                    parsedValues.put('Property_Name_Number__c', capitalizeFirstLetter((String) parsed.get('housenumber')));
                }
                if (parsed.containsKey('street')) {
                    parsedValues.put('pba__Street_pb__c', capitalizeFirstLetter((String) parsed.get('street')));
                }
                if (parsed.containsKey('city')) {
                    parsedValues.put('pba__City_pb__c', capitalizeFirstLetter((String) parsed.get('city')));
                }
            }
             else {
                System.debug('Parsed section is missing in the JSON response.');
            }
        } else {
            System.debug('Query section is missing in the JSON response.');
        }
        
        return parsedValues;
    }
    
    // Function to capitalize the first letter of each word
    public static String capitalizeFirstLetter(String input) {
        List<String> words = input.split(' ');
        for (Integer i = 0; i < words.size(); i++) {
            words[i] = words[i].capitalize();
        }
        return String.join(words, ' ');
    }
  
    // Helper method to update the fields of pba__Property__c record
    public static void updatePropertyFields(Map<String, String> fieldValues, String propertyId) {
        pba__Property__c property = new pba__Property__c(Id = propertyId);
        
        // Update fields with values from the map if they exist
        if (fieldValues.containsKey('Property_Name_Number__c')) {
            property.Property_Name_Number__c = fieldValues.get('Property_Name_Number__c');
            System.debug('Property Number = ' + property.Property_Name_Number__c);
        }
        if (fieldValues.containsKey('pba__Street_pb__c')) {
            property.pba__Street_pb__c = fieldValues.get('pba__Street_pb__c');
            System.debug('Property Street = ' + property.pba__Street_pb__c);
        }
        if (fieldValues.containsKey('pba__City_pb__c')) {
            property.pba__City_pb__c = fieldValues.get('pba__City_pb__c');
            System.debug('Property City = ' + property.pba__City_pb__c);
        }
        // Update other fields as needed
        
        // Update the record
        update property;
    }
    
}
