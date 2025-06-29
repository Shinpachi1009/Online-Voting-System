<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Forgot Password - Online Voting System</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .forgot-container { max-width: 500px; margin: 100px auto; padding: 20px; background: #fff; border-radius: 5px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
    </style>
</head>
<body>
    <div class="container">
        <div class="forgot-container">
            <h2 class="text-center mb-4">Forgot Password</h2>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>
            
            <c:if test="${not empty message}">
                <div class="alert alert-success">${message}</div>
            </c:if>
            
            <form id="forgotPasswordForm" action="password-reset" method="post">
                <input type="hidden" name="action" value="request">
                
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" class="form-control" required>
                    <small class="form-text text-muted">Enter your registered email address to receive a password reset link.</small>
                </div>
                
                <button type="submit" class="btn btn-primary btn-block">Send Reset Link</button>
            </form>
            
            <div class="mt-3 text-center">
                <a href="login.jsp">Back to Login</a>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script>
        $(document).ready(function() {
            $('#forgotPasswordForm').submit(function(e) {
                const email = $('#email').val();
                
                // Simple email validation
                if (!email || !email.includes('@') || !email.includes('.')) {
                    e.preventDefault();
                    alert('Please enter a valid email address');
                    return false;
                }
                
                return true;
            });
        });
    </script>
</body>
</html>