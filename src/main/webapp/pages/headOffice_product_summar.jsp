<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<<<<<<< HEAD
    <head>
        <title>Monthly Product Summary</title>
        <style>
            /* Monthly Summary Section Styles */
            .monthly-summary-section {
                margin: 2rem 0;
                animation: fadeIn 0.6s 0.3s both;
            }

            .monthly-summary-section h2 {
                color: var(--light);
                font-size: 1.75rem;
                margin-bottom: 1.5rem;
                text-align: center;
                position: relative;
                padding-bottom: 0.5rem;
            }

            .monthly-summary-section h2::after {
                content: '';
                position: absolute;
                bottom: 0;
                left: 50%;
                transform: translateX(-50%);
                width: 80px;
                height: 3px;
                background: var(--secondary);
            }

            /* Form Styles */
            .summary-form {
                background: var(--primary-dark);
                padding: 1.5rem;
                border-radius: 0.5rem;
                margin: 1rem auto 2rem;
                max-width: 500px;
                border: 1px solid var(--primary-light);
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }

            .summary-form div {
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 1rem;
                flex-wrap: wrap;
            }

            .summary-form label {
                color: var(--gray-light);
                font-weight: 500;
                margin-right: 0.5rem;
            }

            .summary-form select {
                background: var(--primary);
                color: var(--light);
                border: 1px solid var(--primary-light);
                border-radius: 0.375rem;
                padding: 0.5rem 1rem;
                font-size: 1rem;
                cursor: pointer;
                transition: var(--transition);
            }

            .summary-form select:hover {
                border-color: var(--secondary);
            }

            .summary-form select:focus {
                outline: none;
                border-color: var(--secondary);
                box-shadow: 0 0 0 2px rgba(25, 118, 210, 0.3);
            }

            /* Year Display */
            .year-display {
                text-align: center;
                margin: 1.5rem 0;
                font-size: 1.25rem;
                color: var(--light);
                position: relative;
                display: inline-block;
                width: 100%;
            }

            .year-display::before,
            .year-display::after {
                content: '';
                position: absolute;
                top: 50%;
                width: 30%;
                height: 1px;
                background: var(--primary-light);
            }

            .year-display::before {
                left: 0;
            }

            .year-display::after {
                right: 0;
            }

            /* Table Container */
            .table-container {
                background: var(--primary-dark);
                border-radius: 0.5rem;
                padding: 1rem;
                border: 1px solid var(--primary-light);
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.3);
                margin-top: 1.5rem;
            }

            /* Table Styles */
            .summary-table {
                width: 100%;
                border-collapse: collapse;
                margin: 0;
            }

            .summary-table thead {
                background-color: var(--primary);
            }

            .summary-table th {
                padding: 1rem;
                text-align: left;
                color: var(--light);
                font-weight: 500;
                text-transform: uppercase;
                font-size: 0.75rem;
                letter-spacing: 0.5px;
            }

            .summary-table td {
                padding: 1rem;
                border-bottom: 1px solid var(--primary-light);
                color: var(--gray-light);
            }

            .summary-table tr:last-child td {
                border-bottom: none;
            }

            .summary-table tr:hover td {
                background-color: var(--primary);
                color: var(--white);
            }

            .summary-table td:first-child {
                font-weight: 500;
                color: var(--light);
            }

            .summary-table td:nth-child(2) {
                text-align: center;
            }

            .summary-table td:nth-child(3) {
                text-align: right;
                font-family: 'Courier New', monospace;
                color: var(--success);
            }

            /* No Data Message */
            .no-data-message {
                text-align: center;
                padding: 2rem;
                color: var(--gray);
                font-style: italic;
            }

            /* Responsive Adjustments */
            @media (max-width: 768px) {
                .summary-form div {
                    flex-direction: column;
                    align-items: center;
                }

                .summary-form label {
                    margin-bottom: 0.5rem;
                }

                .table-container {
                    padding: 0.5rem;
                }

                .summary-table th, 
                .summary-table td {
                    padding: 0.75rem 0.5rem;
                }

                .year-display::before,
                .year-display::after {
                    width: 25%;
                }
            }
        </style>
        <script>
            // Automatically submit form when page loads to get initial data
            window.onload = function () {
                // Only submit if no year parameter is present in URL
                if (!window.location.href.includes("year=")) {
                    document.getElementById('summaryForm').submit();
                }
            };

            function autoSubmit() {
=======
<head>
    <title>Monthly Product Summary</title>
    <style>
        /* Monthly Summary Section Styles */
        .monthly-summary-section {
            margin: 2rem 0;
            animation: fadeIn 0.6s 0.3s both;
        }

        .monthly-summary-section h2 {
            color: var(--light);
            font-size: 1.75rem;
            margin-bottom: 1.5rem;
            text-align: center;
            position: relative;
            padding-bottom: 0.5rem;
        }

        .monthly-summary-section h2::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 3px;
            background: var(--secondary);
        }

        /* Form Styles */
        .summary-form {
            background: var(--primary-dark);
            padding: 1.5rem;
            border-radius: 0.5rem;
            margin: 1rem auto 2rem;
            max-width: 500px;
            border: 1px solid var(--primary-light);
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .summary-form div {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .summary-form label {
            color: var(--gray-light);
            font-weight: 500;
            margin-right: 0.5rem;
        }

        .summary-form select {
            background: var(--primary);
            color: var(--light);
            border: 1px solid var(--primary-light);
            border-radius: 0.375rem;
            padding: 0.5rem 1rem;
            font-size: 1rem;
            cursor: pointer;
            transition: var(--transition);
        }

        .summary-form select:hover {
            border-color: var(--secondary);
        }

        .summary-form select:focus {
            outline: none;
            border-color: var(--secondary);
            box-shadow: 0 0 0 2px rgba(25, 118, 210, 0.3);
        }

        /* Year Display */
        .year-display {
            text-align: center;
            margin: 1.5rem 0;
            font-size: 1.25rem;
            color: var(--light);
            position: relative;
            display: inline-block;
            width: 100%;
        }

        .year-display::before,
        .year-display::after {
            content: '';
            position: absolute;
            top: 50%;
            width: 30%;
            height: 1px;
            background: var(--primary-light);
        }

        .year-display::before {
            left: 0;
        }

        .year-display::after {
            right: 0;
        }

        /* Table Container */
        .table-container {
            background: var(--primary-dark);
            border-radius: 0.5rem;
            padding: 1rem;
            border: 1px solid var(--primary-light);
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.3);
            margin-top: 1.5rem;
        }

        /* Table Styles */
        .summary-table {
            width: 100%;
            border-collapse: collapse;
            margin: 0;
        }

        .summary-table thead {
            background-color: var(--primary);
        }

        .summary-table th {
            padding: 1rem;
            text-align: left;
            color: var(--light);
            font-weight: 500;
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 0.5px;
        }

        .summary-table td {
            padding: 1rem;
            border-bottom: 1px solid var(--primary-light);
            color: var(--gray-light);
        }

        .summary-table tr:last-child td {
            border-bottom: none;
        }

        .summary-table tr:hover td {
            background-color: var(--primary);
            color: var(--white);
        }

        .summary-table td:first-child {
            font-weight: 500;
            color: var(--light);
        }

        .summary-table td:nth-child(2) {
            text-align: center;
        }

        .summary-table td:nth-child(3) {
            text-align: right;
            font-family: 'Courier New', monospace;
            color: var(--success);
        }

        /* No Data Message */
        .no-data-message {
            text-align: center;
            padding: 2rem;
            color: var(--gray);
            font-style: italic;
        }

        /* Yearly Summary Section Styles */
        .yearly-summary-section {
            margin: 2rem 0;
            animation: fadeIn 0.6s 0.4s both;
        }
        
        .yearly-summary-section h2 {
            color: var(--light);
            font-size: 1.75rem;
            margin-bottom: 1.5rem;
            text-align: center;
            position: relative;
            padding-bottom: 0.5rem;
        }
        
        .yearly-summary-section h2::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 3px;
            background: var(--secondary);
        }
        
        /* Summary Cards */
        .summary-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
            margin: 2rem 0;
        }
        
        .summary-card {
            background: var(--primary-dark);
            border-radius: 0.5rem;
            padding: 1.5rem;
            border: 1px solid var(--primary-light);
            display: flex;
            align-items: center;
            transition: var(--transition);
        }
        
        .summary-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
        }
        
        .card-icon {
            font-size: 2rem;
            margin-right: 1.5rem;
            color: var(--secondary);
        }
        
        .card-content h3 {
            color: var(--gray-light);
            font-size: 1rem;
            margin-bottom: 0.5rem;
        }
        
        .card-content p {
            color: var(--light);
            font-size: 1.5rem;
            font-weight: 600;
            margin: 0;
        }

        /* Responsive Adjustments */
        @media (max-width: 768px) {
            .summary-form div {
                flex-direction: column;
                align-items: center;
            }
            
            .summary-form label {
                margin-bottom: 0.5rem;
            }
            
            .table-container {
                padding: 0.5rem;
            }
            
            .summary-table th, 
            .summary-table td {
                padding: 0.75rem 0.5rem;
            }
            
            .year-display::before,
            .year-display::after {
                width: 25%;
            }

            .summary-cards {
                grid-template-columns: 1fr;
            }
        }
    </style>
    <script>
        // Automatically submit form when page loads to get initial data
        window.onload = function() {
            // Only submit if no year parameter is present in URL
            if (!window.location.href.includes("year=")) {
>>>>>>> d022bc5563d180b7ffcbc2b814cb0d4f9103f12c
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

<<<<<<< HEAD

        <div class="dashboard-container">
            <!-- Sidebar Navigation -->
            <!-- Sidebar Navigation -->
            <aside class="sidebar">
                <div class="sidebar-header">
                    <h3>Head Office Panel</h3>
                </div>
                <nav>
                    <div class="sidebar-item ">
                        <a href="${pageContext.request.contextPath}/pages/HeadOffice_Dashboard.jsp">
                            <i>🏠</i> Dashboard
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


                <div class="monthly-summary-section">
                    <h2>Monthly Product Summary</h2>

                    <form id="summaryForm" class="summary-form" method="get" action="<%= request.getContextPath()%>/HeadProductSummary">
                        <div>
                            <label for="yearSelect">Select Year:</label>
                            <select id="yearSelect" name="year" onchange="autoSubmit()">
                                <% for (int y = currentYear; y >= 2023; y--) {
                                        String selected = (y == selectedYear) ? "selected" : "";
                                %>
                                <option value="<%= y%>" <%= selected%>><%= y%></option>
                                <% }%>
                            </select>
                        </div>
                    </form>

                    <h3 class="year-display">Year: <%= selectedYear%></h3>

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
                                        for (Map<String, Object> row : summaryList) {%>
                                <tr>
                                    <td><%= row.get("month")%></td>
                                    <td><%= row.get("items")%></td>
                                    <td><%= String.format("%,.2f", row.get("total_price"))%></td>
                                </tr>
                                <% }
                                } else {%>
                                <tr>
                                    <td colspan="3" class="no-data-message">No data found for <%= selectedYear%></td>
                                </tr>
                                <% }%>
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
=======
<div class="dashboard-container">
    <!-- Sidebar Navigation -->
    <aside class="sidebar">
        <div class="sidebar-header">
            <h3>Head Office Panel</h3>
        </div>
        <nav>
            <div class="sidebar-item ">
                <a href="${pageContext.request.contextPath}/pages/HeadOffice_Dashboard.jsp">
                    <i>🏠</i> Dashboard
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
</body>
>>>>>>> d022bc5563d180b7ffcbc2b814cb0d4f9103f12c
</html>