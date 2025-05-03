
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
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Monthly Delivery Report</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500&family=Montserrat:wght@500;600;700&display=swap" rel="stylesheet">
    <!-- Font Awesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <!-- External CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/monthlyDeliveryReport.css">
    <!-- Chart.js for visualizations -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.7.1/chart.min.js"></script>
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
        
        // Month with highest deliveries
        int highestDeliveryCount = 0;
        String highestDeliveryMonth = "";
        
        // Month with highest revenue
        BigDecimal highestRevenue = BigDecimal.ZERO;
        String highestRevenueMonth = "";
        
        // Prepare data for charts
        StringBuilder monthLabels = new StringBuilder("[");
        StringBuilder deliveryData = new StringBuilder("[");
        StringBuilder revenueData = new StringBuilder("[");
        
        if (reports != null) {
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
                
                // Add data for charts
                monthLabels.append("'").append(report.getMonth().getMonth().toString()).append("',");
                deliveryData.append(report.getTotalDeliveries()).append(",");
                revenueData.append(report.getTotalRevenue()).append(",");
            }
        }
        
        // Close the arrays
        if (monthLabels.charAt(monthLabels.length() - 1) == ',') {
            monthLabels.setLength(monthLabels.length() - 1);
        }
        if (deliveryData.charAt(deliveryData.length() - 1) == ',') {
            deliveryData.setLength(deliveryData.length() - 1);
        }
        if (revenueData.charAt(revenueData.length() - 1) == ',') {
            revenueData.setLength(revenueData.length() - 1);
        }
        
        monthLabels.append("]");
        deliveryData.append("]");
        revenueData.append("]");
        
        // Calculate monthly averages
        double avgDeliveries = reports != null && !reports.isEmpty() ? 
            (double) totalDeliveries / reports.size() : 0;
        BigDecimal avgRevenue = reports != null && !reports.isEmpty() ? 
            totalRevenue.divide(new BigDecimal(reports.size()), 2, BigDecimal.ROUND_HALF_UP) : BigDecimal.ZERO;
    %>
    
    <!-- Mobile menu toggle button -->
    <button class="menu-toggle" id="menuToggle">
        <i class="fas fa-bars"></i>
    </button>
    
    <div class="container">
        <!-- Sidebar Navigation -->
        <aside class="sidebar" id="sidebar">
            <div class="sidebar-header">
                <h3><i class="fas fa-chart-line"></i> Admin Panel</h3>
            </div>
            <nav>
                <div class="sidebar-item" style="--i:1">
                    <a href="${pageContext.request.contextPath}/pages/home.jsp">
                        <i class="fas fa-tachometer-alt"></i> Dashboard
                    </a>
                </div>
                <div class="sidebar-item" style="--i:2">
                    <a href="${pageContext.request.contextPath}/pages/tracking.jsp">
                        <i class="fas fa-search-location"></i> Tracking
                    </a>
                </div>
                <div class="sidebar-item active" style="--i:3">
                    <a href="${pageContext.request.contextPath}/delivery-report">
                        <i class="fas fa-chart-bar"></i> Sales Report
                    </a>
                </div>
                <div class="sidebar-item" style="--i:4">
                    <a href="${pageContext.request.contextPath}/pages/addProduct.jsp">
                        <i class="fas fa-plus-circle"></i> Add Product
                    </a>
                </div>
                <div class="sidebar-item" style="--i:5">
                    <a href="${pageContext.request.contextPath}/pages/product-details.jsp">
                        <i class="fas fa-clipboard-list"></i> Product Details
                    </a>
                </div>
                <div class="sidebar-item" style="--i:6">
                    <a href="${pageContext.request.contextPath}/pages/item-details.jsp">
                        <i class="fas fa-box"></i> Inventory
                    </a>
                </div>
                <div class="sidebar-item" style="--i:7">
                    <a href="${pageContext.request.contextPath}/pages/add-staff.jsp">
                        <i class="fas fa-user-plus"></i> Add Staff
                    </a>
                </div>
                <div class="sidebar-item" style="--i:8">
                    <a href="${pageContext.request.contextPath}/pages/staff-management.jsp">
                        <i class="fas fa-users-cog"></i> Staff Management
                    </a>
                </div>
                <div class="sidebar-item" style="--i:9">
                    <a href="${pageContext.request.contextPath}/pages/login.jsp">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                </div>
            </nav>
        </aside>
        
        <!-- Main Content Area -->
        <div class="main-content">
            <!-- Header -->
            <header class="header">
                <h2><i class="fas fa-chart-line"></i> Monthly Delivery Report</h2>
                <div class="user-info">
                    <span>Welcome, ${sessionScope.admin.adminName}</span>
                    <div class="user-avatar">
                        ${sessionScope.admin.adminName.charAt(0)}
                    </div>
                </div>
            </header>
            
            <!-- Content Area -->
            <div class="content-area hover-lift">
                <!-- Filter Section -->
                <div class="filter-section">
                    <form id="yearForm" action="${pageContext.request.contextPath}/delivery-report" method="get">
                        <label for="year"><i class="fas fa-filter"></i> Filter by Year:</label>
                        <select name="year" id="year" onchange="submitForm()">
                            <% for(int year = currentYear; year >= currentYear - 5; year--) { %>
                                <option value="<%= year %>" <%= (String.valueOf(year).equals(selectedYear) ? "selected" : "") %>><%= year %></option>
                            <% } %>
                        </select>
                        <button type="button" class="btn btn-primary" id="printReportBtn">
                            <i class="fas fa-print"></i> Print Report
                        </button>
                    </form>
                </div>
                
                <!-- Branch Information -->
                <div class="branch-info" style="display: flex; align-items: center; margin-bottom: 20px; padding: 15px; background-color: #f0f7ff; border-radius: 8px;">
                    <i class="fas fa-building" style="font-size: 24px; margin-right: 12px; color: var(--primary);"></i>
                    <div>
                        <h3 style="margin: 0; font-size: 18px;">Monthly Delivery Details</h3>
                        <p style="margin: 5px 0 0 0; font-size: 16px;">
                            Branch: <strong><%= outletLocation %></strong> | Year: <strong><%= selectedYear %></strong>
                        </p>
                    </div>
                </div>
                
                <!-- Table -->
                <div class="table-responsive">
                    <table id="monthlyReportTable">
                        <thead>
                            <tr>
                                <th><i class="fas fa-calendar-alt"></i> Month</th>
                                <th><i class="fas fa-calendar-year"></i> Year</th>
                                <th><i class="fas fa-truck"></i> Total Deliveries</th>
                                <th><i class="fas fa-coins"></i> Revenue (LKR)</th>
                                <th><i class="fas fa-chart-pie"></i> % of Total</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (reports != null && !reports.isEmpty()) { 
                                int itemCounter = 0;
                                for (MonthlyReport report : reports) { 
                                    itemCounter++;
                                    double percentageOfTotal = totalRevenue.compareTo(BigDecimal.ZERO) > 0 ? 
                                        report.getTotalRevenue().multiply(new BigDecimal(100)).divide(totalRevenue, 2, BigDecimal.ROUND_HALF_UP).doubleValue() : 0;
                            %>
                                <tr style="animation-delay: <%= 0.1 * itemCounter %>s">
                                    <td><%= report.getMonth().getMonth().toString() %></td>
                                    <td><%= report.getMonth().getYear() %></td>
                                    <td>
                                        <span class="<%= report.getTotalDeliveries() == highestDeliveryCount ? "highlight-value" : "" %>">
                                            <%= report.getTotalDeliveries() %>
                                            <%= report.getTotalDeliveries() == highestDeliveryCount ? "<i class=\"fas fa-trophy\" style=\"color: gold; margin-left: 5px\"></i>" : "" %>
                                        </span>
                                    </td>
                                    <td>
                                        <span class="<%= report.getTotalRevenue().compareTo(highestRevenue) == 0 ? "highlight-value" : "" %>">
                                            LKR <%= String.format("%,.2f", report.getTotalRevenue()) %>
                                            <%= report.getTotalRevenue().compareTo(highestRevenue) == 0 ? "<i class=\"fas fa-crown\" style=\"color: gold; margin-left: 5px\"></i>" : "" %>
                                        </span>
                                    </td>
                                    <td>
                                        <div class="progress-container" style="width: 100%; background-color: #e9ecef; height: 8px; border-radius: 4px; margin-top: 5px;">
                                            <div class="progress-bar" style="width: <%= percentageOfTotal %>%; height: 100%; border-radius: 4px; background-color: var(--primary);"></div>
                                        </div>
                                        <span style="font-size: 0.85em; margin-top: 5px; display: inline-block;">
                                            <%= String.format("%.1f%%", percentageOfTotal) %>
                                        </span>
                                    </td>
                                </tr>
                            <% } 
                            } else { %>
                                <tr>
                                    <td colspan="5" class="no-data">
                                        <i class="fas fa-info-circle"></i> No data available for the selected year
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                
                <!-- Summary Section -->
                <div class="summary-section">
                    <h3><i class="fas fa-chart-line"></i> Performance Summary</h3>
                    
                    <div class="summary-cards" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; margin-bottom: 20px;">
                        <!-- Total Deliveries Card -->
                        <div class="summary-card" style="background-color: #f0f7ff; padding: 15px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.05);">
                            <div style="font-size: 14px; color: var(--gray);">Total Deliveries</div>
                            <div style="font-size: 24px; font-weight: 600; color: var(--primary); margin: 5px 0;" id="totalDeliveriesCounter">
                                <%= totalDeliveries %>
                            </div>
                            <div style="font-size: 13px;">
                                <i class="fas fa-trophy" style="color: gold;"></i> Peak Month: <strong><%= highestDeliveryMonth %></strong>
                            </div>
                        </div>
                        
                        <!-- Total Revenue Card -->
                        <div class="summary-card" style="background-color: #f0fff4; padding: 15px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.05);">
                            <div style="font-size: 14px; color: var(--gray);">Total Revenue</div>
                            <div style="font-size: 24px; font-weight: 600; color: var(--success); margin: 5px 0;" id="totalRevenueCounter">
                                LKR <%= String.format("%,.2f", totalRevenue) %>
                            </div>
                            <div style="font-size: 13px;">
                                <i class="fas fa-crown" style="color: gold;"></i> Best Month: <strong><%= highestRevenueMonth %></strong>
                            </div>
                        </div>
                        
                        <!-- Average Per Month -->
                        <div class="summary-card" style="background-color: #fff0f6; padding: 15px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.05);">
                            <div style="font-size: 14px; color: var(--gray);">Monthly Average</div>
                            <div style="font-size: 24px; font-weight: 600; color: var(--accent); margin: 5px 0;" id="avgDeliveriesCounter">
                                <%= String.format("%.1f", avgDeliveries) %> deliveries
                            </div>
                            <div style="font-size: 13px;">
                                <i class="fas fa-chart-line" style="color: var(--accent);"></i> Avg Revenue: <strong>LKR <%= String.format("%,.2f", avgRevenue) %></strong>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Chart Section -->
                <div class="chart-container hover-lift">
                    <h3><i class="fas fa-chart-bar"></i> Delivery & Revenue Trends</h3>
                    <canvas id="deliveryRevenueChart"></canvas>
                </div>
            </div>
        </div>
    </div>
    
    <!-- JavaScript for functionality -->
    <script>
        // Function to submit form when year is changed
        function submitForm() {
            document.getElementById('yearForm').submit();
        }
        
        // Mobile menu toggle
        document.addEventListener('DOMContentLoaded', function() {
            const menuToggle = document.getElementById('menuToggle');
            const sidebar = document.getElementById('sidebar');
            
            if (menuToggle) {
                menuToggle.addEventListener('click', function() {
                    sidebar.classList.toggle('active');
                });
            }
            
            // Print report functionality
            const printReportBtn = document.getElementById('printReportBtn');
            if (printReportBtn) {
                printReportBtn.addEventListener('click', function() {
                    window.print();
                });
            }
            
            // Animated counters
            function animateCounter(elementId, targetValue, prefix = '', suffix = '', duration = 1000) {
                const element = document.getElementById(elementId);
                if (!element) return;
                
                const startValue = 0;
                const increment = targetValue / (duration / 16);
                let currentValue = startValue;
                
                const formatValue = (value) => {
                    if (Number.isInteger(targetValue)) {
                        return Math.floor(value).toLocaleString();
                    } else {
                        return value.toFixed(1).toLocaleString();
                    }
                };
                
                const updateCounter = () => {
                    currentValue += increment;
                    if (currentValue >= targetValue) {
                        element.textContent = prefix + formatValue(targetValue) + suffix;
                    } else {
                        element.textContent = prefix + formatValue(currentValue) + suffix;
                        requestAnimationFrame(updateCounter);
                    }
                };
                
                updateCounter();
            }
            
            // Initialize animated counters
            animateCounter('totalDeliveriesCounter', <%= totalDeliveries %>);
            animateCounter('totalRevenueCounter', <%= totalRevenue %>, 'LKR ');
            animateCounter('avgDeliveriesCounter', <%= avgDeliveries %>, '', ' deliveries');
            
            // Create chart
            const ctx = document.getElementById('deliveryRevenueChart').getContext('2d');
            const deliveryRevenueChart = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: <%= monthLabels.toString() %>,
                    datasets: [{
                        label: 'Deliveries',
                        data: <%= deliveryData.toString() %>,
                        backgroundColor: 'rgba(0, 86, 179, 0.7)',
                        borderColor: 'rgba(0, 86, 179, 1)',
                        borderWidth: 1,
                        yAxisID: 'y'
                    }, {
                        label: 'Revenue (LKR)',
                        data: <%= revenueData.toString() %>,
                        type: 'line',
                        backgroundColor: 'rgba(76, 175, 80, 0.2)',
                        borderColor: 'rgba(76, 175, 80, 1)',
                        borderWidth: 2,
                        pointBackgroundColor: 'rgba(76, 175, 80, 1)',
                        pointRadius: 4,
                        pointHoverRadius: 6,
                        fill: true,
                        tension: 0.2,
                        yAxisID: 'y1'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    animation: {
                        duration: 1500,
                        easing: 'easeOutQuart'
                    },
                    interaction: {
                        mode: 'index',
                        intersect: false
                    },
                    scales: {
                        y: {
                            type: 'linear',
                            display: true,
                            position: 'left',
                            title: {
                                display: true,
                                text: 'Deliveries',
                                color: 'rgba(0, 86, 179, 1)',
                                font: {
                                    weight: 'bold'
                                }
                            },
                            beginAtZero: true
                        },
                        y1: {
                            type: 'linear',
                            display: true,
                            position: 'right',
                            title: {
                                display: true,
                                text: 'Revenue (LKR)',
                                color: 'rgba(76, 175, 80, 1)',
                                font: {
                                    weight: 'bold'
                                }
                            },
                            beginAtZero: true,
                            grid: {
                                drawOnChartArea: false
                            }
                        }
                    },
                    plugins: {
                        title: {
                            display: true,
                            text: 'Monthly Delivery & Revenue Trends for <%= selectedYear %>',
                            font: {
                                size: 16,
                                family: "'Montserrat', sans-serif",
                                weight: 'bold'
                            },
                            padding: 20
                        },
                        legend: {
                            position: 'bottom'
                        },
                        tooltip: {
                            backgroundColor: 'rgba(33, 37, 41, 0.8)',
                            titleFont: {
                                size: 14,
                                family: "'Montserrat', sans-serif"
                            },
                            bodyFont: {
                                size: 13,
                                family: "'Roboto', sans-serif"
                            },
                            padding: 12,
                            cornerRadius: 6,
                            caretSize: 6,
                            callbacks: {
                                label: function(context) {
                                    let label = context.dataset.label || '';
                                    if (label) {
                                        label += ': ';
                                    }
                                    if (context.datasetIndex === 0) {
                                        label += context.raw.toLocaleString();
                                    } else {
                                        label += 'LKR ' + context.raw.toLocaleString();
                                    }
                                    return label;
                                }
                            }
                        }
                    }
                }
            });
        });
    </script>
</body>
</html>
```