package model;

public class HeadOffice_OutletDetails {
    private int id;
    private String outletName;
    private int totalRegisteredItems;
    private int totalReturnedItems;
    private int remainingReturnedItems;
    private int AvailableNewItems;

    public HeadOffice_OutletDetails(int id, String outletName, int totalRegisteredItems, int totalReturnedItems, int remainingReturnedItems, int AvailableNewItems) {
        this.id = id;
        this.outletName = outletName;
        this.totalRegisteredItems = totalRegisteredItems;
        this.totalReturnedItems = totalReturnedItems;
        this.remainingReturnedItems = remainingReturnedItems;
        this.AvailableNewItems = AvailableNewItems;
    }

    public HeadOffice_OutletDetails() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getOutletName() {
        return outletName;
    }

    public void setOutletName(String outletName) {
        this.outletName = outletName;
    }

    public int getTotalRegisteredItems() {
        return totalRegisteredItems;
    }

    public void setTotalRegisteredItems(int totalRegisteredItems) {
        this.totalRegisteredItems = totalRegisteredItems;
    }

    public int getTotalReturnedItems() {
        return totalReturnedItems;
    }

    public void setTotalReturnedItems(int totalReturnedItems) {
        this.totalReturnedItems = totalReturnedItems;
    }

    public int getRemainingReturnedItems() {
        return remainingReturnedItems;
    }

    public void setRemainingReturnedItems(int remainingReturnedItems) {
        this.remainingReturnedItems = remainingReturnedItems;
    }

    public int getAvailableNewItems() {
        return AvailableNewItems;
    }

    public void setAvailableNewItems(int AvailableNewItems) {
        this.AvailableNewItems = AvailableNewItems;
    }
}
