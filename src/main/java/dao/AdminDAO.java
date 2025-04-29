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
}