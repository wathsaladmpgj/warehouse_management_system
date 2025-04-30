package dao;

import model.MonthlyReport;
import java.sql.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/warehouse_management";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "";
    
    public List<MonthlyReport> getMonthlyReports(String outletLocation) {
        List<MonthlyReport> reports = new ArrayList<>();
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS);
            
            // Query to get monthly stats from product_details and product_pricing
            String sql = "SELECT DATE_FORMAT(pd.added_date, '%Y-%m') as month, " +
                         "COUNT(*) as total_deliveries, " +
                         "SUM(pp.item_price) as total_revenue " +
                         "FROM product_details pd " +
                         "JOIN product_pricing pp ON pd.product_key = pp.product_key " +
                         "WHERE pd.from_location = ? OR pd.to_location = ? " +
                         "GROUP BY DATE_FORMAT(pd.added_date, '%Y-%m') " +
                         "ORDER BY month";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, outletLocation);
            stmt.setString(2, outletLocation);
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                String month = rs.getString("month");
                int totalDeliveries = rs.getInt("total_deliveries");
                BigDecimal totalRevenue = rs.getBigDecimal("total_revenue");
                
                // Format month from YYYY-MM to Month YYYY
                String[] parts = month.split("-");
                String formattedMonth = getMonthName(Integer.parseInt(parts[1])) + " " + parts[0];
                
                reports.add(new MonthlyReport(formattedMonth, totalDeliveries, totalRevenue));
            }
            
            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return reports;
    }
    
    private String getMonthName(int month) {
        String[] monthNames = {"January", "February", "March", "April", "May", "June", 
                             "July", "August", "September", "October", "November", "December"};
        return monthNames[month - 1];
    }
}