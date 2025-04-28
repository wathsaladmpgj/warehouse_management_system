<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Login</title>
</head>
<body>
    <h2>Admin Login</h2>
    <form action="${pageContext.request.contextPath}/LoginServlet" method="post">
        <label>Admin Name:</label>
        <input type="text" name="admin_name" required><br><br>
        <label>Password:</label>
        <input type="password" name="password" required>
        <button type="submit">Login</button>
    </form>
    <p style="color:red;">
        ${requestScope.error}
    </p>
</body>
</html>
