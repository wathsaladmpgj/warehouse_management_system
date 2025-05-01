package service;

import dao.AdminDAO;
import java.sql.SQLException;

public class AdminService {
    private final AdminDAO adminDao;

    public AdminService() {
        this.adminDao = new AdminDAO();
    }

    public String getAdminLocation(String username) throws SQLException {
        return adminDao.getAdminLocation(username);
    }

    public int getMatchingTrackingCount(String location) throws SQLException {
        return adminDao.getMatchingTrackingCount(location);
    }

    public int getTotalRegisteredItems(String outletName) throws SQLException {
        return adminDao.getTotalRegisteredItems(outletName);
    }

    public int getAvailableItemsCount(String outletName) throws SQLException {
        return adminDao.getAvailableItemsCount(outletName);
    }

    // NEW METHOD FOR SUCCESS ITEMS COUNT
    public int getSuccessItemsCount(String outletName) throws SQLException {
        return adminDao.getSuccessItemsCount(outletName);
    }
}