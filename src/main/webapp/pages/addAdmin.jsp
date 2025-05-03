<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.ArrayList" %>
<%
    // Database connection and data fetching
    Connection conn = null;
    Statement stmt = null;
    ResultSet outletRs = null;
    ResultSet adminRs = null;
    ArrayList<String> outletNames = new ArrayList<>();
    ArrayList<String[]> adminData = new ArrayList<>();
    String outletFilter = request.getParameter("outletFilter");

    try {
        // Load driver and establish connection
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/warehouse_management", "root", "");
        stmt = conn.createStatement();

        // Fetch outlet names and store in ArrayList
        outletRs = stmt.executeQuery("SELECT outlet_name FROM outlet_details");
        while (outletRs.next()) {
            outletNames.add(outletRs.getString("outlet_name"));
        }

        // Fetch admin data based on filter
        String adminQuery = "SELECT * FROM admin_register";
        if (outletFilter != null && !outletFilter.isEmpty()) {
            adminQuery += " WHERE outlet_location = '" + outletFilter + "'";
        }
        adminRs = stmt.executeQuery(adminQuery);
        
        while (adminRs.next()) {
            String[] admin = new String[4];
            admin[0] = adminRs.getString("admin_name");
            admin[1] = adminRs.getString("email");
            admin[2] = adminRs.getString("password");
            admin[3] = adminRs.getString("outlet_location");
            adminData.add(admin);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        // Close resources
        try {
            if (outletRs != null) outletRs.close();
            if (adminRs != null) adminRs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Management</title>
    <style>
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
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', sans-serif;
        }
        
        body {
            background-color: var(--dark);
            color: var(--gray-light);
            line-height: 1.6;
            padding: 2rem;
        }
        
        .admin-form-container, .data-table-container {
            max-width: 1000px;
            margin: 0 auto 2rem;
            background: var(--primary-dark);
            border-radius: 0.5rem;
            padding: 2rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.3);
            border: 1px solid var(--primary-light);
            animation: fadeIn 0.6s ease-out;
        }
        
        h1, h2 {
            color: var(--light);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        
        .form-group {
            margin-bottom: 1.5rem;
            position: relative;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: var(--gray-light);
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        
        .form-group input,
        .form-group select {
            width: 100%;
            padding: 0.75rem 1rem;
            border-radius: 0.375rem;
            border: 1px solid var(--primary-light);
            background-color: rgba(255, 255, 255, 0.05);
            color: var(--white);
            font-size: 1rem;
            transition: var(--transition);
        }
        
        .form-group select {
            appearance: none;
            background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='%2390a4ae'%3e%3cpath d='M7 10l5 5 5-5z'/%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right 1rem center;
            background-size: 1rem;
            cursor: pointer;
        }
        
        .form-submit {
            background-color: var(--secondary);
            color: white;
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 0.375rem;
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.75rem;
            font-size: 1rem;
            margin-top: 1rem;
        }
        
        .form-submit:hover {
            background-color: #1565c0;
            transform: translateY(-2px);
        }
        
        .data-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
        }
        
        .data-table th, .data-table td {
            padding: 0.75rem 1rem;
            text-align: left;
            border-bottom: 1px solid var(--primary-light);
        }
        
        .data-table th {
            background-color: var(--primary);
            color: var(--light);
            font-weight: 500;
        }
        
        .action-btn {
            padding: 0.375rem 0.75rem;
            border-radius: 0.25rem;
            border: none;
            cursor: pointer;
            transition: var(--transition);
            font-size: 0.875rem;
            margin-right: 0.5rem;
        }
        
        .edit-btn {
            background-color: var(--warning);
            color: var(--dark);
        }
        
        .delete-btn {
            background-color: var(--danger);
            color: white;
        }
        
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
            padding: 2rem;
            border-radius: 0.5rem;
            width: 90%;
            max-width: 500px;
            border: 1px solid var(--primary-light);
        }
        
        .close-btn {
            float: right;
            cursor: pointer;
            font-size: 1.5rem;
            color: var(--gray-light);
        }
        
        /* Filter Section Styles */
        .filter-section {
            display: flex;
            gap: 1rem;
            margin-bottom: 1.5rem;
            align-items: center;
        }
        
        .filter-section label {
            font-weight: 500;
            color: var(--gray-light);
        }
        
        .filter-section select {
            padding: 0.5rem 1rem;
            border-radius: 0.375rem;
            border: 1px solid var(--primary-light);
            background-color: rgba(255, 255, 255, 0.05);
            color: var(--white);
        }
        
        .filter-btn {
            padding: 0.5rem 1rem;
            background-color: var(--secondary);
            color: white;
            border: none;
            border-radius: 0.375rem;
            cursor: pointer;
            transition: var(--transition);
        }
        
        .filter-btn:hover {
            background-color: #1565c0;
        }
        
        .reset-btn {
            padding: 0.5rem 1rem;
            background-color: var(--gray);
            color: white;
            border: none;
            border-radius: 0.375rem;
            cursor: pointer;
            transition: var(--transition);
            text-decoration: none;
        }
        
        .reset-btn:hover {
            background-color: #78909c;
        }
        
        .filter-status {
            margin-bottom: 1rem;
            color: var(--light);
            font-style: italic;
        }
        
        /* Error and Success Messages */
        .error {
            color: var(--danger);
            background-color: rgba(244, 67, 54, 0.1);
            padding: 1rem;
            border-radius: 0.375rem;
            margin-top: 1.5rem;
            border-left: 4px solid var(--danger);
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        
        .success {
            color: var(--success);
            background-color: rgba(76, 175, 80, 0.1);
            padding: 1rem;
            border-radius: 0.375rem;
            margin-top: 1.5rem;
            border-left: 4px solid var(--success);
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
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
    </style>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/trackingUpdate.css">
</head>
<body>
    <aside class="sidebar">
            <div class="sidebar-header">
                <h3>Admin Panel</h3>
            </div>
            <nav>
                <div class="sidebar-item active">
                    <a href="${pageContext.request.contextPath}/pages/home.jsp">
                        <i>📊</i> Dashboard
                    </a>
                </div>
                <div class="sidebar-item">
                    <a href="${pageContext.request.contextPath}/pages/tracking.jsp">
                        <i>🔍</i> Tracking
                    </a>
                </div>
                <div class="sidebar-item">
                    <a href="${pageContext.request.contextPath}/pages/monthly_report.jsp">
                        <i>📈</i> Sales Report
                    </a>
                </div>
                <div class="sidebar-item">
                    <a href="${pageContext.request.contextPath}/pages/addProduct.jsp">
                        <i>➕</i> Add Product
                    </a>
                </div>
                <div class="sidebar-item">
                    <a href="${pageContext.request.contextPath}/pages/product-details.jsp">
                        <i>📋</i> Product Details
                    </a>
                </div>
                <div class="sidebar-item">
                    <a href="${pageContext.request.contextPath}/pages/item-details.jsp">
                        <i>📦</i> Inventory
                    </a>
                </div>
                <div class="sidebar-item">
                    <a href="${pageContext.request.contextPath}/pages/add-staff.jsp">
                        <i>👥</i> Add Staff
                    </a>
                </div>
                <div class="sidebar-item">
                    <a href="${pageContext.request.contextPath}/pages/staff-management.jsp">
                        <i>👔</i> Staff Management
                    </a>
                </div>
            </nav>
        </aside>

    <div class="admin-form-container">
        <h1>👔 Admin Management</h1>
        
        <form action="${pageContext.request.contextPath}/AddAdminServlet" method="POST">
            <div class="form-group">
                <label for="adminName">👤 Admin Name:</label>
                <input type="text" id="adminName" name="adminName" required>
            </div>
            
            <div class="form-group">
                <label for="adminEmail">📧 Admin Email:</label>
                <input type="email" id="adminEmail" name="adminEmail" required>
            </div>
            
            <div class="form-group">
                <label for="password">🔑 Password:</label>
                <input type="password" id="password" name="password" required>
            </div>
            
            <div class="form-group">
                <label for="outletLocation">🏢 Outlet Location:</label>
                <select id="outletLocation" name="outletLocation" required>
                    <option value="" selected disabled>Select Outlet Location</option>
                    <% for(String outlet : outletNames) { %>
                        <option value="<%= outlet %>"><%= outlet %></option>
                    <% } %>
                </select>
            </div>
            
            <button type="submit" class="form-submit">💾 Save Admin</button>
            
            <% if(request.getAttribute("errorMessage") != null) { %>
                <div class="error">
                    ❌ ${requestScope.errorMessage}
                </div>
            <% } %>
            
            <% if(request.getAttribute("successMessage") != null) { %>
                <div class="success">
                    ✅ ${requestScope.successMessage}
                </div>
            <% } %>
        </form>
    </div>

    <div class="data-table-container">
        <h2>📋 Current Admins</h2>
        
        <!-- Filter section -->
        <div class="filter-section">
            <form method="GET" action="">
                <label for="outletFilter">Filter by Outlet:</label>
                <select id="outletFilter" name="outletFilter">
                    <option value="">All Outlets</option>
                    <% for(String outlet : outletNames) { 
                        boolean isSelected = outlet.equals(outletFilter);
                    %>
                        <option value="<%= outlet %>" <%= isSelected ? "selected" : "" %>>
                            <%= outlet %>
                        </option>
                    <% } %>
                </select>
                <button type="submit" class="filter-btn">Filter</button>
                <% if(outletFilter != null && !outletFilter.isEmpty()) { %>
                    <a href="?" class="reset-btn">Reset</a>
                <% } %>
            </form>
        </div>
        
        <% if(outletFilter != null && !outletFilter.isEmpty()) { %>
            <div class="filter-status">Showing admins for: <%= outletFilter %></div>
        <% } %>
        
        <table class="data-table">
            <thead>
                <tr>
                    <th>Admin Name</th>
                    <th>Email</th>
                    <th>Outlet Location</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% if(adminData.isEmpty()) { %>
                    <tr>
                        <td colspan="4" style="text-align: center;">
                            <% if(outletFilter != null && !outletFilter.isEmpty()) { %>
                                No admins found for <%= outletFilter %>
                            <% } else { %>
                                No admins found
                            <% } %>
                        </td>
                    </tr>
                <% } else { 
                    for(String[] admin : adminData) { %>
                    <tr>
                        <td><%= admin[0] %></td>
                        <td><%= admin[1] %></td>
                        <td><%= admin[3] %></td>
                        <td>
                            <button class="action-btn edit-btn" 
                                    onclick="openEditModal(
                                        '<%= admin[1] %>',
                                        '<%= admin[0] %>',
                                        '<%= admin[2] %>',
                                        '<%= admin[3] %>'
                                    )">Edit</button>
                            <button class="action-btn delete-btn" 
                                    onclick="confirmDelete('<%= admin[1] %>')">Delete</button>
                        </td>
                    </tr>
                <% } 
                } %>
            </tbody>
        </table>
    </div>

    <!-- Edit Modal -->
    <div id="editModal" class="modal">
        <div class="modal-content">
            <span class="close-btn" onclick="closeModal()">&times;</span>
            <h2>✏️ Edit Admin</h2>
            <form id="editForm" action="${pageContext.request.contextPath}/UpdateAdminServlet" method="POST">
                <input type="hidden" id="editOriginalEmail" name="originalEmail">
                
                <div class="form-group">
                    <label for="editAdminName">👤 Admin Name:</label>
                    <input type="text" id="editAdminName" name="adminName" required>
                </div>
                
                <div class="form-group">
                    <label for="editAdminEmail">📧 Admin Email:</label>
                    <input type="email" id="editAdminEmail" name="email" required>
                </div>
                
                <div class="form-group">
                    <label for="editPassword">🔑 Password:</label>
                    <input type="password" id="editPassword" name="password" required>
                </div>
                
                <div class="form-group">
                    <label for="editOutletLocation">🏢 Outlet Location:</label>
                    <select id="editOutletLocation" name="outletLocation" required>
                        <% for(String outlet : outletNames) { %>
                            <option value="<%= outlet %>"><%= outlet %></option>
                        <% } %>
                    </select>
                </div>
                
                <button type="submit" class="form-submit">💾 Update Admin</button>
            </form>
        </div>
    </div>

    <script>
        // Modal functions
        function openEditModal(email, name, password, location) {
            document.getElementById('editOriginalEmail').value = email;
            document.getElementById('editAdminName').value = name;
            document.getElementById('editAdminEmail').value = email;
            document.getElementById('editPassword').value = password;
            
            const select = document.getElementById('editOutletLocation');
            for (let i = 0; i < select.options.length; i++) {
                if (select.options[i].value === location) {
                    select.selectedIndex = i;
                    break;
                }
            }
            
            document.getElementById('editModal').style.display = 'flex';
        }
        
        function closeModal() {
            document.getElementById('editModal').style.display = 'none';
        }
        
        function confirmDelete(email) {
            if (confirm('Are you sure you want to delete admin with email: ' + email + '?')) {
                window.location.href = '${pageContext.request.contextPath}/DeleteAdminServlet?email=' + encodeURIComponent(email);
            }
        }
        
        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('editModal');
            if (event.target === modal) {
                closeModal();
            }
        }
    </script>
</body>
</html>