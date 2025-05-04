package controller;

import dao.ProductDAO;
import model.Product;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Admin;

@WebServlet("/products")
public class ProductServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private ProductDAO productDAO;

    public void init() {
        productDAO = new ProductDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            Admin admin = (Admin) session.getAttribute("admin");

            if (admin != null) {
                String outletLocation = admin.getOutletLocation();
                
                // Changed to use from_location instead of to_location
                listProductsByFromLocation(request, response, outletLocation);
            } else {
                response.sendRedirect("pages/login.jsp");
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    // Updated method to use from_location
    private void listProductsByFromLocation(HttpServletRequest request, HttpServletResponse response, String location)
            throws SQLException, IOException, ServletException {
        List<Product> products = productDAO.selectProductsByFromLocation(location);
        request.setAttribute("products", products);
        RequestDispatcher dispatcher = request.getRequestDispatcher("pages/product-list.jsp");
        dispatcher.forward(request, response);
    }
}
