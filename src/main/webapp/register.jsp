<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Registration Form</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/logo.png" type="image/x-icon">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/register-style.css">
</head>

<body>
    <div class="register-container">
        <div class="register-card">
            <div class="logo-container">
                <img src="${pageContext.request.contextPath}/images/logo.png" alt="Voting System Logo" class="logo">
                <h2 class="text-center mb-4">PUP Online Voting System</h2>
            </div>
            <form id="registerForm" action="user" method="post" class="register-form" novalidate>
                <input type="hidden" name="action" value="register">
                
                <div class="form-row">
                    <div class="form-group col-md-6">
                        <label for="firstName"><i class="fas fa-user"></i>First Name</label>
                        <input type="text" class="form-control" id="firstName" name="firstName" placeholder="Enter your first name">
                    </div>
                    <div class="form-group col-md-6">
                        <label for="lastName"><i class="fas fa-user"></i>Last Name</label>
                        <input type="text" class="form-control" id="lastName" name="lastName" placeholder="Enter your last name">
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group col-md-6">
                        <label for="username"><i class="fas fa-user-tag"></i>Username</label>
                        <input type="text" class="form-control" id="username" name="username" placeholder="6-12 alphanumeric characters">
                    </div>
                    <div class="form-group col-md-6">
                        <label for="email"><i class="fas fa-envelope"></i>Email</label>
                        <input type="text" class="form-control" id="email" name="email" placeholder="example@domain.com">
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="phone"><i class="fas fa-phone"></i>Phone Number</label>
                    <input type="tel" class="form-control" id="phone" name="phone" placeholder="09XXXXXXXXX">
                </div>
                
                <div class="form-group password-group">
                    <label for="password"><i class="fas fa-lock"></i>Password</label>
                    <div class="input-with-icon">
                        <input type="password" class="form-control" id="password" name="password" placeholder="12-24 characters with 1 symbol">
                        <span class="toggle-password" onclick="togglePassword('password')">
                            <i class="fas fa-eye"></i>
                        </span>
                    </div>
                    <small class="form-text text-muted">Password must be 12-24 characters and contain at least 1 symbol.</small>
                </div>
                
                <button type="submit" class="btn btn-register">REGISTER</button>
                
                <div class="form-footer">
                    Already have an account? <a href="${pageContext.request.contextPath}/login.jsp">Login here!</a>
                </div>
            </form>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    
    <script>
    function togglePassword(fieldId) {
        const field = document.getElementById(fieldId);
        const icon = field.nextElementSibling.querySelector('i');
        
        if (field.type === 'password') {
            field.type = 'text';
            icon.classList.remove('fa-eye');
            icon.classList.add('fa-eye-slash');
        } else {
            field.type = 'password';
            icon.classList.remove('fa-eye-slash');
            icon.classList.add('fa-eye');
        }
    }

    document.getElementById('registerForm').addEventListener('submit', function(e) {
        e.preventDefault();
        
        const firstName = document.getElementById('firstName').value.trim();
        const lastName = document.getElementById('lastName').value.trim();
        const username = document.getElementById('username').value.trim();
        const email = document.getElementById('email').value.trim();
        const phone = document.getElementById('phone').value.trim();
        const password = document.getElementById('password').value;

        if (!firstName || !lastName || !username || !email || !phone || !password) {
            Swal.fire({
                icon: 'error',
                title: 'Missing Information',
                text: 'Please fill in all required fields',
                confirmButtonColor: '#3085d6',
                confirmButtonText: 'OK'
            });
            return;
        }

        const nameRegex = /^[A-Za-z ]+$/;
        const usernameRegex = /^[A-Za-z0-9]+$/;
        const emailRegex = /^[^@]+@[^@]+\.[^@]+$/;
        const phoneRegex = /^09\d{9}$/;
        const passwordRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*()_\-+=\[\]{};':"\\|,.<>\/?]).{12,24}$/;

        if (!nameRegex.test(firstName)) {
            Swal.fire({
                icon: 'error',
                title: 'Invalid First Name',
                text: 'First name must contain only alphabetic characters and spaces (A-Z).',
                confirmButtonColor: '#3085d6',
                confirmButtonText: 'OK'
            });
            return;
        }
        
        if (firstName.length > 16) {
            Swal.fire({
                icon: 'error',
                title: 'First Name Too Long',
                text: 'First name must be maximum 16 characters.',
                confirmButtonColor: '#3085d6',
                confirmButtonText: 'OK'
            });
            return;
        }
        
        if (!nameRegex.test(lastName)) {
            Swal.fire({
                icon: 'error',
                title: 'Invalid Last Name',
                text: 'Last name must contain only alphabetic characters and spaces (A-Z).',
                confirmButtonColor: '#3085d6',
                confirmButtonText: 'OK'
            });
            return;
        }
        
        if (lastName.length > 16) {
            Swal.fire({
                icon: 'error',
                title: 'Last Name Too Long',
                text: 'Last name must be maximum 16 characters.',
                confirmButtonColor: '#3085d6',
                confirmButtonText: 'OK'
            });
            return;
        }
        
        if (!usernameRegex.test(username)) {
            Swal.fire({
                icon: 'error',
                title: 'Invalid Username',
                text: 'Username must contain only alphanumeric characters (A-Z, 0-9).',
                confirmButtonColor: '#3085d6',
                confirmButtonText: 'OK'
            });
            return;
        }
        
        if (username.length < 6 || username.length > 12) {
            Swal.fire({
                icon: 'error',
                title: 'Invalid Username Length',
                text: 'Username must be between 6-12 characters.',
                confirmButtonColor: '#3085d6',
                confirmButtonText: 'OK'
            });
            return;
        }
        
        if (email.endsWith('@') || !emailRegex.test(email)) {
            Swal.fire({
                icon: 'error',
                title: 'Invalid Email',
                text: 'Please enter a valid email address (e.g., example@domain.com).',
                confirmButtonColor: '#3085d6',
                confirmButtonText: 'OK'
            });
            return;
        }
        
        if (!phoneRegex.test(phone)) {
            Swal.fire({
                icon: 'error',
                title: 'Invalid Phone Number',
                text: 'Phone number must start with 09 and have exactly 11 digits.',
                confirmButtonColor: '#3085d6',
                confirmButtonText: 'OK'
            });
            return;
        }
        
        if (password.length < 12 || password.length > 24) {
            Swal.fire({
                icon: 'error',
                title: 'Invalid Password Length',
                text: 'Password must be between 12-24 characters.',
                confirmButtonColor: '#3085d6',
                confirmButtonText: 'OK'
            });
            return;
        }
        
        if (!passwordRegex.test(password)) {
            Swal.fire({
                icon: 'error',
                title: 'Invalid Password Format',
                text: 'Password must contain at least 1 letter, 1 number, and 1 special character.',
                confirmButtonColor: '#3085d6',
                confirmButtonText: 'OK'
            });
            return;
        }

        Swal.fire({
            title: 'Confirm Registration',
            text: 'Do you want to create your account?',
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#666',
            confirmButtonText: 'Register',
            cancelButtonText: 'Cancel'
        }).then((result) => {
            if (result.isConfirmed) {
                Swal.fire({
                    title: 'Registering...',
                    allowOutsideClick: false,
                    didOpen: () => {
                        Swal.showLoading();
                        document.getElementById('registerForm').submit();
                    }
                });
            }
        });
    });

    document.addEventListener('DOMContentLoaded', function() {
        const urlParams = new URLSearchParams(window.location.search);
        const error = urlParams.get('error');
        const message = urlParams.get('message');
        
        if (error) {
            Swal.fire({
                icon: 'error',
                title: 'Registration Failed',
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