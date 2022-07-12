public class ContactAndLeadSearch {
    public static List<List<SObject>> searchContactsAndLeads(string Smith){
        List<List<SObject>> searchList = [FIND 'Smith' IN NAME FIELDS RETURNING Contact(FirstName, LastName), Lead(FirstName, LastName)];
        System.debug(searchList);
        return searchList;
    }
}

/*  #Execution Code
    - ContactAndLeadSearch.searchContactsAndLeads('Smith');

    #Output
    - 13:33:06:073 USER_DEBUG [4]|DEBUG|((Contact:{FirstName=Three, LastName=Smith, Id=0035i000008nwRiAAI}, Contact:{FirstName=Two, LastName=Smith, Id=0035i000008nwRdAAI}, Contact:{FirstName=One, LastName=Smith, Id=0035i000008nwROAAY}), (Lead:{FirstName=Dr, LastName=Smith, Id=00Q5i000005MSk9EAG}))
*/