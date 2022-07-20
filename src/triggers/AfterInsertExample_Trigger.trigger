trigger AfterInsertExample_Trigger on Account (after insert) {
    for(Account a : Trigger.New) {
        String accountName = a.Name;
        String accountNo = a.AccountNumber;
        String emailAddress = a.Email__c;
        EmailManager.sendMail(emailAddress, 'Congratulations for creating acconut', 'Congratulations for creating account your account details are Account Number = ' + accountNo + ', Account Name = ' + accountName);
        System.debug('Email Send Successfully at: ' + emailAddress);
    }
}

/*
After Insert Example: Sending a email to to account holder on Account holder mail with Congratulation message
 */