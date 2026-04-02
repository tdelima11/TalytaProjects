public class FCAAccountChangeHandler {
    public static void compareAndNotify(List<Account> newAccounts, Map<Id, Account> oldAccountMap) {
        List<Account> changedAccounts = new List<Account>();
        
        for (Account newAccount : newAccounts) {
            Account oldAccount = oldAccountMap.get(newAccount.Id);
            
            if (oldAccount != null) {
                if (hasFieldChanged(newAccount, oldAccount, 'FCA_Regulator__c') ||
                    hasFieldChanged(newAccount, oldAccount, 'FCA_Restrictions__c') ||
                    hasFieldChanged(newAccount, oldAccount, 'FCA_Activities_and_Services__c') ||
                    hasFieldChanged(newAccount, oldAccount, 'FCA_Status_Effective_Date__c') ||
                    hasFieldChanged(newAccount, oldAccount, 'FCA_Status_Site__c')) {
                    changedAccounts.add(newAccount);
                }
            }
        }
        
        if (!changedAccounts.isEmpty()) {
            FCAEmailNotificationHandler.sendNotification(changedAccounts);
        }
    }
    
    @TestVisible
    private static Boolean hasFieldChanged(Account newAccount, Account oldAccount, String fieldName) {
        return newAccount.get(fieldName) != oldAccount.get(fieldName);
    }
}