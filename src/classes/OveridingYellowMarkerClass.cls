public class OveridingYellowMarkerClass extends OveriddenMarkerClass {
    // Extension for the Marker class
    public override void write() {
        System.debug('Writing some text using the yellow marker.');
    } 
}