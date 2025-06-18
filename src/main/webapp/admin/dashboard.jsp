<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - Online Voting System</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <jsp:include page="../../navbar.jsp" />
    
    <div class="container mt-4">
        <div class="row">
            <div class="col-md-12">
                <h2>Admin Dashboard</h2>
                <hr>
                
                <div class="row">
                    <div class="col-md-4">
                        <div class="card text-white bg-primary mb-3">
                            <div class="card-header">Users</div>
                            <div class="card-body">
                                <h5 class="card-title">Manage Users</h5>
                                <p class="card-text">Create, edit, or delete user accounts</p>
                                <a href="users.jsp" class="btn btn-light">Go to Users</a>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-4">
                        <div class="card text-white bg-success mb-3">
                            <div class="card-header">Elections</div>
                            <div class="card-body">
                                <h5 class="card-title">Manage Elections</h5>
                                <p class="card-text">Create and configure elections</p>
                                <a href="elections.jsp" class="btn btn-light">Go to Elections</a>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-4">
                        <div class="card text-white bg-dark mb-3">
                            <div class="card-header">Audit Logs</div>
                            <div class="card-body">
                                <h5 class="card-title">View Activity</h5>
                                <p class="card-text">Monitor system activities</p>
                                <a href="audit.jsp" class="btn btn-light">View Logs</a>
                            </div>
                        </div>
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