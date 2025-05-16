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
        String fromLocationForm = request.getParameter("fromLocation").trim();
        String toLocationForm = request.getParameter("toLocation").trim();
        String trackingDateForm = request.getParameter("trackingDate").trim();

        String dbURL = "jdbc:mysql://localhost:3306/warehouse_management";
        String dbUser = "root";
        String dbPass = "";

        String message = "";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

            String selectQuery = "SELECT id, from_location, to_location, tracking_update FROM location_tracking " +
                                 "WHERE from_location = ? AND to_location = ? AND tracking_date = ?";
            PreparedStatement selectStmt = conn.prepareStatement(selectQuery);
            selectStmt.setString(1, fromLocationForm);
            selectStmt.setString(2, toLocationForm);
            selectStmt.setString(3, trackingDateForm);

            ResultSet rs = selectStmt.executeQuery();

            int totalUpdated = 0;
            int totalShippedFromAdmin = 0; // to track how many items are shipped from adminLocation

            while (rs.next()) {
                int id = rs.getInt("id");
                String fromLocation = rs.getString("from_location").trim();
                String toLocation = rs.getString("to_location").trim();
                String trackingUpdate = rs.getString("tracking_update").trim();
                String newTrackingUpdate = null;

                if (fromLocation.equalsIgnoreCase(adminLocation) && trackingUpdate.equalsIgnoreCase(adminLocation)) {
                    newTrackingUpdate = "ship";
                    totalShippedFromAdmin++;
                } else if (toLocation.equalsIgnoreCase(adminLocation) && trackingUpdate.equalsIgnoreCase("ship")) {
                    newTrackingUpdate = adminLocation;
                } else if (toLocation.equalsIgnoreCase(adminLocation) && trackingUpdate.equalsIgnoreCase("Return_shiped")) {
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

            // Subtract from available_new_items in outlet_details
            if (totalShippedFromAdmin > 0) {
                String updateOutletQuery = "UPDATE outlet_details SET available_new_items = available_new_items - ? WHERE outlet_name = ?";
                PreparedStatement outletStmt = conn.prepareStatement(updateOutletQuery);
                outletStmt.setInt(1, totalShippedFromAdmin);
                outletStmt.setString(2, adminLocation);
                outletStmt.executeUpdate();
                outletStmt.close();
            }

            conn.close();

            if (totalUpdated > 0) {
                message = "✅ Tracking updated for " + totalUpdated + " record(s).";
                if (totalShippedFromAdmin > 0) {
                    message += " Available items reduced by " + totalShippedFromAdmin + ".";
                }
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
