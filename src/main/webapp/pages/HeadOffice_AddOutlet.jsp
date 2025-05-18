<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Add Outlet | Head Office</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/HeadOffice_addOutlet.css">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/trackingUpdate.css">
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
                            <i>🏠</i> Dashboard
                        </a>
                    </div>
                    <div class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/pages/chart.jsp">
                            <i>📈</i> Analysis
                        </a>
                    </div>
                    <div class="sidebar-item active">
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
                    <div class="sidebar-item">
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

            <!-- Main Content Area -->
            <main class="main-content">
                <!-- Header -->
                <header class="header">
                    <h1>Add New Outlet</h1>
                    <div class="user-info">
                        <span>Welcome, Head Office Admin</span>
                        <div class="user-avatar">
                            HO
                        </div>
                    </div>
                </header>


                <!-- Add Outlet Form -->
                <div class="form-card">
                    <div class="card-header">
                        <h2 class="card-title">Outlet Information</h2>
                    </div>

                    <!-- Display error message if exists -->
                    <c:if test="${not empty errorMessage}">
                        <div class="error-message">
                            <i>⚠️</i> ${errorMessage}
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/HeadOffice_OutletDetailsServlet" method="POST">
                        <div class="form-group">
                            <label for="outletName" class="form-label">Outlet Name</label>
                            <input type="text" id="outletName" name="outletName" class="form-control" 
                                   placeholder="Enter outlet name" required>
                        </div>

                        <div style="margin-top: 2rem; display: flex; justify-content: flex-end; gap: 1rem;">
                            <a href="${pageContext.request.contextPath}/HeadOffice_OutletDetailsServlet" class="btn btn-logout">
                                <i>✖</i> Cancel
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i>✔</i> Add Outlet
                            </button>
                        </div>
                    </form>
                </div>
            </main>
        </div>

        <!-- Action Buttons -->
        <div style="margin-top: 2rem; margin-left: 16rem; display: flex; justify-content: space-between; animation: fadeIn 0.6s 1s both">
            <a href="${pageContext.request.contextPath}/pages/HeadOffice_Dashboard.jsp" class="btn btn-primary">
                <i>⬅️</i> Back to Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/pages/login.jsp" class="btn btn-logout">
                <i>🚪</i> Logout
            </a>
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