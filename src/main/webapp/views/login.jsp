<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - Pahana Edu</title>
    <style type="text/css">
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f7f8;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        
        .login-container {
            background-color: #fff;
            padding: 40px 30px;
            border-radius: 12px;
            box-shadow: 0px 8px 20px rgba(0, 0, 0, 0.1);
            width: 360px;
            text-align: center;
        }
        
        .login-container h2 { 
        	margin-bottom: 10px; 
        	color: #333; 
        }
        
        .login-container p { 
        	color: #666; 
        	font-size: 14px; 
        	margin-bottom: 20px; 
        }
        
        .login-form { 
        	display: flex; 
        	flex-direction: column; 
        	gap: 15px; 
        }
        
        .login-form label { 
        	text-align: left; 
        	font-size: 14px; 
        	color: #444; 
        }
        
        .login-form input {
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 14px;
        }
        
        .login-form input:focus { 
        	border-color: #007bff; 
        	outline: none; 
        }
        
        .login-form button {
            background-color: #007bff;
            color: #fff;
            border: none;
            padding: 12px;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        
        .login-form button:hover { 
        	background-color: #0056b3; 
        }
        
        .error-message {
            display: none;
            color: #f44336;
            background-color: #fdecea;
            padding: 8px 12px;
            margin-bottom: 10px;
            border-radius: 4px;
            border: 1px solid #f5c6cb;
            font-size: 14px;
        }
        
        .info-text { 
        	font-size: 12px; 
        	color: #888; 
        	margin-top: 15px; 
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>Welcome to Pahana Edu</h2>
        <p>Please login with your credentials to continue.</p>

        <form id="loginForm" action="${pageContext.request.contextPath}/UserController" method="post" class="login-form">
            <input type="hidden" name="action" value="login"/>
            
            <label for="username">Username</label>
            <input type="text" id="username" name="username" placeholder="Enter your username" required>
            
            <label for="password">Password</label>
            <input type="password" id="password" name="password" placeholder="Enter your password" required>
            
            <!-- Error message -->
            <div id="errorMsg" class="error-message">${errorMessage}</div>
            
            <button type="submit">Login</button>
        </form>

        <p class="info-text">
            Don't have an account? Please contact the administrator to create one.
        </p>
    </div>

    <script>
        window.onload = function() {
            const errorMsg = document.getElementById('errorMsg');
            if (errorMsg.textContent.trim() !== '') {
                errorMsg.style.display = 'block';
            }
        }
    </script>
</body>
</html>
