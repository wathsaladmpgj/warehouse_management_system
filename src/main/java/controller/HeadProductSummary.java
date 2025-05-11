package controller;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet(name = "HeadProductSummary", urlPatterns = {"/HeadProductSummary"})
public class HeadProductSummary extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Set default to current year (2025)
        int currentYear = Calendar.getInstance().get(Calendar.YEAR);
        int year = currentYear;
        
        // Check if year parameter exists
        String yearParam = request.getParameter("year");
        if (yearParam != null && !yearParam.isEmpty()) {
            try {
                year = Integer.parseInt(yearParam);
            } catch (NumberFormatException e) {
                year = currentYear; // Fallback to current year if invalid
            }
        }
        
        // Get data for the selected year
        List<Map<String, Object>> summaryList = getSummaryData(year);
        
        // Calculate yearly summary statistics
        Map<String, Object> yearlyStats = calculateYearlyStats(summaryList);
        
        // Set attributes for JSP
        request.setAttribute("year", year);
        request.setAttribute("summaryList", summaryList != null ? summaryList : new ArrayList<>());
        request.setAttribute("totalItems", yearlyStats.get("totalItems"));
        request.setAttribute("totalRevenue", yearlyStats.get("totalRevenue"));
        request.setAttribute("avgMonthly", yearlyStats.get("avgMonthly"));
        
        // Forward to JSP
        request.getRequestDispatcher("/pages/headOffice_product_summar.jsp").forward(request, response);
    }

    private List<Map<String, Object>> getSummaryData(int year) {
        List<Map<String, Object>> summaryList = new ArrayList<>();
        
        String[] monthNames = {"January", "February", "March", "April", "May", "June",
                             "July", "August", "September", "October", "November", "December"};
        
        try (Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/warehouse_management", "root", "");
             PreparedStatement ps = con.prepareStatement(
                "SELECT MONTH(price_date) AS month, COUNT(*) AS items, SUM(item_price) AS total_price " +
                "FROM product_pricing WHERE YEAR(price_date) = ? GROUP BY MONTH(price_date) ORDER BY month")) {
            
            // Load JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            ps.setInt(1, year);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                int monthIndex = rs.getInt("month") - 1;
                row.put("month", monthNames[monthIndex]);
                row.put("items", rs.getInt("items"));
                row.put("total_price", rs.getDouble("total_price"));
                summaryList.add(row);
            }
            
        } catch (ClassNotFoundException e) {
            System.err.println("JDBC Driver not found: " + e.getMessage());
        } catch (SQLException e) {
            System.err.println("Database error: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("Unexpected error: " + e.getMessage());
        }
        
        return summaryList;
    }

    private Map<String, Object> calculateYearlyStats(List<Map<String, Object>> monthlyData) {
        Map<String, Object> stats = new HashMap<>();
        int totalItems = 0;
        double totalRevenue = 0.0;
        
        // Calculate totals from monthly data
        for (Map<String, Object> month : monthlyData) {
            totalItems += (int) month.get("items");
            totalRevenue += (double) month.get("total_price");
        }
        
        // Calculate average monthly revenue
        double avgMonthly = monthlyData.isEmpty() ? 0.0 : totalRevenue / monthlyData.size();
        
        stats.put("totalItems", totalItems);
        stats.put("totalRevenue", totalRevenue);
        stats.put("avgMonthly", avgMonthly);
        
        return stats;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Monthly Product Summary Servlet";
    }
}