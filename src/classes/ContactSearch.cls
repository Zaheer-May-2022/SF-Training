public class ContactSearch {
    public static List<Contact> searchForContacts(string lastName, string mailingCode) {
        
        List<Contact> myContacts = [SELECT Name, Id FROM Contact WHERE LastName =: lastName AND MailingPostalCode =: mailingCode];
        System.debug(myContacts);
        
        return myContacts;
    }
}
/*
Execute -  ContactSearch.searchForContacts('Young','66045');

Output - [5]|DEBUG|(Contact:{Name=Andy Young, Id=0035i000006KjKjAAK})
*/