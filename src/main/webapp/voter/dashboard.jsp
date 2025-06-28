<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>

<%@page import="com.voting.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<html>
<head>
    <meta charset="UTF-8">
    <title>Voter Dashboard - Online Voting System</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <jsp:include page="/navbar.jsp" />
    
    <div class="container mt-4">
        <div class="row">
            <div class="col-md-8 offset-md-2">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h4>Voter Dashboard</h4>
                    </div>
                    <div class="card-body">
                        <div class="alert alert-info">
                            <h5>Current Elections</h5>
                            <p>You have 1 active election to participate in.</p>
                        </div>
                        
                        <div class="card mb-3">
                            <div class="card-header">
                                Presidential Election 2023
                            </div>
                            <div class="card-body">
                                <p><strong>Status:</strong> <span class="badge badge-success">Active</span></p>
                                <p><strong>Voting Period:</strong> May 1, 2023 - May 15, 2023</p>
                                <p><strong>Your Status:</strong> 
                                    <c:choose>
                                        <c:when test="${param.voted == 'true'}">
                                            <span class="badge badge-success">Voted</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-warning">Not Voted</span>
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                                
                                <a href="vote.jsp" class="btn btn-primary">Go to Ballot</a>
                                <a href="results.jsp" class="btn btn-secondary ml-2">View Results</a>
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