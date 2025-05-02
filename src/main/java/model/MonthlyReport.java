package model;

import java.time.YearMonth;
import java.math.BigDecimal;

public class MonthlyReport {
    private YearMonth month;
    private int totalDeliveries;
    private BigDecimal totalRevenue;

    public MonthlyReport(YearMonth month, int totalDeliveries, BigDecimal totalRevenue) {
        this.month = month;
        this.totalDeliveries = totalDeliveries;
        this.totalRevenue = totalRevenue;
    }

    public YearMonth getMonth() {
        return month;
    }

    public String getMonthDisplay() {
        return month.toString();
    }

    public int getTotalDeliveries() {
        return totalDeliveries;
    }

    public BigDecimal getTotalRevenue() {
        return totalRevenue;
    }
}