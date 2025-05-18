<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Login</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/login.css">
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