<%@page import="dao.DBHelper"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/sucess.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&family=Montserrat:wght@600;700&display=swap" rel="stylesheet">
    <style>
        /* Font styles for sections */
        .section-heading {
            font-family: 'Roboto', sans-serif;
            font-weight: 500;
            margin: 0 0 10px 0;
            color: white;
            font-size: 18px;
            letter-spacing: 0.5px;
        }
        
        .section-value {
            font-family: 'Montserrat', sans-serif;
            font-weight: 600;
            margin: 0;
            color: white;
            font-size: 24px;
        }
        
        /* New styles for dynamic count display */
        .dynamic-count {
            font-family: 'Montserrat', sans-serif;
            font-weight: 700;
            color: #4CAF50; /* Green color for emphasis */
            font-size: 28px;
            text-shadow: 0 2px 4px rgba(0,0,0,0.2);
            animation: pulse 1.5s infinite alternate;
            display: inline-block;
            padding: 5px 10px;
            background-color: rgba(255,255,255,0.1);
            border-radius: 5px;
            margin-top: 5px;
        }
        
        .dynamic-count-label {
            font-family: 'Roboto', sans-serif;
            font-size: 14px;
            color: #BBDEFB; /* Light blue for contrast */
            display: block;
            margin-top: 3px;
        }
        
        @keyframes pulse {
            from { transform: scale(1); }
            to { transform: scale(1.05); }
        }
    </style>

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/OutLetDashBoard.css">

</head>
<body>
    <div class="container">
        <div class="sidebar">
            <div class="sidebar-item"><a href="${pageContext.request.contextPath}/pages/home.jsp">Add Outlet</a></div>
            <div class="sidebar-item"><a href="${pageContext.request.contextPath}/pages/tracking.jsp">View Report</a></div>
            <div class="sidebar-item"><a href="${pageContext.request.contextPath}/pages/monthly-sales.jsp">Outlet Details</a></div>
            <div class="sidebar-item"><a href="${pageContext.request.contextPath}/pages/add-product.jsp">Staff Details</a></div>

        </div>
        <div class="main-content">
            <div class="header">
                <h2>${sessionScope.admin.outletLocation}</h2>
            </div>
            <div class="content-area">
                <h2>Welcome, ${sessionScope.admin.adminName}!</h2>
                <p>Your outlet location: <b>${sessionScope.admin.outletLocation}</b></p>
                
                <!-- Compact Vertical Sections -->
                <div style="width: 50%; float: left;">
                    <div style="background-color: #004494; padding: 20px; margin-bottom: 15px; border-radius: 10px; min-height: 100px;">
                        <h3 class="section-heading">All items</h3>
                        <%
                            String adminLocation = (String) session.getAttribute("admin.outletLocation");
                            int count = DBHelper.getMatchingRecordsCount(adminLocation);
                        %>
                        <div class="dynamic-count"><%= count %></div>
                        <span class="dynamic-count-label">Items matching your location</span>
                    </div>
                    <div style="background-color: #004494; padding: 20px; margin-bottom: 15px; border-radius: 10px; min-height: 100px;">
                        <h3 class="section-heading">All items price</h3>                                                                                  
                    </div>
                    <div style="background-color: #004494; padding: 20px; margin-bottom: 15px; border-radius: 10px; min-height: 100px;">
                        <h3 class="section-heading">Returned Items</h3>
                        <p class="section-value">128 items</p>
                    </div>
                    <div style="background-color: #004494; padding: 20px; margin-bottom: 15px; border-radius: 10px; min-height: 100px;">
                        <h3 class="section-heading">Success items</h3>
                        <p class="section-value">42 items</p>
                    </div>
                </div>
                
                <!-- Price Sections -->
                <div style="width: 45%; float: right;">
                    <div style="background-color: #004494; padding: 20px; margin-bottom: 15px; border-radius: 10px; min-height: 100px;">
                        <h3 class="section-heading">All item total price</h3>
                        <p class="section-value">$0.00</p>
                    </div>
                    <div style="background-color: #004494; padding: 20px; margin-bottom: 15px; border-radius: 10px; min-height: 100px;">
                        <h3 class="section-heading">Registered item total price</h3>
                        <p class="section-value">$0.00</p>
                    </div>
                    <div style="background-color: #004494; padding: 20px; margin-bottom: 15px; border-radius: 10px; min-height: 100px;">
                        <h3 class="section-heading">Available item total price</h3>
                        <p class="section-value">$0.00</p>
                    </div>
                    <div style="background-color: #004494; padding: 20px; margin-bottom: 15px; border-radius: 10px; min-height: 100px;">
                        <h3 class="section-heading">Success item total price</h3>
                        <p class="section-value">$0.00</p>
                    </div>
                </div>
                
                <div style="clear: both;"></div>
                
                <div style="margin-top: 20px;">
                    <a href="${pageContext.request.contextPath}/pages/login.jsp">Logout</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>