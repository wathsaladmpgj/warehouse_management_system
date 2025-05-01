<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Head Office Dashboard</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/sucess.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&family=Montserrat:wght@600;700&display=swap" rel="stylesheet">
    <style>
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
        .dynamic-count {
            font-family: 'Montserrat', sans-serif;
            font-weight: 700;
            color: #4CAF50;
            font-size: 28px;
            text-shadow: 0 2px 4px rgba(0,0,0,0.2);
            animation: pulse 1.5s infinite alternate;
            display: inline-block;
            padding: 5px 10px;
            background-color: rgba(255,255,255,0.1);
            border-radius: 5px;
            margin-top: 5px;
        }
        @keyframes pulse {
            from { transform: scale(1); }
            to { transform: scale(1.05); }
        }

        /* NEW: Logout button styles */
        .logout-btn {
            display: inline-block;
            padding: 10px 25px;
            background-color: #e74c3c;
            color: white;
            text-decoration: none;
            font-family: 'Montserrat', sans-serif;
            font-weight: 600;
            border-radius: 5px;
            transition: all 0.3s ease;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            border: none;
            cursor: pointer;
        }

        .logout-btn:hover {
            background-color: #c0392b;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }

        .logout-btn:active {
            transform: translateY(0);
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
    </style>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/OutLetDashBoard.css">
</head>
<body>
    <c:if test="${getRowCountTotalRegisteredItems == null}">
        <c:redirect url='/HeadOffice_Servlet' />
    </c:if>
    <div class="container">
        <div class="sidebar">
            <div class="sidebar-item"><a href="${pageContext.request.contextPath}/pages/home.jsp">Add Outlet</a></div>
            <div class="sidebar-item"><a href="${pageContext.request.contextPath}/pages/tracking.jsp">View Report</a></div>
            <div class="sidebar-item"><a href="${pageContext.request.contextPath}/pages/monthly-sales.jsp">Outlet Details</a></div>

            <div class="sidebar-item"><a href="${pageContext.request.contextPath}/pages/add-product.jsp">Staff Details</a></div>

            <div class="sidebar-item"><a href="${pageContext.request.contextPath}/pages/HeadOffice_StaffDetails.jsp">Staff Details</a></div>

        </div>
        <div class="main-content">
            <div class="header">
                <h2>${sessionScope.admin.outletLocation}</h2>
            </div>
            <div class="content-area">
                
                <h2>HEAD OFFICE DASHBOARD</h2>
                <p>Welcome!</b></p>
                <div style="width: 50%; float: left;">
                    
                    
                    <div style="background-color: #004494; padding: 20px; margin-bottom: 15px; border-radius: 10px; min-height: 100px;">
                        <h3 class="section-heading">Total Registered Items</h3>
                        <div class="dynamic-count">${getRowCountTotalRegisteredItems}</div>
                    </div>
                    
                    <div style="background-color: #004494; padding: 20px; margin-bottom: 15px; border-radius: 10px; min-height: 100px;">

                        <h3 class="section-heading">All items price</h3>
                        <div class="dynamic-count">$0.00</div>

                        <h3 class="section-heading">Total Returned Items</h3>
                        <p class="section-value">${getTotalReturnedItems}</p>

                    </div>
                    

                    <div style="background-color: #004494; padding: 20px; margin-bottom: 15px; border-radius: 10px; min-height: 100px;">

                        <h3 class="section-heading">Returned Items</h3>
                        <div class="dynamic-count">128</div>
                        <span class="dynamic-count-label">Returned items</span>
                    </div>
                    <div style="background-color: #004494; padding: 20px; margin-bottom: 15px; border-radius: 10px; min-height: 100px;">
                        <h3 class="section-heading">Success items</h3>
                        <div class="dynamic-count">42</div>
                        <span class="dynamic-count-label">Successful items</span>

                        <h3 class="section-heading">Remaining Returned Items</h3>
                        <p class="section-value">${remaining_returned_items}</p>

                    </div>
                    
                </div>
                    
                <div style="width: 45%; float: right;">
                    
                    <div style="background-color: #004494; padding: 20px; margin-bottom: 15px; border-radius: 10px; min-height: 100px;">

                        <h3 class="section-heading">All item total price</h3>
                        <div class="dynamic-count">$0.00</div>
                    </div>
                    <div style="background-color: #004494; padding: 20px; margin-bottom: 15px; border-radius: 10px; min-height: 100px;">
                        <h3 class="section-heading">Registered item total price</h3>
                        <div class="dynamic-count">$0.00</div>
                    </div>
                    <div style="background-color: #004494; padding: 20px; margin-bottom: 15px; border-radius: 10px; min-height: 100px;">
                        <h3 class="section-heading">Available item total price</h3>
                        <div class="dynamic-count">$0.00</div>
                    </div>
                    <div style="background-color: #004494; padding: 20px; margin-bottom: 15px; border-radius: 10px; min-height: 100px;">
                        <h3 class="section-heading">Success item total price</h3>
                        <div class="dynamic-count">$0.00</div>

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

                
                <div style="margin-top: 20px; text-align: center;">
                    <a href="${pageContext.request.contextPath}/pages/login.jsp" class="logout-btn">Logout</a>

                <div style="margin-top: 20px;">
                    <a href="${pageContext.request.contextPath}/pages/login.jsp">Logout</a>

                </div>
                
            </div>
        </div>
    </div>
</body>
</html>
