package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Staff;

public class StaffDAO {
    public List<Staff> getAllStaff() {
        List<Staff> staff = new ArrayList<>();
     
        String sql = "SELECT * FROM staff_management";
        
        try(
            Connection conn = DBConnection.getConnection();
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql);  
           )       
        {
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
}
