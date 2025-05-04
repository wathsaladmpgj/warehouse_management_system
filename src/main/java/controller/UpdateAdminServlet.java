import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/UpdateAdminServlet")
public class UpdateAdminServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/warehouse_management";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String originalEmail = request.getParameter("originalEmail");
        String adminName = request.getParameter("adminName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String outletLocation = request.getParameter("outletLocation");

        Connection conn = null;
        PreparedStatement checkStmt = null;
        PreparedStatement updateStmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
            
            // First check if new email already exists (if email is being changed)
            if (!originalEmail.equals(email)) {
                String checkEmailSql = "SELECT email FROM admin_register WHERE email = ?";
                checkStmt = conn.prepareStatement(checkEmailSql);
                checkStmt.setString(1, email);
                rs = checkStmt.executeQuery();
                
                if (rs.next()) {
                    request.setAttribute("errorMessage", "Email already exists. Please use a different email.");
                    request.getRequestDispatcher("/pages/addAdmin.jsp").forward(request, response);
                    return;
                }
            }
            
            // Check if outlet exists
            String checkOutletSql = "SELECT outlet_name FROM outlet_details WHERE outlet_name = ?";
            checkStmt = conn.prepareStatement(checkOutletSql);
            checkStmt.setString(1, outletLocation);
            rs = checkStmt.executeQuery();
            
            if (!rs.next()) {
                request.setAttribute("errorMessage", "Invalid outlet location. Please select a valid outlet from the list.");
                request.getRequestDispatcher("/pages/addAdmin.jsp").forward(request, response);
                return;
            }
            
            // Prepare update statement
            String updateSql = "UPDATE admin_register SET admin_name=?, email=?, password=?, outlet_location=? WHERE email=?";
            updateStmt = conn.prepareStatement(updateSql);
            updateStmt.setString(1, adminName);
            updateStmt.setString(2, email);
            updateStmt.setString(3, password); // Note: In production, hash the password!
            updateStmt.setString(4, outletLocation);
            updateStmt.setString(5, originalEmail);
            
            int rowsAffected = updateStmt.executeUpdate();
            
            if (rowsAffected > 0) {
                request.setAttribute("successMessage", "Admin updated successfully!");
            } else {
                request.setAttribute("errorMessage", "Failed to update admin. No changes made.");
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (checkStmt != null) checkStmt.close();
                if (updateStmt != null) updateStmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect(request.getContextPath() + "/pages/addAdmin.jsp");
    }
}