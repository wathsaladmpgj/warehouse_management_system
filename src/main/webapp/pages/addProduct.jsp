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
            padding: 30px;
            border-radius: 15px;
            background: linear-gradient(145deg, #ffffff, #f0f0f0);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            animation: fadeIn 0.5s ease-out;
        }
        
        .product-form:hover {
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15);
            transform: translateY(-5px);
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .form-group {
            margin-bottom: 25px;
            position: relative;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #444;
            transition: all 0.3s ease;
        }
        
        .form-group input, .form-group select {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            box-sizing: border-box;
            font-size: 16px;
            transition: all 0.3s ease;
            background-color: #f9f9f9;
        }
        
        .form-group input:focus, .form-group select:focus {
            border-color: #4CAF50;
            box-shadow: 0 0 0 3px rgba(76, 175, 80, 0.2);
            outline: none;
            background-color: #fff;
        }
        
        .form-group input:hover, .form-group select:hover {
            border-color: #bdbdbd;
        }
        
        .form-submit {
            background: linear-gradient(135deg, #4CAF50, #45a049);
            color: white;
            padding: 14px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
            width: 100%;
            transition: all 0.3s ease;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .form-submit:hover {
            background: linear-gradient(135deg, #45a049, #3d8b40);
            transform: translateY(-2px);
            box-shadow: 0 6px 8px rgba(0, 0, 0, 0.15);
        }
        
        .form-submit:active {
            transform: translateY(0);
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        
        .error {
            color: #e74c3c;
            font-size: 14px;
            padding: 10px;
            background-color: #fdecea;
            border-radius: 6px;
            margin-top: 15px;
            animation: shake 0.5s ease;
        }
        
        .success {
            color: #27ae60;
            font-size: 14px;
            padding: 10px;
            background-color: #e8f5e9;
            border-radius: 6px;
            margin-top: 15px;
            animation: fadeIn 0.5s ease;
        }
        
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            20%, 60% { transform: translateX(-5px); }
            40%, 80% { transform: translateX(5px); }
        }
        
        .form-group input:focus + label,
        .form-group input:not(:placeholder-shown) + label {
            transform: translateY(-25px);
            font-size: 14px;
            color: #4CAF50;
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
                        <input type="text" id="senderName" name="senderName" required placeholder=" ">
                    </div>
                    
                    <div class="form-group">
                        <label for="receiverName">Receiver Name:</label>
                        <input type="text" id="receiverName" name="receiverName" required placeholder=" ">
                    </div>
                    
                    <div class="form-group">
                        <label for="postalCode">Postal Code:</label>
                        <input type="text" id="postalCode" name="postalCode" required placeholder=" ">
                    </div>
                    
                    <div class="form-group">
                        <label for="receiveLocation">Receive Location (Address):</label>
                        <input type="text" id="receiverLocation" name="receiverLocation" required placeholder=" ">
                    </div>
                    
                    <div class="form-group">
                        <label for="productWeight">Product Weight (kg):</label>
                        <input type="number" id="productWeight" name="productWeight" step="0.01" min="0.01" required placeholder=" ">
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