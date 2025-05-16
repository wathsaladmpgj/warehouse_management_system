<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Update Location Tracking</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/trackingUpdate.css">
</head>
<body>

<%-- Show alert message if present --%>
<%
    String alertMessage = (String) session.getAttribute("alertMessage");
    if (alertMessage != null) {
%>
<script>
    alert("<%= alertMessage.replace("\"", "\\\"") %>");
</script>
<%
        session.removeAttribute("alertMessage");
    }
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
                <div class="sidebar-item active">
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
                <div class="sidebar-item">
                    <a href="${pageContext.request.contextPath}/pages/StaffFormOutlet.jsp">
                        <i>👥</i> Add Staff
                    </a>
                </div>
            </nav>
        </aside>

    <main class="main-content">
        <!-- Header -->
            <header class="header">
                <h1>Dashboard Overview</h1>
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

            <div class="content-area">
                <h2>Update Tracking Status</h2>
                <form action="<%=request.getContextPath()%>/updateTracking" method="post" class="tracking-form">
                    <input type="hidden" name="adminLocation" value="${sessionScope.admin.outletLocation}" />
                    <div class="form-row">
                        <div class="form-group">
                            <label for="fromLocation">From Location:</label>
                            <input type="text" id="fromLocation" name="fromLocation" required>
                        </div>
                        <div class="form-group">
                            <label for="toLocation">To Location:</label>
                            <input type="text" id="toLocation" name="toLocation" required>
                        </div>
                        <div class="form-group">
                            <label for="trackingDate">Tracking Date:</label>
                            <input type="date" id="trackingDate" name="trackingDate" required>
                        </div>
                    </div>
                    <div class="form-submit">
                        <input type="submit" value="Update">
                    </div>
                </form>

                <hr><br>

                <h2>Search Location Tracking</h2>
                <form action="<%=request.getContextPath()%>/LocationTrackingServlet" method="post">
                    <input type="text" name="inputValue" placeholder="Enter Tracking Number or ID" required />
                    <input type="radio" name="mode" value="ReturnShip" checked /> ReturnShip
                    <input type="radio" name="mode" value="ReturnUser" /> ReturnUser
                    <input type="radio" name="mode" value="Success"
                        <%= "Success".equals(request.getAttribute("mode")) ? "checked" : "" %> />
                        Success
                    <button type="submit" name="action" value="add">Add</button>
                </form>

            <%-- Show results table if exists --%>
            <%
                List<Map<String, Object>> results = (List<Map<String, Object>>) request.getAttribute("results");
                String mode = (String) request.getAttribute("mode");
                if (results != null && !results.isEmpty()) {
            %>
            <form action="<%=request.getContextPath()%>/LocationTrackingServlet" method="post">
                <input type="hidden" name="mode" value="<%=mode%>"/>
                <input type="hidden" name="inputValue" value="<%=request.getAttribute("inputValue")%>"/>
                <table border="1" style="margin-top:20px;">
                    <tr>
                        <th>ID</th>
                        <th>Product Key</th>
                        <th>From</th>
                        <th>To</th>
                        <th>Date</th>
                        <th>Tracking Update</th>
                        <th>Select</th>
                    </tr>
                    <% for (Map<String, Object> row : results) { %>
                        <tr>
                            <td><%= row.get("id") %></td>
                            <td><%= row.get("product_key") %></td>
                            <td><%= row.get("from_location") %></td>
                            <td><%= row.get("to_location") %></td>
                            <td><%= row.get("tracking_date") %></td>
                            <td><%= row.get("tracking_update") %></td>
                            <td><input type="radio" name="selectedId" value="<%= row.get("id") %>" required /></td>
                        </tr>
                    <% } %>
                </table>
                <br>
                <button type="submit" name="action" value="update">Update</button>
            </form>
            <% } %>

            <%-- Show optional message --%>
            <%
                String message = (String) request.getAttribute("message");
                if (message != null) {
            %>
            <p style="color:green;"><%= message %></p>
            <% } %>
        </div>
    </main>
</div>
        
        <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Animate counting numbers
            function animateValue(id, start, end, duration) {
                const obj = document.getElementById(id);
                let startTimestamp = null;
                const step = (timestamp) => {
                    if (!startTimestamp) startTimestamp = timestamp;
                    const progress = Math.min((timestamp - startTimestamp) / duration, 1);
                    const value = Math.floor(progress * (end - start) + start);
                    obj.innerHTML = value.toLocaleString();
                    if (progress < 1) {
                        window.requestAnimationFrame(step);
                    }
                };
                window.requestAnimationFrame(step);
            }
            
            // Get values from elements
            const newItemsCount = parseInt(document.getElementById('newItemsCount').textContent) || 0;
            const registeredItemsCount = parseInt(document.getElementById('registeredItemsCount').textContent) || 0;
            const availableItemsCount = parseInt(document.getElementById('availableItemsCount').textContent) || 0;
            const successItemsCount = parseInt(document.getElementById('successItemsCount').textContent) || 0;
            
            // Animate counts if they're greater than 0
            if (newItemsCount > 0) animateValue('newItemsCount', 0, newItemsCount, 1000);
            if (registeredItemsCount > 0) animateValue('registeredItemsCount', 0, registeredItemsCount, 1000);
            if (availableItemsCount > 0) animateValue('availableItemsCount', 0, availableItemsCount, 1000);
            if (successItemsCount > 0) animateValue('successItemsCount', 0, successItemsCount, 1000);
            
            // Add hover effects to cards
            const cards = document.querySelectorAll('.card');
            cards.forEach(card => {
                card.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-5px)';
                });
                
                card.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0)';
                });
                
                // Add click effect
                card.addEventListener('click', function() {
                    this.classList.add('pulse');
                    setTimeout(() => {
                        this.classList.remove('pulse');
                    }, 1000);
                });
            });
            
            // Mobile menu toggle (if needed)
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
    </script>

</body>
</html>
