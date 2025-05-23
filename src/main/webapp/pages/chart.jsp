<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.text.DecimalFormat" %>
<html>
<head>
    <title>Product Pricing Chart</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/trackingUpdate.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/chart.css">
    <script>
        // Automatically submit form when page loads to get 2025 data
        window.onload = function() {
            // Only submit if no year parameter is present in URL
            if (!window.location.href.includes("year=")) {
                document.querySelector('form').submit();
            }
        };
    </script>
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
                    <div class="sidebar-item active">
                        <a href="${pageContext.request.contextPath}/pages/chart.jsp">
                            <i>📈</i> Analysis
                        </a>
                    </div>
                    <div class="sidebar-item ">
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

            <!-- Chart Container -->
            <div class="chart-container">
                <div class="chart-header">
                    <h2>Monthly Product Revenue</h2>
                    <div class="chart-controls">
                        <form method="get" action="${pageContext.request.contextPath}/ChartServlet">
                            <label for="year">Select Year:</label>
                            <select name="year" id="year" onchange="this.form.submit()">
                                <% for (int y = 2020; y <= 2025; y++) { 
                                    String selectedYear = (String) request.getAttribute("selectedYear");
                                    if (selectedYear == null) selectedYear = "2025";
                                    String selected = selectedYear.equals(String.valueOf(y)) ? "selected" : "";
                                %>
                                <option value="<%= y %>" <%= selected %>><%= y %></option>
                                <% } %>
                            </select>
                        </form>
                    </div>
                </div>
                
                <div class="chart-wrapper">
                    <canvas id="priceChart"></canvas>
                </div>
                
                <%
                    String[] months = (String[]) request.getAttribute("months");
                    double[] prices = (double[]) request.getAttribute("prices");

                    if (months != null && prices != null) {
                        StringBuilder jsMonths = new StringBuilder("[");
                        for (int i = 0; i < months.length; i++) {
                            jsMonths.append("\"").append(months[i]).append("\"");
                            if (i < months.length - 1) jsMonths.append(", ");
                        }
                        jsMonths.append("]");

                        StringBuilder jsPrices = new StringBuilder("[");
                        for (int i = 0; i < prices.length; i++) {
                            jsPrices.append(prices[i]);
                            if (i < prices.length - 1) jsPrices.append(", ");
                        }
                        jsPrices.append("]");
                %>

                <script>
                    const labels = <%= jsMonths.toString() %>;
                    const data = <%= jsPrices.toString() %>;

                    const ctx = document.getElementById('priceChart').getContext('2d');
                    new Chart(ctx, {
                        type: 'bar',
                        data: {
                            labels: labels,
                            datasets: [{
                                label: 'Total Revenue (Rs.)',
                                data: data,
                                backgroundColor: 'rgba(25, 118, 210, 0.7)',
                                borderColor: 'rgba(25, 118, 210, 1)',
                                borderWidth: 1
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                                tooltip: {
                                    callbacks: {
                                        label: function(context) {
                                            return 'Revenue: Rs. ' + context.raw.toLocaleString();
                                        }
                                    },
                                    displayColors: false,
                                    titleFont: {
                                        size: 14,
                                        weight: 'bold'
                                    },
                                    bodyFont: {
                                        size: 13
                                    }
                                },
                                legend: {
                                    display: false
                                }
                            },
                            scales: {
                                y: {
                                    beginAtZero: true,
                                    grid: {
                                        color: 'rgba(255, 255, 255, 0.1)'
                                    },
                                    ticks: {
                                        color: '#ffffff',
                                        callback: function(value) {
                                            return 'Rs. ' + value.toLocaleString();
                                        }
                                    }
                                },
                                x: {
                                    grid: {
                                        display: false
                                    },
                                    ticks: {
                                        color: '#ffffff' // White color for month labels
                                    }
                                }
                            }
                        }
                    });
                </script>

                <%
                    } else {
                %>
                    <div class="chart-loading">Loading chart data...</div>
                <%
                    }
                %>
            </div>
            
            <!-- Back and Logout Buttons -->
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
</body>
</html>