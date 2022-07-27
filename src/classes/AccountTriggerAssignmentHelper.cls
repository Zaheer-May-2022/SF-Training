/*
Purpose : Handler class for Sending mail to newly created account and adding prefix to account no.
Created By : Zaheer Khan
Created Date : 20-07-22 
Revision Log : 01, 02
 */




public with sharing class AccountTriggerAssignmentHelper {
    // afterInsertCode
    public static void emialSender(List<Account> emailList) {
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        for(Account a : emailList) {
            String accountName = a.Name;
            String accountNo = a.AccountNumber;
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new List<String>{a.Email__c});
            mail.setSubject('Congratulations for creating account');
            mail.setPlainTextBody('Congratulations for creating account your account details are Account        Number = ' + accountNo + ', Account Name = ' + accountName);    
            String emailAddress = a.Email__c;
        // toAddresses.add(a.Email__c);
        // EmailManager.sendMail(emailAddress, 'Congratulations for creating account', 'Congratulations for creating account your account details are Account Number = ' + accountNo + ', Account Name = ' + accountName);
            System.debug('Email Send Successfully at: ' + emailAddress);
            messages.add(mail);
        }
    // Messaging.sendEmail(messages);
        Messaging.SendEmailResult[] results = Messaging.sendEmail(  messages );
        System.debug('Result' + results);
    }
    // beforeInsert
    public static void prefixedMessage(List<Account> accountsList) {
        for(Account a : accountsList) {
            if(a.Type == 'Saving Account') {
                a.AccountNumber = 'SA' + a.AccountNumber;
            }
            else if(a.Type == 'Fixed Deposit') {
                a.AccountNumber = 'FD' + a.AccountNumber;
            }
        }
    }
}



