public class FCAFirmDetailWrapper {

	public String Status {get;set;} 
	public ResultInfo ResultInfo {get;set;} 
	public String Message {get;set;} 
	public List<Data> Data {get;set;} 

	public FCAFirmDetailWrapper(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'Status') {
						Status = parser.getText();
					} else if (text == 'ResultInfo') {
						ResultInfo = new ResultInfo(parser);
					} else if (text == 'Message') {
						Message = parser.getText();
					} else if (text == 'Data') {
						Data = arrayOfData(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'FirmDetailWrapper consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Data {
		public String name {get;set;} 
		public String individuals {get;set;} 
		public String requirements {get;set;} 
		public String permission {get;set;} 
		public String passport {get;set;} 
		public String regulators {get;set;} 
		public String appointedRepresentative {get;set;} 
		public String address {get;set;} 
		public String waivers {get;set;} 
		public String exclusions {get;set;} 
		public String disciplinaryHistory {get;set;} 
		public String systemTimestamp {get;set;} 
		public String exceptionalInfoTitle {get;set;} 
		public String exceptionalInfoBody {get;set;} 
		public String statusEffectiveDate {get;set;} 
		public String e_MoneyAgentStatus {get;set;} // in json: E-Money Agent Status
		public String psd_emdEffectiveDate {get;set;} 
		public String clientMoneyPermission {get;set;} 
		public String subStatusEffectiveFrom {get;set;} 
		public String sub_Status {get;set;} // in json: Sub-Status
		public String mutualSocietyNumber {get;set;} 
		public String companiesHouseNumber {get;set;} 
		public String mlrsStatusEffectiveDate {get;set;} 
		public String mlrsStatus {get;set;} 
		public String e_MoneyAgentEffectiveDate {get;set;} // in json: E-Money Agent Effective Date
		public String psdAgentEffectivedate {get;set;} 
		public String psdAgentStatus {get;set;} 
		public String psd_emdStatus {get;set;} 
		public String status {get;set;} 
		public String businessType {get;set;} 
		public String organisationName {get;set;} 
		public String FRN {get;set;} 

		public Data(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Name') {
							name = parser.getText();
						} else if (text == 'Individuals') {
							individuals = parser.getText();
						} else if (text == 'Requirements') {
							requirements = parser.getText();
						} else if (text == 'Permission') {
							permission = parser.getText();
						} else if (text == 'Passport') {
							passport = parser.getText();
						} else if (text == 'Regulators') {
							regulators = parser.getText();
						} else if (text == 'Appointed Representative') {
							appointedRepresentative = parser.getText();
						} else if (text == 'Address') {
							address = parser.getText();
						} else if (text == 'Waivers') {
							waivers = parser.getText();
						} else if (text == 'Exclusions') {
							exclusions = parser.getText();
						} else if (text == 'DisciplinaryHistory') {
							disciplinaryHistory = parser.getText();
						} else if (text == 'System Timestamp') {
							systemTimestamp = parser.getText();
						} else if (text == 'Exceptional Info Title') {
							exceptionalInfoTitle = parser.getText();
						} else if (text == 'Exceptional Info Body') {
							exceptionalInfoBody = parser.getText();
						} else if (text == 'Status Effective Date') {
							statusEffectiveDate = parser.getText();
						} else if (text == 'E-Money Agent Status') {
							e_MoneyAgentStatus = parser.getText();
						} else if (text == 'PSD / EMD Effective Date') {
							psd_emdEffectiveDate = parser.getText();
						} else if (text == 'Client Money Permission') {
							clientMoneyPermission = parser.getText();
						} else if (text == 'Sub Status Effective from') {
							subStatusEffectiveFrom = parser.getText();
						} else if (text == 'Sub-Status') {
							sub_Status = parser.getText();
						} else if (text == 'Mutual Society Number') {
							mutualSocietyNumber = parser.getText();
						} else if (text == 'Companies House Number') {
							companiesHouseNumber = parser.getText();
						} else if (text == 'MLRs Status Effective Date') {
							mlrsStatusEffectiveDate = parser.getText();
						} else if (text == 'MLRs Status') {
							mlrsStatus = parser.getText();
						} else if (text == 'E-Money Agent Effective Date') {
							e_MoneyAgentEffectiveDate = parser.getText();
						} else if (text == 'PSD Agent Effective date') {
							psdAgentEffectivedate = parser.getText();
						} else if (text == 'PSD Agent Status') {
							psdAgentStatus = parser.getText();
						} else if (text == 'PSD / EMD Status') {
							psd_emdStatus = parser.getText();
						} else if (text == 'Status') {
							status = parser.getText();
						} else if (text == 'Business Type') {
							businessType = parser.getText();
						} else if (text == 'Organisation Name') {
							organisationName = parser.getText();
						} else if (text == 'FRN') {
							FRN = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Data consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class ResultInfo {
		public String page {get;set;} 
		public String per_page {get;set;} 
		public String total_count {get;set;} 

		public ResultInfo(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'page') {
							page = parser.getText();
						} else if (text == 'per_page') {
							per_page = parser.getText();
						} else if (text == 'total_count') {
							total_count = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'ResultInfo consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static FCAFirmDetailWrapper parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new FCAFirmDetailWrapper(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
	



    private static List<Data> arrayOfData(System.JSONParser p) {
        List<Data> res = new List<Data>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Data(p));
        }
        return res;
    }



}