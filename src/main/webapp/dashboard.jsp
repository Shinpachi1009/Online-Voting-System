<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard - Online Voting System</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar-style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard-style.css">
</head>
<body>
    <jsp:include page="/navbar.jsp" />
    
    <div class="dashboard-container">
        <div class="welcome-card">
            <h4 class="welcome-header">
                <i class="fas fa-user-circle"></i> Welcome, ${user.firstName} ${user.lastName}
            </h4>
            <div class="alert alert-info">
                <strong><i class="fas fa-user-shield"></i> Role:</strong> ${user.roleName}<br>
                <strong><i class="fas fa-clock"></i> Last Login:</strong> 
                <c:choose>
                    <c:when test="${empty user.lastLogin}">Never</c:when>
                    <c:otherwise>${user.lastLogin}</c:otherwise>
                </c:choose>
            </div>
        </div>
        
        <c:if test="${user.roleName == 'VOTER'}">
            <div class="action-card">
                <div class="card-header bg-primary">
                    <i class="fas fa-vote-yea"></i> Voting Actions
                </div>
                <div class="card-body">
                    <a href="vote.jsp" class="btn btn-success">
                        <i class="fas fa-check-circle"></i> Cast Your Vote
                    </a>
                    <a href="results.jsp" class="btn btn-info">
                        <i class="fas fa-poll"></i> View Results
                    </a>
                </div>
            </div>
        </c:if>
        
        <c:if test="${user.roleName == 'ADMIN' || user.roleName == 'ELECTION_OFFICER'}">
            <div class="action-card">
                <div class="card-header bg-primary">
                    <i class="fas fa-user-cog"></i> Administration
                </div>
                <div class="card-body">
                    <a href="admin/users.jsp" class="btn btn-success">
                        <i class="fas fa-users-cog"></i> Manage Users
                    </a>
                    <a href="admin/elections.jsp" class="btn btn-warning">
                        <i class="fas fa-calendar-alt"></i> Manage Elections
                    </a>
                    <a href="admin/audit.jsp" class="btn btn-info">
                        <i class="fas fa-clipboard-list"></i> View Audit Logs
                    </a>
                </div>
            </div>
        </c:if>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>