public class ContactSearch {
    public static List<Contact> searchForContacts(string lastName, string mailingCode) {
        
        List<Contact> myContacts = [SELECT Name, Id FROM Contact WHERE LastName =: lastName AND MailingPostalCode =: mailingCode];
        System.debug(myContacts);
        
        return myContacts;
    }
}