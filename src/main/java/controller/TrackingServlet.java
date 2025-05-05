package controller;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;

@WebServlet("/tracking")
public class TrackingServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String productKey = request.getParameter("product_key").trim();
        String fromLocation = "", toLocation = "", receiverLocation = "", trackingUpdate = "";

        if (productKey == null || productKey.isEmpty()) {
            request.setAttribute("error", "Product key is missing.");
            request.getRequestDispatcher("pages/tracking.jsp").forward(request, response);
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/warehouse_management", "root", "")) {

                // Fetch location details
                try (PreparedStatement ps1 = conn.prepareStatement(
                        "SELECT TRIM(from_location) as from_location, TRIM(to_location) as to_location, " +
                                "TRIM(receiver_location) as receiver_location FROM product_details WHERE product_key = ?")) {
                    ps1.setString(1, productKey);
                    ResultSet rs1 = ps1.executeQuery();
                    if (rs1.next()) {
                        fromLocation = rs1.getString("from_location");
                        toLocation = rs1.getString("to_location");
                        receiverLocation = rs1.getString("receiver_location");
                    }
                }

                // Fetch latest tracking update
                try (PreparedStatement ps2 = conn.prepareStatement(
                        "SELECT TRIM(tracking_update) as tracking_update FROM location_tracking " +
                                "WHERE product_key = ?")) {
                    ps2.setString(1, productKey);
                    ResultSet rs2 = ps2.executeQuery();
                    if (rs2.next()) {
                        trackingUpdate = rs2.getString("tracking_update");
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("productKey", productKey);
        request.setAttribute("fromLocation", fromLocation);
        request.setAttribute("toLocation", toLocation);
        request.setAttribute("receiverLocation", receiverLocation);
        request.setAttribute("trackingUpdate", trackingUpdate);

        RequestDispatcher dispatcher = request.getRequestDispatcher("pages/tracking.jsp");
        dispatcher.forward(request, response);
    }
}
