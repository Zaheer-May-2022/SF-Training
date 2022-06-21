public class NumberPattern {
    public static void printPattern(){ 
        integer n = 5;
        for(integer i=1;i<=n;i++) {
            string s='  ';
            for(integer j=1;j<=i;j++){
                s = s + j ;
            }
            system.debug(s);
        }
    }
}