package dao;

import model.Admin;
import java.sql.*;

public class AdminDAO {
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/warehouse_management";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "";

    public Admin validateAdmin(String adminName, String password) {
        Admin admin = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASS);
            String sql = "SELECT * FROM admin_register WHERE admin_name=? AND password=?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, adminName);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                admin = new Admin();
                admin.setId(rs.getInt("id"));
                admin.setAdminName(rs.getString("admin_name"));
                admin.setEmail(rs.getString("email"));
                admin.setPassword(rs.getString("password"));
                admin.setOutletLocation(rs.getString("outlet_location"));
            }
            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return admin;
    }
}
