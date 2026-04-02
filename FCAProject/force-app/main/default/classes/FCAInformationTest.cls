@isTest
private class FCAInformationTest {

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

    @isTest
    static void testFCAInformation() {
        // Create a test Account and insert it
        Account testAccount = new Account(
            Name = 'Test Account',
            FCA_firm_reference_number__c = 12345
        );
        insert testAccount;

        // Create temporary custom settings for the test
        FCA_Integration__c temporarySettings = createTemporarySettings();

        // Add the account's ID to a list
        List<String> acctIds = new List<String>{testAccount.Id};

        // Set up a mock HTTP response
        Test.setMock(HttpCalloutMock.class, new FCAHttpMockCallout());

        // Call the method to be tested
        Test.startTest();
        FCAInformation.getFCAInformation(acctIds);
        FCAInformation.updateAccounts();
        Test.stopTest();

        // Check if the data is updated correctly
        Account updatedAccount = [SELECT FCA_Activities_and_Services__c, FCA_Regulator__c, FCA_Restrictions__c FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals('Acting as a CBTL lender:Acting as a CBTL lender:1', updatedAccount.FCA_Activities_and_Services__c);
        System.assertEquals('Regulator Name:Financial Services Authority', updatedAccount.FCA_Regulator__c);
        System.assertEquals('Not permitted to canvass off trade premises:The firm is not permitted to canvass regulated borrower-lender-supplier agreements or regulated consumer hire agreements off trade premises', updatedAccount.FCA_Restrictions__c);

        // Clean up temporary settings
        delete temporarySettings;
    }

  

}