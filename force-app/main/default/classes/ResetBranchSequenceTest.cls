@isTest
public class ResetBranchSequenceTest {
    @isTest
    public static void testUpdateSeqNum()
    {
        Test.startTest();
        ResetBranchSequenceSchedule Resetsequence = new ResetBranchSequenceSchedule();
        String sch = '0 15 0 1 1 ?'; 
        system.schedule('Testing', sch, Resetsequence); 
        Test.stopTest();
    }
    
}