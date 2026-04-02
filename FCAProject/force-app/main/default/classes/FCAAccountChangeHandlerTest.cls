@isTest
public class FCAAccountChangeHandlerTest {

    @isTest
    static void testAccountChangeHandlerRegulator() {
        // Create test data - insert test accounts
            Account testAcct = new Account();
            testAcct.Name = 'Test Account ';
            testAcct.FCA_Regulator__c = 'Regulator 1';
            testAcct.FCA_Restrictions__c = 'Requirement 1';
            testAcct.FCA_Activities_and_Services__c = 'Permission 1';
            testAcct.FCA_Status_Effective_Date__c = '01/01/2023';
            testAcct.FCA_Status_Site__c = 'Status 1';
            
        
        insert testAcct;

        // Modify some of the test accounts to simulate changes
        
        Test.startTest();
        testAcct.FCA_Regulator__c = 'Regulator 2';
        update testAcct;
        
       
        testAcct.FCA_Restrictions__c = 'Requirement 2';
        update testAcct;
       

   
        testAcct.FCA_Activities_and_Services__c = 'Permission 2';
        update testAcct;
       

      
        testAcct.FCA_Status_Effective_Date__c = '02/02/2023';
        update testAcct;
        

   
        testAcct.FCA_Status_Site__c = 'Status 2';
        update testAcct;
        Test.stopTest();
        
    }
    
}