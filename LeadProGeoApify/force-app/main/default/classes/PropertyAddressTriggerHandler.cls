public with sharing class PropertyAddressTriggerHandler {

    public static void manageProperties(List<pba__Property__c> propertyRecords) {
        for (pba__Property__c property : propertyRecords) {
            String propertyAddress = property.Name;
            String propertyAddressUpdated = propertyAddress;
            String propertyId = String.valueOf(property.Id); // Initialize with the original address

            // List to hold comparable property values

            if (property.Comparable_Properties__c != null && property.Name != null) {
                String commonWord = findCommonWord(property.Comparable_Properties__c);
                propertyAddressUpdated += ' ' + commonWord;
                PropertyAddressHelper.httpCallout(propertyAddressUpdated, propertyId);

            } else if(property.Name != null){
                PropertyAddressHelper.httpCallout(propertyAddress, propertyId);

            }else{
                System.debug('Title Not Found');
            }

            

            System.debug('Updated Address: ' + propertyAddressUpdated + ', Property ID: ' + propertyId);
        }
    }

    // Helper method to find common word
   // Helper method to find common word
    public static String findCommonWord(String comparableProperties) {
        Map<String, Integer> wordCounts = new Map<String, Integer>();
        List<String> words = new List<String>();
        for (String address : comparableProperties.split(',')) {
            for (String word : address.split('\\s+')) {
                word = word.trim().toLowerCase(); // Convert to lowercase if case-sensitivity does not matter
                if (word.length() > 3) { // Exclude short words like "and", "the", etc.
                    Integer wordCount = wordCounts.get(word);
                    if (wordCount == null) {
                        wordCount = 0;
                    }
                    wordCounts.put(word, wordCount + 1);
                }
                System.debug('Processing word: ' + word); // Debug line to print each word being processed
            }
        }

        // Debug: Output the word counts
        System.debug('Word counts: ' + wordCounts);

        // Find the most common word
        Integer maxCount = 0;
        String commonWord = '';
        for (String word : wordCounts.keySet()) {
            Integer count = wordCounts.get(word);
            if (count > maxCount) {
                maxCount = count;
                commonWord = word;
            }
        }

        return commonWord;
    }

}
