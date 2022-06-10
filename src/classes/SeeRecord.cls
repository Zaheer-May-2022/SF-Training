public class SeeRecord {
    public static void seeRcrd(){
        //Single Student
       Student__c s2  = [select Id, Grade__c from Student__c order by createdDate DESC Limit 1];
    System.debug('this is my latest student' + s2);
        //Multiple Students
        List<Student__c> StudentList = [select id,Grade__c from Student__c order by CreatedDate DESC Limit 5];
        for(Student__c student: StudentList){
            System.debug('Check Student Data:::' + student);
        }
    }

}