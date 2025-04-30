<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        h2 {
            color: #333;
        }
        .nav-menu {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin: 20px 0;
        }
        .nav-item {
            background-color: #4CAF50;
            color: white;
            padding: 10px 15px;
            text-decoration: none;
            border-radius: 4px;
            transition: background-color 0.3s;
        }
        .nav-item:hover {
            background-color: #45a049;
        }
        .logout {
            background-color: #f44336;
        }
        .logout:hover {
            background-color: #d32f2f;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Welcome, ${sessionScope.admin.adminName}!</h2>
        <p>Your outlet location: <b>${sessionScope.admin.outletLocation}</b></p>
        
        <div class="nav-menu">
            <a class="nav-item" href="${pageContext.request.contextPath}/MonthlyReportServlet">Monthly Delivery Reports</a>
            <!-- Add more navigation items as needed -->
            <a class="nav-item logout" href="${pageContext.request.contextPath}/pages/login.jsp">Logout</a>
        </div>
    </div>
</body>
</html>