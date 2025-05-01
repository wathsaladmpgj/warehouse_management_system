<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Login</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&family=Montserrat:wght@600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        
        .login-container {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 350px;
        }
        
        h2 {
            font-family: 'Montserrat', sans-serif;
            font-weight: 600;
            color: #004494;
            text-align: center;
            margin-bottom: 25px;
        }
        
        form {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        
        input {
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-family: 'Roboto', sans-serif;
            font-size: 14px;
        }
        
        input:focus {
            outline: none;
            border-color: #004494;
        }
        
        button {
            background-color: #004494;
            color: white;
            border: none;
            padding: 12px;
            border-radius: 5px;
            font-family: 'Montserrat', sans-serif;
            font-weight: 600;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        
        button:hover {
            background-color: #003366;
        }
        
        .error-message {
            color: #d32f2f;
            font-family: 'Roboto', sans-serif;
            text-align: center;
            margin-top: 15px;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>Admin Login</h2>
        
        <form action="${pageContext.request.contextPath}/login" method="post">
            <input type="text" name="username" placeholder="Admin Name" required>
            <input type="password" name="password" placeholder="Password" required>
            <button type="submit">Login</button>
        </form>
        
        <p class="error-message">
            ${requestScope.error}
        </p>
    </div>
</body>
</html>