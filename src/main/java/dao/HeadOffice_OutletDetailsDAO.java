package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.HeadOffice_OutletDetails;

public class HeadOffice_OutletDetailsDAO {

    public HeadOffice_OutletDetails getHighestPerformingOutlet() {
        String sql = "SELECT * FROM outlet_details ORDER BY total_registered_items DESC LIMIT 1";

        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                HeadOffice_OutletDetails outlet = new HeadOffice_OutletDetails();
                outlet.setId(rs.getInt("id"));
                outlet.setOutletName(rs.getString("outlet_name"));
                outlet.setTotalRegisteredItems(rs.getInt("total_registered_items"));
                outlet.setTotalReturnedItems(rs.getInt("total_returned_items"));
                outlet.setRemainingReturnedItems(rs.getInt("remaining_returned_items"));
                outlet.setAvailableNewItems(rs.getInt("available_new_items"));
                return outlet;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    ////////////////////////////////////////////////////////////////////////////////////
    public List<HeadOffice_OutletDetails> getAllOutletDetails() {
        List<HeadOffice_OutletDetails> headOffice_OutletDetails = new ArrayList<>();

        String sql = "SELECT * FROM outlet_details";

        try (
                Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql);) {
            while (rs.next()) {
                HeadOffice_OutletDetails headOffice_OutletDetailsTemp = new HeadOffice_OutletDetails();
                headOffice_OutletDetailsTemp.setId(rs.getInt("id"));
                headOffice_OutletDetailsTemp.setOutletName(rs.getString("outlet_name"));
                headOffice_OutletDetailsTemp.setTotalRegisteredItems(rs.getInt("total_registered_items"));
                headOffice_OutletDetailsTemp.setTotalReturnedItems(rs.getInt("total_returned_items"));
                headOffice_OutletDetailsTemp.setRemainingReturnedItems(rs.getInt("remaining_returned_items"));
                headOffice_OutletDetailsTemp.setAvailableNewItems(rs.getInt("available_new_items"));
                headOffice_OutletDetails.add(headOffice_OutletDetailsTemp);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return headOffice_OutletDetails;
    }

    ////////////////////////////////////
    public boolean addNewOutlet(String outletName) {
        String sql = "INSERT INTO outlet_details (outlet_name, total_registered_items, total_returned_items, "
                + "remaining_returned_items, available_new_items) VALUES (?, 0, 0, 0, 0)";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, outletName);
            int rowsAffected = pstmt.executeUpdate();

            return rowsAffected > 0; // Returns true if insertion was successful

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteOutlet(int id) {
        try (Connection conn = DBConnection.getConnection()) {
            // 1. Get outlet_name before deletion (since others reference it)
            String outletName;
            String getNameSQL = "SELECT outlet_name FROM outlet_details WHERE id = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(getNameSQL)) {
                pstmt.setInt(1, id);
                ResultSet rs = pstmt.executeQuery();
                if (!rs.next()) {
                    return false; // Outlet not found
                }
                outletName = rs.getString("outlet_name");
            }

            // 2. Delete dependent records
            String[] deleteSQLs = {
                "DELETE FROM admin_register WHERE outlet_location = ?",
                "DELETE FROM product_pricing WHERE admin_location = ?",
                "DELETE FROM staff_management WHERE location = ?"
            };

            for (String sql : deleteSQLs) {
                try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    pstmt.setString(1, outletName);
                    pstmt.executeUpdate();
                }
            }

            // 3. Now delete the outlet
            try (PreparedStatement pstmt = conn.prepareStatement(
                    "DELETE FROM outlet_details WHERE id = ?")) {
                pstmt.setInt(1, id);
                return pstmt.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    ///////
    public List<String> getOutletLocations() {
        List<String> outletLocations = new ArrayList<>();
        String sql = "SELECT outlet_name FROM outlet_details";

        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                outletLocations.add(rs.getString("outlet_name"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return outletLocations;
    }
}
