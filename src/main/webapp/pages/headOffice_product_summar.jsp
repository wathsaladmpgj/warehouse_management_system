<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Monthly Product Summary</title>
    <style>
        table { width: 80%; margin: 20px auto; border-collapse: collapse; }
        th, td { padding: 10px; text-align: left; border: 1px solid #ddd; }
        th { background-color: #f2f2f2; }
        select { padding: 8px; font-size: 16px; }
    </style>
    <script>
        // Automatically submit form when page loads to get initial data
        window.onload = function() {
            // Only submit if no year parameter is present in URL
            if (!window.location.href.includes("year=")) {
                document.getElementById('summaryForm').submit();
            }
        };
        
        function autoSubmit() {
            document.getElementById('summaryForm').submit();
        }
    </script>
</head>
<body>

<%
    // Safely get current year and selected year
    int currentYear = Calendar.getInstance().get(Calendar.YEAR);
    Integer selectedYear = (Integer) request.getAttribute("year");
    if (selectedYear == null) {
        selectedYear = currentYear;
    }
    
    List<Map<String, Object>> summaryList = (List<Map<String, Object>>) request.getAttribute("summaryList");
    if (summaryList == null) {
        summaryList = new ArrayList<>();
    }
%>

<h2 style="text-align: center;">Monthly Product Summary</h2>

<form id="summaryForm" method="get" action="<%= request.getContextPath() %>/HeadProductSummary">
    <div style="text-align: center; margin: 20px;">
        <label for="yearSelect">Select Year: </label>
        <select id="yearSelect" name="year" onchange="autoSubmit()">
            <%
                for (int y = currentYear; y >= 2023; y--) {
                    String selected = (y == selectedYear) ? "selected" : "";
            %>
                <option value="<%= y %>" <%= selected %>><%= y %></option>
            <%
                }
            %>
        </select>
    </div>
</form>

<h3 style="text-align: center;">Year: <%= selectedYear %></h3>

<div style="overflow-x: auto;">
    <table>
        <thead>
            <tr>
                <th>Month</th>
                <th>Number of Items</th>
                <th>Total Price (Rs.)</th>
            </tr>
        </thead>
        <tbody>
            <%
                if (!summaryList.isEmpty()) {
                    for (Map<String, Object> row : summaryList) {
            %>
            <tr>
                <td><%= row.get("month") %></td>
                <td><%= row.get("items") %></td>
                <td><%= String.format("%,.2f", row.get("total_price")) %></td>
            </tr>
            <%
                    }
                } else {
            %>
            <tr>
                <td colspan="3" style="text-align: center;">No data found for <%= selectedYear %></td>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>
</div>

</body>
</html>