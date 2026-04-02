@isTest
private class FCAScheduledBatchTest {
    static testMethod void testExecute() {
        Test.startTest();
        
        // Schedule the batch job
        String jobId = System.schedule('Test FCAScheduledBatch', 
                               '0 0 * * * ?', 
                               new FCAScheduledBatch()); // Scheduling to run test class
                                      
        // Ensure the job was scheduled
        System.assertNotEquals(null, jobId);
        
        Test.stopTest();
    }
}