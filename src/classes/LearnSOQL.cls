public with sharing class LearnSOQL {
    public LearnSOQL() {
        // Add account and related contact
        Account acct = new Account(
            Name='SFDC Computing',Phone='(415)555-1212',
            NumberOfEmployees=50,BillingCity='San Francisco');
        insert acct;
        // Once the account is inserted, the sObject will be 
        // populated with an ID.
        // Get this ID.
        ID acctID = acct.ID;
        // Add a contact to this account.
        Contact con = new Contact(
            FirstName='Carol',LastName='Ruiz',
            Phone='(415)555-1212',Department='Wingo',
            AccountId=acctID);
        insert con;
        // Add account with no contact
        Account acct2 = new Account(
            Name='The SFDC Query Man',Phone='(310)555-1213',
            NumberOfEmployees=50,BillingCity='Los Angeles',
            Description='Expert in wing technologies.');
        insert acct2;
    
        String soslFindClause = 'Wingo OR SFDC';
        List<List<SObject>> searchList = [FIND :soslFindClause IN ALL FIELDS 
        RETURNING Account(Name), Contact(FirstName,LastName,Department) ];

        Account[] searchAccounts = (Account[])searchList[0];
        Contact[] searchContacts = (Contact[])searchList[1];
        System.debug('Found the following accounts.');
        for (Account a : searchAccounts) {
            System.debug(a.Name);
        }
        System.debug('Found the following contacts.');
        for (Contact c : searchContacts) {
            System.debug(c.LastName + ', ' + c.FirstName);
        }
    }
}


/* ##### Execution ###
LearnSOQL.LearnSOQL();

###### OUtput #####
USER_DEBUG [31]|DEBUG|Found the following accounts.
USER_DEBUG [35]|DEBUG|Found the following contacts.
*/
