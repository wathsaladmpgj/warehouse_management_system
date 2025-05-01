<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add Product</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/OutLetDashBoard.css">
    <style>
        :root {
            --primary: #1a237e;
            --primary-light: #303f9f;
            --primary-dark: #0d1452;
            --secondary: #1976d2;
            --success: #4caf50;
            --warning: #ff9800;
            --danger: #f44336;
            --dark: #121212;
            --light: #e3f2fd;
            --gray: #90a4ae;
            --gray-light: #cfd8dc;
            --white: #ffffff;
            --sidebar-width: 240px;
            --transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--dark);
            color: var(--gray-light);
            line-height: 1.6;
        }
        
        .dashboard-container {
            display: flex;
            min-height: 100vh;
        }
        
        /* Sidebar Styles */
        .sidebar {
            width: var(--sidebar-width);
            background: var(--primary-dark);
            border-right: 1px solid var(--primary-light);
            padding: 1rem 0;
            position: fixed;
            height: 100vh;
            transition: var(--transition);
            z-index: 100;
        }
        
        .sidebar-header {
            padding: 0 1.5rem 1.5rem;
            border-bottom: 1px solid var(--primary-light);
            margin-bottom: 1rem;
        }
        
        .sidebar-header h3 {
            color: var(--light);
            font-weight: 600;
        }
        
        .sidebar-item {
            padding: 0.75rem 1.5rem;
            margin: 0.25rem 0;
            transition: var(--transition);
        }
        
        .sidebar-item a {
            color: var(--gray-light);
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-weight: 500;
            transition: var(--transition);
        }
        
        .sidebar-item:hover {
            background-color: var(--primary);
        }
        
        .sidebar-item.active {
            background-color: var(--primary);
            border-left: 3px solid var(--secondary);
        }
        
        .sidebar-item.active a {
            color: var(--white);
        }
        
        /* Main Content Area */
        .main-content {
            flex: 1;
            margin-left: var(--sidebar-width);
            padding: 2rem;
            transition: var(--transition);
            background-color: var(--dark);
        }
        
        /* Header Styles */
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            padding-bottom: 1.5rem;
            border-bottom: 1px solid var(--primary-light);
        }
        
        .header h2 {
            font-size: 1.75rem;
            font-weight: 600;
            color: var(--light);
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        
        /* Form Styles */
        .content-area {
            max-width: 800px;
            margin: 0 auto;
        }
        
        .content-area h2 {
            font-size: 1.5rem;
            margin-bottom: 1.5rem;
            color: var(--light);
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        
        .product-form {
            background: var(--primary-dark);
            border-radius: 0.5rem;
            padding: 2rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.3);
            border: 1px solid var(--primary-light);
            animation: fadeIn 0.6s ease-out;
        }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: var(--gray-light);
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        
        .form-group input, 
        .form-group select {
            width: 100%;
            padding: 0.75rem 1rem;
            border-radius: 0.375rem;
            border: 1px solid var(--primary-light);
            background-color: rgba(255, 255, 255, 0.05);
            color: var(--white);
            font-size: 1rem;
            transition: var(--transition);
        }
        
        .form-group input:focus, 
        .form-group select:focus {
            outline: none;
            border-color: var(--secondary);
            box-shadow: 0 0 0 3px rgba(25, 118, 210, 0.3);
        }
        
        .form-submit {
            background-color: var(--secondary);
            color: white;
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 0.375rem;
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.75rem;
            font-size: 1rem;
        }
        
        .form-submit:hover {
            background-color: #1565c0;
            transform: translateY(-2px);
        }
        
        .error {
            color: var(--danger);
            background-color: rgba(244, 67, 54, 0.1);
            padding: 1rem;
            border-radius: 0.375rem;
            margin-top: 1.5rem;
            border-left: 4px solid var(--danger);
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        
        .success {
            color: var(--success);
            background-color: rgba(76, 175, 80, 0.1);
            padding: 1rem;
            border-radius: 0.375rem;
            margin-top: 1.5rem;
            border-left: 4px solid var(--success);
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            color: var(--secondary);
            text-decoration: none;
            margin-top: 1.5rem;
            transition: var(--transition);
        }
        
        .back-link:hover {
            color: var(--light);
        }
        
        /* Animations */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        /* Responsive Adjustments */
        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
                width: 280px;
            }
            
            .sidebar.active {
                transform: translateX(0);
            }
            
            .main-content {
                margin-left: 0;
                padding: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <div class="sidebar">
            <div class="sidebar-header">
                <h3>Warehouse Management</h3>
            </div>
            <div class="sidebar-item">
                <a href="${pageContext.request.contextPath}/pages/home.jsp">📊 Dashboard</a>
            </div>
            <div class="sidebar-item">
                <a href="${pageContext.request.contextPath}/pages/tracking.jsp">🔍 Tracking</a>
            </div>
            <div class="sidebar-item">
                <a href="${pageContext.request.contextPath}/pages/addProduct.jsp">📈 Sales Report</a>
            </div>
            <div class="sidebar-item active">
                <a href="${pageContext.request.contextPath}/pages/addProduct.jsp">➕ Add Product</a>
            </div>
            <div class="sidebar-item">
                <a href="${pageContext.request.contextPath}/pages/addProduct.jsp">📋 Product Details</a>
            </div>
            <div class="sidebar-item">
                <a href="${pageContext.request.contextPath}/pages/addProduct.jsp">📦 Inventory</a>
            </div>
            <div class="sidebar-item">
                <a href="${pageContext.request.contextPath}/pages/addProduct.jsp">👥 Add Staff</a>
            </div>
            <div class="sidebar-item">
                <a href="${pageContext.request.contextPath}/pages/addProduct.jsp">👔 Staff Management</a>
            </div>
        </div>
        <div class="main-content">
            <div class="header">
                <h2>🏢 ${sessionScope.admin.outletLocation}</h2>
            </div>
            <div class="content-area">
                <h2>➕ Add New Product</h2>
                
                <form class="product-form" action="${pageContext.request.contextPath}/AddProductServlet" method="POST">
                    <input type="hidden" name="fromLocation" value="${sessionScope.admin.outletLocation}">
                    
                    <div class="form-group">
                        <label for="senderName">👤 Sender Name:</label>
                        <input type="text" id="senderName" name="senderName" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="receiverName">👤 Receiver Name:</label>
                        <input type="text" id="receiverName" name="receiverName" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="postalCode">📮 Postal Code:</label>
                        <input type="text" id="postalCode" name="postalCode" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="receiveLocation">📍 Receive Location:</label>
                        <input type="text" id="receiverLocation" name="receiverLocation" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="productWeight">⚖️ Product Weight (kg):</label>
                        <input type="number" id="productWeight" name="productWeight" step="0.01" min="0.01" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="date">📅 Date:</label>
                        <input type="date" id="date" name="date" required>
                    </div>
                    
                    <div class="form-group">
                        <input type="submit" class="form-submit" value="🚀 Add Product">
                    </div>
                    
                    <% if(request.getAttribute("errorMessage") != null) { %>
                        <div class="error">
                            ❌ ${requestScope.errorMessage}
                        </div>
                    <% } %>
                    
                    <% if(request.getAttribute("successMessage") != null) { %>
                        <div class="success">
                            ✅ ${requestScope.successMessage}
                        </div>
                    <% } %>
                </form>
                
                <a href="${pageContext.request.contextPath}/pages/home.jsp" class="back-link">🔙 Back to Dashboard</a>
            </div>
        </div>
    </div>
</body>
</html>