package controller;

import model.Admin;
import service.AdminService;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import javax.servlet.annotation.WebServlet;


public class LoginServlet extends HttpServlet {
    private AdminService adminService = new AdminService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String adminName = request.getParameter("admin_name");
        String password = request.getParameter("password");

        Admin admin = adminService.login(adminName, password);

        if (admin != null) {
            HttpSession session = request.getSession();
            session.setAttribute("admin", admin);
            response.sendRedirect(request.getContextPath() + "/pages/OutletDashBoard.jsp");
        } else {
            request.setAttribute("error", "Invalid credentials!");
            RequestDispatcher rd = request.getRequestDispatcher("/pages/login.jsp");
            rd.forward(request, response);
        }
    }
}
