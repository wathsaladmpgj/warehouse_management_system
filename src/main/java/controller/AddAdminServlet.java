import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/AddAdminServlet")
public class AddAdminServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/warehouse_management";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String adminName = request.getParameter("adminName");
        String email = request.getParameter("adminEmail");
        String password = request.getParameter("password");
        String outletLocation = request.getParameter("outletLocation");

        Connection conn = null;
        PreparedStatement checkStmt = null;
        PreparedStatement insertStmt = null;
        ResultSet rs = null;

        try {
            // Load JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Establish connection
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
            
            // First check if email already exists
            String checkEmailSql = "SELECT email FROM admin_register WHERE email = ?";
            checkStmt = conn.prepareStatement(checkEmailSql);
            checkStmt.setString(1, email);
            rs = checkStmt.executeQuery();
            
            if (rs.next()) {
                request.setAttribute("errorMessage", "Email already exists. Please use a different email.");
                request.getRequestDispatcher("/pages/addAdmin.jsp").forward(request, response);
                return;
            }
            
            // Then check if outlet exists
            String checkOutletSql = "SELECT outlet_name FROM outlet_details WHERE outlet_name = ?";
            checkStmt = conn.prepareStatement(checkOutletSql);
            checkStmt.setString(1, outletLocation);
            rs = checkStmt.executeQuery();
            
            if (!rs.next()) {
                request.setAttribute("errorMessage", "Invalid outlet location. Please select a valid outlet from the list.");
                request.getRequestDispatcher("/pages/addAdmin.jsp").forward(request, response);
                return;
            }
            
            // Prepare SQL statement for insertion
            String insertSql = "INSERT INTO admin_register (admin_name, email, password, outlet_location) VALUES (?, ?, ?, ?)";
            insertStmt = conn.prepareStatement(insertSql);
            
            // Set parameters
            insertStmt.setString(1, adminName);
            insertStmt.setString(2, email);
            insertStmt.setString(3, password); // Note: In production, hash the password!
            insertStmt.setString(4, outletLocation);
            
            // Execute query
            int rowsAffected = insertStmt.executeUpdate();
            
            if (rowsAffected > 0) {
                request.setAttribute("successMessage", "Admin registered successfully for " + outletLocation + " outlet!");
            } else {
                request.setAttribute("errorMessage", "Failed to register admin. Please try again.");
            }
        } catch (ClassNotFoundException e) {
            request.setAttribute("errorMessage", "Database driver not found: " + e.getMessage());
            e.printStackTrace();
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            e.printStackTrace();
        } finally {
            // Close resources
            try {
                if (rs != null) rs.close();
                if (checkStmt != null) checkStmt.close();
                if (insertStmt != null) insertStmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        // Forward back to the JSP page
        request.getRequestDispatcher("/pages/addAdmin.jsp").forward(request, response);
    }
}