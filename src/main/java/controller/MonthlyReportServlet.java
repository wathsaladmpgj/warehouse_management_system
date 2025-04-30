package controller;

import model.Admin;
import model.MonthlyReport;
import service.ProductService;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.List;

@WebServlet("/MonthlyReportServlet")
public class MonthlyReportServlet extends HttpServlet {
    private ProductService productService = new ProductService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Admin admin = (Admin) session.getAttribute("admin");
        
        if (admin == null) {
            // Redirect to login if not logged in
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }
        
        String outletLocation = admin.getOutletLocation();
        List<MonthlyReport> monthlyReports = productService.getMonthlyReports(outletLocation);
        
        request.setAttribute("monthlyReports", monthlyReports);
        request.setAttribute("outletLocation", outletLocation);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/pages/monthly_report.jsp");
        dispatcher.forward(request, response);
    }
}