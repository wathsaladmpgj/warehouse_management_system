<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Monthly Product Summary</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/headOffice_product_summar.css">
    <script>
        // Automatically submit form when page loads to get initial data
        window.onload = function() {
            // Only submit if no year parameter is present in URL
            if (!window.location.href.includes("year=")) {
                document.getElementById('summaryForm').submit();
            }
        };

        function autoSubmit() {
            document.getElementById('summaryForm').submit();
        }
    </script>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/trackingUpdate.css">
</head>
<body>

    <%
        // Safely get current year and selected year
        int currentYear = Calendar.getInstance().get(Calendar.YEAR);
        Integer selectedYear = (Integer) request.getAttribute("year");
        if (selectedYear == null) {
            selectedYear = currentYear;
        }

        List<Map<String, Object>> summaryList = (List<Map<String, Object>>) request.getAttribute("summaryList");
        if (summaryList == null) {
            summaryList = new ArrayList<>();
        }
    %>

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
                    <div class="sidebar-item ">
                        <a href="${pageContext.request.contextPath}/pages/HeadOffice_AddOutlet.jsp">
                            <i>🏢</i> Add Outlet
                        </a>
                    </div>
                    <div class="sidebar-item active">
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
            
            <!-- Yearly Summary Section -->
            <div class="yearly-summary-section">
                <h2>Yearly Product Summary</h2>
                
                <div class="summary-cards">
                    <div class="summary-card">
                        <div class="card-icon">📦</div>
                        <div class="card-content">
                            <h3>Total Items</h3>
                            <p><%= request.getAttribute("totalItems") != null ? request.getAttribute("totalItems") : "0" %></p>
                        </div>
                    </div>
                    
                    <div class="summary-card">
                        <div class="card-icon">💰</div>
                        <div class="card-content">
                            <h3>Total Revenue</h3>
                            <p>Rs. <%= request.getAttribute("totalRevenue") != null ? String.format("%,.2f", request.getAttribute("totalRevenue")) : "0.00" %></p>
                        </div>
                    </div>
                    
                    <div class="summary-card">
                        <div class="card-icon">📊</div>
                        <div class="card-content">
                            <h3>Average Monthly</h3>
                            <p>Rs. <%= request.getAttribute("avgMonthly") != null ? String.format("%,.2f", request.getAttribute("avgMonthly")) : "0.00" %></p>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Monthly Summary Section -->
            <div class="monthly-summary-section">
                <h2>Monthly Product Summary</h2>

                <form id="summaryForm" class="summary-form" method="get" action="<%= request.getContextPath() %>/HeadProductSummary">
                    <div>
                        <label for="yearSelect">Select Year:</label>
                        <select id="yearSelect" name="year" onchange="autoSubmit()">
                            <% for (int y = currentYear; y >= 2023; y--) { 
                                String selected = (y == selectedYear) ? "selected" : "";
                            %>
                                <option value="<%= y %>" <%= selected %>><%= y %></option>
                            <% } %>
                        </select>
                    </div>
                </form>

                <h3 class="year-display">Year: <%= selectedYear %></h3>

                <div class="table-container">
                    <table class="summary-table">
                        <thead>
                            <tr>
                                <th>Month</th>
                                <th>Number of Items</th>
                                <th>Total Price (Rs.)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (!summaryList.isEmpty()) { 
                                for (Map<String, Object> row : summaryList) { %>
                            <tr>
                                <td><%= row.get("month") %></td>
                                <td><%= row.get("items") %></td>
                                <td><%= String.format("%,.2f", row.get("total_price")) %></td>
                            </tr>
                            <% } } else { %>
                            <tr>
                                <td colspan="3" class="no-data-message">No data found for <%= selectedYear %></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
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
</body>
</html>