public class FCAInformation {

    public class AccountInfo {
        public Id acctId { get; set; }
        public String formattedActivities { get; set; }
        public String formattedRegulators { get; set; }
        public String formattedRequirements {get; set; }
        public FCAFirmDetailWrapper wrapper {get; set;}

        public AccountInfo(Id acctId, String formattedActivities, String formattedRegulators, String formattedRequirements, FCAFirmDetailWrapper wrapper) {
            this.acctId = acctId;
            this.formattedActivities = formattedActivities;
            this.formattedRegulators = formattedRegulators;
            this.formattedRequirements = formattedRequirements;
            this.wrapper = wrapper;
        }
    }

    // Define accountsInfo as a class-level variable
    public static List<AccountInfo> accountsInfo = new List<AccountInfo>();

    public static void getFCAInformation(List<String> acctIds) {
        // Retrieve FCA Firm IDs for all provided account IDs in a bulkified way
        Map<String, String> acctToFirmIds = getFirmIds(acctIds);
        FCA_Integration__c	 FCAIntegrationCS = FCA_Integration__c.getOrgDefaults();
        String firmIdText = 'firmId';

        // Make HTTP requests for each FCA Firm ID
        for (String acctId : acctIds) {
            String firmId = acctToFirmIds.get(acctId);
            System.debug('Account ID: ' + acctId + ', Firm ID: ' + firmId);

            if (firmId != null) {
                AccountInfo info = new AccountInfo(acctId, null, null, null, null);

                // Retrieve Permissions
                String activitiesEndpoint = FCAIntegrationCS.ActivitiesURL__c.replace(firmIdText, firmId);
                HttpResponse activitiesResponse = makeHttpRequest(activitiesEndpoint);

                if (activitiesResponse.getStatusCode() == 200) {
                    String jsonResponse = activitiesResponse.getBody();
                    System.debug('JSON Response (Activities): ' + jsonResponse);

                    String activitiesString = extractDataFromJson(jsonResponse);
                    String formattedActivities = cleanAndFormatDataString(activitiesString);

                    if (formattedActivities != null) {
                        info.formattedActivities = formattedActivities;
                    }
                }

                // Retrieve Regulators
                String regulatorEndpoint = FCAIntegrationCS.RegulatorURL__c.replace(firmIdText, firmId);
                HttpResponse regulatorResponse = makeHttpRequest(regulatorEndpoint);

                if (regulatorResponse.getStatusCode() == 200) {
                    String jsonResponse = regulatorResponse.getBody();
                    System.debug('JSON Response (Regulators): ' + jsonResponse);

                    String regulatorString = extractDataFromJson(jsonResponse);
                    String formattedRegulators = cleanAndFormatDataString(regulatorString);

                    if (formattedRegulators != null) {
                        info.formattedRegulators = formattedRegulators;
                    }
                }

                  // Retrieve Requirements
                String requirementsEndpoint = FCAIntegrationCS.RequirementsURL__c.replace(firmIdText, firmId);
                HttpResponse requirementsResponse = makeHttpRequest(requirementsEndpoint);

                if (requirementsResponse.getStatusCode() == 200) {
                    String jsonResponse = requirementsResponse.getBody();
                    System.debug('JSON Response (Requirements/Restrictions): ' + jsonResponse);

                    String requirementsString = extractDataFromJson(jsonResponse);
                    String formattedRequirements = cleanAndFormatDataString(requirementsString);

                    if (formattedRequirements != null) {
                        info.formattedRequirements = formattedRequirements;
                    }
                }
                
                  // Retrieve FirmDetails
                String firmDetailEndpoint = FCAIntegrationCS.FirmDetailURL__c.replace(firmIdText, firmId);

                HttpResponse firmDetailResponse = makeHttpRequest(firmDetailEndpoint);

                if (firmDetailResponse.getStatusCode() == 200) {
                    String jsonResponse = firmDetailResponse.getBody();
                    System.debug('JSON Response (FirmDetails): ' + jsonResponse);
                    info.wrapper = FCAFirmDetailWrapper.parse(jsonResponse);
                }

                accountsInfo.add(info);
            }
        }
    }

    public static void updateAccounts() {
        // Process the accountsInfo list
        List<Account> accountsToUpdate = new List<Account>();
        for (AccountInfo info : accountsInfo) {
            Account acct = new Account(Id = info.acctId);
            acct.FCA_Activities_and_Services__c = info.formattedActivities;
            acct.FCA_Regulator__c = info.formattedRegulators;
            acct.FCA_Restrictions__c = info.formattedRequirements;

            if(info.wrapper != null && info.wrapper.Data != null && !info.wrapper.Data.isEmpty()) {
                FCAFirmDetailWrapper.Data data = info.wrapper.Data[0];
                acct.FCA_Business_Type__c = data.businessType;
                acct.FCA_Client_Money_Permission__c = data.clientMoneyPermission;
                acct.FCA_Companies_House_Number__c = data.companiesHouseNumber;
                acct.FCA_E_Money_Agent_Effective_Date__c = data.e_MoneyAgentEffectiveDate;
                acct.FCA_E_Money_Agent_Status__c = data.e_MoneyAgentStatus;
                acct.FCA_Exceptional_Info_Body__c = data.exceptionalInfoBody;
                acct.FCA_Exceptional_Info_Title__c = data.exceptionalInfoTitle;
                acct.FCA_FRN__c = data.FRN;
                acct.FCA_MLRs_Status__c = data.MLRsStatus;
                acct.FCA_MLRs_Status_Effective_Date__c = data.mlrsStatusEffectiveDate;
                acct.FCA_Mutal_Society_Number__c = data.mutualSocietyNumber;
                acct.FCA_Organisation_Name__c = data.organisationName;
                acct.FCA_PSD_Agent_Effective_Date__c = data.psdAgentEffectivedate;
                acct.FCA_PSD_Agent_Status__c = data.psdAgentStatus;
                acct.FCA_PSD_EMD_Effective_Date__c = data.psd_emdEffectiveDate;
                acct.FCA_PSD_EMD_Status__c = data.psd_emdStatus;
                acct.FCA_Status_Site__c = data.status;
                acct.FCA_Status_Effective_Date__c = data.statusEffectiveDate;
                acct.FCA_Sub_Status_Effective_from__c = data.subStatusEffectiveFrom;
                acct.FCA_Sub_Status__c = data.sub_Status;
                acct.FCA_System_Time_Stamp__c = data.systemTimestamp;
            }

            accountsToUpdate.add(acct);
        }

        // Perform a single update operation for all accumulated accounts
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }


    public static HttpResponse makeHttpRequest(String endpoint) {
        FCA_Integration__c	 FCAIntegrationCS = FCA_Integration__c.getOrgDefaults();

        Http h = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        request.setHeader('X-Auth-Email', FCAIntegrationCS.Email__c);
        request.setHeader('X-Auth-Key', FCAIntegrationCS.API_Key__c);
        request.setHeader('content-type', 'application/json');
        
        // Send the HTTP request
        return h.send(request);
    }

    public static Map<String, String> getFirmIds(List<String> acctIds) {
        Map<String, String> acctToFirmIds = new Map<String, String>();

        // Query for FCA Firm IDs for all provided account IDs in bulk
        List<Account> acctInformation = [SELECT Id, FCA_firm_reference_number__c FROM Account WHERE Id IN :acctIds];
        for (Account acct : acctInformation) {
            acctToFirmIds.put(acct.Id, String.valueOf(acct.FCA_firm_reference_number__c));
        }

        return acctToFirmIds;
    }

    public static String extractDataFromJson(String jsonString) {
        // Parse the JSON string
        Map<String, Object> parsedData = (Map<String, Object>) JSON.deserializeUntyped(jsonString);

        // Check if the "Data" field exists
        if (parsedData.containsKey('Data')) {
            Object data = parsedData.get('Data');

            // Serialize the "Data" field back to a JSON string
            String dataJson = JSON.serialize(data);

            return dataJson;
        }

        return null; // Return null if "Data" field is not found
    }

    public static String cleanAndFormatDataString(String dataString) {
        // Replace double quotes, parentheses, brackets, and curly braces with empty strings
        String cleanedString = dataString.replaceAll('[()"\\[\\]{}]', '');

        // Replace commas with line breaks
        cleanedString = cleanedString.replaceAll(',', '\n');

        return cleanedString;
    }
}