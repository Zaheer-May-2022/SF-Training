public with sharing class WorkingWithSOQL {
    public WorkingWithSOQL() {
        insert new Account(Name='Singha');
        Account acc = [SELECT Id FROM Account WHERE Name='Singha' LIMIT 1];
        //Account acc1 = [SELECT Id FROM Account WHERE Name='Singha' LIMIT 1].Name; --> Gives Run Time error
        System.debug(acc);
        //System.debug(acc1); --> Gives Run Time error

        String name  = [SELECT Id, Name FROM Account WHERE Name='Singha' LIMIT 1].Name;
        System.debug(name);
    }
}


/* ##### Execution ###
WorkingWithSOQL.WorkingWithSOQL();


###### OUtput #####
USER_DEBUG [6]|DEBUG|Account:{Id=0015i00000JBwApAAL}
USER_DEBUG [10]|DEBUG|Singha
*/
