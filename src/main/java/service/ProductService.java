package service;

import dao.ProductDAO;
import model.MonthlyReport;
import java.util.List;

public class ProductService {
    private ProductDAO productDAO = new ProductDAO();
    
    public List<MonthlyReport> getMonthlyReports(String outletLocation) {
        return productDAO.getMonthlyReports(outletLocation);
    }
}