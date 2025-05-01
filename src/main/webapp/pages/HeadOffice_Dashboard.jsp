<<<<<<< HEAD
<%@page import="dao.DBHelper"%>
=======
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
>>>>>>> 452882442eb94d8526aa93362a550278ea0837e0
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
<<<<<<< HEAD
    <title>Admin Dashboard</title>

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/sucess.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&family=Montserrat:wght@600;700&display=swap" rel="stylesheet">
    <style>
        /* Font styles for sections */
=======
    <title>Head Office Dashboard</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/sucess.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&family=Montserrat:wght@600;700&display=swap" rel="stylesheet">
    <style>
>>>>>>> 452882442eb94d8526aa93362a550278ea0837e0
        .section-heading {
            font-family: 'Roboto', sans-serif;
            font-weight: 500;
            margin: 0 0 10px 0;
            color: white;
            font-size: 18px;
            letter-spacing: 0.5px;
        }
<<<<<<< HEAD
        
=======
>>>>>>> 452882442eb94d8526aa93362a550278ea0837e0
        .section-value {
            font-family: 'Montserrat', sans-serif;
            font-weight: 600;
            margin: 0;
            color: white;
            font-size: 24px;
        }
<<<<<<< HEAD
        
        /* New styles for dynamic count display */
        .dynamic-count {
            font-family: 'Montserrat', sans-serif;
            font-weight: 700;
            color: #4CAF50; /* Green color for emphasis */
=======
        .dynamic-count {
            font-family: 'Montserrat', sans-serif;
            font-weight: 700;
            color: #4CAF50;
>>>>>>> 452882442eb94d8526aa93362a550278ea0837e0
            font-size: 28px;
            text-shadow: 0 2px 4px rgba(0,0,0,0.2);
            animation: pulse 1.5s infinite alternate;
            display: inline-block;
            padding: 5px 10px;
            background-color: rgba(255,255,255,0.1);
            border-radius: 5px;
            margin-top: 5px;
        }
<<<<<<< HEAD
        
        .dynamic-count-label {
            font-family: 'Roboto', sans-serif;
            font-size: 14px;
            color: #BBDEFB; /* Light blue for contrast */
            display: block;
            margin-top: 3px;
        }
        
=======
>>>>>>> 452882442eb94d8526aa93362a550278ea0837e0
        @keyframes pulse {
            from { transform: scale(1); }
            to { transform: scale(1.05); }
        }
    </style>
<<<<<<< HEAD

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/OutLetDashBoard.css">

</head>
<body>
=======
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/OutLetDashBoard.css">
</head>
<body>
    <c:if test="${getRowCountTotalRegisteredItems == null}">
        <c:redirect url='/HeadOffice_Servlet' />
    </c:if>
>>>>>>> 452882442eb94d8526aa93362a550278ea0837e0
    <div class="container">
        <div class="sidebar">
            <div class="sidebar-item"><a href="${pageContext.request.contextPath}/pages/home.jsp">Add Outlet</a></div>
            <div class="sidebar-item"><a href="${pageContext.request.contextPath}/pages/tracking.jsp">View Report</a></div>
            <div class="sidebar-item"><a href="${pageContext.request.contextPath}/pages/monthly-sales.jsp">Outlet Details</a></div>
<<<<<<< HEAD
            <div class="sidebar-item"><a href="${pageContext.request.contextPath}/pages/add-product.jsp">Staff Details</a></div>
<<<<<<< HEAD

=======
>>>>>>> 452882442eb94d8526aa93362a550278ea0837e0
=======
            <div class="sidebar-item"><a href="${pageContext.request.contextPath}/pages/HeadOffice_StaffDetails.jsp">Staff Details</a></div>
>>>>>>> 9f15ee2c39902742c284ce51a4b958e90ad83775
        </div>
        <div class="main-content">
            <div class="header">
                <h2>${sessionScope.admin.outletLocation}</h2>
            </div>
            <div class="content-area">
<<<<<<< HEAD
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
=======
                
                <h2>HEAD OFFICE DASHBOARD</h2>
                <p>Welcome!</b></p>
                <div style="width: 50%; float: left;">
                    
                    
                    <div style="background-color: #004494; padding: 20px; margin-bottom: 15px; border-radius: 10px; min-height: 100px;">
                        <h3 class="section-heading">Total Registered Items</h3>
                        <div class="dynamic-count">${getRowCountTotalRegisteredItems}</div>
                    </div>
                    
                    <div style="background-color: #004494; padding: 20px; margin-bottom: 15px; border-radius: 10px; min-height: 100px;">
                        <h3 class="section-heading">Total Returned Items</h3>
                        <p class="section-value">${getTotalReturnedItems}</p>
                    </div>
                    

                    <div style="background-color: #004494; padding: 20px; margin-bottom: 15px; border-radius: 10px; min-height: 100px;">
                        <h3 class="section-heading">Remaining Returned Items</h3>
                        <p class="section-value">${remaining_returned_items}</p>
                    </div>
                    
                </div>
                    
                <div style="width: 45%; float: right;">
                    
                    <div style="background-color: #004494; padding: 20px; margin-bottom: 15px; border-radius: 10px; min-height: 100px;">
                        <h3 class="section-heading">Available New Items</h3>
                        <p class="section-value">${available_new_items}</p>
                    </div>
                    <div style="background-color: #004494; padding: 20px; margin-bottom: 15px; border-radius: 10px; min-height: 100px;">
                        <h3 class="section-heading">Total Staff Count</h3>
                        <p class="section-value">${getStaffCount}</p>
                    </div>
                    
                     <div style="background-color: #004494; padding: 20px; margin-bottom: 15px; border-radius: 10px; min-height: 100px;">
                        <h3 class="section-heading">Outlet Count</h3>
                        <p class="section-value">${getOutletCount}</p>
                    </div>
                    
                    
                    
                </div>
                    
                    
                <div style="clear: both;"></div>
                <div style="margin-top: 20px;">
                    <a href="${pageContext.request.contextPath}/pages/login.jsp">Logout</a>
                </div>
                
>>>>>>> 452882442eb94d8526aa93362a550278ea0837e0
            </div>
        </div>
    </div>
</body>
<<<<<<< HEAD
</html>
=======
</html>
>>>>>>> 452882442eb94d8526aa93362a550278ea0837e0
