package model;

import java.util.Date;

public class Product {
    private int id;
    private String senderName;
    private String receiverName;
    private String postalCode;
    private String receiverLocation;
    private String productKey;
    private double productWeight;
    private String fromLocation;
    private String toLocation;
    private Date addedDate;

    // Constructors
    public Product() {
    }

    public Product(int id, String senderName, String receiverName, String postalCode, 
                  String receiverLocation, String productKey, double productWeight, 
                  String fromLocation, String toLocation, Date addedDate) {
        this.id = id;
        this.senderName = senderName;
        this.receiverName = receiverName;
        this.postalCode = postalCode;
        this.receiverLocation = receiverLocation;
        this.productKey = productKey;
        this.productWeight = productWeight;
        this.fromLocation = fromLocation;
        this.toLocation = toLocation;
        this.addedDate = addedDate;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getSenderName() {
        return senderName;
    }

    public void setSenderName(String senderName) {
        this.senderName = senderName;
    }

    public String getReceiverName() {
        return receiverName;
    }

    public void setReceiverName(String receiverName) {
        this.receiverName = receiverName;
    }

    public String getPostalCode() {
        return postalCode;
    }

    public void setPostalCode(String postalCode) {
        this.postalCode = postalCode;
    }

    public String getReceiverLocation() {
        return receiverLocation;
    }

    public void setReceiverLocation(String receiverLocation) {
        this.receiverLocation = receiverLocation;
    }

    public String getProductKey() {
        return productKey;
    }

    public void setProductKey(String productKey) {
        this.productKey = productKey;
    }

    public double getProductWeight() {
        return productWeight;
    }

    public void setProductWeight(double productWeight) {
        this.productWeight = productWeight;
    }

    public String getFromLocation() {
        return fromLocation;
    }

    public void setFromLocation(String fromLocation) {
        this.fromLocation = fromLocation;
    }

    public String getToLocation() {
        return toLocation;
    }

    public void setToLocation(String toLocation) {
        this.toLocation = toLocation;
    }

    public Date getAddedDate() {
        return addedDate;
    }

    public void setAddedDate(Date addedDate) {
        this.addedDate = addedDate;
    }
}