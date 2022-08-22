/*
Purpose : Sending mail to newly created account
Created By : Zaheer Khan
Created Date : 20-07-22 
Revision Log : 01
 */


trigger AfterInsertExample_Trigger on Account (after insert) {
    // List<String> toAddresses = new List<String>(); 
    List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
    for(Account a : Trigger.New) {
        String accountName = a.Name;
        String accountNo = a.AccountNumber;
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new List<String>{a.Email__c});
        mail.setSubject('Congratulations for creating account');
        mail.setPlainTextBody('Congratulations for creating account your account details are Account Number = ' + accountNo + ', Account Name = ' + accountName);    
        String emailAddress = a.Email__c;
        // toAddresses.add(a.Email__c);
        // EmailManager.sendMail(emailAddress, 'Congratulations for creating account', 'Congratulations for creating account your account details are Account Number = ' + accountNo + ', Account Name = ' + accountName);
        System.debug('Email Send Successfully at: ' + emailAddress);
        messages.add(mail);
    }
    // Messaging.sendEmail(messages);
    Messaging.SendEmailResult[] results = Messaging.sendEmail( messages );
    System.debug('Result' + results);
}

// Dont use DML and Event in loops

/*
After Insert Example: Sending a email to to account holder on Account holder mail with Congratulation message

######################## Execution 

List<Account> acc = new List<Account>();
Account a = new Account();
a.Name = 'Zaheer_Email01';
a.Email__c = 'zaheer.khan@fexle.com';
a.AccountNumber = '010101011';
acc.add(a);
Account a1 = new Account();
a1.Name = 'Zaheer_Email02';
a1.Email__c = 'zaheer.khan@fexle.com';
a1.AccountNumber = '0183763761';
acc.add(a1);
insert acc;

 */