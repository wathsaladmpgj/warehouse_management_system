package controller;

import java.io.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.sql.*;

@WebServlet("/InsertLocationServlet")
public class InsertLocationServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String location = request.getParameter("location");
        String postalCode = request.getParameter("postal_code");

        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/warehouse_management", "root", "");
             PreparedStatement ps = conn.prepareStatement("INSERT INTO warehouse_postel_codes (location, postal_code) VALUES (?, ?)")) {

            ps.setString(1, location);
            ps.setString(2, postalCode);
            ps.executeUpdate();

            response.sendRedirect("pages/Head_Office_locationForm.jsp?success=true");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("pages/Head_Office_locationForm.jsp?success=false");
        }
    }
}
