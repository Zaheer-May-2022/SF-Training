// One implementation of the interface for customers
public class CustomerPurchaseOrderClass implements PurchaseOrderInterface{
    // Here is the body and declaration of the above interface method for the customer
    public Double discount() {
        return .05;  // Flat 5% discount
    }
}