public class FCAEmailNotificationHandler {
    public static void sendNotification(List<Account> accountsWithChanges) {
        List<String> emailMessages = new List<String>();
        
        for (Account account : accountsWithChanges) {
            String emailBody = '<b><u>Changes in Account: </u></b>' + account.Name + ' (' + account.Id + '):'+ '<br/>'+ '<br/>';

            if (hasFieldChanged(account, 'FCA_Status_Site__c')) {
                emailBody += '<b><u>FCA Status Field:</u></b>'+ '<br/>';
                emailBody += '<b>Before: </b>' + Trigger.oldMap.get(account.Id).get('FCA_Status_Site__c') + '<br/>';
                emailBody += '<b>After: </b>' + account.get('FCA_Status_Site__c') + '<br/>'+ '<br/>';
            }

            if (hasFieldChanged(account, 'FCA_Status_Effective_Date__c')) {
                emailBody += '<b><u>FCA Status Effective Date:</u></b>'+ '<br/>';
                emailBody += '<b>Before: </b>' + Trigger.oldMap.get(account.Id).get('FCA_Status_Effective_Date__c') + '<br/>';
                emailBody += '<b>After: </b>' + account.get('FCA_Status_Effective_Date__c') + '<br/>'+ '<br/>';
            }
            
            if (hasFieldChanged(account, 'FCA_Regulator__c')) {
                emailBody += '<b><u>Regulator Field:</u></b>'+ '<br/>';
                emailBody += '<b>Before: </b>' + Trigger.oldMap.get(account.Id).get('FCA_Regulator__c') + '<br/>';
                emailBody += '<b>After: </b>' + account.FCA_Regulator__c + '<br/>'+ '<br/>';
            }

            if (hasFieldChanged(account, 'FCA_Restrictions__c')) {
                emailBody += '<b><u>Requirements Field:</u></b>'+ '<br/>';
                emailBody += '<b>Before: </b>' + Trigger.oldMap.get(account.Id).get('FCA_Restrictions__c') + '<br/>';
                emailBody += '<b>After: </b>' + account.FCA_Restrictions__c + + '<br/>'+ '<br/>';
            }

            if (hasFieldChanged(account, 'FCA_Activities_and_Services__c')) {
                emailBody += '<b><u>Activities and Services Field:</u></b>'+ '<br/>';
                emailBody += '<b>Before: </b>' + Trigger.oldMap.get(account.Id).get('FCA_Activities_and_Services__c') + '<br/>';
                emailBody += '<b>After: </b>' + account.FCA_Activities_and_Services__c + + '<br/>'+ '<br/>';
            }

            
            
            emailMessages.add(emailBody);
        }
        
        if (!emailMessages.isEmpty()) {
            List<FCA_Email_Recipient__mdt> mtdaEmails = [SELECT Recipient_Email__c FROM FCA_Email_Recipient__mdt];
            List<String> emailList = new List<String>();

            for(FCA_Email_Recipient__mdt email:mtdaEmails) {
                emailList.add(email.Recipient_Email__c);
            }
            
            String emailSubject = 'Alert of FCA Information Change';
            String emailBody = String.join(emailMessages, '\n\n'); // Join all email messages
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setSubject(emailSubject);
            email.setHTMLBody(emailBody);
            email.setToAddresses(emailList); // Replace with recipient email
            
            // Send the email notification
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
        }
    }
    
    private static Boolean hasFieldChanged(Account account, String fieldName) {
        return account.get(fieldName) != Trigger.oldMap.get(account.Id).get(fieldName);
    }
}