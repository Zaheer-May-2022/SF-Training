public with sharing class CallByReferenceExample {
    //Here the values will be changed
    public CallByReferenceExample() {
        Point point = new Point();
        System.debug('Before Update X: ' +point.x + ', Before Update Y: ' + point.y);
        updatePoint(point);
        System.debug('After Update X: ' +point.x + ', After Update Y: ' + point.y);
    }
    public static void updatePoint(Point point) {
        point.x = 100;
        point.y = 100;
    }
    class Point {
        public Integer x, y;
    }
}