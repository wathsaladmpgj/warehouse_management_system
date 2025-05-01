package controller;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/updateTracking")
public class UpdateTrackingServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String adminLocation = request.getParameter("adminLocation");

        String dbURL = "jdbc:mysql://localhost:3306/warehouse_management"; // ✅ Your DB
        String dbUser = "root";                                            // ✅ DB username
        String dbPass = "";                                                // ✅ DB password

        String message = "";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

            // Select all records from the table
            String selectQuery = "SELECT id, from_location, to_location, tracking_update FROM location_tracking";
            Statement selectStmt = conn.createStatement();
            ResultSet rs = selectStmt.executeQuery(selectQuery);

            int totalUpdated = 0;

            while (rs.next()) {
                int id = rs.getInt("id");
                String fromLocation = rs.getString("from_location").trim();
                String toLocation = rs.getString("to_location").trim();
                String trackingUpdate = rs.getString("tracking_update").trim();
                String newTrackingUpdate = null;

                // Rule 1: from_location == adminLocation AND tracking_update == adminLocation → "ship"
                if (fromLocation.equalsIgnoreCase(adminLocation) && trackingUpdate.equalsIgnoreCase(adminLocation)) {
                    newTrackingUpdate = "ship";
                }

                // Rule 2: to_location == adminLocation AND tracking_update == "ship" → adminLocation
                else if (toLocation.equalsIgnoreCase(adminLocation) && trackingUpdate.equalsIgnoreCase("ship")) {
                    newTrackingUpdate = adminLocation;
                }

                // Rule 3: to_location == adminLocation AND tracking_update == "Return_shipped" → "Return" + adminLocation
                else if (toLocation.equalsIgnoreCase(adminLocation) && trackingUpdate.equalsIgnoreCase("Return_shipped")) {
                    newTrackingUpdate = "Return" + adminLocation;
                }

                if (newTrackingUpdate != null) {
                    String updateQuery = "UPDATE location_tracking SET tracking_update = ? WHERE id = ?";
                    PreparedStatement updateStmt = conn.prepareStatement(updateQuery);
                    updateStmt.setString(1, newTrackingUpdate);
                    updateStmt.setInt(2, id);
                    updateStmt.executeUpdate();
                    updateStmt.close();
                    totalUpdated++;
                }
            }

            rs.close();
            selectStmt.close();
            conn.close();

            if (totalUpdated > 0) {
                message = "✅ Tracking updated successfully for " + totalUpdated + " record(s).";
            } else {
                message = "➖ No matching records found for update.";
            }

        } catch (Exception e) {
            e.printStackTrace();
            message = "❌ Error: " + e.getMessage();
        }

        request.getSession().setAttribute("alertMessage", message);
        response.sendRedirect("pages/updateTracking.jsp");
    }
}
