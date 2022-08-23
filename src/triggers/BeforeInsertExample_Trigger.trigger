trigger BeforeInsertExample_Trigger on Account (before insert) {
    for(Account a : Trigger.New) {
        if(a.Type == 'Saving Account') {
            a.AccountNumber = 'SA' + a.AccountNumber;
        }
        if(a.Type == 'Fixed Deposit') {
            a.AccountNumber = 'FD' + a.AccountNumber;
        }
    }
}

/*
Adding A prefix to Account NO as the added 
In this case we will write a trigger on the Bank Account table and check the logic of Trigger.New.Type == 'Saving' then prefix Trigger.New.AccountNumber = 'SA' + Account Number.*/