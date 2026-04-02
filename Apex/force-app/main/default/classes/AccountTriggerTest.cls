@isTest
public with sharing class AccountTriggerTest {
    @isTest
    public static void TestAccountTrigger() {
        List<Account> acctList = new List<Account>();
        for(Integer i = 0; i < 200; i++ ) {
            Account acc = new Account();
            acc.Name = 'AccountTest' + i;
            acc.BillingState = 'CA';

            acctList.add(acc);
        }
        Test.startTest();
        insert acctList;
        Test.stopTest();

        List<Account> verifyList = [SELECT Id, Name, BillingState, ShippingState FROM Account];
            System.assertEquals(200, verifyList.size());
            for(Account acc:verifyList) {
                System.assertEquals('CA',acc.ShippingState,'Error!');
            }

            



            

    }
}
