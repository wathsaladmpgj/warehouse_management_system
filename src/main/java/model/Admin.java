package model;

public class Admin {
    private String adminName;
    private String outletLocation;
    
    public Admin(String adminName, String outletLocation) {
        this.adminName = adminName;
        this.outletLocation = outletLocation;
    }
    
    public String getAdminName() {
        return adminName;
    }
    
    public String getOutletLocation() {
        return outletLocation;
    }
}