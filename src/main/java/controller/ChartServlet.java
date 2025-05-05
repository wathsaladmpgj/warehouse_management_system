package controller;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/ChartServlet")
public class ChartServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String selectedYear = request.getParameter("year");
        if (selectedYear == null) {
            selectedYear = "2025"; // default
        }

        String[] months = {"Jan", "Feb", "Mar", "Apr", "May", "Jun",
                           "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
        double[] prices = new double[12]; // index 0 = Jan

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/warehouse_management", "root", "");

            PreparedStatement ps = con.prepareStatement(
                "SELECT MONTH(price_date) AS month, SUM(item_price) AS total_price " +
                "FROM product_pricing WHERE YEAR(price_date) = ? GROUP BY MONTH(price_date)");
            ps.setString(1, selectedYear);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                int monthIndex = rs.getInt("month") - 1;
                prices[monthIndex] = rs.getDouble("total_price");
            }

            request.setAttribute("months", months);
            request.setAttribute("prices", prices);
            request.setAttribute("selectedYear", selectedYear);
        } catch (Exception e) {
            e.printStackTrace();
        }

        RequestDispatcher rd = request.getRequestDispatcher("pages/chart.jsp");
        rd.forward(request, response);
    }
}
