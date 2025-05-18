<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <title><c:out value="${staff == null ? 'Add New' : 'Edit'}"/> Staff | Head Office</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/StaffForm.css">
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
