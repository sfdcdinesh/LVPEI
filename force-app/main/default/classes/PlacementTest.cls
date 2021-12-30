// Test class for PlacemenController class
@isTest
public class PlacementTest {
@isTest
    static void PlacementTest(){
        //Getting Account and Contact Id's    
        //Id householdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household Account').getRecordTypeId();
        Id organization = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Organization').getRecordTypeId();
        Id counsellor = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Counselors').getRecordTypeId();
        
        //Inserting Account and Contact
        Account a = TestFactory.getAccount(organization,'Ramayamma International Eye Bank Organisation', true);   
        Contact c = TestFactory.getContact(counsellor,a.Id,'Hasan',true);
        DateTime NotifDateTime = datetime.newInstance(2018, 12, 21, 12, 30, 0);
        Date dob = Date.newInstance(1985, 12, 21);
        DateTime deathTime = datetime.newInstance(2018, 12, 19, 12, 30, 0);
        Referral__c ref = TestFactory.getReferral(NotifDateTime, 'Voluntary', 'Volunteer Motivated',dob,deathTime);
        DateTime tissueRecoveryDate = datetime.newInstance(2018, 12, 20, 12, 30, 0);
        DateTime coolStart = datetime.newInstance(2018, 12, 20, 2, 30, 0);
        DateTime coolEnd = datetime.newInstance(2018, 12, 20, 4, 30, 0);
    Test.startTest();
        PlacementController.getCurrentUser();
         Placement__c place = new Placement__c();        
        place.Shipment_Date__c = Date.newInstance(2018, 12, 9);
        insert place;
        PlacementController.getLookups(place.Id);
        PlacementController.getPlacementDetails(place.Id);
        Request__c req = new Request__c();
        req.Request_Date_time__c = Date.newInstance(2018, 12, 26);
        insert req;
        PlacementController.getRequestDetails(req.Id);
        PlacementController.getReferral(ref.Id);
        Tissue_Return__c tr = new Tissue_Return__c();
        PlacementController.saveReturn(tr, c.Id);
        Placement__c p =new Placement__c();
        
        Tissue_Evaluation__c te = new Tissue_Evaluation__c();        
        te.Tissue_Type__c='Cornea';
        te.Tissue_Sub_Type__c='Whole';
        insert te;
        String text = 'test';
        PlacementController.savePlacement(p, te.Id, c.Id, req.Id, c.Id, tr, p.Id);
       PlacementController.savePDF(text);
        //Inserting Refferal and Donor records
      /*  Referral__c ref = TestFactory.getReferral(NotifDateTime, 'Voluntary', 'Volunteer Motivated');
        Date dob = Date.newInstance(1985, 12, 21);
        DateTime deathTime = datetime.newInstance(2018, 12, 19, 12, 30, 0);

        Referral__c don = TestFactory.getDonor(ref.Id, dob, deathTime);
        DateTime tissueRecoveryDate = datetime.newInstance(2018, 12, 20, 12, 30, 0);
        DateTime coolStart = datetime.newInstance(2018, 12, 20, 2, 30, 0);
        DateTime coolEnd = datetime.newInstance(2018, 12, 20, 4, 30, 0);

        
        //EMR instance creation and inserting record
        EMR__c emr = new EMR__c();
        emr.Name='Test EMR';
        insert emr;
        
        //Placement insert
        Placement__c place = new Placement__c();        
        place.Shipment_Date__c = Date.newInstance(2018, 12, 9);
        //insert place;
        PlacementController.getCurrentUser();
        
        Request__c req = new Request__c();
        req.Request_Date_time__c = Date.newInstance(2018, 12, 26);
        insert req;

        Tissue_Evaluation__c te = new Tissue_Evaluation__c();        
        te.Tissue_Type__c='Cornea';
        te.Tissue_Sub_Type__c='Whole';
        
        insert te;
        
        //Referral__c refer = new Referral__c();
        ref.Death_Notification_Consignment_Date_Time__c=system.now();
        PlacementController.savePlacement(place,te.Id,c.Id,req.Id,c.Id);
        
        PlacementController.getReferral(don.Id);*/
        
       //  String urlstr = 'tester';
         //PlacementController.savePDF(urlstr);
        
        //apexPages.Currentpage().getParameters().put('Id',place.id);
        
    }
}