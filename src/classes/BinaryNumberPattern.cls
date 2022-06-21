public class BinaryNumberPattern {
    public static void printPattern() {
        for(integer i=1;i<=5;i++)
        {
            string s='  ';
            for(integer j=1; j<=5; j++)
            {
                
                if(j==1 || j==3 || j==5)
                {
                    s=s+'1';
                } 
                else
                {
                    s=s+'0';
                }
            }
            system.debug(s);
        }
    }
}