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
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/addAdmin.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/trackingUpdate.css">
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