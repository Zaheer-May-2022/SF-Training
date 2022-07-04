public with sharing class CallByValueExample {
    public static void debugStatusMessage() {
        String msg = 'Original value';
        System.debug('Before any processString: '+msg);
        processString(msg);
        // The value of the msg variable didn't
        // change; it is still the old value.
        System.debug('After processString: '+msg);
    }
    
    public static void processString(String s) {
        s = 'Modified value';
    }
}