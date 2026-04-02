public class ObjectHandler {

    // Inner class to store attachment records for various objects
    public class AttachmentRecords {
        public Map<String, List<ContentDocumentLink>> ObjectAttachments { get; set; }
        
        // Constructor to initialize the map
        public AttachmentRecords(Map<String, List<ContentDocumentLink>> ObjectAttachments) {
            this.ObjectAttachments = ObjectAttachments;
        }
    }

    @InvocableMethod(label='Download Attachment' description='Download Attachment')
    public static void ObjectHandlerMethod(List<String> Objectlist) {
        // Split the input string into a list of objects
        List<String> objects = Objectlist[0].split(',');

        // Define a map to store attachments for each object
        Map<String, List<ContentDocumentLink>> attachmentsMap = new Map<String, List<ContentDocumentLink>>();

        // Iterate over the objects and dynamically query for attachments
        for (String objectName : objects) {
            String query = 'SELECT ContentDocument.Title, ContentDocumentId, ContentDocument.FileExtension, ' +
                           'LinkedEntity.Name, LinkedEntityId ' +
                           'FROM ContentDocumentLink ' +
                           'WHERE LinkedEntityId IN (SELECT Id FROM ' + objectName + ')';

            try {
                // Execute the SOQL query dynamically
                List<ContentDocumentLink> results = Database.query(query);
                // Store the results in the map using the object name as the key
                attachmentsMap.put(objectName, results);
            } catch (Exception e) {
                System.debug('Error querying for object: ' + objectName + ' - ' + e.getMessage());
            }
        }

        // Send the attachments map to the Excel generator and email sender
        ExcelAndEmailService.generateAndSendEmail(attachmentsMap);
    }
}

