<%@page import="model.Admin"%>
<%@page import="service.AdminService"%>
<%@page import="dao.DBHelper"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%
    Admin admin = (Admin) session.getAttribute("admin");
    AdminService adminService = new AdminService();
    double newItemsTotalPrice = adminService.getNewItemsTotalPrice(admin.getOutletLocation());
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
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
        
        /* Dashboard Grid */
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        
        /* Card Styles */
        .card {
            background: var(--primary-dark);
            border-radius: 0.5rem;
            padding: 1.5rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.3);
            transition: var(--transition);
            position: relative;
            overflow: hidden;
            border: 1px solid var(--primary-light);
        }
        
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.4);
            border-color: var(--secondary);
        }
        
        .card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: var(--secondary);
        }
        
        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }
        
        .card-title {
            font-size: 1rem;
            font-weight: 500;
            color: var(--gray-light);
        }
        
        .card-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: rgba(25, 118, 210, 0.2);
            color: var(--secondary);
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .card-value {
            font-size: 1.75rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            color: var(--white);
        }
        
        .card-label {
            font-size: 0.875rem;
            color: var(--gray);
        }
        
        .price-card .card-value {
            color: var(--success);
        }
        
        /* Stats Highlight */
        .stats-highlight {
            font-size: 0.875rem;
            display: flex;
            align-items: center;
            gap: 0.25rem;
        }
        
        .stats-highlight.positive {
            color: var(--success);
        }
        
        .stats-highlight.negative {
            color: var(--danger);
        }
        
        /* Button Styles */
        .btn {
            padding: 0.5rem 1rem;
            border-radius: 0.375rem;
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
            border: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .btn-primary {
            background-color: var(--secondary);
            color: white;
        }
        
        .btn-primary:hover {
            background-color: #1565c0;
        }
        
        .btn-logout {
            background-color: rgba(244, 67, 54, 0.1);
            color: var(--danger);
        }
        
        .btn-logout:hover {
            background-color: var(--danger);
            color: white;
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
            
            .dashboard-grid {
                grid-template-columns: 1fr;
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
        .card {
            animation: fadeIn 0.6s ease-out forwards;
        }
        
        .sidebar-item {
            animation: slideIn 0.4s ease-out forwards;
        }
        
        .pulse {
            animation: pulse 2s infinite;
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar Navigation -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <h3>Admin Panel</h3>
            </div>
            <nav>
                <div class="sidebar-item active">
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
                <div class="sidebar-item">
                    <a href="${pageContext.request.contextPath}/pages/product-list.jsp">
                        <i>📋</i> Product Details
                    </a>
                </div>
                <div class="sidebar-item">
                    <a href="${pageContext.request.contextPath}/pages/add-staff.jsp">
                        <i>👥</i> Add Staff
                    </a>
                </div>
            </nav>
        </aside>

        <!-- Main Content Area -->
        <main class="main-content">
            <!-- Header -->
            <header class="header">
                <h1>Dashboard Overview</h1>
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

            <!-- Dashboard Stats Grid -->
            <div class="dashboard-grid">
                <!-- New Items Card -->
                <div class="card" style="animation-delay: 0.1s">
                    <div class="card-header">
                        <h3 class="card-title">New Items</h3>
                        <div class="card-icon">
                            <i>🆕</i>
                        </div>
                    </div>
                    <h2 class="card-value" id="newItemsCount">${trackingCount}</h2>
                    <p class="card-label">Items matching your location</p>
                    <div class="stats-highlight positive">
                        
                    </div>
                </div>

                <!-- Registered Items Card -->
                <div class="card" style="animation-delay: 0.2s">
                    <div class="card-header">
                        <h3 class="card-title">Registered Items</h3>
                        <div class="card-icon">
                            <i>📝</i>
                        </div>
                    </div>
                    <h2 class="card-value" id="registeredItemsCount">${totalRegisteredItems}</h2>
                    <p class="card-label">Items at your outlet</p>
                    <div class="stats-highlight positive">
                      
                    </div>
                </div>

                <!-- Available Items Card -->
                <div class="card" style="animation-delay: 0.3s">
                    <div class="card-header">
                        <h3 class="card-title">Available Items</h3>
                        <div class="card-icon">
                            <i>✅</i>
                        </div>
                    </div>
                    <h2 class="card-value" id="availableItemsCount">${availableItemsCount}</h2>
                    <p class="card-label">Currently in stock</p>
                    <div class="stats-highlight negative">
                       
                    </div>
                </div>

                <!-- Success Items Card -->
                <div class="card" style="animation-delay: 0.4s">
                    <div class="card-header">
                        <h3 class="card-title">Success Items</h3>
                        <div class="card-icon">
                            <i>🎯</i>
                        </div>
                    </div>
                    <h2 class="card-value" id="successItemsCount">${successItemsCount}</h2>
                    <p class="card-label">Processed successfully</p>
                    <div class="stats-highlight positive">
                       
                    </div>
                </div>
            </div>

            <!-- Price Summary Section -->
            <h2 style="margin-bottom: 1.5rem; animation: fadeIn 0.6s 0.5s both; color: var(--gray-light)">Financial Overview</h2>
            
            <div class="dashboard-grid">
                <!-- New Items Price Card -->
                <div class="card price-card" style="animation-delay: 0.5s">
                    <div class="card-header">
                        <h3 class="card-title">New Items Value</h3>
                        <div class="card-icon">
                            <i>💰</i>
                        </div>
                    </div>
                    <h2 class="card-value pulse" id="newItemsPrice">Rs. <%= String.format("%,.2f", newItemsTotalPrice) %></h2>
                    <p class="card-label">Total value of new items</p>
                </div>

                <!-- Registered Items Price Card -->
                <div class="card price-card" style="animation-delay: 0.6s">
                    <div class="card-header">
                        <h3 class="card-title">Registered Items Value</h3>
                        <div class="card-icon">
                            <i>💳</i>
                        </div>
                    </div>
                <h2 class="card-value">
                    Rs. ${empty sessionScope.registeredItemsTotalPrice ? '0.00' : 
                        String.format("%,.2f", sessionScope.registeredItemsTotalPrice)}
                </h2>
                </div>

                <!-- Available Items Price Card -->
                <div class="card price-card" style="animation-delay: 0.7s">
                    <div class="card-header">
                        <h3 class="card-title">Available Items Value</h3>
                        <div class="card-icon">
                            <i>📊</i>
                        </div>
                    </div>
                    <h2 class="card-value">Rs. ${String.format("%,.2f", sessionScope.availableItemsTotalPrice)}</h2>
                    <p class="card-label">Current inventory value</p>
                </div>

                <!-- Success Items Price Card -->
                <div class="card price-card" style="animation-delay: 0.8s">
                    <div class="card-header">
                        <h3 class="card-title">Success Items Value</h3>
                        <div class="card-icon">
                            <i>🏆</i>
                        </div>
                    </div>
                    <h2 class="card-value">Rs. ${String.format("%,.2f", sessionScope.successItemsTotalPrice)}</h2>
                    <p class="card-label">Total processed value</p>
                </div>
            </div>

            <!-- Action Buttons -->
            <div style="margin-top: 2rem; display: flex; justify-content: flex-end; gap: 1rem; animation: fadeIn 0.6s 1s both">
                <a href="${pageContext.request.contextPath}/pages/login.jsp" class="btn btn-logout">
                    <i>🚪</i> Logout
                </a>
            </div>
        </main>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Animate counting numbers
            function animateValue(id, start, end, duration) {
                const obj = document.getElementById(id);
                let startTimestamp = null;
                const step = (timestamp) => {
                    if (!startTimestamp) startTimestamp = timestamp;
                    const progress = Math.min((timestamp - startTimestamp) / duration, 1);
                    const value = Math.floor(progress * (end - start) + start);
                    obj.innerHTML = value.toLocaleString();
                    if (progress < 1) {
                        window.requestAnimationFrame(step);
                    }
                };
                window.requestAnimationFrame(step);
            }
            
            // Get values from elements
            const newItemsCount = parseInt(document.getElementById('newItemsCount').textContent) || 0;
            const registeredItemsCount = parseInt(document.getElementById('registeredItemsCount').textContent) || 0;
            const availableItemsCount = parseInt(document.getElementById('availableItemsCount').textContent) || 0;
            const successItemsCount = parseInt(document.getElementById('successItemsCount').textContent) || 0;
            
            // Animate counts if they're greater than 0
            if (newItemsCount > 0) animateValue('newItemsCount', 0, newItemsCount, 1000);
            if (registeredItemsCount > 0) animateValue('registeredItemsCount', 0, registeredItemsCount, 1000);
            if (availableItemsCount > 0) animateValue('availableItemsCount', 0, availableItemsCount, 1000);
            if (successItemsCount > 0) animateValue('successItemsCount', 0, successItemsCount, 1000);
            
            // Add hover effects to cards
            const cards = document.querySelectorAll('.card');
            cards.forEach(card => {
                card.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-5px)';
                });
                
                card.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0)';
                });
                
                // Add click effect
                card.addEventListener('click', function() {
                    this.classList.add('pulse');
                    setTimeout(() => {
                        this.classList.remove('pulse');
                    }, 1000);
                });
            });
            
            // Mobile menu toggle (if needed)
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