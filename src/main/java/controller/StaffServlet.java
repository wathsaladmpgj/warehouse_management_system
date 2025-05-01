package controller;

import dao.StaffDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Staff;

public class StaffServlet extends HttpServlet {

    @Override
    protected  void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        StaffDAO staffDAO = new StaffDAO();
        List<Staff> staff = staffDAO.getAllStaff();
        
        request.setAttribute("staff", staff);
        RequestDispatcher dispatcher = request.getRequestDispatcher("pages/HeadOffice_StaffDetails.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
    }
}
