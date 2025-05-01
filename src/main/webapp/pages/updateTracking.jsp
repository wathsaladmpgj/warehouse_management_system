<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Update Location Tracking</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/OutLetDashBoard.css">
</head>
<body>

<%-- Show alert message if present --%>
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
                <input type="hidden" name="adminLocation" value="${sessionScope.admin.outletLocation}" />
                <label>From Location:</label><br>
                <input type="text" name="fromLocation" required><br><br>
                <label>To Location:</label><br>
                <input type="text" name="toLocation" required><br><br>
                <label>Tracking Date (YYYY-MM-DD):</label><br>
                <input type="date" name="trackingDate" required><br><br>
                <input type="submit" value="Update">
            </form>

            <hr><br>

            <h2>Search Location Tracking</h2>
            <form action="<%=request.getContextPath()%>/LocationTrackingServlet" method="post">
                <input type="text" name="inputValue" placeholder="Enter Tracking Number or ID" required />
                <input type="radio" name="mode" value="ReturnShip" checked /> ReturnShip
                <input type="radio" name="mode" value="ReturnUser" /> ReturnUser
                <button type="submit" name="action" value="add">Add</button>
            </form>

            <%-- Show results table if exists --%>
            <%
                List<Map<String, Object>> results = (List<Map<String, Object>>) request.getAttribute("results");
                String mode = (String) request.getAttribute("mode");
                if (results != null && !results.isEmpty()) {
            %>
            <form action="<%=request.getContextPath()%>/LocationTrackingServlet" method="post">
                <input type="hidden" name="mode" value="<%=mode%>"/>
                <input type="hidden" name="inputValue" value="<%=request.getAttribute("inputValue")%>"/>
                <table border="1" style="margin-top:20px;">
                    <tr>
                        <th>ID</th>
                        <th>Product Key</th>
                        <th>From</th>
                        <th>To</th>
                        <th>Date</th>
                        <th>Tracking Update</th>
                        <th>Select</th>
                    </tr>
                    <% for (Map<String, Object> row : results) { %>
                        <tr>
                            <td><%= row.get("id") %></td>
                            <td><%= row.get("product_key") %></td>
                            <td><%= row.get("from_location") %></td>
                            <td><%= row.get("to_location") %></td>
                            <td><%= row.get("tracking_date") %></td>
                            <td><%= row.get("tracking_update") %></td>
                            <td><input type="radio" name="selectedId" value="<%= row.get("id") %>" required /></td>
                        </tr>
                    <% } %>
                </table>
                <br>
                <button type="submit" name="action" value="update">Update</button>
            </form>
            <% } %>

            <%-- Show optional message --%>
            <%
                String message = (String) request.getAttribute("message");
                if (message != null) {
            %>
            <p style="color:green;"><%= message %></p>
            <% } %>
        </div>
    </div>
</div>

</body>
</html>
