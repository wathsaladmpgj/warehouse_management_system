package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
<<<<<<< HEAD
    private static final String URL = "jdbc:mysql://localhost:3306/library_db";
=======
    private static final String URL = "jdbc:mysql://localhost:3306/warehouse_management";
>>>>>>> 452882442eb94d8526aa93362a550278ea0837e0
    private static final String USER = "root";
    private static final String PASSWORD = ""; // Your database password
    
    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL JDBC Driver not found", e);
        }
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}