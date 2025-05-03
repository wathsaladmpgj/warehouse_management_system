<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.MonthlyReport" %>
<%@ page import="model.Admin" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.time.YearMonth" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.math.BigDecimal" %>

<!DOCTYPE html>
<html>
<head>
    <title>Monthly Delivery Report</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&family=Montserrat:wght@600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
        }
        
        .container {
            display: flex;
            min-height: 100vh;
        }
        
        .sidebar {
            width: 250px;
            background-color: #004494;
            padding: 0;
        }
        
        .sidebar-header {
            padding: 20px;
            color: white;
            text-align: center;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .sidebar-header h3 {
            margin: 0;
            font-family: 'Montserrat', sans-serif;
            font-size: 20px;
        }
        
        .sidebar-item {
            padding: 12px 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .sidebar-item a {
            color: white;
            text-decoration: none;
            font-family: 'Montserrat', sans-serif;
            font-weight: 500;
            display: flex;
            align-items: center;
        }
        
        .sidebar-item i {
            margin-right: 10px;
            font-style: normal;
        }
        
        .sidebar-item:hover {
            background-color: rgba(255, 255, 255, 0.1);
        }
        
        .sidebar-item.active {
            background-color: rgba(255, 255, 255, 0.2);
        }
        
        .main-content {
            flex: 1;
            padding: 20px;
        }
        
        .header {
            background-color: #004494;
            color: white;
            padding: 15px 20px;
            margin-bottom: 20px;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        
        .header h2 {
            font-family: 'Montserrat', sans-serif;
            margin: 0;
            font-size: 24px;
        }
        
        .content-area {
            background-color: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        
        h2 {
            font-family: 'Montserrat', sans-serif;
            color: #004494;
            margin-top: 0;
        }
        
        .filter-section {
            margin-bottom: 20px;
            padding: 15px;
            background-color: #f9f9f9;
            border-radius: 5px;
            border: 1px solid #ddd;
        }
        
        .filter-section select {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-family: 'Roboto', sans-serif;
            margin-right: 10px;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        
        th {
            background-color: #f2f2f2;
            font-family: 'Montserrat', sans-serif;
            font-weight: 600;
        }
        
        tr:hover {
            background-color: #f9f9f9;
        }
        
        .no-data {
            text-align: center;
            padding: 20px;
            color: #666;
            font-style: italic;
        }
        
        .summary-section {
            margin-top: 30px;
            padding: 15px;
            background-color: #f9f9f9;
            border-radius: 5px;
            border: 1px solid #ddd;
        }
        
        .summary-info {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }
        
        .info-item {
            font-family: 'Roboto', sans-serif;
        }
        
        .value {
            font-weight: 500;
            color: #004494;
        }
    </style>
    <script>
        function submitForm() {
            document.getElementById('yearForm').submit();
        }
    </script>
</head>
<body>
    <%
        // Get current year for the dropdown
        int currentYear = Calendar.getInstance().get(Calendar.YEAR);
        
        // Get selected year from request parameter
        String selectedYear = request.getParameter("year");
        if (selectedYear == null || selectedYear.isEmpty()) {
            selectedYear = String.valueOf(currentYear);
            // Auto-redirect on first load
            if (request.getAttribute("monthlyReports") == null) {
                response.sendRedirect(request.getContextPath() + "/delivery-report?year=" + currentYear);
                return;
            }
        }
        
        List<MonthlyReport> reports = (List<MonthlyReport>) request.getAttribute("monthlyReports");
        String outletLocation = (String) request.getAttribute("outletLocation");
        
        // If outletLocation is null, get it from session
        if (outletLocation == null || outletLocation.equals("null")) {
            Admin admin = (Admin) session.getAttribute("admin");
            if (admin != null) {
                outletLocation = admin.getOutletLocation();
            } else {
                outletLocation = "Unknown";
            }
        }
        
        // Calculate totals
        int totalDeliveries = 0;
        BigDecimal totalRevenue = BigDecimal.ZERO;
        
        if (reports != null) {
            for (MonthlyReport report : reports) {
                totalDeliveries += report.getTotalDeliveries();
                totalRevenue = totalRevenue.add(report.getTotalRevenue());
            }
        }
    %>
    
    <div class="container">
        <aside class="sidebar">
            <div class="sidebar-header">
                <h3>Admin Panel</h3>
            </div>
            <nav>
                <div class="sidebar-item">
                    <a href="${pageContext.request.contextPath}/pages/home.jsp">
                        <i>📊</i> Dashboard
                    </a>
                </div>
                <div class="sidebar-item">
                    <a href="${pageContext.request.contextPath}/pages/tracking.jsp">
                        <i>🔍</i> Tracking
                    </a>
                </div>
                <div class="sidebar-item active">
                    <a href="${pageContext.request.contextPath}/delivery-report">
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
        
        <div class="main-content">
            <div class="header">
                <h2>Monthly Delivery Report</h2>
            </div>
            
            <div class="content-area">
                <div class="filter-section">
                    <form id="yearForm" action="${pageContext.request.contextPath}/delivery-report" method="get">
                        <label for="year">Filter by Year:</label>
                        <select name="year" id="year" onchange="submitForm()">
                            <% for(int year = currentYear; year >= currentYear - 5; year--) { %>
                                <option value="<%= year %>" <%= (String.valueOf(year).equals(selectedYear) ? "selected" : "") %>><%= year %></option>
                            <% } %>
                        </select>
                    </form>
                </div>
                
                <h3>Monthly Delivery Details for <%= outletLocation %></h3>
                
                <table>
                    <thead>
                        <tr>
                            <th>Month</th>
                            <th>Year</th>
                            <th>Total Deliveries</th>
                            <th>Revenue (LKR)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (reports != null && !reports.isEmpty()) { %>
                            <% for (MonthlyReport report : reports) { %>
                                <tr>
                                    <td><%= report.getMonth().getMonth().toString() %></td>
                                    <td><%= report.getMonth().getYear() %></td>
                                    <td><%= report.getTotalDeliveries() %></td>
                                    <td>LKR <%= String.format("%.2f", report.getTotalRevenue()) %></td>
                                </tr>
                            <% } %>
                        <% } else { %>
                            <tr>
                                <td colspan="4" class="no-data">No data available</td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
                
                <div class="summary-section">
                    <h3>Summary</h3>
                    <div class="summary-info">
                        <div class="info-item">
                            Total Deliveries: <span class="value"><%= totalDeliveries %></span>
                        </div>
                        <div class="info-item">
                            Total Revenue: <span class="value">LKR <%= String.format("%.2f", totalRevenue) %></span>
                        </div>
                    </div>
                    <div class="summary-info">
                        <div class="info-item">
                            Logged in: <span class="value">${sessionScope.admin.adminName}</span>
                        </div>
                        <div class="info-item">
                            Location: <span class="value">${sessionScope.admin.outletLocation}</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>