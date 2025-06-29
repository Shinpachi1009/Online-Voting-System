<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Elections - Online Voting System</title>
    <link rel="icon" href="${pageContext.request.contextPath}/images/logo.png" type="image/x-icon">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar-style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/election-management-style.css">
</head>
<body>
    <jsp:include page="/navbar.jsp" />
    
    <div class="management-container">
        <div class="welcome-card">
            <h4 class="welcome-header">
                <i class="fas fa-tasks"></i> Election Management
            </h4>
            <div class="alert alert-info">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <strong><i class="fas fa-info-circle"></i> Manage all elections:</strong> Create or delete elections
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary">
                            <i class="fas fa-arrow-left"></i> Back to Dashboard
                        </a>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="action-card">
            <div class="card-header bg-primary">
                <i class="fas fa-list"></i> Elections List
            </div>
            <div class="card-body">
                <c:if test="${not empty message}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i> ${message}
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle"></i> ${error}
                    </div>
                </c:if>
                
                <div class="mb-4">
                    <a href="election?action=new" class="btn btn-success">
                        <i class="fas fa-plus"></i> Create New Election
                    </a>
                </div>
                
                <div class="table-responsive">
                    <table class="table table-hover election-table">
                        <thead>
                            <tr>
                                <th><i class="fas fa-heading"></i> Title</th>
                                <th><i class="fas fa-align-left"></i> Description</th>
                                <th><i class="fas fa-hourglass-start"></i> Start Date</th>
                                <th><i class="fas fa-hourglass-end"></i> End Date</th>
                                <th><i class="fas fa-info-circle"></i> Status</th>
                                <th class="text-center"><i class="fas fa-trash"></i> Delete</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${elections}" var="election">
                                <tr>
                                    <td>${election.title}</td>
                                    <td>${election.description}</td>
                                    <td>${election.startDate}</td>
                                    <td>${election.endDate}</td>
                                    <td>
                                        <span class="status-badge 
                                            ${election.status == 'ACTIVE' ? 'badge-active' : 
                                              election.status == 'UPCOMING' ? 'badge-upcoming' : 'badge-ended'}">
                                            ${election.status}
                                        </span>
                                    </td>
                                    <td class="text-center">
                                        <form action="${pageContext.request.contextPath}/election" method="post" 
                                              onsubmit="return confirm('Are you sure you want to delete this election?')">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="${election.electionId}">
                                            <button type="submit" class="btn btn-danger action-btn">
                                                <i class="fas fa-trash"></i> Delete
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>