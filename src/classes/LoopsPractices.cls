public with sharing class LoopsPractices {
    // for loop example--Iterating number 1 to 10
    public void forLoopExample() {
        Integer sum = 0;
        Integer numbers = 10;
        
        // for loop
        for (Integer i = numbers; i >= 1; --i) {
            sum += i;     // sum = sum + i
        }
        System.debug('Sum = ' + sum);
    }
    
    // for-each loop example -- Iterating the list
    public void forEachLoop() {
        // create an array
        List<Integer> list1 = new List<Integer>();
        list1.add(4);
        list1.add(2);
        list1.add(0);
        list1.add(-5);
        list1.add(8);
        
        // iterating through the array 
        for (Integer num : list1) {
            System.debug(num);
        }
    }
}