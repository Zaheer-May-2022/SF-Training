public class ContactAndLeadSearch {
    public static List<List<SObject>> searchContactsAndLeads(string Smith){
        List<List<SObject>> searchList = [FIND 'Smith' IN NAME FIELDS RETURNING Contact(FirstName, LastName), Lead(FirstName, LastName)];
        
        return searchList;
    }
}