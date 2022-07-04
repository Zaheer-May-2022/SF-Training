public with sharing class PracticeConstantFinalKeyword {
    /* 1. We can onle intiate final key word , then we can't modify it
	   2. We can declare method as final then this method cannot be overridden 
	   3. We can declare class as a finla then this class cannot be extends
	*/
    static final Integer PRIVATE_INT_CONST = 200;
    static final Integer PRIVATE_INT_CONST2; 
    
    public static Integer calculate() {
        return 2 + 7;
    }
    
    static {
        PRIVATE_INT_CONST2 = calculate();
    }
}