@isTest
public class TransactionEntryTriggerHelperTest {

    @isTest
    private static void safeTestRecords(){
        
        Test.startTest();

        Contact con = new Contact();
        //Inserting Limit 
        Transaction_Limit__c trasnLimitObj = new Transaction_Limit__c(Maximum_Debit_Allowed_per_Month__c = 100000, Maximum_Debit_Allowed_per_Day__c = 20000, Maximum_Debit_Allowed_per_Transaction__c = 3000, Maximum_Transactions_Allowed_per_Month__c = 60, Maximum_Transactions_Allowed_per_Day__c = 3);

        insert trasnLimitObj;
        
        //Inserting Contact
        con = new Contact(FirstName = 'Con', LastName = 'Admin', Transaction_Limit__c =         
        trasnLimitObj.Id, Email = 'Admin@fexle.com', Available_Balance__c = 20000, Transaction_Status__c = 'Active');
        
        insert con;
        
        //date
        Date dt = Date.newInstance(2022,10,1);
        Date dt2 = Date.newInstance(2022,12,1);

        //List to hold Transaction
        List<Transaction_Entry__c> transEntryList = new List<Transaction_Entry__c>();
            
        //Inserting First Transaction
        transEntryList.add(new Transaction_Entry__c(Amount__c = 100, type__c = 'Debit', Status__c = 'Pending', Contact__c = con.Id, Transaction_Date__c = dt));

        transEntryList.add(new Transaction_Entry__c(Amount__c = 200, type__c = 'Debit', Status__c = 'Pending', Contact__c = con.Id, Transaction_Date__c = dt));

        transEntryList.add(new Transaction_Entry__c(Amount__c = 300, type__c = 'Debit', Status__c = 'Pending', Contact__c = con.Id, Transaction_Date__c = dt));

        insert transEntryList;

        Test.stopTest();
    }
}
