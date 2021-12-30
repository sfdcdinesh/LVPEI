@isTest(seealldata=false)
private class ConsolidatedRecordTest {
    
    static testmethod void getData()
    {
        account acc = new account(Name='test1');
        insert acc;
        
        contact con =new contact(accountid=acc.id,lastname='sagiraju',City__c='hyderabd',Street_1__c='ramnagar',Street_2__c='plotno436',Zip_Postal_Code__c='530045',Country__c='india',State__c='hyderabad',MobilePhone='9381956789');
        insert con;
        
        Referral__c ref = new Referral__c(Death_Notification_Consignment_Date_Time__c = datetime.newInstance(2019, 12, 20, 12, 0, 0), 
                                         Referral_Method__c = 'HCRP', Referral_Source__c = 'HCRP motivated', Age_of_Donor__c = 45,
                                         Date_Time_of_Death__c = datetime.newInstance(2019, 12, 20, 12, 0, 0), 
                                         Date_of_Birth__c =  date.newInstance(1995, 12, 11));
        insert ref;
        
        
        Recovery__c rec = new Recovery__c();
        rec.Tissue_recovery_date_time__c = datetime.newInstance(2019, 12, 20, 12, 0, 0);
        rec.Recovery_completed_by__c = con.Id;
        rec.Referral__c = ref.Id ;
        rec.Cornea_Preservation_Date_Time__c = system.today();
        insert rec;
		
        Medical_Review__c mr = new Medical_Review__c();
        mr.Referral__c = ref.Id;
        mr.Recovery__c = rec.Id;

        insert mr;
        
        
        Tissue_Evaluation__c tiseval = new Tissue_Evaluation__c();
        tiseval.Recovery__c = rec.Id;
        tiseval.Medical_Review__c = mr.Id;
        tiseval.Eye__c = 'OS';
        tiseval.Tissue_Type__c = 'Cornea';
        tiseval.Tissue_Sub_Type__c = 'Whole';
        tiseval.Approval_Outcome__c = 'Placed';
        tiseval.Specular_Evaluation__c = 'Yes';
        tiseval.Pre_Cut__c = 'Yes';
        
        
        insert tiseval;
        
        Request__c req =new Request__c();
        req.Request_Date_time__c = system.today();
        req.Tissue_Evaluation__c = tiseval.Id;
        req.Requesting_Organization__c = acc.Id;
        req.Requesting_Surgeon__c = con.Id;
      	req.Surgery_Location__c = acc.Id;
        req.Eye_Bank_Performing_Pre_Cut__c = acc.Id;
        
        insert req;
        
        Placement__c p = new Placement__c();
        p.Request__c = req.Id;
        p.Shipment_Date__c = system.today();
        p.Select_Tissue__c = tiseval.Id;
        p.Hand_Carried_By_By_Hand__c = con.id;
        p.To__c = acc.id;
        
        insert p;
        
        
        Test.startTest();
        
    }
    

}