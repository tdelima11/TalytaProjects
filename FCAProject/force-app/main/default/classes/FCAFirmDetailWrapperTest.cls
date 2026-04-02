@isTest
public class FCAFirmDetailWrapperTest {

    @isTest
    public static void testParse() {
        // Sample JSON data for testing
        String json = '{"Status":"Active","ResultInfo":{"page":"1","per_page":"10","total_count":"100"},"Message":"Success","Data":[{"Name":"Company A","Individuals":"John Doe","Requirements":"Yes","Permission":"Granted","Passport":"12345","Regulators":"Regulator 1","Appointed Representative":"Yes","Address":"123 Main St","Waivers":"None","Exclusions":"None","DisciplinaryHistory":"None","System Timestamp":"2023-10-10","Exceptional Info Title":"Info Title","Exceptional Info Body":"Info Body","Status Effective Date":"2023-01-01","E-Money Agent Status":"Active","PSD / EMD Effective Date":"2023-02-01","Client Money Permission":"Yes","Sub Status Effective from":"2023-03-01","Sub-Status":"Active","Mutual Society Number":"M123","Companies House Number":"C123","MLRs Status Effective Date":"2023-04-01","MLRs Status":"Approved","E-Money Agent Effective Date":"2023-05-01","PSD Agent Effective date":"2023-06-01","PSD Agent Status":"Active","PSD / EMD Status":"Approved","Status":"Active","Business Type":"Type A","Organisation Name":"Org A","FRN":"FRN123"}]}';

        // Parsing the JSON string into FCAFirmDetailWrapper
        FCAFirmDetailWrapper wrapper = FCAFirmDetailWrapper.parse(json);

        // Assertions for the parsed values
        System.assertEquals('Active', wrapper.Status);
        System.assertEquals('Success', wrapper.Message);
        System.assertEquals('1', wrapper.ResultInfo.page);
        System.assertEquals('10', wrapper.ResultInfo.per_page);
        System.assertEquals('100', wrapper.ResultInfo.total_count);

        List<FCAFirmDetailWrapper.Data> dataList = wrapper.Data;
        System.assertNotEquals(null, dataList);
        System.assertEquals(1, dataList.size());

        FCAFirmDetailWrapper.Data data = dataList[0];
        System.assertEquals('Company A', data.name);
        System.assertEquals('John Doe', data.individuals);
        System.assertEquals('Yes', data.requirements);
        System.assertEquals('Granted', data.permission);
        System.assertEquals('12345', data.passport);
        System.assertEquals('Regulator 1', data.regulators);
        System.assertEquals('Yes', data.appointedRepresentative);
        System.assertEquals('123 Main St', data.address);
        System.assertEquals('None', data.waivers);
        System.assertEquals('None', data.exclusions);
        System.assertEquals('None', data.disciplinaryHistory);
        System.assertEquals('2023-10-10', data.systemTimestamp);
        System.assertEquals('Info Title', data.exceptionalInfoTitle);
        System.assertEquals('Info Body', data.exceptionalInfoBody);
        System.assertEquals('2023-01-01', data.statusEffectiveDate);
        System.assertEquals('Active', data.e_MoneyAgentStatus);
        System.assertEquals('2023-02-01', data.psd_emdEffectiveDate);
        System.assertEquals('Yes', data.clientMoneyPermission);
        System.assertEquals('2023-03-01', data.subStatusEffectiveFrom);
        System.assertEquals('Active', data.sub_Status);
        System.assertEquals('M123', data.mutualSocietyNumber);
        System.assertEquals('C123', data.companiesHouseNumber);
        System.assertEquals('2023-04-01', data.mlrsStatusEffectiveDate);
        System.assertEquals('Approved', data.mlrsStatus);
        System.assertEquals('2023-05-01', data.e_MoneyAgentEffectiveDate);
        System.assertEquals('2023-06-01', data.psdAgentEffectivedate);
        System.assertEquals('Active', data.psdAgentStatus);
        System.assertEquals('Approved', data.psd_emdStatus);
        System.assertEquals('Active', data.status);
        System.assertEquals('Type A', data.businessType);
        System.assertEquals('Org A', data.organisationName);
        System.assertEquals('FRN123', data.FRN);
    }
}