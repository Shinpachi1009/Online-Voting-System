<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Elections</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .action-btn {
            margin: 0 3px;
        }
        .status-badge {
            font-size: 0.8rem;
        }
    </style>
</head>
<body>
    <jsp:include page="/navbar.jsp" />
    
    <div class="container mt-4">
        <div class="card">
            <div class="card-header bg-primary text-white">
                <h4><i class="fas fa-tasks"></i> Manage Elections</h4>
            </div>
            <div class="card-body">
                <c:if test="${not empty message}">
                    <div class="alert alert-success">${message}</div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>
                
                <div class="mb-3">
                    <a href="election?action=new" class="btn btn-success">
                        <i class="fas fa-plus"></i> Create New Election
                    </a>
                </div>
                
                <div class="table-responsive">
                    <table class="table table-striped table-hover">
                        <thead class="thead-dark">
                            <tr>
                                <th>Title</th>
                                <th>Description</th>
                                <th>Start Date</th>
                                <th>End Date</th>
                                <th>Status</th>
                                <th>Actions</th>
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
                                        <span class="badge 
                                            ${election.status == 'ACTIVE' ? 'badge-success' : 
                                              election.status == 'UPCOMING' ? 'badge-info' : 'badge-secondary'} 
                                            status-badge">
                                            ${election.status}
                                        </span>
                                    </td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/election" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this election?')">
										    <input type="hidden" name="action" value="delete" />
										    <input type="hidden" name="id" value="${election.electionId}" />
										    <button type="submit" class="btn btn-sm btn-danger action-btn" title="Delete">
										        <i class="fas fa-trash"></i>
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