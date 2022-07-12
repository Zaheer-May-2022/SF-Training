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