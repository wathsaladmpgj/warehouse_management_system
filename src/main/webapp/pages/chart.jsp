<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.text.DecimalFormat" %>
<html>
<head>
    <title>Product Pricing Chart</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
        }

        .container {
            width: 90%;
            margin: 40px auto;
            padding: 20px;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }

        h2 {
            text-align: center;
            color: #333;
        }

        form {
            text-align: center;
            margin-bottom: 30px;
        }

        select, input[type="submit"] {
            padding: 10px;
            margin: 5px;
            font-size: 16px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>View Total Item Price by Month</h2>
        <form method="get" action="${pageContext.request.contextPath}/ChartServlet">
            <label for="year">Select Year:</label>
            <select name="year" id="year">
                <% for (int y = 2020; y <= 2025; y++) {
                    String selectedYear = (String) request.getAttribute("selectedYear");
                    String selected = (selectedYear != null && selectedYear.equals(String.valueOf(y))) ? "selected" : "";
                %>
                <option value="<%= y %>" <%= selected %>><%= y %></option>
                <% } %>
            </select>
            <input type="submit" value="Show Chart">
        </form>

        <canvas id="priceChart" width="800" height="400"></canvas>

        <%
    String[] months = (String[]) request.getAttribute("months");
    double[] prices = (double[]) request.getAttribute("prices");

    if (months != null && prices != null) {
        StringBuilder jsMonths = new StringBuilder("[");
        for (int i = 0; i < months.length; i++) {
            jsMonths.append("\"").append(months[i]).append("\"");
            if (i < months.length - 1) jsMonths.append(", ");
        }
        jsMonths.append("]");

        StringBuilder jsPrices = new StringBuilder("[");
        for (int i = 0; i < prices.length; i++) {
            jsPrices.append(prices[i]);
            if (i < prices.length - 1) jsPrices.append(", ");
        }
        jsPrices.append("]");
%>

<script>
    const labels = <%= jsMonths.toString() %>;
    const data = <%= jsPrices.toString() %>;

    const ctx = document.getElementById('priceChart').getContext('2d');
    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: 'Total Item Price (Monthly)',
                data: data,
                backgroundColor: 'rgba(54, 162, 235, 0.7)',
                borderColor: 'rgba(54, 162, 235, 1)',
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    });
</script>

<%
    } else {
%>
    <p style="text-align:center; color: red;">Error: Chart data not available. Please access this page via <b>ChartServlet</b>.</p>
<%
    }
%>

    </div>
</body>
</html>
