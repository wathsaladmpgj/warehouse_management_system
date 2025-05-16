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
    <style>
        /* Dark Blue Theme Variables */
        :root {
            --primary: #1a237e;
            --primary-light: #303f9f;
            --primary-dark: #0d1452;
            --secondary: #1976d2;
            --success: #4caf50;
            --warning: #ff9800;
            --danger: #f44336;
            --dark: #121212;
            --light: #e3f2fd;
            --gray: #90a4ae;
            --gray-light: #cfd8dc;
            --white: #ffffff;
            --sidebar-width: 240px;
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--dark);
            color: var(--gray-light);
            line-height: 1.6;
        }
        
        /* Layout Structure */
        .dashboard-container {
            display: flex;
            min-height: 100vh;
        }
        
        /* Sidebar Styles */
        .sidebar {
            width: var(--sidebar-width);
            background: var(--primary-dark);
            border-right: 1px solid var(--primary-light);
            padding: 1rem 0;
            position: fixed;
            height: 100vh;
            transition: var(--transition);
            z-index: 100;
        }
        
        .sidebar-header {
            padding: 0 1.5rem 1.5rem;
            border-bottom: 1px solid var(--primary-light);
            margin-bottom: 1rem;
        }
        
        .sidebar-header h3 {
            color: var(--light);
            font-weight: 600;
        }
        
        .sidebar-item {
            padding: 0.75rem 1.5rem;
            margin: 0.25rem 0;
            transition: var(--transition);
        }
        
        .sidebar-item a {
            color: var(--gray-light);
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-weight: 500;
            transition: var(--transition);
        }
        
        .sidebar-item a i {
            width: 24px;
            text-align: center;
        }
        
        .sidebar-item:hover {
            background-color: var(--primary);
        }
        
        .sidebar-item.active {
            background-color: var(--primary);
            border-left: 3px solid var(--secondary);
        }
        
        .sidebar-item.active a {
            color: var(--white);
        }
        
        /* Main Content Area */
        .main-content {
            flex: 1;
            margin-left: var(--sidebar-width);
            padding: 2rem;
            transition: var(--transition);
            background-color: var(--dark);
        }
        
        /* Header Styles */
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            padding-bottom: 1.5rem;
            border-bottom: 1px solid var(--primary-light);
        }
        
        .header h1 {
            font-size: 1.75rem;
            font-weight: 600;
            color: var(--light);
        }
        
        .user-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        
        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: var(--secondary);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
        }
        
        /* Branch Info Display */
        .branch-info {
            background: var(--primary);
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            animation: fadeIn 0.6s 0.3s both;
        }
        
        .branch-info i {
            font-size: 1.25rem;
        }
        
        /* Form Styles */
        .form-container {
            background: var(--primary-dark);
            border-radius: 0.5rem;
            padding: 2rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.3);
            border: 1px solid var(--primary-light);
            animation: fadeIn 0.6s ease-out forwards;
            margin-bottom: 2rem;
        }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        label {
            display: block;
            margin-bottom: 0.5rem;
            color: var(--gray-light);
            font-weight: 500;
        }
        
        input[type="text"] {
            width: 100%;
            padding: 0.75rem;
            border-radius: 4px;
            border: 1px solid var(--primary-light);
            background-color: var(--dark);
            color: var(--white);
            font-size: 1rem;
            transition: var(--transition);
        }
        
        input[type="text"]:focus {
            outline: none;
            border-color: var(--secondary);
            box-shadow: 0 0 0 2px rgba(25, 118, 210, 0.2);
        }
        
        .btn {
            padding: 0.75rem 1.5rem;
            border-radius: 4px;
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
            border: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 1rem;
        }
        
        .btn-primary {
            background-color: var(--secondary);
            color: white;
        }
        
        .btn-primary:hover {
            background-color: #1565c0;
        }
        
        .btn-secondary {
            background-color: transparent;
            border: 1px solid var(--gray);
            color: var(--gray-light);
        }
        
        .btn-secondary:hover {
            background-color: rgba(144, 164, 174, 0.1);
        }
        
        .btn-danger {
            background-color: rgba(244, 67, 54, 0.1);
            color: var(--danger);
            border: 1px solid var(--danger);
        }
        
        .btn-danger:hover {
            background-color: var(--danger);
            color: white;
        }
        
        .btn-edit {
            background-color: rgba(255, 152, 0, 0.1);
            color: var(--warning);
            border: 1px solid var(--warning);
        }
        
        .btn-edit:hover {
            background-color: var(--warning);
            color: white;
        }
        
        .button-group {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
        }
        
        .alert {
            padding: 1rem;
            border-radius: 4px;
            margin-bottom: 1.5rem;
        }
        
        .alert-success {
            background-color: rgba(76, 175, 80, 0.1);
            border: 1px solid var(--success);
            color: var(--success);
        }
        
        .alert-danger {
            background-color: rgba(244, 67, 54, 0.1);
            border: 1px solid var(--danger);
            color: var(--danger);
        }
        
        /* Table Styles */
        .staff-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1.5rem;
            background: var(--primary-dark);
            border-radius: 0.5rem;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.3);
            animation: fadeIn 0.6s ease-out forwards;
        }
        
        .staff-table th, 
        .staff-table td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid var(--primary-light);
        }
        
        .staff-table th {
            background-color: var(--primary);
            color: var(--white);
            font-weight: 600;
        }
        
        .staff-table tr:last-child td {
            border-bottom: none;
        }
        
        .staff-table tr:hover {
            background-color: rgba(48, 63, 159, 0.1);
        }
        
        .action-buttons {
            display: flex;
            gap: 0.5rem;
        }
        
        .action-btn {
            padding: 0.5rem;
            border-radius: 4px;
            cursor: pointer;
            transition: var(--transition);
            border: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 0.875rem;
            width: 32px;
            height: 32px;
        }
        
        .action-btn-edit {
            background-color: rgba(255, 152, 0, 0.1);
            color: var(--warning);
            border: 1px solid var(--warning);
        }
        
        .action-btn-edit:hover {
            background-color: var(--warning);
            color: white;
        }
        
        .action-btn-delete {
            background-color: rgba(244, 67, 54, 0.1);
            color: var(--danger);
            border: 1px solid var(--danger);
        }
        
        .action-btn-delete:hover {
            background-color: var(--danger);
            color: white;
        }
        
        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.7);
            z-index: 1000;
            justify-content: center;
            align-items: center;
        }
        
        .modal-content {
            background-color: var(--primary-dark);
            border-radius: 0.5rem;
            padding: 2rem;
            width: 500px;
            max-width: 90%;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.5);
            border: 1px solid var(--primary-light);
        }
        
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid var(--primary-light);
        }
        
        .modal-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--light);
        }
        
        .modal-close {
            background: none;
            border: none;
            color: var(--gray);
            font-size: 1.5rem;
            cursor: pointer;
            transition: var(--transition);
        }
        
        .modal-close:hover {
            color: var(--danger);
        }
        
        /* Responsive Adjustments */
        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
                width: 280px;
            }
            
            .sidebar.active {
                transform: translateX(0);
            }
            
            .main-content {
                margin-left: 0;
            }
            
            .action-buttons {
                flex-direction: column;
            }
        }
        
        /* Animations */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }
        
        @keyframes slideIn {
            from { transform: translateX(-20px); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }
        
        /* Apply Animations */
        .sidebar-item {
            animation: slideIn 0.4s ease-out forwards;
        }
    </style>
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
