public virtual class OveriddenMarkerClass {
    public virtual void write() {
        System.debug('Writing some text.');
    }
    
    public virtual Double discount() {
        return .05;
    }
}