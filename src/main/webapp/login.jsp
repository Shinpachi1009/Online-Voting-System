<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - Online Voting System</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <!-- SweetAlert2 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/password-toggle.css">
</head>
<body>
    <div class="container">
        <div class="form-container">
            <h2 class="text-center mb-4">Online Voting System</h2>
            
            <form id="loginForm" action="${pageContext.request.contextPath}/auth" method="post">
                <input type="hidden" name="action" value="login">
                
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" class="form-control" id="username" name="username">
                </div>
                
                <div class="form-group password-toggle">
                    <label for="password">Password</label>
                    <input type="password" class="form-control" id="password" name="password">
                    <span class="toggle-password" onclick="togglePassword('password')">
                    </span>
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

    <!-- jQuery first, then Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <!-- SweetAlert2 JS -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <!-- Custom JS -->
    <script src="${pageContext.request.contextPath}/js/password-toggle.js"></script>
    
    <script>
    // Function to validate login form
    function validateLoginForm() {
        const username = document.getElementById('username').value.trim();
        const password = document.getElementById('password').value.trim();
        
        // Scene 1: Empty fields validation
        if (!username || !password) {
            Swal.fire({
                icon: 'error',
                title: 'Missing Information',
                text: 'Please fill in both username and password fields',
                confirmButtonColor: '#3085d6',
                confirmButtonText: 'OK'
            });
            return false;
        }
        
        // Show confirmation dialog before submitting
        return Swal.fire({
            title: 'Confirm Login',
            text: 'Are you ready to sign in to your account?',
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Yes, login!',
            cancelButtonText: 'Cancel'
        }).then((result) => {
            if (result.isConfirmed) {
                // Show loading indicator
                Swal.fire({
                    title: 'Logging in...',
                    allowOutsideClick: false,
                    didOpen: () => {
                        Swal.showLoading();
                    }
                });
                return true;
            }
            return false;
        });
    }
    
    // Attach validation to form submission
    document.getElementById('loginForm').addEventListener('submit', function(e) {
        e.preventDefault();
        validateLoginForm().then((shouldSubmit) => {
            if (shouldSubmit) {
                this.submit();
            }
        });
    });
    
    // Show any server-side errors/messages
    document.addEventListener('DOMContentLoaded', function() {
        const urlParams = new URLSearchParams(window.location.search);
        const error = urlParams.get('error');
        const message = urlParams.get('message');
        
        if (error) {
            Swal.fire({
                icon: 'error',
                title: 'Login Failed',
                text: error,
                confirmButtonColor: '#3085d6',
                confirmButtonText: 'OK'
            });
        }
        
        if (message) {
            Swal.fire({
                icon: 'success',
                title: 'Success',
                text: message,
                confirmButtonColor: '#3085d6',
                confirmButtonText: 'OK'
            });
        }
    });
    </script>
</body>
</html>