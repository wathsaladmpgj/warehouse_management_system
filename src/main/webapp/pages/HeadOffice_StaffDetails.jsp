<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Staff Details | Head Office</title>
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

            /* Card Styles */
            .card {
                background: var(--primary-dark);
                border-radius: 0.5rem;
                padding: 1.5rem;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.3);
                transition: var(--transition);
                position: relative;
                overflow: hidden;
                border: 1px solid var(--primary-light);
                margin-bottom: 1.5rem;
                animation: fadeIn 0.6s ease-out forwards;
            }

            .card-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 1rem;
            }

            .card-title {
                font-size: 1.25rem;
                font-weight: 500;
                color: var(--light);
            }

            /* Table Styles */
            .data-table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 1.5rem;
                background-color: var(--primary-dark);
                border-radius: 0.5rem;
                overflow: hidden;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.3);
                animation: fadeIn 0.6s 0.3s both;
            }

            .data-table th {
                background-color: var(--primary);
                color: var(--light);
                padding: 1rem;
                text-align: left;
                font-weight: 500;
            }

            .data-table td {
                padding: 1rem;
                border-bottom: 1px solid var(--primary-light);
                color: var(--gray-light);
            }

            .data-table tr:nth-child(even) {
                background-color: rgba(30, 58, 138, 0.2);
            }

            .data-table tr:hover {
                background-color: var(--primary);
            }

            /* Button Styles */
            .btn {
                padding: 0.5rem 1rem;
                border-radius: 0.375rem;
                font-weight: 500;
                cursor: pointer;
                transition: var(--transition);
                border: none;
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                text-decoration: none;
            }

            .btn-primary {
                background-color: var(--secondary);
                color: white;
            }

            .btn-primary:hover {
                background-color: #1565c0;
            }

            .btn-logout {
                background-color: rgba(244, 67, 54, 0.1);
                color: var(--danger);
            }

            .btn-logout:hover {
                background-color: var(--danger);
                color: white;
            }

            /* Stats Card */
            .stats-card {
                background-color: var(--primary-dark);
                padding: 1.5rem;
                border-radius: 0.5rem;
                margin-bottom: 1.5rem;
                animation: fadeIn 0.6s 0.2s both;
                border-left: 4px solid var(--secondary);
            }

            .stats-card h3 {
                color: var(--light);
                margin-top: 0;
                margin-bottom: 1rem;
            }

            .stats-value {
                font-size: 1.75rem;
                font-weight: 700;
                color: var(--white);
                margin: 0.5rem 0;
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
                    padding: 1rem;
                }

                .data-table {
                    display: block;
                    overflow-x: auto;
                }
            }
        </style>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/trackingUpdate.css">
    </head>
    <body>
        <c:if test="${staff == null}">
            <c:redirect url='/StaffServlet' />
        </c:if>

        <div class="dashboard-container">
            <!-- Sidebar Navigation -->
            <aside class="sidebar">
                <div class="sidebar-header">
                    <h3>Head Office Panel</h3>
                </div>
                <nav>
                    <div class="sidebar-item ">
                        <a href="${pageContext.request.contextPath}/pages/HeadOffice_Dashboard.jsp">
                            <i>🏠</i> Dashboard
                        </a>
                    </div>
                    <div class="sidebar-item">
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
                        <a href="${pageContext.request.contextPath}/pages/HeadOffice_StaffDetails.jsp">
                            <i>👥</i> Staff Details
                        </a>
                    </div>
                </nav>
            </aside>

            <!-- Main Content Area -->
            <main class="main-content">
                <!-- Header -->
                <header class="header">
                    <h1>Staff Details</h1>
                    <div class="user-info">
                        <span>Welcome, Head Office Admin</span>
                        <div class="user-avatar">
                            HO
                        </div>
                    </div>
                </header>

                <!-- Staff Count Card -->
                <div class="stats-card">
                    <h3>👥 Total Staff Members</h3>
                    <div class="stats-value">${staff.size()}</div>
                    <p>Across all outlets</p>
                    <div class="card-header">
                        <h2 class="card-title">All Staff Members</h2>
                        <a href="StaffServlet?action=new" class="btn btn-primary">
                            <i>➕</i> Add New Staff
                        </a>
                    </div>
                </div>


                <!-- live search input -->
                <div class="search-container" style="margin-bottom: 1.5rem; animation: fadeIn 0.6s 0.4s both;">
                    <input type="text" id="staffSearch" placeholder="Search staff by name or outlet..." 
                           style="padding: 0.75rem; width: 100%; border-radius: 0.375rem; 
                           border: 1px solid var(--primary-light); background: var(--primary-dark); 
                           color: var(--gray-light); font-family: inherit;">
                </div>



                <!-- Staff Details Table -->
                <div class="card">
                    <div class="card-header">
                        <h2 class="card-title">All Staff Members</h2>
                    </div>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Role</th>
                                <th>Outlet</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${staff}" var="staff">
                                <tr>
                                    <td>${staff.id}</td>
                                    <td>${staff.name}</td>
                                    <td>${staff.role}</td>
                                    <td>${staff.location}</td>
                                    <td>
                                        <a href="StaffServlet?action=edit&id=${staff.id}" class="btn btn-primary" style="padding: 0.25rem 0.5rem; font-size: 0.875rem;">
                                            Edit/Delete
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- Action Buttons -->
                <div style="margin-top: 2rem; display: flex; justify-content: space-between; animation: fadeIn 0.6s 1s both">
                    <a href="${pageContext.request.contextPath}/pages/HeadOffice_Dashboard.jsp" class="btn btn-primary">
                        <i>⬅️</i> Back to Dashboard
                    </a>
                    <a href="${pageContext.request.contextPath}/pages/login.jsp" class="btn btn-logout">
                        <i>🚪</i> Logout
                    </a>
                </div>
            </main>
        </div>

        <script>
    document.addEventListener('DOMContentLoaded', function () {
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

        mobileMenuToggle.addEventListener('click', function () {
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

        // Add hover effects to table rows
        const tableRows = document.querySelectorAll('.data-table tr');
        tableRows.forEach(row => {
            row.addEventListener('mouseenter', function () {
                this.style.backgroundColor = 'var(--primary-light)';
            });

            row.addEventListener('mouseleave', function () {
                if (this.rowIndex % 2 === 0) {
                    this.style.backgroundColor = 'rgba(30, 58, 138, 0.2)';
                } else {
                    this.style.backgroundColor = 'var(--primary-dark)';
                }
            });
        });

        // Live search functionality
        document.getElementById('staffSearch').addEventListener('input', function() {
            const searchTerm = this.value.toLowerCase();
            const rows = document.querySelectorAll('.data-table tbody tr');
            
            rows.forEach(row => {
                const name = row.cells[1].textContent.toLowerCase(); // Name column (index 1)
                const outlet = row.cells[3].textContent.toLowerCase(); // Outlet column (index 3)
                
                if (name.includes(searchTerm) || outlet.includes(searchTerm)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        });
    });
</script>
    </body>
</html>