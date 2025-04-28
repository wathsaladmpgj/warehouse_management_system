package model;

public class Admin {
    private int id;
    private String adminName;
    private String email;
    private String password;
    private String outletLocation;

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getAdminName() { return adminName; }
    public void setAdminName(String adminName) { this.adminName = adminName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getOutletLocation() { return outletLocation; }
    public void setOutletLocation(String outletLocation) { this.outletLocation = outletLocation; }
}
