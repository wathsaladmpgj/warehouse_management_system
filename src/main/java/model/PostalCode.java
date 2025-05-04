package model;

public class PostalCode {
    private int id;
    private String location;
    private String postalCode;

    // Constructors
    public PostalCode() {}
    
    public PostalCode(int id, String location, String postalCode) {
        this.id = id;
        this.location = location;
        this.postalCode = postalCode;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    public String getPostalCode() { return postalCode; }
    public void setPostalCode(String postalCode) { this.postalCode = postalCode; }
}