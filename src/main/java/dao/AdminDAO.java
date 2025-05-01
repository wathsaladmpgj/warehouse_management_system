package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AdminDAO {
    public String getAdminLocation(String adminName) throws SQLException {
        String sql = "SELECT outlet_location FROM admin_register WHERE admin_name = ?";
        try (Connection conn = DBHelper.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, adminName);
            ResultSet rs = stmt.executeQuery();
            return rs.next() ? rs.getString("outlet_location") : null;
        }
    }

    public int getMatchingTrackingCount(String location) throws SQLException {
        String sql = "SELECT COUNT(*) AS count FROM location_tracking WHERE tracking_update = ?";
        try (Connection conn = DBHelper.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, location);
            ResultSet rs = stmt.executeQuery();
            return rs.next() ? rs.getInt("count") : 0;
        }
    }

    public int getTotalRegisteredItems(String outletName) throws SQLException {
        String sql = "SELECT SUM(total_registered_items) AS total FROM outlet_details WHERE outlet_name = ?";
        try (Connection conn = DBHelper.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, outletName);
            ResultSet rs = stmt.executeQuery();
            return rs.next() ? rs.getInt("total") : 0;
        }
    }

    public int getAvailableItemsCount(String outletName) throws SQLException {
        String sql = "SELECT SUM(remaining_returned_items + available_new_items) AS total_available " +
                    "FROM outlet_details WHERE outlet_name LIKE ?";
        try (Connection conn = DBHelper.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, "%" + outletName + "%");
            ResultSet rs = stmt.executeQuery();
            return rs.next() ? rs.getInt("total_available") : 0;
        }
    }

    // NEW METHOD FOR SUCCESS ITEMS COUNT
    public int getSuccessItemsCount(String outletName) throws SQLException {
        String sql = "SELECT SUM(total_registered_items - (remaining_returned_items + available_new_items)) AS success_count " +
                    "FROM outlet_details WHERE outlet_name = ?";
        try (Connection conn = DBHelper.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, outletName);
            ResultSet rs = stmt.executeQuery();
            return rs.next() ? rs.getInt("success_count") : 0;
        }
    }
    
    
    // Add these methods to your existing AdminDAO class


public double getNewItemsTotalPrice(String warehouseLocation) throws SQLException {
    String sql = "SELECT SUM(pp.item_price) AS total " +
                 "FROM product_pricing pp " +
                 "JOIN location_tracking lt ON pp.product_key = lt.product_key " +
                 "WHERE lt.tracking_update = ?";
    
    try (Connection conn = DBHelper.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
         
        stmt.setString(1, warehouseLocation);
        ResultSet rs = stmt.executeQuery();
        
        return rs.next() ? rs.getDouble("total") : 0.0;
    }
}

// Add to AdminDAO.java
public double getRegisteredItemsTotalPrice(String outletLocation) throws SQLException {
    String sql = "SELECT SUM(pp.item_price) AS total " +
                 "FROM product_pricing pp " +
                 "JOIN admin_register ar ON pp.admin_location = ar.outlet_location " +
                 "WHERE ar.outlet_location = ? " +
                 "OR pp.item_prices LIKE 'return%'";
    
    try (Connection conn = DBHelper.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
         
        stmt.setString(1, outletLocation);
        ResultSet rs = stmt.executeQuery();
        
        return rs.next() ? rs.getDouble("total") : 0.0;
    }
}

// Add to AdminDAO.java
public double getAvailableItemsTotalPrice(String outletLocation) throws SQLException {
    String sql = "SELECT SUM(pp.item_price) AS total " +
                 "FROM product_pricing pp " +
                 "JOIN outlet_details od ON pp.admin_location = od.outlet_name " +
                 "WHERE od.outlet_name LIKE ? " +
                 "AND (od.remaining_returned_items > 0 OR od.available_new_items > 0)";
    
    try (Connection conn = DBHelper.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
         
        stmt.setString(1, "%" + outletLocation + "%");
        ResultSet rs = stmt.executeQuery();
        
        return rs.next() ? rs.getDouble("total") : 0.0;
    }
}

public double getSuccessItemsTotalPrice(String outletLocation) throws SQLException {
    String sql = "SELECT SUM(pp.item_price) AS total " +
                 "FROM product_pricing pp " +
                 "JOIN outlet_details od ON pp.admin_location = od.outlet_name " +
                 "WHERE od.outlet_name = ? " +
                 "AND od.total_registered_items > (od.remaining_returned_items + od.available_new_items)";
    
    try (Connection conn = DBHelper.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
         
        stmt.setString(1, outletLocation);
        ResultSet rs = stmt.executeQuery();
        
        return rs.next() ? rs.getDouble("total") : 0.0;
    }
}
    
}