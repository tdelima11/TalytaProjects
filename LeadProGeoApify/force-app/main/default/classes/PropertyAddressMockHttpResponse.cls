@isTest
public class PropertyAddressMockHttpResponse implements HttpCalloutMock {
    // Implement the respond method
    public HTTPResponse respond(HTTPRequest req) {
        // Create a new HTTPResponse object
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);
        // Sample JSON response for testing purposes
        String jsonResponse = '{' +
            '"query": {' +
                '"parsed": {' +
                    '"housenumber": "123",' +
                    '"street": "Test St",' +
                    '"postcode": "12345",' +
                    '"city": "Test City"' +
                '}' +
            '}' +
        '}';
        res.setBody(jsonResponse);
        return res;
    }
}
