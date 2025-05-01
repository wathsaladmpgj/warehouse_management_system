package controller;

import model.Admin;
import service.AdminService;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import javax.servlet.annotation.WebServlet;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private final AdminService adminService = new AdminService();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String adminName = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            String adminLocation = adminService.getAdminLocation(adminName);
            
            if (adminLocation != null) {
                HttpSession session = request.getSession();
                Admin admin = new Admin(adminName, adminLocation);
                session.setAttribute("admin", admin);
                
                int trackingCount = adminService.getMatchingTrackingCount(adminLocation);
                session.setAttribute("trackingCount", trackingCount);
                
                int totalRegisteredItems = adminService.getTotalRegisteredItems(adminLocation);
                session.setAttribute("totalRegisteredItems", totalRegisteredItems);
                
                int availableItemsCount = adminService.getAvailableItemsCount(adminLocation);
                session.setAttribute("availableItemsCount", availableItemsCount);
                
                // NEW: Add success items count to session
                int successItemsCount = adminService.getSuccessItemsCount(adminLocation);
                session.setAttribute("successItemsCount", successItemsCount);
                
                // Add to LoginServlet.java
                double availableItemsTotalPrice = adminService.getAvailableItemsTotalPrice(adminLocation);
                session.setAttribute("availableItemsTotalPrice", availableItemsTotalPrice);

                double successItemsTotalPrice = adminService.getSuccessItemsTotalPrice(adminLocation);
                session.setAttribute("successItemsTotalPrice", successItemsTotalPrice);
                
                response.sendRedirect("pages/OutletDashBoard.jsp");
            } else {
                request.setAttribute("error", "Invalid credentials");
                request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error. Please try again.");
            request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
        }
    }
}