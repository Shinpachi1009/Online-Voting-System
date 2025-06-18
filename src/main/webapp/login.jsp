<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - Online Voting System</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .login-container { max-width: 400px; margin: 100px auto; padding: 20px; background: #fff; border-radius: 5px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
    </style>
</head>
<body>
    <div class="container">
        <div class="login-container">
            <h2 class="text-center mb-4">Online Voting System</h2>
            
            <c:if test="${not empty param.error}">
                <div class="alert alert-danger">${param.error}</div>
            </c:if>
            
            <c:if test="${not empty param.message}">
                <div class="alert alert-success">${param.message}</div>
            </c:if>
            
            <form id="loginForm" action="${pageContext.request.contextPath}/auth" method="post">
                <input type="hidden" name="action" value="login">
                
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" class="form-control" id="username" name="username" required>
                </div>
                
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" class="form-control" id="password" name="password" required>
                </div>
                
                <div class="form-group form-check">
                    <input type="checkbox" class="form-check-input" id="rememberMe" name="rememberMe">
                    <label class="form-check-label" for="rememberMe">Remember me</label>
                </div>
                
                <button type="submit" class="btn btn-primary btn-block">Login</button>
            </form>
            
            <div class="mt-3 text-center">
                <a href="${pageContext.request.contextPath}/forgotPassword.jsp">Forgot Password?</a>
            </div>
            
            <div class="mt-2 text-center">
                Don't have an account? <a href="${pageContext.request.contextPath}/register.jsp">Register here</a>
            </div>
        </div>
    </div>

    <script>
        // Basic client-side validation
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            const username = document.getElementById('username').value.trim();
            const password = document.getElementById('password').value.trim();
            
            if (!username || !password) {
                e.preventDefault();
                alert('Please enter both username and password');
                return false;
            }
            return true;
        });
    </script>
</body>
</html>