@isTest 
public class FCABatchesTest {
    private static FCA_Integration__c createTemporarySettings() {
        FCA_Integration__c temporarySettings = new FCA_Integration__c();
        temporarySettings.Name = 'Temporary Test Settings';
        temporarySettings.Email__c = 'temporary@example.com';
        temporarySettings.API_Key__c = '123456789456';
        temporarySettings.ActivitiesURL__c = 'https://register.fca.org.uk/services/V0.1/Firm/firmId/Permissions';
        temporarySettings.RegulatorURL__c = 'https://register.fca.org.uk/services/V0.1/Firm/firmId/Regulators';
        temporarySettings.RequirementsURL__c = 'https://register.fca.org.uk/services/V0.1/Firm/firmId/Requirements';
        temporarySettings.FirmDetailURL__c = 'https://register.fca.org.uk/services/V0.1/Firm/firmId';
        insert temporarySettings;
        return temporarySettings;
    }

    @isTest static void testBatchSync() {
        List<Account> accList = new List<Account>();
        
        for(Integer i = 0; i < 5; i++) {
            accList.add(new Account(Name = 'Test Account ' + i , Type = 'Prospect', FCA_firm_reference_number__c = 1234 + i));
        }
        
        insert accList;
        
        FCA_Integration__c temporarySettings = createTemporarySettings(); // Create temporary settings
        
        Test.setMock(HttpCalloutMock.class, new FCAHttpMockCallout());
        
        FCABatches bs = new FCABatches(); // Instantiate the batch class

        Test.startTest();
        database.executeBatch(bs, 200); // Execute the batch job
        Test.stopTest();

        // Clean up temporary settings
        delete temporarySettings;
    }
}