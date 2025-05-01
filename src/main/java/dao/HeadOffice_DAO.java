package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class HeadOffice_DAO {
    //HeadOfiice_Dashboard fetch Data
    public int getRowCountTotalRegisteredItems() {
        System.out.println("DEBUG: Starting getRowCountTotalRegisteredItems");
        int count = 0;
        String query = "SELECT SUM(total_registered_items) AS total FROM outlet_details";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            
            System.out.println("DEBUG: Query executed: " + query);
            
            if (rs.next()) {
                count = rs.getInt("total");
                System.out.println("DEBUG: Count retrieved: " + count);
            } else {
                System.out.println("DEBUG: No results from count query");
            }
        } catch (SQLException e) {
            System.err.println("DEBUG: SQL Error in getRowCountTotalRegisteredItems");
            e.printStackTrace();
        }
        
        System.out.println("DEBUG: Returning count: " + count);
        return count;
    }
    
    public int getTotalReturnedItems() {
        System.out.println("DEBUG: Starting getTotalReturnedItems");
        int totalReturned = 0;
        String query = "SELECT SUM(total_returned_items) AS total_returned FROM outlet_details";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            
            System.out.println("DEBUG: Query executed: " + query);
            
            if (rs.next()) {
                totalReturned = rs.getInt("total_returned");
                System.out.println("DEBUG: Total returned items retrieved: " + totalReturned);
            } else {
                System.out.println("DEBUG: No results from sum query");
            }
        } catch (SQLException e) {
            System.err.println("DEBUG: SQL Error in getTotalReturnedItems");
            e.printStackTrace();
        }
        
        System.out.println("DEBUG: Returning total returned items: " + totalReturned);
        return totalReturned;
    }
    
    public int getOutletCount() {
        System.out.println("DEBUG: Starting getOutletCount");
        int outletCount = 0;
        String query = "SELECT COUNT(*) AS outletCount FROM outlet_details";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            
            System.out.println("DEBUG: Query executed: " + query);
            
            if (rs.next()) {
                outletCount = rs.getInt("outletCount");
                System.out.println("DEBUG: outletCount items retrieved: " + outletCount);
            } else {
                System.out.println("DEBUG: No results from sum query");
            }
        } catch (SQLException e) {
            System.err.println("DEBUG: SQL Error in getoutletCount");
            e.printStackTrace();
        }
        
        System.out.println("DEBUG: Returning total outlets : " + outletCount);
        return outletCount;
    }
    
    public int getRemainingReturnedItems() {
        System.out.println("DEBUG: getRemainingReturnedItems");
        int remaining_returned_items = 0;
        String query = "SELECT SUM(remaining_returned_items) AS remaining_returned_items FROM outlet_details";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            
            System.out.println("DEBUG: Query executed: " + query);
            
            if (rs.next()) {
                remaining_returned_items = rs.getInt("remaining_returned_items");
                System.out.println("DEBUG: remaining_returned_items items retrieved: " + remaining_returned_items);
            } else {
                System.out.println("DEBUG: No results from sum query");
            }
        } catch (SQLException e) {
            System.err.println("DEBUG: SQL Error in remaining_returned_items");
            e.printStackTrace();
        }
        
        System.out.println("DEBUG: Returning total returned items: " + remaining_returned_items);
        return remaining_returned_items;
    }
    
    
    public int getAvailableNewItems() {
        System.out.println("DEBUG: getAvailableNewItems");
        int available_new_items = 0;
        String query = "SELECT SUM(available_new_items) AS available_new_items FROM outlet_details";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            
            System.out.println("DEBUG: Query executed: " + query);
            
            if (rs.next()) {
                available_new_items = rs.getInt("available_new_items");
                System.out.println("DEBUG: available_new_items  retrieved: " + available_new_items);
            } else {
                System.out.println("DEBUG: No results from sum query");
            }
        } catch (SQLException e) {
            System.err.println("DEBUG: SQL Error in available_new_items");
            e.printStackTrace();
        }
        
        System.out.println("DEBUG: Returning total available_new_items items: " + available_new_items);
        return available_new_items;
    }
    
    public int getStaffCount() {
        System.out.println("DEBUG: getStaffCount");
        int staffCount = 0;
        String query = "SELECT COUNT(*) AS staffCount FROM staff_management";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            
            System.out.println("DEBUG: Query executed: " + query);
            
            if (rs.next()) {
                staffCount = rs.getInt("staffCount");
                System.out.println("DEBUG: staffCount  retrieved: " + staffCount);
            } else {
                System.out.println("DEBUG: No results from sum query");
            }
        } catch (SQLException e) {
            System.err.println("DEBUG: SQL Error in staffCount");
            e.printStackTrace();
        }
        
        System.out.println("DEBUG: Returning total staffCount : " + staffCount);
        return staffCount;
    }
    
    
    //HeadOfiice_StaffDetails fetch Data
    
    
    
    
    
    
    
    
    
    
    
    
    // Updated main method for direct testing
    public static void main(String[] args) {
        HeadOffice_DAO dao = new HeadOffice_DAO();
        
        int count = dao.getRowCountTotalRegisteredItems();
        System.out.println("Direct test - Total registered items: " + count);
        
        int returned = dao.getTotalReturnedItems();
        System.out.println("Direct test - Total returned items: " + returned);
        
        int outletCount = dao.getOutletCount();
        System.out.println("Direct test - getOutletCount: " + outletCount);
        
        int getRemainingReturnedItems = dao.getRemainingReturnedItems();
        System.out.println("Direct test - getRemainingReturnedItems: " + getRemainingReturnedItems);
        
        int getAvailableNewItems = dao.getAvailableNewItems();
        System.out.println("Direct test - getAvailableNewItems: " + getAvailableNewItems);
        
        int getStaffCount = dao.getStaffCount();
        System.out.println("Direct test - getStaffCount: " + getStaffCount);
    }
}