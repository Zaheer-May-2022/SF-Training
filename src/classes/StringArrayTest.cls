public class StringArrayTest {
    public static List<String> generateStringArray(Integer returnedStrings) {
        List<String> names = new List<String>();
        
        for (integer i = 0; i < returnedStrings; i++) {
            string oneName = 'Test ' + i;
           	names.add(oneName);
        }
        
        System.debug('This is the list: ' + names);
        return names;
    }
}

/*
Execution - StringArrayTest.generateStringArray(3);

Output - 13:34:28:014 USER_DEBUG [10]|DEBUG|This is the list: (Test 0, Test 1, Test 2)
 */