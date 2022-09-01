global  with sharing class LWC {
    
    @AuraEnabled(cacheable=true)
    public static string getTextMethod1() {
        return 'METHOD-1';
    }
    @AuraEnabled(cacheable=true)
    public static string getTextMethod2() {
        return 'METHOD-2';
    }
    @AuraEnabled(cacheable=true)
    public static string getTextMethod3() {
        return 'METHOD-3';
    }
}

// (i) getTextMethod1() method
//          argument = Not any
//          return = 'METHOD-1'

// (ii) getTextMethod2() method
//          argument = Not any
//          return = 'METHOD-2' 

// (iii) getTextMethod3() method
//          argument = Not any
//          return = 'METHOD-3' 
