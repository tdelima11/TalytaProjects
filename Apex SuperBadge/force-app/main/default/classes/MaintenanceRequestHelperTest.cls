@isTest
public with sharing class MaintenanceRequestHelperTest {

    private static final String Status_New = 'New';
    private static final String Working = 'Working';
    private static final String Closed = 'Closed';
    private static final String Repair = 'Repair';
    private static final String Request_Origin = 'Web';
    private static final String Request_Type = 'Routine Maintenance';
    private static final String Request_Subject = 'Testing Subject';

    private static Vehicle__c createVehicle(){
        Vehicle__c vehicle = new Vehicle__c(name = 'Truck1');
        return vehicle;
    }

     private static Product2 createEq(){
         Product2 equipment = new Product2(name = 'Equipment1',
                                            Lifespan_Months__c = 10,
                                            maintenance_Cycle__c = 10,
                                            Replacement_Part__c = true);
        return equipment;
     }

     private static Case createMaintenanceRequest(id vehicleId, id equipmentId){
         Case cse = new Case(Type = Repair,
                            Status = Status_New,
                             Origin = Request_Origin,
                             Subject = Request_Subject,
                             Equipment__c = equipmentId,
                             Vehicle__c = vehicleId);
        return cse;
     }

     private static Equipment_Maintenance_Item__c createWorkPart(id equipmentId, id requestId){
        Equipment_Maintenance_Item__c wp = new Equipment_Maintenance_Item__c(Equipment__c = equipmentId,
                                                                        Maintenance_Request__c = requestId);
        return wp;
     }

    @isTest
    private static void  testMaintenanceRequestPositive(){
        Vehicle__c vehicle = createVehicle();
        insert vehicle;
        id vehicleId = vehicle.Id;

        Product2 equipment = createEq();
        insert equipment;
        id equipmentId = equipment.Id;

        Case somethingToUpdate = createMaintenanceRequest(vehicleId, equipmentId);
        insert somethingToUpdate;

        Equipment_Maintenance_Item__c workP = createWorkPart(equipmentId, somethingToUpdate.id);
        insert workP;

        test.startTest();
        somethingToUpdate.status = Closed;
        update somethingToUpdate;
        test.stopTest();

        Case newReq = [SELECT Id, Subject, Type, Equipment__c, Date_Reported__c, Vehicle__c, Date_Due__c
                        FROM Case 
                        WHERE status =: Status_New];
        
        Equipment_Maintenance_Item__c workPart = [SELECT Id 
                                                FROM Equipment_Maintenance_Item__c
                                                WHERE Maintenance_Request__c =: newReq.Id];
        
        System.assert(workPart != null);
        System.assert(newReq.Subject != null);
        System.assertEquals(newReq.Type, REQUEST_TYPE);
        System.assertEquals(newReq.Equipment__c, equipmentId);
        System.assertEquals(newReq.Vehicle__c, vehicleId);
        System.assertEquals(newReq.Date_Reported__c, System.today());
    }

    @isTest 
    private static void testMaintenanceRequestNegative(){
        Vehicle__c vehicle = createVehicle();
        insert vehicle;
        id vehicleId = vehicle.Id;

        Product2 equipment = createEq();
        insert equipment;
        id equipmentId = equipment.Id;

        Case emptyReq = createMaintenanceRequest(vehicleId, equipmentId);
        insert emptyReq;

        Equipment_Maintenance_Item__c workP = createWorkPart(equipmentId, emptyReq.Id);
        insert workP;

        test.startTest();
        emptyReq.Status = Working;
        update emptyReq;
        test.stopTest();

        List<Case> allRequest = [SELECT Id 
                                FROM Case];

        Equipment_Maintenance_Item__c workPart = [SELECT Id 
                                                FROM Equipment_Maintenance_Item__c
                                                WHERE Maintenance_Request__c =: emptyReq.Id];

        System.assert(workPart != null);
        System.assert(allRequest.size() == 1);
    }

    private static void testMaintenanceRequestBulk(){
        List<Vehicle__c> vehicleList = new List<Vehicle__c>();
        List<Product2> equipmentList = new List<Product2>();
        List<Equipment_Maintenance_Item__c> workPartList = new List<Equipment_Maintenance_Item__c>();
        List<Case> requestList = new List<Case>();
        List <Id> oldRequestIds = new List<Id>();
        
        for(Integer i = 0; i < 300; i++){
            vehicleList.add(createVehicle());
            equipmentList.add(createEq());
        }
        insert vehicleList;
        insert equipmentList;

        for(Integer i = 0; i < 300; i++){
            requestList.add(createMaintenanceRequest(vehicleList.get(i).id, equipmentList.get(i).id));
        }
        insert requestList;

        for(Integer i = 0; i < 300; i++){
            workPartList.add(createWorkPart(equipmentList.get(i).id, requestList.get(i).id));
        }
        insert workPartList;

        test.startTest();
        for(Case req : requestList){
            req.Status = Closed;
            oldRequestIds.add(req.Id);
        }
        update requestList;
        test.stopTest();

        List<Case> allRequest = [SELECT Id 
                                FROM Case 
                                WHERE Status =: Status_New];

        List<Equipment_Maintenance_Item__c> workParts = [SELECT Id
                                                        FROM Equipment_Maintenance_Item__c
                                                        WHERE Maintenance_Request__c in: oldRequestIds];
        
        System.assert(allRequest.size()== 300);
    }

}
