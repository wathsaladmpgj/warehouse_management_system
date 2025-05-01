<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Login</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&family=Montserrat:wght@600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background: linear-gradient(135deg, #004494, #0066cc);
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            overflow: hidden;
        }
        
        .login-container {
            background-color: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            width: 380px;
            position: relative;
            z-index: 1;
            transform: translateY(20px);
            opacity: 0;
            transition: all 0.6s ease-out;
            overflow: hidden;
        }
        
        .login-container::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: linear-gradient(
                to bottom right,
                rgba(255, 255, 255, 0.1) 0%,
                rgba(255, 255, 255, 0) 60%
            );
            transform: rotate(30deg);
            z-index: -1;
        }
        
        .login-container.visible {
            transform: translateY(0);
            opacity: 1;
        }
        
        h2 {
            font-family: 'Montserrat', sans-serif;
            font-weight: 700;
            color: #004494;
            text-align: center;
            margin-bottom: 30px;
            font-size: 28px;
            position: relative;
        }
        
        h2::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 50px;
            height: 3px;
            background: #004494;
            border-radius: 3px;
        }
        
        form {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        
        .input-group {
            position: relative;
        }
        
        input {
            padding: 14px 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-family: 'Roboto', sans-serif;
            font-size: 15px;
            width: 100%;
            box-sizing: border-box;
            transition: all 0.3s;
            background-color: #f9f9f9;
        }
        
        input:focus {
            outline: none;
            border-color: #004494;
            box-shadow: 0 0 0 3px rgba(0, 68, 148, 0.2);
            background-color: white;
        }
        
        .floating-label {
            position: absolute;
            left: 15px;
            top: 14px;
            color: #999;
            font-size: 15px;
            pointer-events: none;
            transition: all 0.3s;
        }
        
        input:focus + .floating-label,
        input:not(:placeholder-shown) + .floating-label {
            top: -10px;
            left: 10px;
            font-size: 12px;
            background-color: white;
            padding: 0 5px;
            color: #004494;
        }
        
        button {
            background: linear-gradient(to right, #004494, #0066cc);
            color: white;
            border: none;
            padding: 14px;
            border-radius: 8px;
            font-family: 'Montserrat', sans-serif;
            font-weight: 600;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 10px;
            position: relative;
            overflow: hidden;
        }
        
        button:hover {
            background: linear-gradient(to right, #003366, #004494);
            box-shadow: 0 5px 15px rgba(0, 68, 148, 0.4);
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
            background: rgba(255, 255, 255, 0.2);
            transform: rotate(30deg) translate(-20px, -40px);
            transition: all 0.3s;
        }
        
        button:hover::after {
            transform: rotate(30deg) translate(20px, 40px);
        }
        
        .error-message {
            color: #d32f2f;
            font-family: 'Roboto', sans-serif;
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
            padding: 10px;
            border-radius: 5px;
            background-color: rgba(211, 47, 47, 0.1);
            animation: shake 0.5s ease-in-out;
        }
        
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            20%, 60% { transform: translateX(-5px); }
            40%, 80% { transform: translateX(5px); }
        }
        
        /* Background animation elements */
        .bg-bubbles {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 0;
            overflow: hidden;
        }
        
        .bg-bubbles li {
            position: absolute;
            list-style: none;
            display: block;
            width: 40px;
            height: 40px;
            background-color: rgba(255, 255, 255, 0.15);
            bottom: -160px;
            animation: square 20s infinite;
            transition-timing-function: linear;
            border-radius: 5px;
        }
        
        .bg-bubbles li:nth-child(1) {
            left: 10%;
            animation-delay: 0s;
            animation-duration: 16s;
        }
        
        .bg-bubbles li:nth-child(2) {
            left: 20%;
            animation-delay: 2s;
            animation-duration: 14s;
        }
        
        .bg-bubbles li:nth-child(3) {
            left: 25%;
            animation-delay: 4s;
        }
        
        .bg-bubbles li:nth-child(4) {
            left: 40%;
            animation-delay: 6s;
            animation-duration: 18s;
        }
        
        .bg-bubbles li:nth-child(5) {
            left: 70%;
            animation-delay: 0s;
        }
        
        .bg-bubbles li:nth-child(6) {
            left: 80%;
            animation-delay: 3s;
            animation-duration: 17s;
        }
        
        .bg-bubbles li:nth-child(7) {
            left: 30%;
            animation-delay: 7s;
        }
        
        .bg-bubbles li:nth-child(8) {
            left: 50%;
            animation-delay: 1s;
            animation-duration: 15s;
        }
        
        .bg-bubbles li:nth-child(9) {
            left: 65%;
            animation-delay: 5s;
        }
        
        .bg-bubbles li:nth-child(10) {
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
    <ul class="bg-bubbles">
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
                    this.parentNode.querySelector('.floating-label').style.color = '#004494';
                });
                
                input.addEventListener('blur', function() {
                    if (!this.value) {
                        this.parentNode.querySelector('.floating-label').style.color = '#999';
                    }
                });
            });
            
            // Animate button on hover
            const loginButton = document.getElementById('loginButton');
            loginButton.addEventListener('mouseenter', function() {
                this.style.boxShadow = '0 5px 15px rgba(0, 68, 148, 0.4)';
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
                background: rgba(255, 255, 255, 0.7);
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