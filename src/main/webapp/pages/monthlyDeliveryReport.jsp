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
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/monthlyDeliveryReport.css">
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
                    <a href="${pageContext.request.contextPath}/pages/OutletDashBoard.jsp">
                        <i>📊</i> Dashboard
                    </a>
                </div>
                <div class="sidebar-item">
                    <a href="${pageContext.request.contextPath}/pages/updateTracking.jsp">
                        <i>🔍</i> Tracking
                    </a>
                </div>
                <div class="sidebar-item active">
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
                         <button type="button" class="btn btn-primary" id="jumpToChartsBtn" onclick="jumpToCharts()">
                              <i>📊</i> View Charts
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
                        
                <div class="chart-reminder" style="margin-bottom: 1.5rem; background: var(--primary); padding: 1rem; border-radius: 0.5rem; border-left: 4px solid var(--accent); display: flex; align-items: center; gap: 1rem;">
                    <div style="font-size: 1.5rem;">📊</div>
                    <div>
                        <h3 style="margin: 0; color: var(--light);">Charts & Visualizations</h3>
                        <p style="margin: 0.25rem 0 0 0; color: var(--gray-light);">Visual representation of your monthly delivery performance</p>
                    </div>
                </div>
            <!-- Chart Sections -->
            <div id="chartsSection" style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem;">
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
               <!-- Return to Top Button -->
            <div style="text-align: center; margin: 2rem 0;">
                <button class="btn btn-primary" onclick="window.scrollTo({top: 0, behavior: 'smooth'})">
                    <i>⬆️</i> Return to Top
                </button>
            </div>
        </main>
    </div>>

<%-- Fix for the submitForm function being in the wrong scope --%>
<script>
    
    function jumpToCharts() {
    const chartsSection = document.getElementById('chartsSection');
    if (chartsSection) {
        chartsSection.scrollIntoView({ behavior: 'smooth' });
        
        // Add a brief highlight effect
        chartsSection.style.animation = 'none';
        setTimeout(() => {
            chartsSection.style.animation = 'pulse 1s ease-in-out';
        }, 10);
    }
}
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