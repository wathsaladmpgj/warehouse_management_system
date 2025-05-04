package service;

import dao.DeliveryReportDAO;
import model.MonthlyReport;
import java.sql.SQLException;
import java.util.List;

public class DeliveryReportService {
    private final DeliveryReportDAO deliveryReportDAO;

    public DeliveryReportService() {
        this.deliveryReportDAO = new DeliveryReportDAO();
    }

    public List<MonthlyReport> getMonthlyReports(String outletLocation, String yearFilter) throws SQLException {
        return deliveryReportDAO.getMonthlyReports(outletLocation, yearFilter);
    }
}