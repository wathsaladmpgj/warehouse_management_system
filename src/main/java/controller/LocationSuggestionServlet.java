package controller;

import java.io.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.sql.*;

@WebServlet("/LocationSuggestionServlet")
public class LocationSuggestionServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String query = request.getParameter("query");
        response.setContentType("text/html");

        try (PrintWriter out = response.getWriter();
             Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/warehouse_management", "root", "");
             PreparedStatement ps = conn.prepareStatement("SELECT DISTINCT outlet_name FROM outlet_details WHERE outlet_name LIKE ? LIMIT 5")) {

            ps.setString(1, query + "%");
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                out.println("<div onclick='fillSuggestion(\"" + rs.getString("outlet_name") + "\")'>" + rs.getString("outlet_name") + "</div>");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
