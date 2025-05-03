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
        // Check if this is a delete request
        String deleteId = request.getParameter("delete");
        if (deleteId != null && !deleteId.isEmpty()) {
            try {
                int id = Integer.parseInt(deleteId);
                HeadOffice_OutletDetailsDAO dao = new HeadOffice_OutletDetailsDAO();
                boolean success = dao.deleteOutlet(id);

                if (success) {
                    request.setAttribute("successMessage", "Outlet deleted successfully");
                } else {
                    request.setAttribute("errorMessage", "Failed to delete outlet");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid outlet ID");
            }
        }

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

        // First check if this is a delete request
        String deleteId = request.getParameter("deleteId");
        if (deleteId != null) {
            handleDeleteOutlet(request, response);
            return;
        }

        // Otherwise handle as add outlet request
        handleAddOutlet(request, response);
    }

    private void handleDeleteOutlet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int outletId = Integer.parseInt(request.getParameter("deleteId"));
            HeadOffice_OutletDetailsDAO dao = new HeadOffice_OutletDetailsDAO();
            boolean success = dao.deleteOutlet(outletId);

            if (success) {
                request.getSession().setAttribute("successMessage", "Outlet deleted successfully");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to delete outlet. It may have associated records.");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid outlet ID");
        }

        // Always redirect back to outlet details page after delete
        response.sendRedirect(request.getContextPath() + "/HeadOffice_OutletDetailsServlet");
    }

    private void handleAddOutlet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String outletName = request.getParameter("outletName");

        if (outletName == null || outletName.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Outlet name cannot be empty");
            request.getRequestDispatcher("pages/HeadOffice_AddOutlet.jsp").forward(request, response);
            return;
        }

        HeadOffice_OutletDetailsDAO dao = new HeadOffice_OutletDetailsDAO();
        boolean success = dao.addNewOutlet(outletName);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/HeadOffice_OutletDetailsServlet");
        } else {
            request.setAttribute("errorMessage", "Failed to add new outlet. Please try again.");
            request.getRequestDispatcher("pages/HeadOffice_AddOutlet.jsp").forward(request, response);
        }
    }

}
