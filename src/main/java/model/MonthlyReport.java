package model;

import java.math.BigDecimal;

public class MonthlyReport {
    private String month;
    private int totalDeliveries;
    private BigDecimal totalRevenue;
    
    public MonthlyReport() {
    }
    
    public MonthlyReport(String month, int totalDeliveries, BigDecimal totalRevenue) {
        this.month = month;
        this.totalDeliveries = totalDeliveries;
        this.totalRevenue = totalRevenue;
    }

    // Getters and Setters
    public String getMonth() {
        return month;
    }

    public void setMonth(String month) {
        this.month = month;
    }

    public int getTotalDeliveries() {
        return totalDeliveries;
    }

    public void setTotalDeliveries(int totalDeliveries) {
        this.totalDeliveries = totalDeliveries;
    }

    public BigDecimal getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(BigDecimal totalRevenue) {
        this.totalRevenue = totalRevenue;
    }
}