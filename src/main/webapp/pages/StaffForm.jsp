<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <title><c:out value="${staff == null ? 'Add New' : 'Edit'}"/> Staff | Head Office</title>
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

            /* Form Styles */
            .form-container {
                max-width: 600px;
                margin: 0 auto;
                background: var(--primary-dark);
                padding: 2rem;
                border-radius: 0.5rem;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.3);
                border: 1px solid var(--primary-light);
                animation: fadeIn 0.6s ease-out forwards;
            }

            .form-group {
                margin-bottom: 1.5rem;
            }

            .form-group label {
                display: block;
                margin-bottom: 0.5rem;
                color: var(--light);
                font-weight: 500;
            }

            .form-control {
                width: 100%;
                padding: 0.75rem;
                border: 1px solid var(--primary-light);
                border-radius: 0.375rem;
                background-color: var(--primary);
                color: var(--white);
                font-family: inherit;
                transition: var(--transition);
            }

            .form-control:focus {
                outline: none;
                border-color: var(--secondary);
                box-shadow: 0 0 0 2px rgba(25, 118, 210, 0.3);
            }

            select.form-control {
                appearance: none;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='%2390a4ae' viewBox='0 0 16 16'%3E%3Cpath d='M7.247 11.14 2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z'/%3E%3C/svg%3E");
                background-repeat: no-repeat;
                background-position: right 0.75rem center;
                background-size: 16px 12px;
                padding-right: 2.5rem;
            }

            .btn {
                padding: 0.75rem 1.5rem;
                border-radius: 0.375rem;
                font-weight: 500;
                cursor: pointer;
                transition: var(--transition);
                border: none;
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                text-decoration: none;
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
                background-color: var(--gray);
                color: white;
            }

            .btn-secondary:hover {
                background-color: #78909c;
            }

            .btn-danger {
                background-color: var(--danger);
                color: white;
            }

            .btn-danger:hover {
                background-color: #d32f2f;
            }

            .action-buttons {
                display: flex;
                justify-content: space-between;
                margin-top: 2rem;
                gap: 1rem;
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
                    padding: 1rem;
                }

                .form-container {
                    padding: 1.5rem;
                }

                .action-buttons {
                    flex-direction: column;
                }
            }
        </style>
    </head>
    <body>
        <div class="dashboard-container">
            <!-- Sidebar Navigation -->
            <aside class="sidebar">
                <div class="sidebar-header">
                    <h3>Head Office Panel</h3>
                </div>
                <nav>
                    <div class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/pages/HeadOffice_Dashboard.jsp">
                            <i>🏢</i> Dashboard
                        </a>
                    </div>
                    <div class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/pages/HeadOffice_AddOutlet.jsp">
                            <i>🏢</i> Add Outlet
                        </a>
                    </div>
                    <div class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/pages/tracking.jsp">
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
                    <h1><c:out value="${staff == null ? 'Add New' : 'Edit'}"/> Staff Member</h1>
                    <div class="user-info">
                        <span>Welcome, Head Office Admin</span>
                        <div class="user-avatar">
                            HO
                        </div>
                    </div>
                </header>

                <!-- Staff Form -->
                <div class="form-container">
                    <form action="StaffServlet" method="post">
                        <input type="hidden" name="id" value="${staff.id}"/>
                        <input type="hidden" name="action" value="${staff == null ? 'insert' : 'update'}"/>

                        <div class="form-group">
                            <label for="name">Full Name</label>
                            <input type="text" class="form-control" id="name" name="name" 
                                   value="${staff.name}" required>
                        </div>

                        <div class="form-group">
                            <label for="role">Role</label>
                            <input type="text" class="form-control" id="role" name="role" 
                                   value="${staff.role}" required>
                        </div>
                        <!-- fetching the drop down -->
                        <div class="form-group">
                            <label for="location">Outlet Location</label>
                            <select name="location" class="form-control" required>
                                <option value="">-- Select Location --</option>
                                <c:forEach items="${outlets}" var="outlet">
                                    <option value="${outlet}" ${staff.location eq outlet ? 'selected' : ''}>
                                        ${outlet}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="action-buttons">
                            <div style="display: flex; gap: 1rem;">
                                <button type="submit" class="btn btn-primary">
                                    ${staff == null ? 'Add Staff' : 'Update Staff'}
                                </button>
                                <a href="StaffServlet" class="btn btn-secondary">Cancel</a>
                            </div>

                            <c:if test="${staff != null}">
                                <a href="StaffServlet?action=delete&id=${staff.id}" 
                                   class="btn btn-danger"
                                   onclick="return confirm('Are you sure you want to delete this staff member?')">
                                    Delete
                                </a>
                            </c:if>
                        </div>
                    </form>
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
            });
        </script>
    </body>
</html>