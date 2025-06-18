<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard - Online Voting System</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <jsp:include page="navbar.jsp" />
    
    <div class="container mt-4">
        <div class="row">
            <div class="col-md-8 offset-md-2">
                <div class="card">
                    <div class="card-header">
                        <h4>Welcome, ${user.firstName} ${user.lastName}</h4>
                    </div>
                    <div class="card-body">
                        <div class="alert alert-info">
                            <strong>Role:</strong> ${user.roleName}<br>
                            <strong>Last Login:</strong> 
                            <c:choose>
                                <c:when test="${empty user.lastLogin}">Never</c:when>
                                <c:otherwise>${user.lastLogin}</c:otherwise>
                            </c:choose>
                        </div>
                        
                        <c:if test="${user.roleName == 'VOTER'}">
                            <div class="card mb-3">
                                <div class="card-header bg-primary text-white">
                                    Voting Actions
                                </div>
                                <div class="card-body">
                                    <a href="vote.jsp" class="btn btn-success">Cast Your Vote</a>
                                    <a href="results.jsp" class="btn btn-info ml-2">View Results</a>
                                </div>
                            </div>
                        </c:if>
                        
                        <c:if test="${user.roleName == 'ADMIN' || user.roleName == 'ELECTION_OFFICER'}">
                            <div class="card mb-3">
                                <div class="card-header bg-danger text-white">
                                    Administration
                                </div>
                                <div class="card-body">
                                    <a href="admin/users.jsp" class="btn btn-dark">Manage Users</a>
                                    <a href="admin/elections.jsp" class="btn btn-dark ml-2">Manage Elections</a>
                                    <a href="admin/audit.jsp" class="btn btn-dark ml-2">View Audit Logs</a>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>