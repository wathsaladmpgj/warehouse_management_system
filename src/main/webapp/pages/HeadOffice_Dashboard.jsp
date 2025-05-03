<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Head Office Dashboard</title>
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

            .dynamic-count {
                font-family: 'Inter', sans-serif;
                font-weight: 700;
                color: var(--success);
                font-size: 1.75rem;
                text-shadow: 0 2px 4px rgba(0,0,0,0.2);
                animation: pulse 1.5s infinite alternate;
                display: inline-block;
                margin-bottom: 0.5rem;
            }
        </style>
    </head>
    <body>
        <c:if test="${getRowCountTotalRegisteredItems == null}">
            <c:redirect url='/HeadOffice_Servlet' />
        </c:if>

        <div class="dashboard-container">
            <!-- Sidebar Navigation -->
            <aside class="sidebar">
                <div class="sidebar-header">
                    <h3>Head Office Panel</h3>
                </div>
                <nav>
                    <div class="sidebar-item active">
                        <a href="${pageContext.request.contextPath}/pages/HeadOffice_Dashboard.jsp">
                            <i>🏢</i> Dashboard
                        </a>
                    </div>
                    <div class="sidebar-item ">
                        <a href="${pageContext.request.contextPath}/pages/HeadOffice_AddOutlet.jsp">
                            <i>🏢</i> Add Outlet
                        </a>
                    </div>
                    <div class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/pages/tracking.jsp">
                            <i>📊</i> View Report
                        </a>
                    </div>
                    <div class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/pages/HeadOffice_OutletDetails.jsp">
                            <i>🏬</i> Outlet Details
                        </a>
                    </div>
                    <div class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/pages/HeadOffice_StaffDetails.jsp">
                            <i>👥</i> Staff Details
                        </a>
                    </div>
                </nav>
            </aside>

            <!-- Main Content Area -->
            <main class="main-content">
                <!-- Header -->
                <header class="header">
                    <h1>Head Office Dashboard</h1>
                    <div class="user-info">
                        <span>Welcome, Head Office Admin</span>
                        <div class="user-avatar">
                            HO
                        </div>
                    </div>
                </header>

                <!-- Dashboard Stats Grid -->
                <div class="dashboard-grid">
                    <!-- Total Registered Items Card -->
                    <div class="card" style="animation-delay: 0.1s">
                        <div class="card-header">
                            <h3 class="card-title">Total Registered Items</h3>
                            <div class="card-icon">
                                <i>📝</i>
                            </div>
                        </div>
                        <h2 class="dynamic-count" id="registeredItemsCount">${getRowCountTotalRegisteredItems}</h2>
                        <p class="card-label">Items registered across all outlets</p>
                        <div class="stats-highlight positive">
                            <span>▲ 12%</span>
                        </div>
                    </div>

                    <!-- Total Returned Items Card -->
                    <div class="card" style="animation-delay: 0.2s">
                        <div class="card-header">
                            <h3 class="card-title">Total Returned Items</h3>
                            <div class="card-icon">
                                <i>↩️</i>
                            </div>
                        </div>
                        <h2 class="card-value" id="returnedItemsCount">${getTotalReturnedItems}</h2>
                        <p class="card-label">Items returned to head office</p>
                        <div class="stats-highlight positive">
                            <span>▲ 5%</span>
                        </div>
                    </div>

                    <!-- Remaining Returned Items Card -->
                    <div class="card" style="animation-delay: 0.3s">
                        <div class="card-header">
                            <h3 class="card-title">Remaining Returned Items</h3>
                            <div class="card-icon">
                                <i>🔄</i>
                            </div>
                        </div>
                        <h2 class="card-value" id="remainingReturnedItems">${remaining_returned_items}</h2>
                        <p class="card-label">Items pending processing</p>
                        <div class="stats-highlight negative">
                            <span>▼ 3%</span>
                        </div>
                    </div>

                    <!-- Available New Items Card -->
                    <div class="card" style="animation-delay: 0.4s">
                        <div class="card-header">
                            <h3 class="card-title">Available New Items</h3>
                            <div class="card-icon">
                                <i>🆕</i>
                            </div>
                        </div>
                        <h2 class="card-value" id="availableNewItems">${available_new_items}</h2>
                        <p class="card-label">New items in inventory</p>
                        <div class="stats-highlight positive">
                            <span>▲ 8%</span>
                        </div>
                    </div>
                </div>

                <!-- Second Row of Cards -->
                <div class="dashboard-grid">
                    <!-- Total Staff Count Card -->
                    <div class="card" style="animation-delay: 0.5s">
                        <div class="card-header">
                            <h3 class="card-title">Total Staff Count</h3>
                            <div class="card-icon">
                                <i>👥</i>
                            </div>
                        </div>
                        <h2 class="card-value" id="staffCount">${getStaffCount}</h2>
                        <p class="card-label">Staff members across outlets</p>
                        <div class="stats-highlight positive">
                            <span>▲ 4%</span>
                        </div>
                    </div>

                    <!-- Outlet Count Card -->
                    <div class="card" style="animation-delay: 0.6s">
                        <div class="card-header">
                            <h3 class="card-title">Outlet Count</h3>
                            <div class="card-icon">
                                <i>🏬</i>
                            </div>
                        </div>
                        <h2 class="card-value" id="outletCount">${getOutletCount}</h2>
                        <p class="card-label">Active outlets in system</p>
                        <div class="stats-highlight positive">
                            <span>▲ 2%</span>
                        </div>
                    </div>

                    <!-- Placeholder Card 1 -->
                    <div class="card" style="animation-delay: 0.7s">
                        <div class="card-header">
                            <h3 class="card-title">System Status</h3>
                            <div class="card-icon">
                                <i>✅</i>
                            </div>
                        </div>
                        <h2 class="card-value">Operational</h2>
                        <p class="card-label">All systems normal</p>
                    </div>

                    <!-- Placeholder Card 2 -->
                    <div class="card" style="animation-delay: 0.8s">
                        <div class="card-header">
                            <h3 class="card-title">Recent Activity</h3>
                            <div class="card-icon">
                                <i>🔄</i>
                            </div>
                        </div>
                        <h2 class="card-value">24</h2>
                        <p class="card-label">Updates today</p>
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
            document.addEventListener('DOMContentLoaded', function () {
                // Animate counting numbers
                function animateValue(id, start, end, duration) {
                    const obj = document.getElementById(id);
                    if (!obj)
                        return;

                    let startTimestamp = null;
                    const step = (timestamp) => {
                        if (!startTimestamp)
                            startTimestamp = timestamp;
                        const progress = Math.min((timestamp - startTimestamp) / duration, 1);
                        const value = Math.floor(progress * (end - start) + start);
                        obj.innerHTML = value.toLocaleString();
                        if (progress < 1) {
                            window.requestAnimationFrame(step);
                        }
                    };
                    window.requestAnimationFrame(step);
                }

                // Get values from elements and animate them
                const registeredItemsCount = parseInt(document.getElementById('registeredItemsCount')?.textContent) || 0;
                        const returnedItemsCount = parseInt(document.getElementById('returnedItemsCount')?.textContent) || 0;
                        const remainingReturnedItems = parseInt(document.getElementById('remainingReturnedItems')?.textContent) || 0;
                        const availableNewItems = parseInt(document.getElementById('availableNewItems')?.textContent) || 0;
                        const staffCount = parseInt(document.getElementById('staffCount')?.textContent) || 0;
                        const outletCount = parseInt(document.getElementById('outletCount')?.textContent) || 0;

                // Animate counts if they're greater than 0
                if (registeredItemsCount > 0)
                    animateValue('registeredItemsCount', 0, registeredItemsCount, 1000);
                if (returnedItemsCount > 0)
                    animateValue('returnedItemsCount', 0, returnedItemsCount, 1000);
                if (remainingReturnedItems > 0)
                    animateValue('remainingReturnedItems', 0, remainingReturnedItems, 1000);
                if (availableNewItems > 0)
                    animateValue('availableNewItems', 0, availableNewItems, 1000);
                if (staffCount > 0)
                    animateValue('staffCount', 0, staffCount, 1000);
                if (outletCount > 0)
                    animateValue('outletCount', 0, outletCount, 1000);

                // Add hover effects to cards
                const cards = document.querySelectorAll('.card');
                cards.forEach(card => {
                    card.addEventListener('mouseenter', function () {
                        this.style.transform = 'translateY(-5px)';
                    });

                    card.addEventListener('mouseleave', function () {
                        this.style.transform = 'translateY(0)';
                    });

                    // Add click effect
                    card.addEventListener('click', function () {
                        this.classList.add('pulse');
                        setTimeout(() => {
                            this.classList.remove('pulse');
                        }, 1000);
                    });
                });

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

                mobileMenuToggle.addEventListener('click', function () {
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