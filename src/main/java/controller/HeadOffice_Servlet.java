package controller;

import dao.HeadOffice_DAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class HeadOffice_Servlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HeadOffice_DAO headofficeDAO = new HeadOffice_DAO();
        
        // Get total registered items count
        int getRowCountTotalRegisteredItems = headofficeDAO.getRowCountTotalRegisteredItems();
        request.setAttribute("getRowCountTotalRegisteredItems", getRowCountTotalRegisteredItems);
        
        // Get total returned items sum
        int getTotalReturnedItems = headofficeDAO.getTotalReturnedItems();
        request.setAttribute("getTotalReturnedItems", getTotalReturnedItems);
        
        // Get total Outlet Count
        int getOutletCount = headofficeDAO.getOutletCount();
        request.setAttribute("getOutletCount", getOutletCount);
        
        
         // Get remaining_returned_items 
        int remaining_returned_items = headofficeDAO.getRemainingReturnedItems();
        request.setAttribute("remaining_returned_items", remaining_returned_items);
        
          // Get remaining_returned_items 
        int available_new_items = headofficeDAO.getAvailableNewItems();
        request.setAttribute("available_new_items", available_new_items);
        
         // Get getStaffCount 
        int getStaffCount = headofficeDAO.getStaffCount();
        request.setAttribute("getStaffCount", getStaffCount);
        
        
        
        
        request.getRequestDispatcher("pages/HeadOffice_Dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Not implemented
    }
}