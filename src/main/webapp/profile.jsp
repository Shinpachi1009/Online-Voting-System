<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Profile - Online Voting System</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/password-toggle.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
</head>

<body>
    <jsp:include page="/navbar.jsp" />
    
    <div class="container mt-4">
        <div class="row">
            <div class="col-md-8 offset-md-2">
                <div class="form-container">
                    <div class="card-header">
                        <h4>My Profile</h4>
                    </div>
                    
                    <div class="card-body">
                        <!-- Profile Update Form -->
                        <form id="profileForm" action="user" method="post">
                            <input type="hidden" name="action" value="update">
                            
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="firstName">First Name</label>
                                    <input type="text" class="form-control" id="firstName" name="firstName" 
                                        value="${user.firstName}">
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="lastName">Last Name</label>
                                    <input type="text" class="form-control" id="lastName" name="lastName" 
                                        value="${user.lastName}">
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="username">Username</label>
                                <input type="text" class="form-control" id="username" 
                                    value="${user.username}" readonly>
                            </div>
                            
                            <div class="form-group">
                                <label for="email">Email</label>
                                <input type="text" class="form-control" id="email" name="email" 
                                    value="${user.email}">
                            </div>
                            
                            <div class="form-group">
                                <label for="phone">Phone Number</label>
                                <input type="text" class="form-control" id="phone" name="phone" 
                                    value="${user.phone}">
                            </div>
                            
                            <div class="form-group">
                                <label>Role</label>
                                <input type="text" class="form-control" 
                                    value="${user.roleName}" readonly>
                            </div>
                            
                            <button type="submit" class="btn btn-primary">Update Profile</button>
                        </form>
                        
                        <hr>
                        
                        <!-- Password Change Form -->
                        <form id="passwordForm" action="${pageContext.request.contextPath}/user" method="post">
                            <input type="hidden" name="action" value="changepassword">
                            
                            <div class="form-group password-toggle">
                                <label for="currentPassword">Current Password</label>
                                <input type="password" class="form-control" id="currentPassword" name="currentPassword">
                                <span class="toggle-password" onclick="togglePassword('currentPassword')">
                                </span>
                            </div>
                            
                            <div class="form-group password-toggle">
                                <label for="newPassword">New Password</label>
                                <input type="password" class="form-control" id="newPassword" name="newPassword">
                                <span class="toggle-password" onclick="togglePassword('newPassword')">
                                </span>
                                <small class="text-muted">Must be 6-12 characters with 1 number and 1 letter</small>
                            </div>
                            
                            <div class="form-group password-toggle">
                                <label for="confirmPassword">Confirm New Password</label>
                                <input type="password" class="form-control" id="confirmPassword" name="confirmNewPassword">
                                <span class="toggle-password" onclick="togglePassword('confirmPassword')">
                                </span>
                            </div>
                            
                            <button type="submit" class="btn btn-primary">Change Password</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/password-toggle.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    
    <script>
    $(document).ready(function() {
        // Profile Form Validation
        $('#profileForm').on('submit', function(e) {
            e.preventDefault();
            
            const firstName = $('#firstName').val().trim();
            const lastName = $('#lastName').val().trim();
            const email = $('#email').val().trim();
            const phone = $('#phone').val().trim();
            
            // Scene 1: Empty fields validation
            if (!firstName || !lastName || !email) {
                Swal.fire({
                    icon: 'error',
                    title: 'Missing Information',
                    text: 'Please fill in all required fields',
                    confirmButtonColor: '#3085d6'
                });
                return;
            }
            
            // Scene 2: Validate email format
            if (!validateEmail(email)) {
                Swal.fire({
                    icon: 'error',
                    title: 'Invalid Email',
                    text: 'Please enter a valid email address (e.g., user@example.com)',
                    confirmButtonColor: '#3085d6'
                });
                return;
            }
            
            // Scene 3: Validate phone number if provided
            if (phone && !validatePhone(phone)) {
                return;
            }
            
            // Scene 4: Show confirmation dialog
            Swal.fire({
                title: 'Confirm Update',
                text: 'Are you sure you want to update your profile information?',
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Yes, update it!'
            }).then((result) => {
                if (result.isConfirmed) {
                    this.submit();
                }
            });
        });
        
        // Password Form Validation
        $('#passwordForm').on('submit', function(e) {
            e.preventDefault();
            
            const currentPassword = $('#currentPassword').val();
            const newPassword = $('#newPassword').val();
            const confirmPassword = $('#confirmPassword').val();
            
            // Scene 1: Check if current password is empty
            if (!currentPassword) {
                showPasswordError('Please enter your current password');
                return;
            }
            
            // Scene 2: Check if new passwords match
            if (newPassword !== confirmPassword) {
                showPasswordError('New password and confirm password do not match');
                return;
            }
            
            // Scene 3: Password requirements
            if (newPassword.length < 6 || newPassword.length > 12) {
                showPasswordError('Password must be between 6 and 12 characters');
                return;
            }
            
            if (!/\d/.test(newPassword)) {
                showPasswordError('Password must contain at least one number');
                return;
            }
            
            if (!/[a-zA-Z]/.test(newPassword)) {
                showPasswordError('Password must contain at least one letter');
                return;
            }
            
            // Verify current password with server before proceeding
            verifyCurrentPassword(currentPassword).then(isValid => {
                if (!isValid) {
                    showPasswordError('Current password is incorrect');
                    return;
                }
                
                // Scene 4: Show confirmation dialog
                Swal.fire({
                    title: 'Confirm Password Change',
                    text: 'Are you sure you want to change your password?',
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: 'Yes, change it!'
                }).then((result) => {
                    if (result.isConfirmed) {
                        this.submit();
                    }
                });
            });
        });
        
        // Helper functions
        function validateEmail(email) {
            const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return re.test(email);
        }
        
        function validatePhone(phone) {
            if (!/^\d+$/.test(phone)) {
                Swal.fire({
                    icon: 'error',
                    title: 'Invalid Phone Number',
                    text: 'Phone number should contain only numbers',
                    confirmButtonColor: '#3085d6'
                });
                return false;
            }
            
            if (!phone.startsWith('09')) {
                Swal.fire({
                    icon: 'error',
                    title: 'Invalid Phone Number',
                    text: 'Phone number should start with 09',
                    confirmButtonColor: '#3085d6'
                });
                return false;
            }
            
            if (phone.length !== 11) {
                Swal.fire({
                    icon: 'error',
                    title: 'Invalid Phone Number',
                    text: 'Phone number should be 11 digits long',
                    confirmButtonColor: '#3085d6'
                });
                return false;
            }
            
            return true;
        }
        
        function showPasswordError(message) {
            Swal.fire({
                icon: 'error',
                title: 'Password Error',
                text: message,
                confirmButtonColor: '#3085d6'
            });
        }
        
        function verifyCurrentPassword(password) {
            return new Promise((resolve) => {
                $.ajax({
                    url: '${pageContext.request.contextPath}/user',
                    type: 'POST',
                    data: {
                        action: 'verifypassword',
                        currentPassword: password
                    },
                    success: function(response) {
                        resolve(response.isValid);
                    },
                    error: function() {
                        resolve(false);
                    }
                });
            });
        }
    });
    </script>
</body>
</html>