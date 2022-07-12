public class AccountHandler {
    public static Account insertNewAccount(string accName) {
        Account acct = new Account(Name = accName);
        
        try {
            insert acct;
        }
        catch (DmlException error) {
            System.debug('DML exception occured' + error.getMessage());
            return null;
        }
        return acct;
    }
}