<%@page import="model.Admin"%>
<%@page import="service.AdminService"%>
<%@page import="dao.DBHelper"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.Comparator" %>
<%@ page import="model.MonthlyReport" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.time.YearMonth" %>
<%@ page import="java.time.Month" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page session="true" %>
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
    
    // Sort reports by month chronologically (January to December)
    if (reports != null && !reports.isEmpty()) {
        Collections.sort(reports, new Comparator<MonthlyReport>() {
            @Override
            public int compare(MonthlyReport r1, MonthlyReport r2) {
                return r1.getMonth().getMonthValue() - r2.getMonth().getMonthValue();
            }
        });
    }
    
    // Calculate totals
    int totalDeliveries = 0;
    BigDecimal totalRevenue = BigDecimal.ZERO;
    
    // Month with highest deliveries
    int highestDeliveryCount = 0;
    String highestDeliveryMonth = "";
    
    // Month with highest revenue
    BigDecimal highestRevenue = BigDecimal.ZERO;
    String highestRevenueMonth = "";
    
    // Growth rates - month-to-month
    double deliveryGrowthRate = 0;
    double revenueGrowthRate = 0;
    
    // Prepare data for charts
    StringBuilder monthLabels = new StringBuilder("[");
    StringBuilder deliveryData = new StringBuilder("[");
    StringBuilder revenueData = new StringBuilder("[");
    StringBuilder growthData = new StringBuilder("[");
    
    if (reports != null && !reports.isEmpty()) {
        int previousMonthDeliveries = 0;
        BigDecimal previousMonthRevenue = BigDecimal.ZERO;
        int monthCount = 0;
        
        for (MonthlyReport report : reports) {
            totalDeliveries += report.getTotalDeliveries();
            totalRevenue = totalRevenue.add(report.getTotalRevenue());
            
            // Check for highest delivery
            if (report.getTotalDeliveries() > highestDeliveryCount) {
                highestDeliveryCount = report.getTotalDeliveries();
                highestDeliveryMonth = report.getMonth().getMonth().toString();
            }
            
            // Check for highest revenue
            if (report.getTotalRevenue().compareTo(highestRevenue) > 0) {
                highestRevenue = report.getTotalRevenue();
                highestRevenueMonth = report.getMonth().getMonth().toString();
            }
            
            // Calculate growth rates if not first month
            if (monthCount > 0 && previousMonthDeliveries > 0) {
                double monthlyDeliveryGrowth = ((double)(report.getTotalDeliveries() - previousMonthDeliveries) / previousMonthDeliveries) * 100;
                growthData.append(monthlyDeliveryGrowth).append(",");
                
                // Contribute to overall growth rate
                deliveryGrowthRate += monthlyDeliveryGrowth;
            } else if (monthCount > 0) {
                growthData.append("0,");
            }
            
            // Add data for charts
            monthLabels.append("'").append(report.getMonth().getMonth().toString()).append("',");
            deliveryData.append(report.getTotalDeliveries()).append(",");
            revenueData.append(report.getTotalRevenue()).append(",");
            
            // Store for next iteration
            previousMonthDeliveries = report.getTotalDeliveries();
            previousMonthRevenue = report.getTotalRevenue();
            monthCount++;
        }
        
        // Calculate average growth rates
        if (monthCount > 1) {
            deliveryGrowthRate = deliveryGrowthRate / (monthCount - 1);
            // Round to 2 decimal places
            deliveryGrowthRate = Math.round(deliveryGrowthRate * 100.0) / 100.0;
        }
    }
    
    // Close the arrays
    if (monthLabels.length() > 1 && monthLabels.charAt(monthLabels.length() - 1) == ',') {
        monthLabels.setLength(monthLabels.length() - 1);
    }
    if (deliveryData.length() > 1 && deliveryData.charAt(deliveryData.length() - 1) == ',') {
        deliveryData.setLength(deliveryData.length() - 1);
    }
    if (revenueData.length() > 1 && revenueData.charAt(revenueData.length() - 1) == ',') {
        revenueData.setLength(revenueData.length() - 1);
    }
    if (growthData.length() > 1 && growthData.charAt(growthData.length() - 1) == ',') {
        growthData.setLength(growthData.length() - 1);
    }
    
    monthLabels.append("]");
    deliveryData.append("]");
    revenueData.append("]");
    growthData.append("]");
    
    // Calculate monthly averages
    double avgDeliveries = reports != null && !reports.isEmpty() ? 
        (double) totalDeliveries / reports.size() : 0;
    BigDecimal avgRevenue = reports != null && !reports.isEmpty() ? 
        totalRevenue.divide(new BigDecimal(reports.size()), 2, BigDecimal.ROUND_HALF_UP) : BigDecimal.ZERO;
%>
<!DOCTYPE html>
<html>
<head>
    <title>Monthly Delivery Report</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.7.1/chart.min.js"></script>
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
            --accent: #ff9800;
            --sidebar-width: 240px;
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            --shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            --shadow-hover: 0 10px 15px rgba(0, 0, 0, 0.2);
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
            animation: slideIn 0.4s ease-out forwards;
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
        
        /* Branch Info Display */
        .branch-info {
            background: var(--primary);
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            animation: fadeIn 0.6s 0.3s both;
        }
        
        .branch-info i {
            font-size: 1.25rem;
        }
        
        /* Filter Section */
        .filter-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            background: var(--primary-dark);
            padding: 1rem 1.5rem;
            border-radius: 0.5rem;
            border: 1px solid var(--primary-light);
            animation: fadeIn 0.6s 0.2s both;
        }
        
        .filter-section form {
            display: flex;
            align-items: center;
            justify-content: space-between;
            width: 100%;
        }
        
        .filter-section label {
            margin-right: 0.75rem;
            font-weight: 500;
        }
        
        .filter-section select {
            background-color: var(--primary);
            color: var(--light);
            border: 1px solid var(--primary-light);
            padding: 0.5rem 1rem;
            border-radius: 0.375rem;
            outline: none;
            cursor: pointer;
            transition: var(--transition);
        }
        
        .filter-section select:hover, 
        .filter-section select:focus {
            border-color: var(--secondary);
        }
        
        /* Table Styles */
        .table-responsive {
            overflow-x: auto;
            margin-bottom: 2rem;
            animation: fadeIn 0.6s 0.4s both;
            border-radius: 0.5rem;
            border: 1px solid var(--primary-light);
            background: var(--primary-dark);
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        th, td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid var(--primary-light);
        }
        
        th {
            background-color: var(--primary);
            color: var(--light);
            font-weight: 600;
            white-space: nowrap;
        }
        
        tr:hover {
            background-color: rgba(48, 63, 159, 0.1);
        }
        
        tr {
            animation: fadeIn 0.5s calc(0.1s * var(--i)) both;
        }
        
        .highlight-value {
            color: var(--accent);
            font-weight: 600;
        }
        
        .no-data {
            text-align: center;
            padding: 2rem;
            color: var(--gray);
        }
        
        /* Progress Bar */
        .progress-container {
            width: 100%;
            background-color: var(--primary-dark);
            border-radius: 10px;
            height: 6px;
            overflow: hidden;
        }
        
        .progress-bar {
            background-color: var(--secondary);
            height: 100%;
            border-radius: 10px;
            transition: width 1s ease-in-out;
        }
        
        /* Growth Indicators */
        .growth-positive {
            color: var(--success);
            font-weight: 500;
        }
        
        .growth-negative {
            color: var(--danger);
            font-weight: 500;
        }
        
        .growth-neutral {
            color: var(--gray);
            font-weight: 500;
        }
        
        /* Summary Section */
        .summary-section {
            margin-bottom: 2rem;
            animation: fadeIn 0.6s 0.5s both;
        }
        
        .summary-section h3 {
            margin-bottom: 1rem;
            color: var(--light);
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .summary-cards {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 1.5rem;
        }
        
        .summary-card {
            background: var(--primary-dark);
            border: 1px solid var(--primary-light);
            border-radius: 0.5rem;
            padding: 1.25rem;
            transition: var(--transition);
            box-shadow: var(--shadow);
        }
        
        .summary-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-hover);
            border-color: var(--secondary);
        }
        
        /* Chart Container */
        .chart-container {
            background: var(--primary-dark);
            border: 1px solid var(--primary-light);
            border-radius: 0.5rem;
            padding: 1.5rem;
            margin-bottom: 2rem;
            animation: fadeIn 0.6s 0.6s both;
            transition: var(--transition);
            box-shadow: var(--shadow);
            height: 400px;
        }
        
        .chart-container:hover {
            box-shadow: var(--shadow-hover);
            border-color: var(--secondary);
        }
        
        .chart-container h3 {
            margin-bottom: 1rem;
            color: var(--light);
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.5rem;
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
        }
        
        .btn-primary {
            background-color: var(--secondary);
            color: white;
        }
        
        .btn-primary:hover {
            background-color: #1565c0;
            transform: translateY(-2px);
        }
        
        /* Utility Classes */
        .hover-lift {
            transition: var(--transition);
        }
        
        .hover-lift:hover {
            transform: translateY(-5px);
        }
        
        .text-success {
            color: var(--success);
        }
        
        .text-danger {
            color: var(--danger);
        }
        
        /* Mobile Menu Toggle */
        .menu-toggle {
            position: fixed;
            top: 1rem;
            left: 1rem;
            z-index: 1000;
            background: var(--primary);
            color: white;
            border: none;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            display: none;
            justify-content: center;
            align-items: center;
            cursor: pointer;
            box-shadow: var(--shadow);
        }
        
        /* Action button styles */
        .action-buttons {
            display: flex;
            gap: 10px;
        }
        
        .export-btn {
            background-color: var(--success);
            color: white;
        }
        
        .export-btn:hover {
            background-color: #388e3c;
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
            }
            
            .menu-toggle {
                display: flex;
            }
            
            .filter-section form {
                flex-direction: column;
                align-items: flex-start;
                gap: 1rem;
            }
            
            .summary-cards {
                grid-template-columns: 1fr;
            }
        }
        
        /* Print Styles */
        @media print {
            .sidebar, .menu-toggle, .btn {
                display: none;
            }
    
            .main-content {
                margin-left: 0;
                padding: 0;
                width: 100%;
            }

            body {
                background: white;
                color: black;
                width: 100%;
            }
            
            /* Make charts display in a single column */
            .main-content > div[style*="grid-template-columns"] {
                display: block !important;
                margin-bottom: 30px;
            }

            /* Fix chart containers */
            .chart-container {
                width: 100%;
                height: 350px !important;
                margin-bottom: 30px;
                page-break-inside: avoid;
                break-inside: avoid;
                border: 1px solid #ccc !important; /* Ensure border is visible */
                background-color: white !important; /* White background for print */
                box-shadow: none !important; /* Remove shadows in print */
            }

            /* Fix for chart rendering */
            canvas {
                max-width: 100% !important;
                height: auto !important;
            }

            /* Fix table borders */
            .table-responsive {
                border: 1px solid #ccc !important;
                break-inside: avoid;
                page-break-inside: avoid;
                margin-bottom: 20px;
                background-color: white !important;
            }

            table {
                border-collapse: collapse !important;
                width: 100% !important;
            }

            th, td {
                border: 1px solid #ccc !important;
                padding: 8px !important;
                text-align: left;
            }

            th {
                background-color: #f2f2f2 !important;
                color: black !important;
            }

            tr:nth-child(even) {
                background-color: #f9f9f9 !important;
            }

            /* Summary cards */
            .summary-card {
                border: 1px solid #ccc !important;
                background-color: white !important;
                break-inside: avoid;
                page-break-inside: avoid;
                color: black !important;
            }
            
            .summary-card div {
                color: black !important;
            }

            /* Ensure proper page breaks */
            .summary-section {
                page-break-after: always;
            }

            /* Colors for print */
            .highlight-value, .growth-positive, .growth-negative, .growth-neutral {
                color: black !important;
                font-weight: bold !important;
            }

            /* Progress bar for print */
            .progress-container {
                border: 1px solid #ccc !important;
            }

            .progress-bar {
                background-color: #888 !important;
            }
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
        
        @keyframes slideIn {
            from { transform: translateX(-20px); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }
        
        .pulse {
            animation: pulse 2s infinite;
        }
    </style>
</head>
<body>
    <!-- Mobile menu toggle button -->
    <button class="menu-toggle" id="menuToggle">
        <i>☰</i>
    </button>

    <div class="dashboard-container">
        <!-- Sidebar Navigation -->
        <aside class="sidebar" id="sidebar">
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
                    <a href="${pageContext.request.contextPath}/pages/monthly_report.jsp">
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

        <!-- Main Content Area -->
        <main class="main-content">
            <!-- Header -->
            <header class="header">
                <h1>Monthly Delivery Report</h1>
                <div class="user-info">
                    <span>Welcome, ${sessionScope.admin.adminName}</span>
                    <div class="user-avatar">
                        ${sessionScope.admin.adminName.charAt(0)}
                    </div>
                </div>
            </header>

            <!-- Filter Section -->
            <div class="filter-section">
                <form id="yearForm" action="${pageContext.request.contextPath}/delivery-report" method="get">
                    <div>
                        <label for="year"><i>🗓️</i> Filter by Year:</label>
                        <select name="year" id="year" onchange="submitForm()">
                            <% for(int year = currentYear; year >= currentYear - 5; year--) { %>
                                <option value="<%= year %>" <%= (String.valueOf(year).equals(selectedYear) ? "selected" : "") %>><%= year %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="action-buttons">
                        <button type="button" class="btn btn-primary" id="printReportBtn">
                            <i>🖨️</i> Print Report
                        </button>
                        <button type="button" class="btn export-btn" id="exportExcelBtn">
                            <i>📊</i> Export Excel
                        </button>
                    </div>
                </form>
            </div>

            <!-- Branch Information -->
            <div class="branch-info">
                <i>🏢</i>
                <div>
                    <span>Branch: <strong><%= outletLocation %></strong> | Year: <strong><%= selectedYear %></strong></span>
                </div>
            </div>

            <!-- Table -->
            <div class="table-responsive">
                <table id="monthlyReportTable">
                    <thead>
                        <tr>
                            <th><i>📅</i> Month</th>
                            <th><i>📆</i> Year</th>
                            <th><i>🚚</i> Total Deliveries</th>
                            <th><i>💰</i> Revenue (LKR)</th>
                            <th><i>📊</i> % of Total</th>
                            <th><i>📈</i> Growth</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (reports != null && !reports.isEmpty()) { 
                            int itemCounter = 0;
                            int previousDeliveries = 0;
                            BigDecimal previousRevenue = BigDecimal.ZERO;
                            boolean isFirstMonth = true;
                            
                            for (MonthlyReport report : reports) { 
                                itemCounter++;
                                double percentageOfTotal = totalRevenue.compareTo(BigDecimal.ZERO) > 0 ? 
                                    report.getTotalRevenue().multiply(new BigDecimal(100)).divide(totalRevenue, 2, BigDecimal.ROUND_HALF_UP).doubleValue() : 0;
                                
                                // Calculate growth rate for this month
                                double deliveryGrowth = 0;
                                if (!isFirstMonth && previousDeliveries > 0) {
                                    deliveryGrowth = ((double)(report.getTotalDeliveries() - previousDeliveries) / previousDeliveries) * 100;
                                }
                                
                                String growthIcon = "";
                                String growthClass = "";
                                if (!isFirstMonth) {
                                    if (deliveryGrowth > 0) {
                                        growthIcon = "<i>▲</i>";
                                        growthClass = "growth-positive";
                                    } else if (deliveryGrowth < 0) {
                                        growthIcon = "<i>▼</i>";
                                        growthClass = "growth-negative";
                                    } else {
                                        growthIcon = "<i>◆</i>";
                                        growthClass = "growth-neutral";
                                    }
                                }
                        %>
                            <tr style="--i:<%= itemCounter %>">
                                <td><%= report.getMonth().getMonth().toString() %></td>
                                <td><%= report.getMonth().getYear() %></td>
                                <td>
                                    <span class="<%= report.getTotalDeliveries() == highestDeliveryCount ? "highlight-value" : "" %>">
                                        <%= report.getTotalDeliveries() %></span>
                                </td>
                                <td>
                                    <span class="<%= report.getTotalRevenue().compareTo(highestRevenue) == 0 ? "highlight-value" : "" %>">
                                        LKR <%= String.format("%,.2f", report.getTotalRevenue()) %>
                                    </span>
                                </td>
                                <td>
                                    <div class="progress-container">
                                        <div class="progress-bar" style="width: <%= percentageOfTotal %>%;"></div>
                                    </div>
                                    <%= String.format("%.1f", percentageOfTotal) %>%
                                </td>
                                <td class="<%= growthClass %>">
                                    <% if (!isFirstMonth) { %>
                                        <%= growthIcon %> <%= String.format("%.1f", deliveryGrowth) %>%
                                    <% } else { %>
                                        <span class="growth-neutral">—</span>
                                    <% } %>
                                </td>
                            </tr>
                        <% 
                            // Store current values for next iteration
                            previousDeliveries = report.getTotalDeliveries();
                            previousRevenue = report.getTotalRevenue();
                            isFirstMonth = false;
                            }
                        } else { %>
                            <tr>
                                <td colspan="6" class="no-data">No data available for <%= selectedYear %></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <!-- Summary Section -->
            <div class="summary-section">
                <h3><i>📊</i> Summary Analysis</h3>
                <div class="summary-cards">
                    <!-- Total Deliveries Card -->
                    <div class="summary-card">
                        <div style="font-size: 14px; color: var(--gray);">Total Deliveries</div>
                        <div style="font-size: 24px; font-weight: 600; color: var(--secondary); margin: 10px 0;" id="totalDeliveriesCounter">
                            <%= totalDeliveries %>
                        </div>
                        <div style="font-size: 13px; color: var(--light);">
                            <i>🏆</i> Highest: <strong><%= highestDeliveryMonth %> (<%= highestDeliveryCount %>)</strong>
                        </div>
                    </div>
                    
                    <!-- Total Revenue Card -->
                    <div class="summary-card">
                        <div style="font-size: 14px; color: var(--gray);">Total Revenue</div>
                        <div style="font-size: 24px; font-weight: 600; color: var(--success); margin: 10px 0;">
                            LKR <%= String.format("%,.2f", totalRevenue) %>
                        </div>
                        <div style="font-size: 13px; color: var(--light);">
                            <i>💎</i> Best Month: <strong><%= highestRevenueMonth %></strong>
                        </div>
                    </div>
                    
                    <!-- Growth Rate Card -->
                    <div class="summary-card">
                        <div style="font-size: 14px; color: var(--gray);">Average Growth</div>
                        <div style="font-size: 24px; font-weight: 600; color: <%= deliveryGrowthRate >= 0 ? "var(--success)" : "var(--danger)" %>; margin: 10px 0;">
                            <%= String.format("%.1f", deliveryGrowthRate) %>%
                        </div>
                        <div style="font-size: 13px; color: var(--light);">
                            <i><%= deliveryGrowthRate >= 0 ? "🚀" : "📉" %></i> 
                            <%= deliveryGrowthRate >= 0 ? "Positive" : "Negative" %> Trend
                        </div>
                    </div>
                    
                    <!-- Monthly Average Card -->
                    <div class="summary-card">
                        <div style="font-size: 14px; color: var(--gray);">Monthly Average</div>
                        <div style="font-size: 24px; font-weight: 600; color: var(--secondary); margin: 10px 0;">
                            <%= String.format("%.0f", avgDeliveries) %>
                        </div>
                        <div style="font-size: 13px; color: var(--light);">
                            <i>🔄</i> Avg Revenue: <strong>LKR <%= String.format("%,.2f", avgRevenue) %></strong>
                        </div>
                    </div>
                    
                    <!-- Outlet Performance Card -->
                    <div class="summary-card">
                        <div style="font-size: 14px; color: var(--gray);">Outlet Performance</div>
                        <div style="font-size: 24px; font-weight: 600; color: var(--accent); margin: 10px 0;">
                            <%= outletLocation %>
                        </div>
                        <div style="font-size: 13px; color: var(--light);">
                            <i>📍</i> Year: <strong><%= selectedYear %></strong>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Chart Sections -->
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem;">
                <!-- Delivery Trends Chart -->
                <div class="chart-container">
                    <h3><i>📈</i> Delivery Trends</h3>
                    <canvas id="deliveryChart"></canvas>
                </div>
                
                <!-- Revenue Chart -->
                <div class="chart-container">
                    <h3><i>💰</i> Revenue Analysis</h3>
                    <canvas id="revenueChart"></canvas>
                </div>
            </div>
            
            <!-- Growth Rate Chart -->
            <div class="chart-container">
                <h3><i>🚀</i> Monthly Growth Rate</h3>
                <canvas id="growthChart"></canvas>
            </div>
        </main>
    </div>

<%-- Fix for the submitForm function being in the wrong scope --%>
<script>
    // Move submitForm to global scope so it can be called from the onchange attribute
    function submitForm() {
        // Submit the form when the year selection changes
        document.getElementById('yearForm').submit();
    }

    document.addEventListener('DOMContentLoaded', function() {
        // Chart color palette
        const colors = {
            primary: '#303f9f',
            secondary: '#1976d2',
            accent: '#ff9800',
            success: '#4caf50',
            danger: '#f44336',
            light: '#e3f2fd',
            gray: '#90a4ae'
        };
        
        // Common chart options
        const chartOptions = {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'top',
                    labels: {
                        color: colors.light,
                        font: {
                            family: "'Inter', sans-serif",
                            size: 12
                        }
                    }
                },
                tooltip: {
                    backgroundColor: 'rgba(26, 35, 126, 0.8)',
                    titleFont: {
                        family: "'Inter', sans-serif",
                        size: 14
                    },
                    bodyFont: {
                        family: "'Inter', sans-serif",
                        size: 13
                    },
                    padding: 10,
                    cornerRadius: 4
                }
            },
            scales: {
                x: {
                    grid: {
                        color: 'rgba(144, 164, 174, 0.1)'
                    },
                    ticks: {
                        color: colors.gray
                    }
                },
                y: {
                    grid: {
                        color: 'rgba(144, 164, 174, 0.1)'
                    },
                    ticks: {
                        color: colors.gray
                    }
                }
            }
        };
        
        // Fix month order - Convert month names to proper order
        const months = ["JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE", "JULY", "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER"];
        
        // Get data and sort by month order
        const rawLabels = <%= monthLabels.toString() %>;
        const rawDeliveryData = <%= deliveryData.toString() %>;
        const rawRevenueData = <%= revenueData.toString() %>;
        const rawGrowthData = <%= growthData.toString() %>;
        
        // Create data object for sorting
        let dataArray = [];
        for (let i = 0; i < rawLabels.length; i++) {
            dataArray.push({
                month: rawLabels[i],
                monthIndex: months.indexOf(rawLabels[i].toUpperCase()),
                deliveries: rawDeliveryData[i],
                revenue: rawRevenueData[i],
                growth: rawGrowthData[i] || 0
            });
        }
        
        // Sort by month index
        dataArray.sort((a, b) => a.monthIndex - b.monthIndex);
        
        // Extract sorted data
        const sortedLabels = dataArray.map(item => item.month);
        const sortedDeliveryData = dataArray.map(item => item.deliveries);
        const sortedRevenueData = dataArray.map(item => item.revenue);
        const sortedGrowthData = dataArray.map(item => item.growth);
        
        // Delivery chart
        const deliveryCtx = document.getElementById('deliveryChart').getContext('2d');
        const deliveryChart = new Chart(deliveryCtx, {
            type: 'line',
            data: {
                labels: sortedLabels,
                datasets: [{
                    label: 'Total Deliveries',
                    data: sortedDeliveryData,
                    backgroundColor: 'rgba(25, 118, 210, 0.2)',
                    borderColor: colors.secondary,
                    borderWidth: 2,
                    tension: 0.3,
                    pointBackgroundColor: colors.secondary,
                    pointBorderColor: '#fff',
                    pointRadius: 4,
                    pointHoverRadius: 6,
                    fill: true
                }]
            },
            options: {
                ...chartOptions,
                scales: {
                    ...chartOptions.scales,
                    y: {
                        ...chartOptions.scales.y,
                        beginAtZero: true,
                        title: {
                            display: true,
                            text: 'Number of Deliveries',
                            color: colors.gray
                        }
                    }
                }
            }
        });
        
        // Revenue chart
        const revenueCtx = document.getElementById('revenueChart').getContext('2d');
        const revenueChart = new Chart(revenueCtx, {
            type: 'bar',
            data: {
                labels: sortedLabels,
                datasets: [{
                    label: 'Revenue (LKR)',
                    data: sortedRevenueData,
                    backgroundColor: 'rgba(76, 175, 80, 0.4)',
                    borderColor: colors.success,
                    borderWidth: 1,
                    barPercentage: 0.7,
                    categoryPercentage: 0.8
                }]
            },
            options: {
                ...chartOptions,
                scales: {
                    ...chartOptions.scales,
                    y: {
                        ...chartOptions.scales.y,
                        beginAtZero: true,
                        title: {
                            display: true,
                            text: 'Revenue (LKR)',
                            color: colors.gray
                        },
                        ticks: {
                            callback: function(value) {
                                return 'LKR ' + value.toLocaleString();
                            }
                        }
                    }
                }
            }
        });
        
        // Growth chart
        const growthCtx = document.getElementById('growthChart').getContext('2d');
        const growthChart = new Chart(growthCtx, {
            type: 'line',
            data: {
                labels: sortedLabels,
                datasets: [{
                    label: 'Growth Rate (%)',
                    data: sortedGrowthData,
                    backgroundColor: 'rgba(255, 152, 0, 0.2)',
                    borderColor: colors.accent,
                    borderWidth: 2,
                    fill: true,
                    tension: 0.4,
                    pointBackgroundColor: colors.accent,
                    pointBorderColor: '#fff',
                    pointRadius: 4,
                    pointHoverRadius: 6
                }]
            },
            options: {
                ...chartOptions,
                scales: {
                    ...chartOptions.scales,
                    y: {
                        ...chartOptions.scales.y,
                        title: {
                            display: true,
                            text: 'Growth Rate (%)',
                            color: colors.gray
                        },
                        ticks: {
                            callback: function(value) {
                                return value + '%';
                            }
                        }
                    }
                },
                plugins: {
                    ...chartOptions.plugins,
                    tooltip: {
                        ...chartOptions.plugins.tooltip,
                        callbacks: {
                            label: function(context) {
                                return context.parsed.y.toFixed(1) + '%';
                            }
                        }
                    }
                }
            }
        });
        
        // Counter animation for summary cards
        function animateCounter(elementId, endValue, prefix = '', suffix = '', duration = 1500) {
            const element = document.getElementById(elementId);
            if (!element) return;
            
            const startValue = 0;
            const increment = endValue / (duration / 16);
            let currentValue = startValue;
            
            const formatValue = (value) => {
                if (typeof value === 'number') {
                    return value.toLocaleString('en-US', {
                        maximumFractionDigits: 2
                    });
                }
                return value;
            };
            
            const updateCounter = () => {
                currentValue += increment;
                if (currentValue >= endValue) {
                    element.textContent = prefix + formatValue(endValue) + suffix;
                    return;
                }
                
                element.textContent = prefix + formatValue(Math.floor(currentValue)) + suffix;
                requestAnimationFrame(updateCounter);
            };
            
            updateCounter();
        }
        
        // Animate counters
        animateCounter('totalDeliveriesCounter', <%= totalDeliveries %>);
        // For revenue, we don't animate due to formatting requirements
    });

    // Print Report Button functionality - moved outside DOMContentLoaded
    document.getElementById('printReportBtn').addEventListener('click', function() {
        // Trigger the browser's print dialog
        window.print();
    });

    // Export Excel Button functionality
    document.getElementById('exportExcelBtn').addEventListener('click', function() {
        // Create a temporary anchor element
        const link = document.createElement('a');

        // Get the selected year and outlet location from the page
        const selectedYear = <%= selectedYear %>;
        const outletLocation = "<%= outletLocation.replace("\"", "\\\"") %>";

        // Set file name - replace spaces with underscores
        const fileName = "Monthly_Delivery_Report_" + selectedYear + "_" + outletLocation.replace(/\s+/g, '_') + ".csv";

        // Get table data
        const table = document.getElementById('monthlyReportTable');
        let csvContent = "data:text/csv;charset=utf-8,";

        // Get headers
        const headers = [];
        const headerCells = table.querySelectorAll('thead th');
        headerCells.forEach(cell => {
            // Remove icons from header text - simplified regex for broader browser support
            const text = cell.textContent.replace(/[^\x00-\x7F]/g, '').trim();
            headers.push('"' + text + '"');
        });
        csvContent += headers.join(",") + "\r\n";

        // Get rows
        const rows = table.querySelectorAll('tbody tr');
        rows.forEach(row => {
            const rowData = [];
            const cells = row.querySelectorAll('td');

            cells.forEach(cell => {
                // Clean up text content (remove special characters, trim whitespace)
                let text = cell.textContent.replace(/[^\x00-\x7F]/g, '');
                // For revenue columns, remove "LKR " prefix
                text = text.replace('LKR ', '');
                text = text.trim();
                rowData.push('"' + text + '"');
            });

            csvContent += rowData.join(",") + "\r\n";
        });

        // Add summary data
        const totalDeliveriesValue = <%= totalDeliveries %>;
        const totalRevenueValue = "<%= String.format("%,.2f", totalRevenue).replace(",", "") %>";
        const growthRateValue = "<%= String.format("%.1f", deliveryGrowthRate) %>";
        const avgDeliveriesValue = "<%= String.format("%.0f", avgDeliveries) %>";
        const avgRevenueValue = "<%= String.format("%,.2f", avgRevenue).replace(",", "") %>";

        csvContent += '"Summary","","","","",""\r\n';
        csvContent += '"Total Deliveries","' + totalDeliveriesValue + '","","","",""\r\n';
        csvContent += '"Total Revenue","' + totalRevenueValue + '","","","",""\r\n';
        csvContent += '"Average Growth Rate","' + growthRateValue + '%","","","",""\r\n';
        csvContent += '"Monthly Average Deliveries","' + avgDeliveriesValue + '","","","",""\r\n';
        csvContent += '"Monthly Average Revenue","' + avgRevenueValue + '","","","",""\r\n';

        // Encode the CSV data to handle special characters
        const encodedUri = encodeURI(csvContent);
        link.setAttribute("href", encodedUri);
        link.setAttribute("download", fileName);
        document.body.appendChild(link);

        // Trigger download
        link.click();

        // Clean up
        document.body.removeChild(link);
    });
</script>
</body>
</html>