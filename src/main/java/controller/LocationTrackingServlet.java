package controller;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/LocationTrackingServlet")
public class LocationTrackingServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/warehouse_management";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String mode = request.getParameter("mode");
        String inputValue = request.getParameter("inputValue");
        String message = null;

        if ("add".equals(action)) {
            List<Map<String, Object>> results = new ArrayList<>();
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {
                String sql = "SELECT * FROM location_tracking WHERE product_key = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, inputValue);
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            Map<String, Object> row = new HashMap<>();
                            row.put("id", rs.getInt("id"));
                            row.put("product_key", rs.getString("product_key"));
                            row.put("from_location", rs.getString("from_location"));
                            row.put("to_location", rs.getString("to_location"));
                            row.put("tracking_date", rs.getDate("tracking_date"));
                            row.put("tracking_update", rs.getString("tracking_update"));
                            results.add(row);
                        }
                    }
                }
            } catch (SQLException e) {
                throw new ServletException(e);
            }

            request.setAttribute("results", results);
            request.setAttribute("mode", mode);
            request.setAttribute("inputValue", inputValue);
        }

        else if ("update".equals(action)) {
            String selectedId = request.getParameter("selectedId");
            String updateValue = "";

            if ("ReturnShip".equals(mode)) {
                updateValue = "Return_shiped";

                try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {
                    // Fetch current from/to
                    String query = "SELECT from_location, to_location FROM location_tracking WHERE id=?";
                    String fromLocation = "";
                    String toLocation = "";

                    try (PreparedStatement ps = conn.prepareStatement(query)) {
                        ps.setInt(1, Integer.parseInt(selectedId));
                        try (ResultSet rs = ps.executeQuery()) {
                            if (rs.next()) {
                                fromLocation = rs.getString("from_location");
                                toLocation = rs.getString("to_location");
                            }
                        }
                    }

                    // Swap locations + update tracking
                    String updateSQL = "UPDATE location_tracking SET tracking_update=?, from_location=?, to_location=? WHERE id=?";
                    try (PreparedStatement ps = conn.prepareStatement(updateSQL)) {
                        ps.setString(1, updateValue);
                        ps.setString(2, toLocation); // Swapped
                        ps.setString(3, fromLocation);
                        ps.setInt(4, Integer.parseInt(selectedId));
                        int rows = ps.executeUpdate();
                        message = (rows > 0) ? "Tracking updated with location swap!" : "Update failed!";
                    }
                } catch (SQLException e) {
                    throw new ServletException(e);
                }

            } else if ("ReturnUser".equals(mode)) {
                updateValue = "ReturnUser";
            } else if ("Success".equals(mode)) {
                updateValue = "Success";
            }

            // Simple update if not ReturnShip
            if (!"ReturnShip".equals(mode)) {
                try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {
                    String sql = "UPDATE location_tracking SET tracking_update=? WHERE id=?";
                    try (PreparedStatement ps = conn.prepareStatement(sql)) {
                        ps.setString(1, updateValue);
                        ps.setInt(2, Integer.parseInt(selectedId));
                        int rows = ps.executeUpdate();
                        message = (rows > 0) ? "Tracking update successful!" : "Update failed!";
                    }
                } catch (SQLException e) {
                    throw new ServletException(e);
                }
            }

            request.setAttribute("message", message);
        }

        RequestDispatcher rd = request.getRequestDispatcher("pages/updateTracking.jsp");
        rd.forward(request, response);
    }
}
