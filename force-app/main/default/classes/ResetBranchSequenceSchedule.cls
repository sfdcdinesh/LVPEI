global class ResetBranchSequenceSchedule implements Schedulable{
    global void execute(System.SchedulableContext sc) {
        Map<String, Branch__c> params = new Map<String, Branch__c>();
        Flow.Interview.Reset_Branch_Sequence_Numbers seqflow = new Flow.Interview.Reset_Branch_Sequence_Numbers(params);
        seqflow.start();
        ResetBranchSequenceSchedule apexSch = new ResetBranchSequenceSchedule(); 
        String CRON_EXP = '0 15 0 1 1 ?';
        String jobID = System.schedule('Update Sequence number', CRON_EXP, apexSch);
    }
}