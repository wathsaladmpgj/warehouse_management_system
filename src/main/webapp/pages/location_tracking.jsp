<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Location Tracking</title>
</head>
<body>
    <h2>Location Tracking</h2>
    <form method="post" action="pages/LocationTrackingServlet">
        <input type="text" name="inputValue" placeholder="Enter Tracking Number or ID" required />
        <input type="radio" name="mode" value="ReturnShip" checked /> ReturnShip
        <input type="radio" name="mode" value="ReturnUser" /> ReturnUser
        <button type="submit" name="action" value="add">Add</button>
    </form>
    <br/>

    <%
        // Display table if present in request scope
        List<Map<String, Object>> results = (List<Map<String, Object>>) request.getAttribute("results");
        String mode = (String) request.getAttribute("mode");
        if (results != null && !results.isEmpty()) {
    %>
        <form method="post" action="pages/LocationTrackingServlet">
            <input type="hidden" name="mode" value="<%=mode%>"/>
            <input type="hidden" name="inputValue" value="<%=request.getAttribute("inputValue")%>"/>
            <table border="1">
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
                        <td>
                            <input type="radio" name="selectedId" value="<%= row.get("id") %>" required />
                        </td>
                    </tr>
                <% } %>
            </table>
            <br/>
            <button type="submit" name="action" value="update">Update</button>
        </form>
    <%
        }
        String message = (String) request.getAttribute("message");
        if (message != null) {
    %>
        <p style="color:green;"><%= message %></p>
    <%
        }
    %>
</body>
</html>
