<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Outlet Details | Head Office</title>
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

            /* Top Performer Styles */
            .top-performer {
                background-color: var(--primary-dark);
                border-left: 4px solid var(--success);
                padding: 1.5rem;
                border-radius: 0.5rem;
                margin-bottom: 1.5rem;
                animation: fadeIn 0.6s 0.2s both;
            }

            .top-performer h3 {
                color: var(--light);
                margin-top: 0;
                margin-bottom: 1rem;
                font-size: 1.25rem;
            }

            .top-performer p {
                margin: 0.5rem 0;
                color: var(--gray-light);
            }

            .top-performer strong {
                color: var(--white);
                font-weight: 600;
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
    </head>
    <body>
        <c:if test="${headOffice_OutletDetails == null}">
            <c:redirect url='/HeadOffice_OutletDetailsServlet' />
        </c:if>

        <div class="dashboard-container">
            <!-- Sidebar Navigation -->
            <aside class="sidebar">
                <div class="sidebar-header">
                    <h3>Head Office Panel</h3>
                </div>
                <nav>
                    <div class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/pages/home.jsp">
                            <i>🏢</i> Add Outlet
                        </a>
                    </div>
                    <div class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/pages/tracking.jsp">
                            <i>📊</i> View Report
                        </a>
                    </div>
                    <div class="sidebar-item active">
                        <a href="${pageContext.request.contextPath}/pages/HeadOffice_OutletDetails.jsp">
                            <i>🏬</i> Outlet Details
                        </a>
                    </div>
                    <div class="sidebar-item">
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
                    <h1>Outlet Details</h1>
                    <div class="user-info">
                        <span>Welcome, Head Office Admin</span>
                        <div class="user-avatar">
                            HO
                        </div>
                    </div>
                </header>

                <!-- Top Performing Outlet Card -->
                <div class="top-performer">
                    <h3>🏆 Top Performing Outlet</h3>
                    <c:choose>
                        <c:when test="${not empty topOutlet}">
                            <p><strong>${topOutlet.outletName}</strong></p>
                            <p>Total Registered Items: <strong>${topOutlet.totalRegisteredItems}</strong></p>
                        </c:when>
                        <c:otherwise>
                            <p>No outlet data available</p>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Outlet Details Table -->
                <div class="card">
                    <div class="card-header">
                        <h2 class="card-title">All Outlets</h2>
                    </div>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Outlet Name</th>
                                <th>Registered Items</th>
                                <th>Returned Items</th>
                                <th>Remaining Returns</th>
                                <th>Available Items</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${headOffice_OutletDetails}" var="outlet">
                                <tr>
                                    <td>${outlet.id}</td>
                                    <td>${outlet.outletName}</td>
                                    <td>${outlet.totalRegisteredItems}</td>
                                    <td>${outlet.totalReturnedItems}</td>
                                    <td>${outlet.remainingReturnedItems}</td>
                                    <td>${outlet.availableNewItems}</td>
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
            });
        </script>
    </body>
</html>