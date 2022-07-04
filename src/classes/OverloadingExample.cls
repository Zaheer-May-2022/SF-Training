public with sharing class OverloadingExample {
    public static void main()
    {
        System.debug(OverloadingExample.multiply(12,12));
        System.debug(OverloadingExample.multiply(6,6,6));
    }
    static Integer multiply(Integer a, Integer b)
    {
        Integer  c = a*b;
        return c;
    }
    // Overloading by Changing of an arguments
    static Integer multiply(Integer a, Integer b, Integer c)
    {
        Integer z = a*b*c;
        return z;
    }
    // Overloading by Changing of an Data types/return type
    static Double multiply(Double a, Double b)
    {
        Double z = a*b;
        return z;
    }
}