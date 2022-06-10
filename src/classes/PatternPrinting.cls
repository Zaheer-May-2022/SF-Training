public class PatternPrinting {
 	Integer i,j;
    String pattern='';
    public void pattern_12(){
        for(i=1;i<5;++i){
           for (j = 1; j <= i; ++j) {
               pattern+=j; 
       	    }
     	pattern+='\n';       
     	}
        System.debug('Pattern \n'+pattern);
}
}