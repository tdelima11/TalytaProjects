global class FCABatches implements Database.Batchable<sObject>, Database.AllowsCallouts {

    global Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator([SELECT Id FROM Account WHERE FCA_firm_reference_number__c != null]);
    }

    global void execute(Database.BatchableContext context, List<Account> scope) {
        List<List<Account>> accountBatches = new List<List<Account>>();
        List<Account> currentBatch = new List<Account>();
        Integer batchSize = 20; // Adjust the batch size to process 10 records at a time

        for (Account acct : scope) {
            currentBatch.add(acct);

            if (currentBatch.size() == batchSize) {
                accountBatches.add(new List<Account>(currentBatch));
                currentBatch.clear();
            }
        }

        // Add any remaining records to the last batch
        if (!currentBatch.isEmpty()) {
            accountBatches.add(new List<Account>(currentBatch));
        }

        // Process each batch
        for (List<Account> batch : accountBatches) {
            List<String> acctIds = new List<String>();

            for (Account acct : batch) {
                acctIds.add(acct.Id);
            }

            FCAInformation.getFCAInformation(acctIds);
            FCAInformation.updateAccounts();
        }
    }

    global void finish(Database.BatchableContext context) {
        // Optional: Add any post-processing logic here

        
    }
}