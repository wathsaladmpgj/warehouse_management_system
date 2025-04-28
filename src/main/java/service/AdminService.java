package service;

import dao.AdminDAO;
import model.Admin;

public class AdminService {
    private AdminDAO adminDAO = new AdminDAO();

    public Admin login(String adminName, String password) {
        return adminDAO.validateAdmin(adminName, password);
    }
}
