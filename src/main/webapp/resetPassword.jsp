<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reset Password - Online Voting System</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .reset-container { max-width: 500px; margin: 100px auto; padding: 20px; background: #fff; border-radius: 5px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
    </style>
</head>
<body>
    <div class="container">
        <div class="reset-container">
            <h2 class="text-center mb-4">Reset Password</h2>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>
            
            <form id="resetPasswordForm" action="password-reset" method="post">
                <input type="hidden" name="action" value="reset">
                <input type="hidden" name="token" value="${param.token}">
                
                <div class="form-group">
                    <label for="newPassword">New Password</label>
                    <input type="password" id="newPassword" name="newPassword" class="form-control" required>
                    <small class="form-text text-muted">Password must be at least 8 characters long and contain at least one number and one special character.</small>
                </div>
                
                <div class="form-group">
                    <label for="confirmPassword">Confirm New Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" required>
                </div>
                
                <button type="submit" class="btn btn-primary btn-block">Reset Password</button>
            </form>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script>
        $(document).ready(function() {
            $('#resetPasswordForm').submit(function(e) {
                const password = $('#newPassword').val();
                const confirmPassword = $('#confirmPassword').val();
                
                // Check if passwords match
                if (password !== confirmPassword) {
                    e.preventDefault();
                    alert('Passwords do not match!');
                    return false;
                }
                
                // Check password complexity
                const passwordRegex = /^(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{8,}$/;
                if (!passwordRegex.test(password)) {
                    e.preventDefault();
                    alert('Password must be at least 8 characters long and contain at least one number and one special character.');
                    return false;
                }
                
                return true;
            });
        });
    </script>
</body>
</html>