package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Staff;

public class StaffDAO {
    // Get all staff
    public List<Staff> getAllStaff() {
        List<Staff> staff = new ArrayList<>();
        String sql = "SELECT * FROM staff_management";
        
        try(Connection conn = DBConnection.getConnection();
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Staff staffDetail = new Staff();
                staffDetail.setId(rs.getInt("id"));
                staffDetail.setName(rs.getString("name"));
                staffDetail.setRole(rs.getString("role"));
                staffDetail.setLocation(rs.getString("location"));
                staff.add(staffDetail);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return staff;
    }

    // Add new staff
    public boolean addStaff(Staff staff) {
        String sql = "INSERT INTO staff_management (name, role, location) VALUES (?, ?, ?)";
        
        try(Connection conn = DBConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, staff.getName());
            pstmt.setString(2, staff.getRole());
            pstmt.setString(3, staff.getLocation());
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get staff by ID
    public Staff getStaffById(int id) {
        String sql = "SELECT * FROM staff_management WHERE id = ?";
        Staff staff = new Staff();
        
        try(Connection conn = DBConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                staff.setId(rs.getInt("id"));
                staff.setName(rs.getString("name"));
                staff.setRole(rs.getString("role"));
                staff.setLocation(rs.getString("location"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return staff;
    }

    // Update staff
    public boolean updateStaff(Staff staff) {
        String sql = "UPDATE staff_management SET name = ?, role = ?, location = ? WHERE id = ?";
        
        try(Connection conn = DBConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, staff.getName());
            pstmt.setString(2, staff.getRole());
            pstmt.setString(3, staff.getLocation());
            pstmt.setInt(4, staff.getId());
            
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete staff
    public boolean deleteStaff(int id) {
        String sql = "DELETE FROM staff_management WHERE id = ?";
        
        try(Connection conn = DBConnection.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}