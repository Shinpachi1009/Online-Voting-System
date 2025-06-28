<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Profile</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/profile-style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar-style.css">
</head>
<body>
    <jsp:include page="/navbar.jsp" />
    
    <div class="profile-container">
        <div class="profile-card">
            <div class="profile-section">
                <h4 class="profile-title"><i class="fas fa-user-circle"></i> My Profile</h4>
                
                <c:if test="${not empty param.error}">
                    <div class="alert alert-danger">${param.error}</div>
                </c:if>
                
                <c:if test="${not empty param.message}">
                    <div class="alert alert-success">${param.message}</div>
                </c:if>
                
                <form id="profileForm" action="user" method="post" class="profile-form">
                    <input type="hidden" name="action" value="update">
                    
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label for="firstName"><i class="fas fa-user"></i>First Name</label>
                            <input type="text" class="form-control" id="firstName" name="firstName" 
                                value="${user.firstName}">
                        </div>
                        <div class="form-group col-md-6">
                            <label for="lastName"><i class="fas fa-user"></i>Last Name</label>
                            <input type="text" class="form-control" id="lastName" name="lastName" 
                                value="${user.lastName}">
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="username"><i class="fas fa-user-tag"></i>Username</label>
                        <input type="text" class="form-control" id="username" 
                            value="${user.username}" readonly>
                    </div>
                    
                    <div class="form-group">
                        <label for="email"><i class="fas fa-envelope"></i>Email</label>
                        <input type="text" class="form-control" id="email" name="email" 
                            value="${user.email}">
                    </div>
                    
                    <div class="form-group">
                        <label for="phone"><i class="fas fa-phone"></i>Phone Number</label>
                        <input type="tel" class="form-control" id="phone" name="phone" 
                            value="${user.phone}">
                    </div>
                    
                    <div class="form-group">
                        <label><i class="fas fa-user-shield"></i>Role</label>
                        <input type="text" class="form-control" 
                            value="${user.roleName}" readonly>
                    </div>
                    
                    <button type="submit" class="btn btn-update-profile">Update Profile</button>
                </form>
            </div>
            
            <div class="password-section">
                <h4 class="password-title"><i class="fas fa-key"></i> Change Password</h4>
                
                <form id="passwordForm" action="${pageContext.request.contextPath}/user" method="post" class="password-form">
                    <input type="hidden" name="action" value="changepassword">
                    
                    <div class="form-group password-group">
                        <label for="currentPassword"><i class="fas fa-lock"></i>Current Password</label>
                        <div class="input-with-icon">
                            <input type="password" class="form-control" id="currentPassword" name="currentPassword">
                            <span class="toggle-password" onclick="togglePassword('currentPassword')">
                                <i class="fas fa-eye"></i>
                            </span>
                        </div>
                    </div>
                    
                    <div class="form-group password-group">
                        <label for="newPassword"><i class="fas fa-lock"></i>New Password</label>
                        <div class="input-with-icon">
                            <input type="password" class="form-control" id="newPassword" name="newPassword">
                            <span class="toggle-password" onclick="togglePassword('newPassword')">
                                <i class="fas fa-eye"></i>
                            </span>
                        </div>
                        <small class="form-text text-muted">Password must be 12-24 characters and contain at least 1 symbol.</small>
                    </div>
                    
                    <div class="form-group password-group">
                        <label for="confirmPassword"><i class="fas fa-lock"></i>Confirm New Password</label>
                        <div class="input-with-icon">
                            <input type="password" class="form-control" id="confirmPassword" name="confirmNewPassword">
                            <span class="toggle-password" onclick="togglePassword('confirmPassword')">
                                <i class="fas fa-eye"></i>
                            </span>
                        </div>
                    </div>
                    
                    <button type="submit" class="btn btn-change-password">Change Password</button>
                </form>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    
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

    document.getElementById('profileForm').addEventListener('submit', function(e) {
        e.preventDefault();
        
        const firstName = document.getElementById('firstName').value.trim();
        const lastName = document.getElementById('lastName').value.trim();
        const email = document.getElementById('email').value.trim();
        const phone = document.getElementById('phone').value.trim();

        document.getElementById('profileForm').setAttribute('novalidate', 'true');

        if (!firstName || !lastName || !email) {
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
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        const phoneRegex = /^09\d{9}$/;

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
        
        if (phone && !phoneRegex.test(phone)) {
            Swal.fire({
                icon: 'error',
                title: 'Invalid Phone Number',
                text: 'Phone number must start with 09 and have exactly 11 digits.',
                confirmButtonColor: '#3085d6',
                confirmButtonText: 'OK'
            });
            return;
        }

        this.submit();
    });

    document.getElementById('passwordForm').addEventListener('submit', function(e) {
        e.preventDefault();
        
        const currentPassword = document.getElementById('currentPassword').value;
        const newPassword = document.getElementById('newPassword').value;
        const confirmPassword = document.getElementById('confirmPassword').value;
        const passwordRegex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*()_\-+=\[\]{};':"\\|,.<>\/?]).{12,24}$/;

        document.getElementById('passwordForm').setAttribute('novalidate', 'true');

        if (!currentPassword || !newPassword || !confirmPassword) {
            Swal.fire({
                icon: 'error',
                title: 'Missing Information',
                text: 'Please fill in all password fields',
                confirmButtonColor: '#3085d6',
                confirmButtonText: 'OK'
            });
            return;
        }

        if (newPassword !== confirmPassword) {
            Swal.fire({
                icon: 'error',
                title: 'Password Mismatch',
                text: 'New password and confirm password do not match',
                confirmButtonColor: '#3085d6',
                confirmButtonText: 'OK'
            });
            return;
        }

        if (newPassword.length < 12 || newPassword.length > 24) {
            Swal.fire({
                icon: 'error',
                title: 'Invalid Password Length',
                text: 'Password must be between 12-24 characters.',
                confirmButtonColor: '#3085d6',
                confirmButtonText: 'OK'
            });
            return;
        }
        
        if (!passwordRegex.test(newPassword)) {
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
            title: 'Confirm Password Change',
            text: 'Are you sure you want to change your password?',
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#666',
            confirmButtonText: 'Change Password',
            cancelButtonText: 'Cancel'
        }).then((result) => {
            if (result.isConfirmed) {
                Swal.fire({
                    title: 'Updating Password...',
                    allowOutsideClick: false,
                    didOpen: () => {
                        Swal.showLoading();
                        this.submit();
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
                title: 'Error',
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