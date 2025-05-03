package controller;

import model.Admin;
import model.MonthlyReport;
import service.DeliveryReportService;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/delivery-report")
public class DeliveryReportServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(DeliveryReportServlet.class.getName());
    private DeliveryReportService service = new DeliveryReportService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect("pages/login.jsp");
            return;
        }

        Admin admin = (Admin) session.getAttribute("admin");
        String outletLocation = admin.getOutletLocation();
        String yearFilter = request.getParameter("year");
        
        logger.info("Generating report for location: " + outletLocation + 
                  ", year: " + (yearFilter != null ? yearFilter : "all"));

        try {
            List<MonthlyReport> reports = service.getMonthlyReports(outletLocation, yearFilter);
            logger.info("Found " + reports.size() + " monthly records");
            
            request.setAttribute("monthlyReports", reports);
            request.setAttribute("outletLocation", outletLocation);
            
            request.getRequestDispatcher("/pages/monthlyDeliveryReport.jsp").forward(request, response);
        } catch (SQLException e) {
            logger.severe("Database error: " + e.getMessage());
            request.setAttribute("error", "Error generating report: " + e.getMessage());
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
        }
    }
}