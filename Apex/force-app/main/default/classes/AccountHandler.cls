public with sharing class AccountHandler {

    public static void insertAccount(Integer numAccounts) {

        List<Account> addAccounts = new List<Account>();
        for(Integer n = 0; n < numAccounts; n++) {
          Account newAcct = new Account(Name = 'Acme Inc' + n,
                                        AccountNumber = 'A000' + n);

           
        
              addAccounts.add(newAcct);                          
        }
            insert addAccounts;
            System.debug(addAccounts);
    }
}
