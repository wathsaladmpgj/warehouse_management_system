<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add Product</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/OutLetDashBoard.css">
    <style>
        .product-form {
            max-width: 600px;
            margin: 20px auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 5px;
            background-color: #f9f9f9;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .form-group input, .form-group select {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .form-submit {
            background-color: #4CAF50;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }
        .form-submit:hover {
            background-color: #45a049;
        }
        .error {
            color: red;
            font-size: 14px;
        }
        .success {
            color: green;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="sidebar">
            <div class="sidebar-item"><a href="${pageContext.request.contextPath}/pages/home.jsp">Home page</a></div>
            <div class="sidebar-item"><a href="${pageContext.request.contextPath}/pages/tracking.jsp">Tracking page</a></div>
            <div class="sidebar-item"><a href="${pageContext.request.contextPath}/pages/addProduct.jsp">Add Product</a></div>
        </div>
        <div class="main-content">
            <div class="header">
                <h2>${sessionScope.admin.outletLocation}</h2>
            </div>
            <div class="content-area">
                <h2>Add New Product</h2>
                
                <form class="product-form" action="${pageContext.request.contextPath}/AddProductServlet" method="POST">
                    <input type="hidden" name="fromLocation" value="${sessionScope.admin.outletLocation}">
                    
                    <div class="form-group">
                        <label for="senderName">Sender Name:</label>
                        <input type="text" id="senderName" name="senderName" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="receiverName">Receiver Name:</label>
                        <input type="text" id="receiverName" name="receiverName" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="postalCode">Postal Code:</label>
                        <input type="text" id="postalCode" name="postalCode" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="receiveLocation">Receive Location (Address):</label>
                        <input type="text" id="receiverLocation" name="receiverLocation" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="productWeight">Product Weight (kg):</label>
                        <input type="number" id="productWeight" name="productWeight" step="0.01" min="0.01" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="date">Date:</label>
                        <input type="date" id="date" name="date" required>
                    </div>
                    
                    <div class="form-group">
                        <input type="submit" class="form-submit" value="Add Product">
                    </div>
                    
                    <% if(request.getAttribute("errorMessage") != null) { %>
                        <div class="error">
                            ${requestScope.errorMessage}
                        </div>
                    <% } %>
                    
                    <% if(request.getAttribute("successMessage") != null) { %>
                        <div class="success">
                            ${requestScope.successMessage}
                        </div>
                    <% } %>
                </form>
                
                <p><a href="${pageContext.request.contextPath}/pages/home.jsp">Back to Dashboard</a></p>
            </div>
        </div>
    </div>
</body>
</html>