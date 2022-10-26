
global class MonthlyTransactionEmail implements Database.Batchable<sObject>, Schedulable {
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([Select Name, Email, Available_Balance__c From Contact Where Status__c like 'Active']);
    }
    global void execute(Database.BatchableContext bc, List<Contact> records) {

        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        List<String> sendTo = new List<String>();

        for(Contact con :records) {

            String s ='';
            Decimal Avl_bal = con.Available_Balance__c;

            sendTO.add(con.Email);
            s+=con.Name;
             Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setSenderDisplayName('Email Alert');

            mail.setSubject('Transaction Monthly update');
            String body = 'Hello '+ s + ' Your Available Balance is  ' ;
            mail.setToAddresses(sendTo);
            mail.setHtmlBody(body);
            mails.add(mail);
    	}
        Messaging.SendEmail(mails);
    }
    global void finish(Database.BatchableContext bc){
        System.debug('bc === '+ bc);
    }

    global void execute(SchedulableContext sc){

        MonthlyTransactionEmail b = new MonthlyTransactionEmail();
        database.executeBatch(b);
    }
}