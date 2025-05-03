package dao;

import model.MonthlyReport;
import java.sql.*;
import java.time.YearMonth;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DeliveryReportDAO {
    private static final Logger logger = Logger.getLogger(DeliveryReportDAO.class.getName());

    public List<MonthlyReport> getMonthlyReports(String outletLocation, String yearFilter) throws SQLException {
        List<MonthlyReport> reports = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT YEAR(p.added_date) AS year, MONTH(p.added_date) AS month, "
            + "COUNT(p.id) AS total_deliveries, COALESCE(SUM(pr.item_price), 0) AS total_revenue "
            + "FROM product_details p "
            + "JOIN product_pricing pr ON p.product_key = pr.product_key "
            + "WHERE pr.admin_location = ? "
        );

        if (yearFilter != null && !yearFilter.isEmpty()) {
            sql.append("AND YEAR(p.added_date) = ? ");
        }

        sql.append("GROUP BY YEAR(p.added_date), MONTH(p.added_date) "
                 + "ORDER BY year DESC, month DESC");

        try (Connection conn = DBHelper.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            stmt.setString(1, outletLocation);
            if (yearFilter != null && !yearFilter.isEmpty()) {
                stmt.setString(2, yearFilter);
            }
            
            logger.log(Level.INFO, "Executing query: {0}", stmt.toString());
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    YearMonth yearMonth = YearMonth.of(
                        rs.getInt("year"), 
                        rs.getInt("month")
                    );
                    MonthlyReport report = new MonthlyReport(
                        yearMonth,
                        rs.getInt("total_deliveries"),
                        rs.getBigDecimal("total_revenue")
                    );
                    reports.add(report);
                    logger.log(Level.INFO, "Found record: {0}", report.getMonthDisplay());
                }
            }
        }
        return reports;
    }
}