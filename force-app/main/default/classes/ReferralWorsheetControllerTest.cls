@isTest(seealldata=false)
private class ReferralWorsheetControllerTest {
    
    public Double offset{get{
        TimeZone tz = UserInfo.getTimeZone();
        //Milliseconds to Day
        return tz.getOffset(DateTime.now()) / (1000 * 3600 * 24.0);
    }}
    static testmethod void getReferralWorksheet()
    {
        Test.StartTest(); 
        PageReference pageRef = Page.ReferralWorksheetPdf;
         Profile profile = [Select Id From Profile where Name = 'System Administrator' limit 1];
       user u = new user();
       u.firstName = 'test1';
       u.lastName = 'test2';
       u.email = 'test@test.com';
       u.Username ='kiransai94310@gmail.com.hello';
       u.Alias ='rev';
       u.ProfileId = profile.id;
       u.LanguageLocaleKey= 'en_US';   
       u.TimeZoneSidKey ='Asia/Kolkata';
       u.EmailEncodingKey = 'ISO-8859-1';
       u.LocaleSidKey ='en_US';
        insert u;
         Branch__c branch = new Branch__c();
        branch.Name ='Drushtidaan Eye Bank';
        branch.Branch_Code__c = 'DDEB';
        branch.Request_Sequence_Number__c = 1;
        branch.Placement_Sequence_Number__c = 1;
        branch.Tissue_Return_Sequence_Number__c = 1;
        branch.Referral_Sequence_Number__c = 1;
        branch.Recovery_Sequence_Number__c = 1;
        insert branch;
        
        Branch_Team__c bt = new Branch_Team__c();
        bt.Name ='Team Megnity';
        bt.User__c = u.id;
        bt.Branch__c = branch.id;
        insert bt;
        
        
        Branch__c tempobj = [select Id,Name from Branch__c where Id = :branch.Id];
        system.debug('brnahc details '+tempobj);
        
        System.runAs(u) {

        account acc = new account(Name='test558768');
        insert acc;
        
        contact con =new contact(accountid=acc.id,lastname='sagiraju',City__c='hyderabd',Street_1__c='ramnagar',Street_2__c='plotno436',Zip_Postal_Code__c='530045',Country__c='india',State__c='hyderabad',MobilePhone='9381956789');
        insert con;
        
        Referral__c ref = new Referral__c(Death_Notification_Consignment_Date_Time__c = datetime.newInstance(2019, 12, 20, 12, 0, 0), 
                                         Referral_Method__c = 'HCRP', Referral_Source__c = 'HCRP motivated', Age_of_Donor__c = 45,
                                         Date_Time_of_Death__c = datetime.newInstance(2019, 12, 20, 12, 0, 0), 
                                         Date_of_Birth__c =  date.newInstance(1995, 12, 11), Gender__c = 'Male', Social_and_Behavioral_History__c = 'No Reports',
                                         Was_the_donor_on_a_ventilator__c = 'Yes', Duration_of_time_on_Ventilator_if_Yes__c = '36 hours');
        ref.Autopsy_Completed__c = 'Yes';
        ref.First_Name__c = 'Ramya';
        ref.Last_Name__c = 'K';
        ref.Religion__c = 'Hindu';
        ref.Medical_Record_Number__c = '526';
        ref.Date_of_Admission__c = System.today();
        ref.Height__c = 190;
        ref.Weight__c = 78;
        ref.Donation_Counselor_Volunteer__c = con.Id;
        ref.Primary_Cause_of_Death__c = 'Cancer';
        ref.If_Other_Provide_Cause__c = 'test';
        ref.Circumstances_Leading_to_Death__c = 'test'; 
        ref.Height_Unit__c = 'cm';
        ref.Weight_Unit__c = 'KG';
        ref.Isolation__c = 'Yes';
        ref.Sign_symptoms_of_systemic_infection__c = 'Yes';
        ref.Facility_Name__c = 'test';
        ref.To_Where__c = 'test';
        ref.How_many_IV_Fluids_given_in_Last_Hour__c = 'test';
        ref.Blood_given_in_the_last_48_hours__c = 'tets';
        ref.If_Yes_Please_Specify_the_Isolation__c = 'test';
        ref.If_Yes_Mention_the_Sign_symptoms__c = 'test';
        ref.Transferred_from_other_facility__c = 'Yes';
        ref.Medical_Ocular_Histor__c = 'Medical';
        ref.Social_and_Behavioral_History__c = 'No history';
        ref.IV_Fluid_Date_Time__c =  System.today();
        ref.Death_Notification_Consignment_Date_Time__c = System.today();
        ref.Recovery_Address__c = 'test';
        ref.Recovery_Direction__c = 'test';
        ref.IV_Fluid_given_in_last_hour__c = 'Yes';
        ref.Referral_Method__c = 'HCRP';
        ref.Donation_Counselor_Volunteer__c = con.Id;
        ref.Unit_Type__c = 'Mortuary';
        ref.Unit_Organization_Hospital_Name__c =  acc.id;
        ref.Comments__c = 'test';
        ref.Special_Instructions__c = 'test';
        ref.Caller_First_Name__c = 'Ram';
        ref.Caller_Last_Name__c = 'K';
        ref.Location_of_Donor__c = 'Hospital';
        ref.Phone_Number_Of_Caller__c = '7893670620';
        ref.Relationship_of_caller_to_donor__c = 'Parent';
       
        insert ref;
        
        System.debug(ref.Id);
        Referral__c referral = new Referral__c();
        
        referral = [select Id, Name, OwnerId, First_Name__c, Last_Name__c, DonorID__c, Donor_ID__c, Date_of_Birth__c, Age_of_Donor__c, Gender__c, 
                 Religion__c,  Medical_Record_Number__c,Date_of_Admission__c, Height__c,Weight__c,Donation_Counselor_Volunteer__r.Name,
                 Primary_Cause_of_Death__c, If_Other_Provide_Cause__c, Circumstances_Leading_to_Death__c, Height_Unit__c, Weight_Unit__c,
                 Attending_physician__c, Date_Time_of_Death__c, Was_the_donor_on_a_ventilator__c, How_much_Blood_given_in_last_48_hours__c,Blood_given_Date_Time__c,
                 Duration_of_time_on_Ventilator_if_Yes__c, Isolation__c, Sign_symptoms_of_systemic_infection__c,Facility_Name__c,To_Where__c,
                 How_many_IV_Fluids_given_in_Last_Hour__c, Blood_given_in_the_last_48_hours__c,If_Yes_Please_Specify_the_Isolation__c,If_Yes_Mention_the_Sign_symptoms__c, 
                 Transferred_from_other_facility__c, Medical_Ocular_Histor__c, Social_and_Behavioral_History__c,IV_Fluid_Date_Time__c,
                 Death_Notification_Consignment_Date_Time__c,Recovery_Address__c,Recovery_Direction__c,IV_Fluid_given_in_last_hour__c,
                 Referral_Method__c,Donation_Counselor_Volunteer__c,Unit_Type__c,Unit_Organization_Hospital_Name__c, Comments__c,
                 Special_Instructions__c,Caller_First_Name__c,Caller_Last_Name__c,Location_of_Donor__c,Unit_Organization_Hospital_Name__r.Name,Phone_Number_Of_Caller__c,Relationship_of_caller_to_donor__c
                 from Referral__c where id =: ref.Id limit 1];
        
        Test.setCurrentPage(pageRef);
        
        
        pageRef.getParameters().put('referralid', ref.Id);
       
		ApexPages.StandardController sc = new ApexPages.StandardController(ref);
        ReferralWorksheetPdfController testAccPlan = new ReferralWorksheetPdfController();
        
        testAccPlan.refRend = true;
        if(testAccPlan.offset != null)
        {
            
        }
        }
        
    }

}