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
        String fromLocation = request.getParameter("fromLocation");
        String toLocation = request.getParameter("toLocation");
        String trackingDate = request.getParameter("trackingDate");

        String dbURL = "jdbc:mysql://localhost:3306/warehouse_management";
        String dbUser = "root";
        String dbPass = "";

        String message = "";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

            String updateSQL = "UPDATE location_tracking SET tracking_update = ? " +
                               "WHERE from_location = ? AND to_location = ? AND tracking_date = ?";

            PreparedStatement pstmt = conn.prepareStatement(updateSQL);

            if (adminLocation.equalsIgnoreCase(fromLocation)) {
                pstmt.setString(1, "ship");
            } else if (adminLocation.equalsIgnoreCase(toLocation)) {
                pstmt.setString(1, adminLocation);
            } else {
                message = "Admin location doesn't match either from or to location. No update done.";
                request.getSession().setAttribute("alertMessage", message);
                response.sendRedirect("pages/updateTracking.jsp");
                conn.close();
                return;
            }

            pstmt.setString(2, fromLocation);
            pstmt.setString(3, toLocation);
            pstmt.setDate(4, Date.valueOf(trackingDate));

            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                message = "Tracking updateud successfully for " + rowsAffected + " record(s).";
            } else {
                message = "No matching records found.";
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            message = "Error: " + e.getMessage();
        }

        request.getSession().setAttribute("alertMessage", message);
        response.sendRedirect("pages/updateTracking.jsp");
    }
}
