<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Panel</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .card {
            margin-bottom: 20px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .card-header {
            font-weight: bold;
        }
        .table-responsive {
            margin-top: 20px;
        }
        .action-btn {
            margin: 0 3px;
        }
    </style>
</head>
<body>
    <jsp:include page="../navbar.jsp" />
    
    <div class="container mt-4">
        <c:if test="${not empty message}">
            <div class="alert alert-success">${message}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>
        
        <div class="card">
            <div class="card-header bg-primary text-white">
                <h4><i class="fas fa-users"></i> Voters</h4>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped table-hover">
                        <thead class="thead-dark">
                            <tr>
                                <th>ID</th>
                                <th>Username</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${voters}" var="voter">
                                <tr>
                                    <td>${voter.userId}</td>
                                    <td>${voter.username}</td>
                                    <td>${voter.firstName} ${voter.lastName}</td>
                                    <td>${voter.email}</td>
                                    <td>
                                        <span class="badge ${voter.status == 'ACTIVE' ? 'badge-success' : 'badge-danger'}">
                                            ${voter.status}
                                        </span>
                                    </td>
                                    <td>
                                        <form action="admin" method="post" style="display: inline;">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="${voter.userId}">
                                            <input type="hidden" name="type" value="voter">
                                            <button type="submit" class="btn btn-danger btn-sm action-btn" 
                                                    onclick="return confirm('Are you sure you want to delete this voter?')">
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
        
        <div class="card">
            <div class="card-header bg-success text-white">
                <h4><i class="fas fa-user-tie"></i> Candidates</h4>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped table-hover">
                        <thead class="thead-dark">
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Position</th>
                                <th>Bio</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${candidates}" var="candidate">
                                <tr>
                                    <td>${candidate.candidateId}</td>
                                    <td>${candidate.fullName}</td>
                                    <td>${candidate.position}</td>
                                    <td>${candidate.bio}</td>
                                    <td>
                                        <form action="admin" method="post" style="display: inline;">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="${candidate.candidateId}">
                                            <input type="hidden" name="type" value="candidate">
                                            <button type="submit" class="btn btn-danger btn-sm action-btn" 
                                                    onclick="return confirm('Are you sure you want to delete this candidate?')">
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