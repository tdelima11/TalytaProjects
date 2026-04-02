public class ExcelAndEmailService {

    // Generate and send email with attachments
    public static void generateAndSendEmail(Map<String, List<ContentDocumentLink>> attachmentsMap) {
        List<Messaging.EmailFileAttachment> emailAttachments = new List<Messaging.EmailFileAttachment>();

        // Get today's date in the desired format
        Date currentDate = Date.today();
        String DateToday = String.valueOf(currentDate.day()).padLeft(2, '0') + '-' +
                           String.valueOf(currentDate.month()).padLeft(2, '0') + '-' +
                           String.valueOf(currentDate.year());

        for (String objectName : attachmentsMap.keySet()) {
            // Generate an Excel file for each object and get it as a Blob
            Blob excelBlob = generateExcelForAttachments(objectName, attachmentsMap.get(objectName));

            // Create an email attachment
            Messaging.EmailFileAttachment emailAttachment = new Messaging.EmailFileAttachment();
            emailAttachment.setFileName(objectName + '_Attachments_' + DateToday + '.xlsx');
            emailAttachment.setBody(excelBlob);
            emailAttachment.setContentType('application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');

            // Add to the list of email attachments
            emailAttachments.add(emailAttachment);
        }

        // Ensure emailAttachments is not empty before attempting to send an email
        if (emailAttachments.isEmpty()) {
            System.debug('No attachments to send. Email will not be sent.');
            return;
        }

        sendEmailWithAttachments(emailAttachments);
    }

    // Generate an Excel file (as CSV) for a specific object and its attachments
    private static Blob generateExcelForAttachments(String objectName, List<ContentDocumentLink> attachments) {
        // Initialize CSV content with headers
        String csvContent = 'Title,ContentDocumentId,FileExtension,LinkedEntityName,LinkedEntityId\n';
        for (ContentDocumentLink attachment : attachments) {
            csvContent += String.format(
                '{0},{1},{2},{3},{4}\n',
                new String[] {
                    attachment.ContentDocument.Title,
                    attachment.ContentDocumentId,
                    attachment.ContentDocument.FileExtension,
                    attachment.LinkedEntity.Name,
                    attachment.LinkedEntityId
                }
            );
        }

        // Debug the generated CSV content
        System.debug('Generated CSV Content for ' + objectName + ':\n' + csvContent);

        // Convert the CSV content to Blob
        return Blob.valueOf(csvContent);
    }

    // Send email with the generated attachments
    private static void sendEmailWithAttachments(List<Messaging.EmailFileAttachment> emailAttachments) {
        // Create email message
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new List<String>{'your.real.email@example.com'}); // Replace with actual recipient
        email.setSubject('Attachment Reports');
        email.setPlainTextBody('Please find attached the reports for the queried objects.');

        // Attach the files
        email.setFileAttachments(emailAttachments);

        // Log the number of attachments and their sizes
        Integer totalSize = 0;
        for (Messaging.EmailFileAttachment attachment : emailAttachments) {
            totalSize += attachment.getBody().size();
        }
        System.debug('Total attachment size: ' + totalSize + ' bytes. Sending email.');

        // Send the email
        Messaging.SendEmailResult[] results = Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{email});

        // Debug email sending results
        for (Messaging.SendEmailResult result : results) {
            if (result.isSuccess()) {
                System.debug('Email sent successfully.');
            } else {
                System.debug('Email send failed: ' + result.getErrors()[0].getMessage());
            }
        }
    }
}
