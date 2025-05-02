package controller;

import dao.HeadOffice_OutletDetailsDAO;
import dao.StaffDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.HeadOffice_OutletDetails;
import model.Staff;

public class HeadOffice_OutletDetailsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HeadOffice_OutletDetailsDAO headOffice_OutletDetailsDAO = new HeadOffice_OutletDetailsDAO();
        List<HeadOffice_OutletDetails> headOffice_OutletDetails = headOffice_OutletDetailsDAO.getAllOutletDetails();

        // Get the highest performing outlet
        HeadOffice_OutletDetails topOutlet = headOffice_OutletDetailsDAO.getHighestPerformingOutlet();

        
        request.setAttribute("topOutlet", topOutlet);
        request.setAttribute("headOffice_OutletDetails", headOffice_OutletDetails);
        RequestDispatcher dispatcher = request.getRequestDispatcher("pages/HeadOffice_OutletDetails.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

}
