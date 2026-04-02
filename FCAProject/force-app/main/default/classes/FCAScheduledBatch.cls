global class FCAScheduledBatch implements Schedulable {
    global void execute(SchedulableContext ctx) {
        FCABatches batchJob = new FCABatches();
        Database.executeBatch(batchJob, 20); // 20 is the scope size for each batch
    }
}