<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.ArrayList" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    
    // Store variables in request scope
    request.setAttribute("outletNames", outletNames);
    request.setAttribute("outletFilter", outletFilter);
    request.setAttribute("adminData", adminData);
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
            --sidebar-width: 250px;
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
            margin-left: var(--sidebar-width);
            padding: 2rem;
            transition: var(--transition);
        }
        
        /* Header Styles */
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid var(--primary-light);
        }
        
        .header h1 {
            font-size: 1.75rem;
            font-weight: 600;
            color: var(--light);
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        
        .user-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        
        .user-avatar {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background-color: var(--secondary);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
        }
        
        .branch-info {
            margin-bottom: 1.5rem;
            padding: 0.5rem 1rem;
            background-color: var(--primary-dark);
            border-radius: 0.375rem;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        /* Form and Table Containers */
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
        
        /* Searchable Select Styles */
        .searchable-select-container {
            position: relative;
        }
        
        .search-box {
            width: 100%;
            padding: 0.75rem 1rem;
            border-radius: 0.375rem;
            border: 1px solid var(--primary-light);
            background-color: rgba(255, 255, 255, 0.05);
            color: var(--white);
            font-size: 1rem;
            margin-bottom: 0.5rem;
        }
        
        .select-options {
            max-height: 200px;
            overflow-y: auto;
            border: 1px solid var(--primary-light);
            border-radius: 0.375rem;
            background-color: var(--primary-dark);
            display: none;
            position: absolute;
            width: 100%;
            z-index: 100;
        }
        
        .select-option {
            padding: 0.75rem 1rem;
            cursor: pointer;
        }
        
        .select-option:hover {
            background-color: var(--primary);
        }
        
        /* Animations */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
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
                padding: 1.5rem;
            }
            
            .header {
                flex-direction: column;
                align-items: flex-start;
                gap: 1rem;
            }
        }
    </style>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/trackingUpdate.css">+
</head>
<body>                
    <aside class="sidebar">
        <div class="sidebar-header">
            <h3>Admin Panel</h3>
        </div>
        <nav>
                    <div class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/pages/HeadOffice_Dashboard.jsp">
                            <i>🏠</i> Dashboard
                        </a>
                    </div>
                    <div class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/pages/chart.jsp">
                            <i>📈</i> Analysis
                        </a>
                    </div>
                    <div class="sidebar-item ">
                        <a href="${pageContext.request.contextPath}/pages/HeadOffice_AddOutlet.jsp">
                            <i>🏢</i> Add Outlet
                        </a>
                    </div>
                    <div class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/pages/headOffice_product_summar.jsp">
                            <i>📊</i> View Report
                        </a>
                    </div>
                    <div class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/pages/HeadOffice_OutletDetails.jsp">
                            <i>🏬</i> Outlet Details
                        </a>
                    </div>
                    <div class="sidebar-item active">
                        <a href="${pageContext.request.contextPath}/pages/addAdmin.jsp">
                            <i>👥</i>Admin ADD
                        </a>
                    </div>
                    <div class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/pages/HeadOffice_StaffDetails.jsp">
                            <i>👥</i> Staff Details
                        </a>
                    </div>
                </nav>
    </aside>

    <div class="main-content">
        <!-- Header -->
        <header class="header">
            <h1>Admin Management</h1>
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

        <div class="admin-form-container">
            <h2>👔 Add New Admin</h2>
            
            <form action="${pageContext.request.contextPath}/AddAdminServlet" method="POST">
                <div class="form-group">
                    <label for="adminName">👤 Name:</label>
                    <input type="text" id="adminName" name="adminName" required>
                </div>
                
                <div class="form-group">
                    <label for="adminEmail">📧 Email:</label>
                    <input type="email" id="adminEmail" name="adminEmail" required>
                </div>
                
                <div class="form-group">
                    <label for="password">🔑 Password:</label>
                    <input type="password" id="password" name="password" required>
                </div>
                
                <div class="form-group">
                    <label for="outletLocation">🏢 Outlet Location:</label>
                    <div class="searchable-select-container">
                        <input type="text" class="search-box" placeholder="Search outlets..." id="outletSearch">
                        <select id="outletLocation" name="outletLocation" style="display: none;" required>
                            <option value="" selected disabled>Select Outlet Location</option>
                            <c:forEach items="${outletNames}" var="outlet">
                                <option value="${outlet}">${outlet}</option>
                            </c:forEach>
                        </select>
                        <div class="select-options" id="outletOptions">
                            <c:forEach items="${outletNames}" var="outlet">
                                <div class="select-option" data-value="${outlet}">${outlet}</div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
                
                <button type="submit" class="form-submit">💾 Save Admin</button>
                
                <c:if test="${not empty requestScope.errorMessage}">
                    <div class="error">
                        ❌ ${requestScope.errorMessage}
                    </div>
                </c:if>
                
                <c:if test="${not empty requestScope.successMessage}">
                    <div class="success">
                        ✅ ${requestScope.successMessage}
                    </div>
                </c:if>
            </form>
        </div>

        <div class="data-table-container">
            <h2>📋 Current Admins</h2>
            
            <!-- Filter section with searchable select -->
            <div class="filter-section">
                <form method="GET" action="">
                    <label for="outletFilter">Filter by Outlet:</label>
                    <div class="searchable-select-container">
                        <input type="text" class="search-box" placeholder="Search outlets..." id="filterSearch">
                        <select id="outletFilter" name="outletFilter" style="display: none;">
                            <option value="">All Outlets</option>
                            <c:forEach items="${outletNames}" var="outlet">
                                <option value="${outlet}" ${outlet eq outletFilter ? 'selected' : ''}>
                                    ${outlet}
                                </option>
                            </c:forEach>
                        </select>
                        <div class="select-options" id="filterOptions">
                            <div class="select-option" data-value="">All Outlets</div>
                            <c:forEach items="${outletNames}" var="outlet">
                                <div class="select-option" data-value="${outlet}">${outlet}</div>
                            </c:forEach>
                        </div>
                    </div>
                    <button type="submit" class="filter-btn">Filter</button>
                    <c:if test="${not empty outletFilter}">
                        <a href="?" class="reset-btn">Reset</a>
                    </c:if>
                </form>
            </div>
            
            <c:if test="${not empty outletFilter}">
                <div class="filter-status">Showing admins for: ${outletFilter}</div>
            </c:if>
            
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Outlet Location</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty adminData}">
                            <tr>
                                <td colspan="4" style="text-align: center;">
                                    <c:choose>
                                        <c:when test="${not empty outletFilter}">
                                            No admins found for ${outletFilter}
                                        </c:when>
                                        <c:otherwise>
                                            No admins found
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${adminData}" var="admin">
                                <tr>
                                    <td>${admin[0]}</td>
                                    <td>${admin[1]}</td>
                                    <td>${admin[3]}</td>
                                    <td>
                                        <button class="action-btn edit-btn" 
                                                onclick="openEditModal(
                                                    '${admin[1]}',
                                                    '${admin[0]}',
                                                    '${admin[2]}',
                                                    '${admin[3]}'
                                                )">Edit</button>
                                        <button class="action-btn delete-btn" 
                                                onclick="confirmDelete('${admin[1]}')">Delete</button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
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
                        <label for="editAdminName">👤 Name:</label>
                        <input type="text" id="editAdminName" name="adminName" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="editAdminEmail">📧 Email:</label>
                        <input type="email" id="editAdminEmail" name="email" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="editPassword">🔑 Password:</label>
                        <input type="password" id="editPassword" name="password" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="editOutletLocation">🏢 Outlet Location:</label>
                        <div class="searchable-select-container">
                            <input type="text" class="search-box" placeholder="Search outlets..." id="editOutletSearch">
                            <select id="editOutletLocation" name="outletLocation" style="display: none;" required>
                                <c:forEach items="${outletNames}" var="outlet">
                                    <option value="${outlet}">${outlet}</option>
                                </c:forEach>
                            </select>
                            <div class="select-options" id="editOutletOptions">
                                <c:forEach items="${outletNames}" var="outlet">
                                    <div class="select-option" data-value="${outlet}">${outlet}</div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                    
                    <button type="submit" class="form-submit">💾 Update Admin</button>
                </form>
            </div>
        </div>
    </div>

    <script>
        // Search functionality for all select boxes
        function initializeSearchableSelect(searchId, optionsId, selectId) {
            const searchBox = document.getElementById(searchId);
            const optionsContainer = document.getElementById(optionsId);
            const selectElement = document.getElementById(selectId);
            const options = optionsContainer.querySelectorAll('.select-option');
            
            // Show selected value in the search box
            const selectedOption = selectElement.querySelector('option[selected]');
            if (selectedOption) {
                searchBox.value = selectedOption.textContent;
            }
            
            searchBox.addEventListener('input', function() {
                const searchTerm = this.value.toLowerCase();
                options.forEach(option => {
                    const text = option.textContent.toLowerCase();
                    option.style.display = text.includes(searchTerm) ? 'block' : 'none';
                });
            });
            
            options.forEach(option => {
                option.addEventListener('click', function() {
                    const value = this.getAttribute('data-value');
                    const text = this.textContent;
                    
                    // Update the hidden select element
                    selectElement.value = value;
                    
                    // Update the search box with selected value
                    searchBox.value = text;
                    
                    // Hide options
                    optionsContainer.style.display = 'none';
                });
            });
            
            // Toggle options visibility
            searchBox.addEventListener('focus', function() {
                optionsContainer.style.display = 'block';
            });
            
            // Hide options when clicking outside
            document.addEventListener('click', function(e) {
                if (!searchBox.contains(e.target) && !optionsContainer.contains(e.target)) {
                    optionsContainer.style.display = 'none';
                }
            });
        }
        
        // Initialize all searchable selects
        document.addEventListener('DOMContentLoaded', function() {
            initializeSearchableSelect('outletSearch', 'outletOptions', 'outletLocation');
            initializeSearchableSelect('filterSearch', 'filterOptions', 'outletFilter');
            
            // For edit modal, we'll initialize when modal opens
        });

        // Modal functions (updated to handle searchable select)
        function openEditModal(email, name, password, location) {
            document.getElementById('editOriginalEmail').value = email;
            document.getElementById('editAdminName').value = name;
            document.getElementById('editAdminEmail').value = email;
            document.getElementById('editPassword').value = password;
            
            const select = document.getElementById('editOutletLocation');
            select.value = location;
            
            // Initialize searchable select for edit modal
            initializeSearchableSelect('editOutletSearch', 'editOutletOptions', 'editOutletLocation');
            
            // Set the search box value to the current location
            document.getElementById('editOutletSearch').value = location;
            
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