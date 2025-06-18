<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Profile - Online Voting System</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <jsp:include page="/navbar.jsp" />
    
    <div class="container mt-4">
        <div class="row">
            <div class="col-md-8 offset-md-2">
                <div class="card">
                    <div class="card-header">
                        <h4>My Profile</h4>
                    </div>
                    
                    <div class="card-body">
                        <c:if test="${not empty param.error}">
                            <div class="alert alert-danger">${param.error}</div>
                        </c:if>
                        
                        <c:if test="${not empty param.message}">
                            <div class="alert alert-success">${param.message}</div>
                        </c:if>
                        
                        <form action="user" method="post">
                            <input type="hidden" name="action" value="update">
                            
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="firstName">First Name</label>
                                    <input type="text" class="form-control" id="firstName" name="firstName" 
                                        value="${user.firstName}" required>
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="lastName">Last Name</label>
                                    <input type="text" class="form-control" id="lastName" name="lastName" 
                                        value="${user.lastName}" required>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="username">Username</label>
                                <input type="text" class="form-control" id="username" 
                                    value="${user.username}" readonly>
                            </div>
                            
                            <div class="form-group">
                                <label for="email">Email</label>
                                <input type="email" class="form-control" id="email" name="email" 
                                    value="${user.email}" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="phone">Phone Number</label>
                                <input type="tel" class="form-control" id="phone" name="phone" 
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
                        
                        <h5 class="mt-4">Change Password</h5>
						<div id="passwordError"></div>
						
						<form action="${pageContext.request.contextPath}/user?action=changepassword" method="post" onsubmit="return validatePasswordChange()">
						    <input type="hidden" name="action" value="changepassword">
						    
						    <div class="form-group">
						        <label for="currentPassword">Current Password</label>
						        <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
						    </div>
						    
						    <div class="form-group">
						        <label for="newPassword">New Password</label>
						        <input type="password" class="form-control" id="newPassword" name="newPassword" required>
						        <small class="text-muted">Must be at least 8 characters with 1 number and 1 special character</small>
						    </div>
						    
						    <div class="form-group">
						        <label for="confirmPassword">Confirm New Password</label>
						        <input type="password" class="form-control" id="confirmPassword" name="confirmNewPassword" required>
						    </div>
						    
						    <button type="submit" class="btn btn-primary">Change Password</button>
						</form>

                    </div>
                </div>
            </div>
        </div>
    </div>
    
	<script>
		document.querySelector('form[action="user"]:last-of-type').addEventListener('submit', function(e) {
		    const currentPassword = document.getElementById('currentPassword').value;
		    const newPassword = document.getElementById('newPassword').value;
		    const confirmPassword = document.getElementById('confirmNewPassword').value;
		    
		    // Expanded special character set
		    const specialChars = /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/;
		    
		    if (newPassword.length < 8) {
		        e.preventDefault();
		        alert('Password must be at least 8 characters long');
		        return false;
		    }
		    
		    if (!/\d/.test(newPassword)) {
		        e.preventDefault();
		        alert('Password must contain at least one number');
		        return false;
		    }
		    
		    if (!specialChars.test(newPassword)) {
		        e.preventDefault();
		        alert('Password must contain at least one special character');
		        return false;
		    }
		    
		    if (newPassword !== confirmPassword) {
		        e.preventDefault();
		        alert('Passwords do not match');
		        return false;
		    }
		    
		    if (currentPassword === newPassword) {
		        e.preventDefault();
		        alert('New password must be different from current password');
		        return false;
		    }
		    
		    return true;
		});
	</script>
</html>