<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Product" %>
<%@ page import="model.Admin" %>
<%@ page import="dao.ProductDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Product Details</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        /* Dark Blue Theme Variables */
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
        
        /* Layout Structure */
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
        
        .sidebar-item a i {
            width: 24px;
            text-align: center;
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
        
        .header h1 {
            font-size: 1.75rem;
            font-weight: 600;
            color: var(--light);
        }
        
        .user-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        
        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: var(--secondary);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
        }
        
        /* Branch Info Display */
        .branch-info {
            background: var(--primary);
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            animation: fadeIn 0.6s 0.3s both;
        }
        
        .branch-info i {
            font-size: 1.25rem;
        }
        
        /* Table Styles */
        .product-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1.5rem;
            background-color: var(--primary-dark);
            border-radius: 0.5rem;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.3);
            animation: fadeIn 0.6s ease-out forwards;
        }
        
        .product-table th, 
        .product-table td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid var(--primary-light);
        }
        
        .product-table th {
            background-color: var(--primary);
            color: var(--white);
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.875rem;
            letter-spacing: 0.5px;
        }
        
        .product-table tr:last-child td {
            border-bottom: none;
        }
        
        .product-table tr:hover {
            background-color: rgba(25, 118, 210, 0.1);
        }
        
        .product-table .product-key {
            font-family: monospace;
            background-color: rgba(25, 118, 210, 0.1);
            padding: 0.25rem 0.5rem;
            border-radius: 0.25rem;
            font-size: 0.875rem;
        }
        
        .product-table .location-badge {
            display: inline-block;
            padding: 0.25rem 0.5rem;
            border-radius: 0.25rem;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .product-table .from-location {
            background-color: rgba(76, 175, 80, 0.2);
            color: var(--success);
        }
        
        .product-table .to-location {
            background-color: rgba(255, 152, 0, 0.2);
            color: var(--warning);
        }
        
        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 3rem;
            background-color: var(--primary-dark);
            border-radius: 0.5rem;
            margin-top: 2rem;
        }
        
        .empty-state i {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: var(--gray);
        }
        
        .empty-state h3 {
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
            color: var(--light);
        }
        
        .empty-state p {
            color: var(--gray);
            max-width: 500px;
            margin: 0 auto;
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
            }
            
            .product-table {
                display: block;
                overflow-x: auto;
            }
        }
        
        /* Animations */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }
        
        @keyframes slideIn {
            from { transform: translateX(-20px); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }
        
        /* Apply Animations */
        .sidebar-item {
            animation: slideIn 0.4s ease-out forwards;
        }
    </style>
</head>
<body>
    <%
        // Check if user is logged in
        Admin admin = (Admin) session.getAttribute("admin");
        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }
        
        // Get products for this outlet (where from_location matches outlet)
        ProductDAO productDAO = new ProductDAO();
        List<Product> products = productDAO.selectProductsByFromLocation(admin.getOutletLocation());
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    %>
    <div class="dashboard-container">
        <!-- Sidebar Navigation -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <h3>Admin Panel</h3>
            </div>
            <nav>
                <div class="sidebar-item">
                    <a href="${pageContext.request.contextPath}/pages/OutletDashBoard.jsp">
                        <i>📊</i> Dashboard
                    </a>
                </div>
                <div class="sidebar-item">
                    <a href="${pageContext.request.contextPath}/pages/updateTracking.jsp">
                        <i>🔍</i> Tracking
                    </a>
                </div>
                <div class="sidebar-item">
                    <a href="${pageContext.request.contextPath}/pages/monthlyDeliveryReport.jsp">
                        <i>📈</i> Sales Report
                    </a>
                </div>
                <div class="sidebar-item">
                    <a href="${pageContext.request.contextPath}/pages/addProduct.jsp">
                        <i>➕</i> Add Product
                    </a>
                </div>
                <div class="sidebar-item active">
                    <a href="${pageContext.request.contextPath}/pages/product-list.jsp">
                        <i>📋</i> Product Details
                    </a>
                </div>
                <div class="sidebar-item">
                    <a href="${pageContext.request.contextPath}/pages/StaffFormOutlet.jsp">
                        <i>👥</i> Add Staff
                    </a>
                </div>
            </nav>
        </aside>

        <!-- Main Content Area -->
        <main class="main-content">
            <!-- Header -->
            <header class="header">
                <h1>Product Details</h1>
                <div class="user-info">
                    <span>Welcome, ${sessionScope.admin.adminName}</span>
                    <div class="user-avatar">
                        ${sessionScope.admin.adminName.charAt(0)}
                    </div>
                </div>
            </header>

            <!-- Branch Information -->
            <div class="branch-info">
                <i>🏢</i>
                <span>Branch: <strong>${sessionScope.admin.outletLocation}</strong></span>
            </div>
            
            <!-- Products Table -->
            <% if (products != null && !products.isEmpty()) { %>
                <table class="product-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Sender</th>
                            <th>Receiver</th>
                            <th>Product Key</th>
                            <th>Weight (kg)</th>
                            <th>From</th>
                            <th>To</th>
                            <th>Date Added</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Product product : products) { %>
                            <tr>
                                <td><%= product.getId() %></td>
                                <td><%= product.getSenderName() %></td>
                                <td><%= product.getReceiverName() %></td>
                                <td><span class="product-key"><%= product.getProductKey() %></span></td>
                                <td><%= product.getProductWeight() %></td>
                                <td><span class="location-badge from-location"><%= product.getFromLocation() %></span></td>
                                <td><span class="location-badge to-location"><%= product.getToLocation() %></span></td>
                                <td><%= product.getAddedDate() != null ? dateFormat.format(product.getAddedDate()) : "N/A" %></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } else { %>
                <div class="empty-state">
                    <i>📦</i>
                    <h3>No Products Found</h3>
                    <p>There are no products originating from your outlet location. Products will appear here once they are registered at your branch.</p>
                </div>
            <% } %>
        </main>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Mobile menu toggle
            const mobileMenuToggle = document.createElement('button');
            mobileMenuToggle.innerHTML = '☰';
            mobileMenuToggle.style.position = 'fixed';
            mobileMenuToggle.style.top = '1rem';
            mobileMenuToggle.style.left = '1rem';
            mobileMenuToggle.style.zIndex = '1000';
            mobileMenuToggle.style.background = 'var(--primary)';
            mobileMenuToggle.style.color = 'white';
            mobileMenuToggle.style.border = 'none';
            mobileMenuToggle.style.borderRadius = '50%';
            mobileMenuToggle.style.width = '40px';
            mobileMenuToggle.style.height = '40px';
            mobileMenuToggle.style.display = 'none';
            mobileMenuToggle.style.justifyContent = 'center';
            mobileMenuToggle.style.alignItems = 'center';
            mobileMenuToggle.style.cursor = 'pointer';
            
            mobileMenuToggle.addEventListener('click', function() {
                document.querySelector('.sidebar').classList.toggle('active');
            });
            
            document.body.appendChild(mobileMenuToggle);
            
            // Show mobile menu button on small screens
            function checkScreenSize() {
                if (window.innerWidth <= 768) {
                    mobileMenuToggle.style.display = 'flex';
                } else {
                    mobileMenuToggle.style.display = 'none';
                    document.querySelector('.sidebar').classList.remove('active');
                }
            }
            
            window.addEventListener('resize', checkScreenSize);
            checkScreenSize();
        });
    </script>
</body>
</html>
