public class ConditionalStatement {
     ConditionalStatement(Integer place) {
         String medal_color;
        if (place == 1) {
            medal_color = 'gold';
        } else if (place == 2) {
            medal_color = 'silver';
        } else if (place == 3) {
            medal_color = 'bronze';
        } else {
            medal_color = null;
        }
        System.debug(place);
    }
}