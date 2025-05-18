<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Head Office Dashboard</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/HeadOffice_Dashboard.css">
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
                            <i>🏠</i> Dashboard
                        </a>
                    </div>
                    <div class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/pages/chart.jsp">
                            <i>📈</i> Analysis
                        </a>
                    </div>
                    <div class="sidebar-item ">
                        <a href="${pageContext.request.contextPath}/pages/HeadOffice_AddOutlet.jsp">
                            <i>🏢</i> Add Outlet
                        </a>
                    </div>
                    <div class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/pages/headOffice_product_summar.jsp">
                            <i>📊</i> View Report
                        </a>
                    </div>
                    <div class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/pages/HeadOffice_OutletDetails.jsp">
                            <i>🏬</i> Outlet Details
                        </a>
                    </div>
                    <div class="sidebar-item">
                        <a href="${pageContext.request.contextPath}/pages/addAdmin.jsp">
                            <i>👥</i>Admin ADD
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

                <!-- First Row of Cards -->
                <div class="dashboard-grid">
                    <!-- Total Registered Items Card -->
                    <div class="card" style="animation-delay: 0.1s">
                        <div class="card-header">
                            <h3 class="card-title">Total Registered Items</h3>
                            <div class="card-icon">
                                <i>📝</i>
                            </div>
                        </div>
                        <h2 class="" id="registeredItemsCount">${getRowCountTotalRegisteredItems}</h2>
                        <p class="card-label">Items registered across all outlets</p>
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
                        <p class="card-label">returned items across outlets</p>
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
                        <p class="card-label">Remaining Returned Items across outlets</p>
                    </div>
                </div>

                <!-- Second Row of Cards -->
                <div class="dashboard-grid">
                    <!-- Available New Items Card -->
                    <div class="card" style="animation-delay: 0.4s">
                        <div class="card-header">
                            <h3 class="card-title">Available New Items</h3>
                            <div class="card-icon">
                                <i>🆕</i>
                            </div>
                        </div>
                        <h2 class="card-value" id="availableNewItems">${available_new_items}</h2>
                        <p class="card-label">Available New Items across outlets</p>
                    </div>

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
