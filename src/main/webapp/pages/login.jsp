<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Login</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
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
            background: var(--primary-dark);
            color: var(--gray-light);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            overflow: hidden;
        }
        
        .login-container {
            background: var(--dark);
            padding: 2.5rem;
            border-radius: 0.5rem;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
            width: 380px;
            position: relative;
            z-index: 1;
            transform: translateY(20px);
            opacity: 0;
            transition: var(--transition);
            border: 1px solid var(--primary-light);
        }
        
        .login-container.visible {
            transform: translateY(0);
            opacity: 1;
        }
        
        h2 {
            font-family: 'Inter', sans-serif;
            font-weight: 600;
            color: var(--light);
            text-align: center;
            margin-bottom: 2rem;
            font-size: 1.75rem;
            position: relative;
        }
        
        h2::after {
            content: '';
            position: absolute;
            bottom: -0.75rem;
            left: 50%;
            transform: translateX(-50%);
            width: 50px;
            height: 3px;
            background: var(--secondary);
            border-radius: 3px;
        }
        
        form {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }
        
        .input-group {
            position: relative;
        }
        
        input {
            padding: 0.875rem 1rem;
            border: 1px solid var(--primary-light);
            border-radius: 0.375rem;
            font-family: 'Inter', sans-serif;
            font-size: 0.9375rem;
            width: 100%;
            box-sizing: border-box;
            transition: var(--transition);
            background-color: var(--primary-dark);
            color: var(--gray-light);
        }
        
        input:focus {
            outline: none;
            border-color: var(--secondary);
            box-shadow: 0 0 0 3px rgba(25, 118, 210, 0.3);
            background-color: var(--primary);
        }
        
        .floating-label {
            position: absolute;
            left: 1rem;
            top: 0.875rem;
            color: var(--gray);
            font-size: 0.9375rem;
            pointer-events: none;
            transition: var(--transition);
        }
        
        input:focus + .floating-label,
        input:not(:placeholder-shown) + .floating-label {
            top: -0.625rem;
            left: 0.625rem;
            font-size: 0.75rem;
            background-color: var(--primary-dark);
            padding: 0 0.3125rem;
            color: var(--secondary);
        }
        
        button {
            background: linear-gradient(to right, var(--primary), var(--primary-light));
            color: var(--white);
            border: none;
            padding: 0.875rem;
            border-radius: 0.375rem;
            font-family: 'Inter', sans-serif;
            font-weight: 600;
            font-size: 1rem;
            cursor: pointer;
            transition: var(--transition);
            margin-top: 0.5rem;
            position: relative;
            overflow: hidden;
        }
        
        button:hover {
            background: linear-gradient(to right, var(--primary-light), var(--primary));
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
            transform: translateY(-2px);
        }
        
        button:active {
            transform: translateY(0);
        }
        
        button::after {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: rgba(255, 255, 255, 0.1);
            transform: rotate(30deg) translate(-20px, -40px);
            transition: var(--transition);
        }
        
        button:hover::after {
            transform: rotate(30deg) translate(20px, 40px);
        }
        
        .error-message {
            color: var(--danger);
            font-family: 'Inter', sans-serif;
            text-align: center;
            margin-top: 1.25rem;
            font-size: 0.875rem;
            padding: 0.625rem;
            border-radius: 0.25rem;
            background-color: rgba(244, 67, 54, 0.1);
            animation: shake 0.5s ease-in-out;
        }
        
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            20%, 60% { transform: translateX(-5px); }
            40%, 80% { transform: translateX(5px); }
        }
        
        /* Background animation elements */
        .bg-shapes {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 0;
            overflow: hidden;
        }
        
        .bg-shapes li {
            position: absolute;
            list-style: none;
            display: block;
            width: 40px;
            height: 40px;
            background-color: rgba(25, 118, 210, 0.1);
            bottom: -160px;
            animation: square 20s infinite;
            transition-timing-function: linear;
            border-radius: 5px;
        }
        
        .bg-shapes li:nth-child(1) {
            left: 10%;
            animation-delay: 0s;
            animation-duration: 16s;
        }
        
        .bg-shapes li:nth-child(2) {
            left: 20%;
            animation-delay: 2s;
            animation-duration: 14s;
        }
        
        .bg-shapes li:nth-child(3) {
            left: 25%;
            animation-delay: 4s;
        }
        
        .bg-shapes li:nth-child(4) {
            left: 40%;
            animation-delay: 6s;
            animation-duration: 18s;
        }
        
        .bg-shapes li:nth-child(5) {
            left: 70%;
            animation-delay: 0s;
        }
        
        .bg-shapes li:nth-child(6) {
            left: 80%;
            animation-delay: 3s;
            animation-duration: 17s;
        }
        
        .bg-shapes li:nth-child(7) {
            left: 30%;
            animation-delay: 7s;
        }
        
        .bg-shapes li:nth-child(8) {
            left: 50%;
            animation-delay: 1s;
            animation-duration: 15s;
        }
        
        .bg-shapes li:nth-child(9) {
            left: 65%;
            animation-delay: 5s;
        }
        
        .bg-shapes li:nth-child(10) {
            left: 90%;
            animation-delay: 2s;
            animation-duration: 12s;
        }
        
        @keyframes square {
            0% {
                transform: translateY(0) rotate(0deg);
                opacity: 1;
            }
            100% {
                transform: translateY(-1000px) rotate(720deg);
                opacity: 0;
            }
        }
    </style>
</head>
<body>
    <!-- Animated background elements -->
    <ul class="bg-shapes">
        <li></li>
        <li></li>
        <li></li>
        <li></li>
        <li></li>
        <li></li>
        <li></li>
        <li></li>
        <li></li>
        <li></li>
    </ul>
    
    <div class="login-container" id="loginContainer">
        <h2>Admin Login</h2>
        
        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="input-group">
                <input type="text" name="username" id="username" placeholder=" " required>
                <label for="username" class="floating-label">Admin Name</label>
            </div>
            
            <div class="input-group">
                <input type="password" name="password" id="password" placeholder=" " required>
                <label for="password" class="floating-label">Password</label>
            </div>
            
            <button type="submit" id="loginButton">Login</button>
        </form>
        
        <p class="error-message" id="errorMessage">
            ${requestScope.error}
        </p>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Show login container with fade-in animation
            const loginContainer = document.getElementById('loginContainer');
            setTimeout(() => {
                loginContainer.classList.add('visible');
            }, 100);
            
            // Add focus effects to inputs
            const inputs = document.querySelectorAll('input');
            inputs.forEach(input => {
                input.addEventListener('focus', function() {
                    this.parentNode.querySelector('.floating-label').style.color = 'var(--secondary)';
                });
                
                input.addEventListener('blur', function() {
                    if (!this.value) {
                        this.parentNode.querySelector('.floating-label').style.color = 'var(--gray)';
                    }
                });
            });
            
            // Animate button on hover
            const loginButton = document.getElementById('loginButton');
            loginButton.addEventListener('mouseenter', function() {
                this.style.boxShadow = '0 5px 15px rgba(0, 0, 0, 0.3)';
            });
            
            loginButton.addEventListener('mouseleave', function() {
                this.style.boxShadow = 'none';
            });
            
            // Show error message with animation if exists
            const errorMessage = document.getElementById('errorMessage');
            if (errorMessage.textContent.trim() !== '') {
                errorMessage.style.display = 'block';
            } else {
                errorMessage.style.display = 'none';
            }
            
            // Add ripple effect to button
            loginButton.addEventListener('click', function(e) {
                // Only animate if form is valid
                if (document.forms[0].checkValidity()) {
                    const rect = this.getBoundingClientRect();
                    const x = e.clientX - rect.left;
                    const y = e.clientY - rect.top;
                    
                    const ripple = document.createElement('span');
                    ripple.style.left = x + 'px';
                    ripple.style.top = y + 'px';
                    ripple.classList.add('ripple-effect');
                    
                    this.appendChild(ripple);
                    
                    setTimeout(() => {
                        ripple.remove();
                    }, 600);
                }
            });
        });
        
        // Add CSS for ripple effect dynamically
        const style = document.createElement('style');
        style.textContent = `
            .ripple-effect {
                position: absolute;
                border-radius: 50%;
                background: rgba(255, 255, 255, 0.3);
                transform: scale(0);
                animation: ripple 0.6s linear;
                pointer-events: none;
                width: 20px;
                height: 20px;
            }
            
            @keyframes ripple {
                to {
                    transform: scale(10);
                    opacity: 0;
                }
            }
        `;
        document.head.appendChild(style);
    </script>
</body>
</html>