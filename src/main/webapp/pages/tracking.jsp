<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String fromLocation = (String) request.getAttribute("fromLocation");
    String toLocation = (String) request.getAttribute("toLocation");
    String receiverLocation = (String) request.getAttribute("receiverLocation");
    String trackingUpdate = (String) request.getAttribute("trackingUpdate");
    String productKey = (String) request.getAttribute("productKey");
    
    // Set default values if not provided
    if (fromLocation == null) fromLocation = "Warehouse A";
    if (toLocation == null) toLocation = "Distribution Center";
    if (receiverLocation == null) receiverLocation = "Customer Location";
    if (trackingUpdate == null) trackingUpdate = "";
    if (productKey == null) productKey = "";
%>
<!DOCTYPE html>
<html>
<head>
    <title>Delivery Progress</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
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
            padding: 20px;
        }
        
        .container {
            max-width: 1000px;
            margin: 0 auto;
            background: var(--primary-dark);
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
            padding: 30px;
            border: 1px solid var(--primary-light);
        }
        
        h1 {
            color: var(--light);
            text-align: center;
            margin-bottom: 30px;
        }
        
        .tracking-form {
            background: var(--primary);
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 40px;
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .tracking-form label {
            font-weight: 600;
            color: var(--light);
        }
        
        .tracking-form input {
            padding: 10px 15px;
            border: 1px solid var(--primary-light);
            border-radius: 6px;
            flex-grow: 1;
            font-size: 16px;
            background: var(--primary-dark);
            color: var(--white);
        }
        
        .tracking-form button {
            background: var(--secondary);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            transition: var(--transition);
        }
        
        .tracking-form button:hover {
            background: #1565c0;
        }
        
        .timeline-container {
            position: relative;
            padding: 40px 0;
        }
        
        .timeline-line {
            position: absolute;
            top: 100px;
            left: 50px;
            right: 50px;
            height: 6px;
            background: var(--primary-light);
            z-index: 1;
            border-radius: 3px;
        }
        
        .progress-line {
            position: absolute;
            top: 100px;
            left: 50px;
            width: 0;
            height: 6px;
            background: var(--secondary);
            z-index: 2;
            border-radius: 3px;
            transition: width 0.5s ease;
        }
        
        .timeline-point {
            position: absolute;
            top: 90px;
            width: 20px;
            height: 20px;
            background: var(--primary-light);
            border-radius: 50%;
            z-index: 3;
            transform: translateX(-50%);
        }
        
        .timeline-point.active {
            background: var(--secondary);
            box-shadow: 0 0 0 5px rgba(25, 118, 210, 0.2);
        }
        
        .timeline-point.completed {
            background: var(--success);
            box-shadow: 0 0 0 5px rgba(76, 175, 80, 0.2);
        }
        
        .timeline-label {
            position: absolute;
            top: 130px;
            width: 200px;
            text-align: center;
            transform: translateX(-50%);
        }
        
        .location-name {
            font-weight: 600;
            color: var(--light);
            margin-bottom: 5px;
        }
        
        .location-example {
            color: var(--gray);
            font-size: 14px;
        }
        
        .vehicle-container {
            position: absolute;
            top: 70px;
            left: 50px;
            z-index: 4;
            transform: translateX(-50%);
            transition: left 0.5s ease;
        }
        
        .vehicle {
            font-size: 30px;
            color: var(--danger);
            position: relative;
            animation: bounce 2s infinite;
        }
        
        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }
        
        .status-message {
            text-align: center;
            margin-top: 60px;
            padding: 15px;
            background: var(--primary);
            border-radius: 8px;
            font-size: 18px;
            color: var(--light);
        }
        
        .status-icon {
            font-size: 24px;
            margin-right: 10px;
            vertical-align: middle;
        }
        
        .default-message {
            text-align: center;
            margin-top: 40px;
            color: var(--gray);
            font-style: italic;
        }
        
        .progress-steps {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }
        
        .progress-step {
            text-align: center;
            flex: 1;
            position: relative;
        }
        
        .step-icon {
            font-size: 24px;
            color: var(--gray);
            margin-bottom: 10px;
        }
        
        .step-icon.active {
            color: var(--secondary);
        }
        
        .step-icon.completed {
            color: var(--success);
        }
        
        .step-label {
            font-size: 14px;
            color: var(--gray);
        }
        
        /* Animations */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .container {
            animation: fadeIn 0.6s ease-out;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Track Your Delivery</h1>
        
        <form action="<%=request.getContextPath()%>/tracking" method="post" class="tracking-form">
            <label>Enter Tracking Number:</label>
            <input type="text" name="product_key" required value="<%= productKey %>" placeholder="e.g. ABC123456789"/>
            <button type="submit"><i class="fas fa-search"></i> Track Package</button>
        </form>

            <h2><%= trackingUpdate %></h2>
        <div class="timeline-container">
            <div class="timeline-line"></div>
            <div class="progress-line" id="progressLine"></div>
            
            <!-- Vehicle Indicator -->
            <div class="vehicle-container" id="vehicleContainer">
                <div class="vehicle">
                    <i class="fas fa-truck"></i>
                </div>
            </div>
            
            <!-- Points -->
            <div class="timeline-point" id="point1"></div>
            <div class="timeline-point" id="point2"></div>
            <div class="timeline-point" id="point3"></div>
            
            <!-- Labels -->
            <div class="timeline-label" style="left: 10%;">
                <div class="location-name">Origin</div>
                <div class="location-example"><%= fromLocation %></div>
            </div>
            <div class="timeline-label" style="left: 50%;">
                <div class="location-name">In Transit</div>
                <div class="location-example"><%= toLocation %></div>
            </div>
            <div class="timeline-label" style="left: 90%;">
                <div class="location-name">Destination</div>
                <div class="location-example"><%= receiverLocation %></div>
            </div>
            
            <!-- Progress Steps -->
            <div class="progress-steps">
                <div class="progress-step">
                    <div class="step-icon" id="step1"><i class="fas fa-warehouse"></i></div>
                    <div class="step-label">Processing</div>
                </div>
                <div class="progress-step">
                    <div class="step-icon" id="step2"><i class="fas fa-shipping-fast"></i></div>
                    <div class="step-label">Shipped</div>
                </div>
                <div class="progress-step">
                    <div class="step-icon" id="step3"><i class="fas fa-map-marker-alt"></i></div>
                    <div class="step-label">In Transit</div>
                </div>
                <div class="progress-step">
                    <div class="step-icon" id="step4"><i class="fas fa-check-circle"></i></div>
                    <div class="step-label">Delivered</div>
                </div>
            </div>
            
            <!-- Status Message -->
            <div class="status-message" id="statusMessage">
                <% if(trackingUpdate == null || trackingUpdate.isEmpty()) { %>
                    <i class="fas fa-info-circle status-icon"></i> Enter your tracking number to view delivery status
                <% } %>
            </div>
        </div>
    </div>

    <% if(trackingUpdate != null && !trackingUpdate.isEmpty()) { %>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const trackingUpdateValue = '<%= trackingUpdate %>'.toLowerCase();
            const fromLocation = '<%= fromLocation %>'.toLowerCase();
            const toLocation = '<%= toLocation %>'.toLowerCase();
            
            const progressLine = document.getElementById('progressLine');
            const vehicleContainer = document.getElementById('vehicleContainer');
            const statusMessage = document.getElementById('statusMessage');
            
            // Points and steps
            const point1 = document.getElementById('point1');
            const point2 = document.getElementById('point2');
            const point3 = document.getElementById('point3');
            const step1 = document.getElementById('step1');
            const step2 = document.getElementById('step2');
            const step3 = document.getElementById('step3');
            const step4 = document.getElementById('step4');
            
            let progress = 0;
            let vehiclePosition = '10%';
            let message = '';
            let icon = 'fas fa-info-circle';
            let iconColor = 'var(--secondary)';
            
            // Determine status based on trackingUpdate
            if (fromLocation === trackingUpdateValue) {
                progress = 0;
                vehiclePosition = '10%';
                message = 'Package is being processed at origin';
                icon = 'fas fa-warehouse';
                
                point1.classList.add('active');
                step1.classList.add('active');
            } 
            else if (trackingUpdateValue === 'ship' || trackingUpdateValue === 'shipped') {
                progress = 33;
                vehiclePosition = '33%';
                message = 'Package has been shipped';
                icon = 'fas fa-shipping-fast';
                
                point1.classList.add('completed');
                point2.classList.add('active');
                step1.classList.add('completed');
                step2.classList.add('active');
            } 
            else if (toLocation === trackingUpdateValue || trackingUpdateValue === 'traffic') {
                progress = 66;
                vehiclePosition = '66%';
                message = 'Package is in transit';
                icon = 'fas fa-truck';
                
                point1.classList.add('completed');
                point2.classList.add('completed');
                point3.classList.add('active');
                step1.classList.add('completed');
                step2.classList.add('completed');
                step3.classList.add('active');
            }
            else if (trackingUpdateValue === 'success' || trackingUpdateValue === 'delivered') {
                progress = 100;
                vehiclePosition = '90%';
                message = 'Package has been delivered successfully!';
                icon = 'fas fa-check-circle';
                iconColor = 'var(--success)';
                
                point1.classList.add('completed');
                point2.classList.add('completed');
                point3.classList.add('completed');
                step1.classList.add('completed');
                step2.classList.add('completed');
                step3.classList.add('completed');
                step4.classList.add('completed');
            }
            else if (trackingUpdateValue.includes('return')) {
                progress = 10;
                vehiclePosition = '20%';
                message = 'Package is being returned';
                icon = 'fas fa-undo';
                iconColor = 'var(--danger)';
                
                point1.classList.add('active');
                step1.classList.add('active');
            }
            
            // Update progress display
            progressLine.style.width = progress + '%';
            vehicleContainer.style.left = vehiclePosition;
            
            // Update status message
            statusMessage.innerHTML = `<i class="${icon} status-icon" style="color: ${iconColor}"></i> ${message}`;
        });
    </script>
    <% } %>
</body>
</html>