@isTest
global class FCAHttpMockCallout implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest request) {
        // Create a response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        
        // Parse the endpoint to determine the type of response
        String endpoint = request.getEndpoint();
        
        if (endpoint.contains('Permissions')) {
            response.setBody('{"Status": "FSR-API-02-03-00","ResultInfo":{"page": "1","per_page":"20","total_count":"15"},"Message":"Ok.Firm permission found","Data": {"Acting as a CBTL lender": [{"Acting as a CBTL lender":["1"]}]}}');
            response.setStatusCode(200);
        } else if (endpoint.contains('Regulators')) {
            response.setBody('{"Status": "FSR-API-02-09-00","ResultInfo": {"page": "1","per_page": "10","total_count": "3"},"Message": "Ok. Firm Regulator found","Data": [{"Regulator Name": "Financial Services Authority"}]}');
            response.setStatusCode(200);
        } else if (endpoint.contains('Requirements')) {
            response.setBody('{"Status": "FSR-API-02-06-00","ResultInfo": {"page": "1","per_page": "1","total_count": "1"},"Message": "Ok. Firm Requirements found","Data": [{"Not permitted to canvass off trade premises": "The firm is not permitted to canvass regulated borrower-lender-supplier agreements or regulated consumer hire agreements off trade premises"}]}');
            response.setStatusCode(200);
        } else {
            response.setBody('{"Status": "Active","ResultInfo":{"page":"1","per_page":"10","total_count":"100"},"Message":"Success","Data":[{"Name":"Company A","Individuals":"John Doe","Requirements":"Yes","Permission":"Granted","Passport":"12345","Regulators":"Regulator 1","Appointed Representative":"Yes","Address":"123 Main St","Waivers":"None","Exclusions":"None","DisciplinaryHistory":"None","System Timestamp":"2023-10-10","Exceptional Info Title":"Info Title","Exceptional Info Body":"Info Body","Status Effective Date":"2023-01-01","E-Money Agent Status":"Active","PSD / EMD Effective Date":"2023-02-01","Client Money Permission":"Yes","Sub Status Effective from":"2023-03-01","Sub-Status":"Active","Mutual Society Number":"M123","Companies House Number":"C123","MLRs Status Effective Date":"2023-04-01","MLRs Status":"Approved","E-Money Agent Effective Date":"2023-05-01","PSD Agent Effective date":"2023-06-01","PSD Agent Status":"Active","PSD / EMD Status":"Approved","Status":"Active","Business Type":"Type A","Organisation Name":"Org A","FRN":"FRN123"}]}');
            response.setStatusCode(200);
        }
        
        return response;
    }
}