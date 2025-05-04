import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/DeleteAdminServlet")
public class DeleteAdminServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/warehouse_management";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
            
            String sql = "DELETE FROM admin_register WHERE email=?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                request.getSession().setAttribute("successMessage", "Admin deleted successfully!");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to delete admin. It may have already been removed.");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Database error: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect(request.getContextPath() + "/pages/addAdmin.jsp");
    }
}