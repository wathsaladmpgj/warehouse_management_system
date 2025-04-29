import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/AddProductServlet")
public class AddProductServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/your_database_name"; // Replace with your DB
    private static final String DB_USER = "your_username"; // Replace with your username
    private static final String DB_PASS = "your_password"; // Replace with your password

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String senderName = request.getParameter("senderName");
        String receiverName = request.getParameter("receiverName");
        String postalCode = request.getParameter("postalCode");
        String receiverLocation = request.getParameter("receiverLocation");
        String productWeightStr = request.getParameter("productWeight");
        String fromLocation = request.getParameter("fromLocation");
        String date = request.getParameter("date");

        // Generate a unique product key (you may change logic)
        String productKey = UUID.randomUUID().toString().replace("-", "").substring(0, 12);

        try {
            double productWeight = Double.parseDouble(productWeightStr);

            // JDBC connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            String sql = "INSERT INTO your_table_name " +
                         "(sender_name, receiver_name, postal_code, receiver_location, product_key, product_weight, from_location, to_location, added_date) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, senderName);
            stmt.setString(2, receiverName);
            stmt.setString(3, postalCode);
            stmt.setString(4, receiverLocation);
            stmt.setString(5, productKey);
            stmt.setDouble(6, productWeight);
            stmt.setString(7, fromLocation);
            stmt.setString(8, receiverLocation); // to_location is same as receiver_location
            stmt.setString(9, date); // assuming it's in yyyy-MM-dd format

            int result = stmt.executeUpdate();

            if (result > 0) {
                request.setAttribute("successMessage", "Product added successfully.");
            } else {
                request.setAttribute("errorMessage", "Failed to add product.");
            }

            stmt.close();
            conn.close();
        } catch (NumberFormatException | ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
        }

        request.getRequestDispatcher("/pages/addProduct.jsp").forward(request, response);
    }
}
