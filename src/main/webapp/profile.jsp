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
                        
                        <form action="${pageContext.request.contextPath}/user" method="post" onsubmit="return validatePasswordChange()">
                            <input type="hidden" name="action" value="changepassword">
                            
                            <div class="form-group password-toggle">
                                <label for="currentPassword">Current Password</label>
                                <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                                <span class="toggle-password" onclick="togglePassword('currentPassword')">
                                </span>
                            </div>
                            
                            <div class="form-group password-toggle">
                                <label for="newPassword">New Password</label>
                                <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                                <span class="toggle-password" onclick="togglePassword('newPassword')">
                                </span>
                                <small class="text-muted">Must be at least 8 characters with 1 number and 1 special character</small>
                            </div>
                            
                            <div class="form-group password-toggle">
                                <label for="confirmPassword">Confirm New Password</label>
                                <input type="password" class="form-control" id="confirmPassword" name="confirmNewPassword" required>
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
    
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/password-toggle.js"></script>
</body>
</html>