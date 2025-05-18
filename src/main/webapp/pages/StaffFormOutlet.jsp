<%@page import="model.Admin"%>
<%@page import="model.Staff"%>
<%@page import="dao.StaffDAO"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Staff Management</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/StaffForm_Outlet.css">
</head>
<body>
    <%
        // Get the admin from the session
        Admin admin = (Admin) session.getAttribute("admin");
        
        // Check if admin is logged in
        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }
        
        // Get the outlet location from the admin object
        String outletLocation = admin.getOutletLocation();
        
        // Check for success or error messages
        String successMessage = (String) request.getAttribute("successMessage");
        String errorMessage = (String) request.getAttribute("errorMessage");
        
        // Get staff members for this location
        StaffDAO staffDAO = new StaffDAO();
        List<Staff> staffList = staffDAO.getStaffByLocation(outletLocation);
    %>
    
    <div class="dashboard-container">
        <!-- Sidebar Navigation -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <h3>Admin Panel</h3>
            </div>
            <nav>
                <div class="sidebar-item">
                    <a href="${pageContext.request.contextPath}/pages/OutletDashBoard.jsp">
                        <i>📊</i> Dashboard
                    </a>
                </div>
                <div class="sidebar-item">
                    <a href="${pageContext.request.contextPath}/pages/updateTracking.jsp">
                        <i>🔍</i> Tracking
                    </a>
                </div>
                <div class="sidebar-item">
                    <a href="${pageContext.request.contextPath}/pages/monthlyDeliveryReport.jsp">
                        <i>📈</i> Sales Report
                    </a>
                </div>
                <div class="sidebar-item">
                    <a href="${pageContext.request.contextPath}/pages/addProduct.jsp">
                        <i>➕</i> Add Product
                    </a>
                </div>
                <div class="sidebar-item">
                    <a href="${pageContext.request.contextPath}/pages/product-list.jsp">
                        <i>📋</i> Product Details
                    </a>
                </div>
                <div class="sidebar-item active">
                    <a href="${pageContext.request.contextPath}/pages/StaffFormOutlet.jsp">

                        <i>👥</i> Add Staff
                    </a>
                </div>
            </nav>
        </aside>

        <!-- Main Content Area -->
        <main class="main-content">
            <!-- Header -->
            <header class="header">
                <h1>Staff Management</h1>
                <div class="user-info">
                    <span>Welcome, ${sessionScope.admin.adminName}</span>
                    <div class="user-avatar">
                        ${sessionScope.admin.adminName.charAt(0)}
                    </div>
                </div>
            </header>

            <!-- Branch Information -->
            <div class="branch-info">
                <i>🏢</i>
                <span>Branch: <strong>${sessionScope.admin.outletLocation}</strong></span>
            </div>
            
            <% if (successMessage != null) { %>
                <div class="alert alert-success">
                    <%= successMessage %>
                </div>
            <% } %>
            
            <% if (errorMessage != null) { %>
                <div class="alert alert-danger">
                    <%= errorMessage %>
                </div>
            <% } %>
            
            <!-- Add Staff Form -->
            <div class="form-container">
                <h2 style="margin-bottom: 1.5rem; color: var(--light);">Add New Staff Member</h2>
                <form action="${pageContext.request.contextPath}/OutletStaffServlet" method="post">
                    <input type="hidden" name="action" value="insert">
                    <!-- Hidden field for location that comes from the admin session -->
                    <input type="hidden" name="location" value="<%= outletLocation %>">
                    
                    <div class="form-group">
                        <label for="name">Staff Name</label>
                        <input type="text" id="name" name="name" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="role">Staff Role</label>
                        <input type="text" id="role" name="role" required placeholder="Enter staff role">
                    </div>
                    
                    <div class="button-group">
                        <button type="submit" class="btn btn-primary">
                            <i>+</i> Add Staff Member
                        </button>
                        <button type="reset" class="btn btn-secondary">
                            <i>↺</i> Reset Form
                        </button>
                    </div>
                </form>
            </div>
            
            <!-- Staff List Table -->
            <h2 style="margin: 2rem 0 1rem; color: var(--light);">Staff Members at <%= outletLocation %></h2>
            
            <% if (staffList.isEmpty()) { %>
                <div style="background: var(--primary-dark); padding: 2rem; border-radius: 0.5rem; text-align: center; border: 1px solid var(--primary-light);">
                    <p>No staff members found for this location. Add your first staff member using the form above.</p>
                </div>
            <% } else { %>
                <table class="staff-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Role</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Staff staff : staffList) { %>
                            <tr>
                                <td><%= staff.getId() %></td>
                                <td><%= staff.getName() %></td>
                                <td><%= staff.getRole() %></td>
                                <td class="action-buttons">
                                    <button class="action-btn action-btn-edit" onclick="openEditModal(<%= staff.getId() %>, '<%= staff.getName() %>', '<%= staff.getRole() %>')">
                                        ✏️
                                    </button>
                                    <a href="${pageContext.request.contextPath}/OutletStaffServlet?action=delete&id=<%= staff.getId() %>" 
                                       class="action-btn action-btn-delete" 
                                       onclick="return confirm('Are you sure you want to delete this staff member?')">
                                        🗑️
                                    </a>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
            
            <!-- Edit Modal -->
            <div id="editModal" class="modal">
                <div class="modal-content">
                    <div class="modal-header">
                        <h3 class="modal-title">Edit Staff Member</h3>
                        <button class="modal-close" onclick="closeEditModal()">&times;</button>
                    </div>
                    <form action="${pageContext.request.contextPath}/OutletStaffServlet" method="post">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" id="edit-id">
                        <input type="hidden" name="location" value="<%= outletLocation %>">
                        
                        <div class="form-group">
                            <label for="edit-name">Staff Name</label>
                            <input type="text" id="edit-name" name="name" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="edit-role">Staff Role</label>
                            <input type="text" id="edit-role" name="role" required>
                        </div>
                        
                        <div class="button-group">
                            <button type="submit" class="btn btn-primary">
                                <i>💾</i> Save Changes
                            </button>
                            <button type="button" class="btn btn-secondary" onclick="closeEditModal()">
                                <i>✖️</i> Cancel
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Mobile menu toggle
            const mobileMenuToggle = document.createElement('button');
            mobileMenuToggle.innerHTML = '☰';
            mobileMenuToggle.style.position = 'fixed';
            mobileMenuToggle.style.top = '1rem';
            mobileMenuToggle.style.left = '1rem';
            mobileMenuToggle.style.zIndex = '1000';
            mobileMenuToggle.style.background = 'var(--primary)';
            mobileMenuToggle.style.color = 'white';
            mobileMenuToggle.style.border = 'none';
            mobileMenuToggle.style.borderRadius = '50%';
            mobileMenuToggle.style.width = '40px';
            mobileMenuToggle.style.height = '40px';
            mobileMenuToggle.style.display = 'none';
            mobileMenuToggle.style.justifyContent = 'center';
            mobileMenuToggle.style.alignItems = 'center';
            mobileMenuToggle.style.cursor = 'pointer';
            
            mobileMenuToggle.addEventListener('click', function() {
                document.querySelector('.sidebar').classList.toggle('active');
            });
            
            document.body.appendChild(mobileMenuToggle);
            
            // Show mobile menu button on small screens
            function checkScreenSize() {
                if (window.innerWidth <= 768) {
                    mobileMenuToggle.style.display = 'flex';
                } else {
                    mobileMenuToggle.style.display = 'none';
                    document.querySelector('.sidebar').classList.remove('active');
                }
            }
            
            window.addEventListener('resize', checkScreenSize);
            checkScreenSize();
        });
        
        // Edit modal functions
        function openEditModal(id, name, role) {
            document.getElementById('edit-id').value = id;
            document.getElementById('edit-name').value = name;
            document.getElementById('edit-role').value = role;
            document.getElementById('editModal').style.display = 'flex';
        }
        
        function closeEditModal() {
            document.getElementById('editModal').style.display = 'none';
        }
        
        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('editModal');
            if (event.target === modal) {
                closeEditModal();
            }
        }
    </script>
</body>
</html>
