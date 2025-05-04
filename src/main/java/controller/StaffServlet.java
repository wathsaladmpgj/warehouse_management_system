package controller;

import dao.StaffDAO;
import dao.HeadOffice_OutletDetailsDAO;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Staff;

@WebServlet(name = "StaffServlet", urlPatterns = {"/StaffServlet"})
public class StaffServlet extends HttpServlet {

    private StaffDAO staffDAO;
    private HeadOffice_OutletDetailsDAO outletDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        this.staffDAO = new StaffDAO();
        this.outletDAO = new HeadOffice_OutletDetailsDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String action = request.getParameter("action");

            if (action == null || action.isEmpty()) {
                listStaff(request, response);
            } else {
                switch (action) {
                    case "new":
                        showNewForm(request, response);
                        break;
                    case "edit":
                        showEditForm(request, response);
                        break;
                    case "delete":
                        deleteStaff(request, response);
                        break;
                    default:
                        listStaff(request, response);
                        break;
                }
            }
        } catch (Exception e) {
            throw new ServletException("Error in StaffServlet: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String action = request.getParameter("action");

            if (action == null || action.isEmpty()) {
                listStaff(request, response);
            } else {
                switch (action) {
                    case "insert":
                        insertStaff(request, response);
                        break;
                    case "update":
                        updateStaff(request, response);
                        break;
                    default:
                        listStaff(request, response);
                        break;
                }
            }
        } catch (Exception e) {
            throw new ServletException("Error in StaffServlet: " + e.getMessage(), e);
        }
    }

    private void listStaff(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("staff", staffDAO.getAllStaff());
        request.getRequestDispatcher("pages/HeadOffice_StaffDetails.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<String> outletLocations = outletDAO.getOutletLocations();
        request.setAttribute("outlets", outletLocations);
        request.getRequestDispatcher("pages/StaffForm.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Staff existingStaff = staffDAO.getStaffById(id);
        List<String> outletLocations = outletDAO.getOutletLocations();

        request.setAttribute("staff", existingStaff);
        request.setAttribute("outlets", outletLocations);
        request.getRequestDispatcher("pages/StaffForm.jsp").forward(request, response);
    }

    private void insertStaff(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        String name = request.getParameter("name");
        String role = request.getParameter("role");
        String location = request.getParameter("location");

        if (name == null || role == null || location == null) {
            throw new ServletException("Missing parameters for staff creation");
        }

        Staff newStaff = new Staff(name, role, location);
        staffDAO.addStaff(newStaff);
        response.sendRedirect("StaffServlet");
    }

    private void updateStaff(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String role = request.getParameter("role");
        String location = request.getParameter("location");

        if (name == null || role == null || location == null) {
            throw new ServletException("Missing parameters for staff update");
        }

        Staff staff = new Staff(name, role, location);
        staff.setId(id);
        staffDAO.updateStaff(staff);
        response.sendRedirect("StaffServlet");
    }

    private void deleteStaff(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean isDeleted = staffDAO.deleteStaff(id);

            if (!isDeleted) {
                request.setAttribute("errorMessage", "Failed to delete staff member. Please try again.");
            } else {
                request.setAttribute("successMessage", "Staff member deleted successfully.");
            }

            listStaff(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid staff ID format.");
            listStaff(request, response);
        } catch (Exception e) {
            throw new ServletException("Error deleting staff member", e);
        }
    }
}
