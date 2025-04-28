<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/sucess.css">
</head>
<body>
    <div class="container">
        <div class="sidebar">
            <div class="sidebar-item"><a href="${pageContext.request.contextPath}/pages/home.jsp">Home page</a></div>
            <div class="sidebar-item"><a href="${pageContext.request.contextPath}/pages/tracking.jsp">Tracking page</a></div>
        </div>
        <div class="main-content">
            <div class="header">
                <h2>${sessionScope.admin.outletLocation}</h2>
            </div>
            <div class="content-area">
                <h2>Welcome, ${sessionScope.admin.adminName}!</h2>
                <p>Your outlet location: <b>${sessionScope.admin.outletLocation}</b></p>
                <a href="${pageContext.request.contextPath}/pages/login.jsp">Logout</a>
            </div>
        </div>
    </div>
</body>
</html>