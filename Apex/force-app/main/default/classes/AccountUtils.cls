public with sharing class AccountUtils {

    public static List<Account> AccountsByState(String state) {
        List<Account> accountList = [SELECT Id, Name FROM Account WHERE BillingState =: state];
        System.debug(accountList);
       return accountList;
        

    }
}
