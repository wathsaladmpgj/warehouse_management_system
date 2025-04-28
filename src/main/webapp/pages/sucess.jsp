<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
</head>
<body>
    <h2>Welcome, ${sessionScope.admin.adminName}!</h2>
    <p>Your outlet location: <b>${sessionScope.admin.outletLocation}</b></p>
    <a href="${pageContext.request.contextPath}/pages/login.jsp">Logout</a>
</body>
</html>
