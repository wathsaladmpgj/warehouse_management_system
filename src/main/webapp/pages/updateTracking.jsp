<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Update Location Tracking</title>
     <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/OutLetDashBoard.css">
</head>
<body>
    <%
    String alertMessage = (String) session.getAttribute("alertMessage");
    if (alertMessage != null) {
%>
    <script>
        alert("<%= alertMessage.replace("\"", "\\\"") %>");
    </script>
<%
        session.removeAttribute("alertMessage");
    }
%>
    <div class="container">
        <div class="sidebar">
            <div class="sidebar-item"><a href="${pageContext.request.contextPath}/pages/home.jsp">Home page</a></div>
            <div class="sidebar-item"><a href="${pageContext.request.contextPath}/pages/tracking.jsp">Tracking page</a></div>
            <div class="sidebar-item"><a href="${pageContext.request.contextPath}/pages/monthly-sales.jsp">Monthly Sales Report</a></div>
            <div class="sidebar-item"><a href="${pageContext.request.contextPath}/pages/add-product.jsp">Add Product</a></div>
            <div class="sidebar-item"><a href="${pageContext.request.contextPath}/pages/product-details.jsp">Product Details</a></div>
            <div class="sidebar-item"><a href="${pageContext.request.contextPath}/pages/item-details.jsp">Inventory Details</a></div>
            <div class="sidebar-item"><a href="${pageContext.request.contextPath}/pages/add-staff.jsp">Add Staff</a></div>
            <div class="sidebar-item"><a href="${pageContext.request.contextPath}/pages/staff-management.jsp">Staff Management</a></div>
        </div>
        <div class="main-content">
            <div class="header">
                <h2>${sessionScope.admin.outletLocation}</h2>
            </div>
            <div class="content-area">
                <h2>Update Tracking Status</h2>
                <form action="<%=request.getContextPath()%>/updateTracking" method="post">
                    <!-- Hidden input for adminLocation from session -->
                    <input type="hidden" name="adminLocation" value="${sessionScope.admin.outletLocation}" />

                    <label>From Location:</label><br>
                    <input type="text" name="fromLocation" required><br><br>

                    <label>To Location:</label><br>
                    <input type="text" name="toLocation" required><br><br>

                    <label>Tracking Date (YYYY-MM-DD):</label><br>
                    <input type="date" name="trackingDate" required><br><br>

                    <input type="submit" value="Update">
                </form>
            </div>
        </div>
    </div>
</body>
</html>
 UpdateTrackingSe