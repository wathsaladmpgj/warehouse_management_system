<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Monthly Delivery Report</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 1000px;
            margin: 0 auto;
            background: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        h2 {
            color: #333;
            border-bottom: 1px solid #ddd;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        .footer {
            margin-top: 20px;
            text-align: center;
            font-size: 14px;
            color: #777;
        }
        .btn {
            display: inline-block;
            padding: 8px 16px;
            background-color: #4CAF50;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            transition: background-color 0.3s;
        }
        .btn:hover {
            background-color: #45a049;
        }
        .select-years {
            padding: 8px;
            border-radius: 4px;
            border: 1px solid #ddd;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>Monthly Delivery Details of ${sessionScope.admin.outletLocation}</h2>
            <div>
                <select class="select-years" id="yearFilter">
                    <option value="">All Years</option>
                    <option value="2025">2025</option>
                    <option value="2024">2024</option>
                </select>
            </div>
        </div>
        
        <table id="monthlyTable">
            <thead>
                <tr>
                    <th>Month</th>
                    <th>Total Deliveries</th>
                    <th>Revenue (LKR)</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="report" items="${monthlyReports}">
                    <tr>
                        <td>${report.month}</td>
                        <td>${report.totalDeliveries}</td>
                        <td><fmt:formatNumber value="${report.totalRevenue}" type="currency" currencySymbol="LKR " /></td>
                    </tr>
                </c:forEach>
                
                <c:if test="${empty monthlyReports}">
                    <tr>
                        <td colspan="3" style="text-align: center;">No delivery data available for ${outletLocation}</td>
                    </tr>
                </c:if>
            </tbody>
            <tfoot>
                <tr style="font-weight: bold; background-color: #e9e9e9;">
                    <td>Total</td>
                    <td id="totalDeliveries">
                        <c:set var="totalDeliveries" value="0" />
                        <c:forEach var="report" items="${monthlyReports}">
                            <c:set var="totalDeliveries" value="${totalDeliveries + report.totalDeliveries}" />
                        </c:forEach>
                        ${totalDeliveries}
                    </td>
                    <td id="totalRevenue">
                        <c:set var="totalRevenue" value="0" />
                        <c:forEach var="report" items="${monthlyReports}">
                            <c:set var="totalRevenue" value="${totalRevenue + report.totalRevenue}" />
                        </c:forEach>
                        <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="LKR " />
                    </td>
                </tr>
            </tfoot>
        </table>
        
        <div class="footer">
            <p>Logged in as: ${sessionScope.admin.adminName} | Location: ${sessionScope.admin.outletLocation}</p>
            <a class="btn" href="${pageContext.request.contextPath}/pages/sucess.jsp">Back to Dashboard</a>
        </div>
    </div>
    
    <script>
        document.getElementById('yearFilter').addEventListener('change', function() {
            const selectedYear = this.value;
            const table = document.getElementById('monthlyTable');
            const rows = table.getElementsByTagName('tbody')[0].getElementsByTagName('tr');
            
            let totalDeliveries = 0;
            let totalRevenue = 0;
            
            for (let i = 0; i < rows.length; i++) {
                const row = rows[i];
                const monthCell = row.cells[0];
                
                if (selectedYear === '' || monthCell.textContent.includes(selectedYear)) {
                    row.style.display = '';
                    
                    // Update totals for visible rows
                    if (row.cells.length > 1) {
                        totalDeliveries += parseInt(row.cells[1].textContent) || 0;
                        
                        // Extract number from currency format
                        const revenueText = row.cells[2].textContent;
                        const revenueValue = parseFloat(revenueText.replace('LKR ', '').replace(/,/g, '')) || 0;
                        totalRevenue += revenueValue;
                    }
                } else {
                    row.style.display = 'none';
                }
            }
            
            // Update footer totals
            document.getElementById('totalDeliveries').textContent = totalDeliveries;
            document.getElementById('totalRevenue').textContent = 'LKR ' + totalRevenue.toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ',');
        });
    </script>
</body>
</html>