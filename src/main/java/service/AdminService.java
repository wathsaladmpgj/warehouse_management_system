package service;

import dao.AdminDAO;
import java.sql.SQLException;

public class AdminService {

    private final AdminDAO adminDao;  // Field name is 'adminDao' (lowercase 'D')

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

    // Add these methods to your existing AdminService class
    public double getNewItemsTotalPrice(String outletLocation) throws SQLException {
        return adminDao.getNewItemsTotalPrice(outletLocation);
    }

    // Add to AdminService.java
    public double getRegisteredItemsTotalPrice(String outletLocation) throws SQLException {
        return adminDao.getRegisteredItemsTotalPrice(outletLocation);
    }

// Add to AdminService.java
    public double getAvailableItemsTotalPrice(String outletLocation) throws SQLException {
        return adminDao.getAvailableItemsTotalPrice(outletLocation);
    }

    public double getSuccessItemsTotalPrice(String outletLocation) throws SQLException {
        return adminDao.getSuccessItemsTotalPrice(outletLocation);
    }

    public boolean validateAdmin(String username, String password) throws SQLException {
        return adminDao.validateAdmin(username, password);
    }

}
