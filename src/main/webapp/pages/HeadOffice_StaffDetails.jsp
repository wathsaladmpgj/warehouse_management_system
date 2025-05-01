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
            
            @keyframes pulse {
                from { transform: scale(1); }
                to { transform: scale(1.05); }
            }
            .staff-table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
                font-family: 'Roboto', sans-serif;
                box-shadow: 0 4px 8px rgba(0,0,0,0.1);
                border-radius: 8px;
                overflow: hidden;
            }
            .staff-table th {
                background-color: #004494;
                color: white;
                padding: 12px 15px;
                text-align: left;
                font-weight: 500;
                font-family: 'Montserrat', sans-serif;
            }
            .staff-table td {
                padding: 12px 15px;
                border-bottom: 1px solid #e0e0e0;
                color: #333;
            }
            .staff-table tr:nth-child(even) {
                background-color: #f8f9fa;
            }
            .staff-table tr:nth-child(odd) {
                background-color: white;
            }
            .staff-table tr:hover {
                background-color: #f1f1f1;
            }
        </style>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/OutLetDashBoard.css">
    </head>
    <body>

        <!-- redirect goes here -->
        <c:if test="${staff == null}">
            <c:redirect url='/StaffServlet' />
        </c:if>


        <div class="container">
            <div class="sidebar">
                <div class="sidebar-item"><a href="${pageContext.request.contextPath}/pages/home.jsp">Add Outlet</a></div>
                <div class="sidebar-item"><a href="${pageContext.request.contextPath}/pages/tracking.jsp">View Report</a></div>
                <div class="sidebar-item"><a href="${pageContext.request.contextPath}/pages/monthly-sales.jsp">Outlet Details</a></div>
                <div class="sidebar-item"><a href="${pageContext.request.contextPath}/pages/HeadOffice_StaffDetails.jsp">Staff Details</a></div>
            </div>
            <div class="main-content">
                <div class="header">
                    <h2>${sessionScope.admin.outletLocation}</h2>
                </div>
                <div class="content-area">

                    <h2>HEAD OFFICE DASHBOARD</h2>
                    <p>Staff Details</b></p>
                    

            
                    <div style="clear: both;"></div>

                    <table class="staff-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Role</th>
                                <th>Outlet</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${staff}" var="staff">
                                <tr>
                                    <td><c:out value="${staff.id}" /></td>
                                    <td><c:out value="${staff.name}" /></td>
                                    <td><c:out value="${staff.role}" /></td>
                                    <td><c:out value="${staff.location}" /></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <div style="margin-top: 20px;">
                        <a href="${pageContext.request.contextPath}/pages/login.jsp">Logout</a>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>