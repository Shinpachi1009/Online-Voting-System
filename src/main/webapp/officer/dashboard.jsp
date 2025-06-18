<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Election Officer Dashboard - Online Voting System</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <jsp:include page="/navbar.jsp" />
    
    <div class="container mt-4">
        <div class="row">
            <div class="col-md-12">
                <h2>Election Officer Dashboard</h2>
                <hr>
                
                <div class="row">
                    <div class="col-md-4">
                        <div class="card text-white bg-info mb-3">
                            <div class="card-header">Voter Approvals</div>
                            <div class="card-body">
                                <h5 class="card-title">5 Pending</h5>
                                <p class="card-text">Voter registrations awaiting approval</p>
                                <a href="approvals.jsp" class="btn btn-light">Review Now</a>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-4">
                        <div class="card text-white bg-success mb-3">
                            <div class="card-header">Election Status</div>
                            <div class="card-body">
                                <h5 class="card-title">2 Active Elections</h5>
                                <p class="card-text">Monitor ongoing elections</p>
                                <a href="elections.jsp" class="btn btn-light">View Elections</a>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-4">
                        <div class="card text-white bg-warning mb-3">
                            <div class="card-header">Reports</div>
                            <div class="card-body">
                                <h5 class="card-title">Generate Reports</h5>
                                <p class="card-text">Voter turnout and results</p>
                                <a href="reports.jsp" class="btn btn-light">Create Reports</a>
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